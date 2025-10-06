module pht_agree (
  input  logic              i_clk           ,
  input  logic              i_rst_n         ,
  input  logic              i_actual_taken  ,
  input  logic              i_valid_update  ,
  input  logic              i_is_branch     ,
  input  logic              i_is_jump       ,
  input  logic [31:0]       i_pc            ,
  input  logic [7:0]        i_ghr           ,
  input  logic              i_bias          ,
  output logic              o_predict_taken
);

  typedef enum logic [1:0] {
    weak_agree      = 2'b00,
    strong_agree    = 2'b01,
    weak_disagree   = 2'b10,
    strong_disagree = 2'b11
  } state_agree;

  logic        agree            ;
  logic [1:0]  state_t          ;
  logic [7:0]  gshare_index     ;
  logic [19:0] tag              ;
  logic [1:0]  pht_table [0:255];
  logic [19:0] tag_table [0:255];

  assign gshare_index = i_pc[9:2] ^ i_ghr         ;
  assign tag          = i_pc[31:12]               ;
  assign agree        = ~(i_actual_taken ^ i_bias);  // 1 if agree, 0 if disagree

  // FSM update logic
  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      for (int i = 0; i < 256; i = i + 1) begin
        pht_table[i] <= weak_disagree;
        tag_table[i] <= 20'b0        ;
      end
    end else if (i_valid_update) begin
      tag_table[gshare_index] <= tag    ;
      pht_table[gshare_index] <= state_t;
    end
  end

  // FSM transition logic
  always_comb begin: state_transition
    case (pht_table[gshare_index])
      weak_disagree  :  state_t = agree ? weak_agree    : strong_disagree;
      strong_disagree:  state_t = agree ? weak_disagree : strong_disagree;
      weak_agree     :  state_t = agree ? strong_agree  : weak_disagree  ;
      strong_agree   :  state_t = agree ? strong_agree  : weak_agree     ;
      default:          state_t = weak_disagree;
    endcase
  end

  // Prediction output
  always_comb begin: out_predict_taken
    o_predict_taken = 1'b0;
    if ((tag_table[gshare_index] == tag && i_is_branch) || i_is_jump) begin
      case (state_t)
        weak_agree, strong_agree:   begin
          o_predict_taken =  i_bias;
        end 
        weak_disagree, strong_disagree: begin
          o_predict_taken = ~i_bias;
        end 
        default: begin
          o_predict_taken = ~i_bias;
        end
      endcase
    end else begin
      o_predict_taken = 1'b0;
    end
  end

endmodule
