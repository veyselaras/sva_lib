module fsm_formal_top (input logic clk, rst_n, go);
  logic [3:0] state;

  dut_fsm u_dut (.clk(clk), .rst_n(rst_n), .go(go), .state(state));
  chk_fsm_state #(.W(4)) u_chk (.clk(clk), .rst_n(rst_n), .state(state));

  // Formal'da flop'lar rastgele değerle başlar; ilk adımda reset'i zorla
  initial assume (!rst_n);
endmodule