module fsm_formal_top (input logic clk, rst_in, go);
`ifdef RST_AH
  localparam bit RAL = 1'b0;      // dış reset aktif-yüksek
  wire rst_act = rst_in;
`else
  localparam bit RAL = 1'b1;      // dış reset aktif-düşük
  wire rst_act = !rst_in;
`endif

  logic [3:0] state;

  dut_fsm u_dut (.clk(clk), .rst_n(!rst_act), .go(go), .state(state));
  chk_fsm_state #(.W(4), .RST_ACTIVE_LOW(RAL)) u_chk (.clk(clk), .rst(rst_in), .state(state));

  // Adım 0'da reset aktif olsun (polariteden bağımsız)
  initial assume (rst_act);
endmodule
