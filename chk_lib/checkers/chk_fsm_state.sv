`include "chk_macros.svh"

module chk_fsm_state #(parameter int W = 4) (
  input logic         clk, rst_n,
  input logic [W-1:0] state
);
  `CHK_ASSERT(a_state_onehot, clk, !rst_n, `CHK_ONEHOT(state))
  `CHK_NO_X  (a_state_no_x,   clk, !rst_n, state)
endmodule