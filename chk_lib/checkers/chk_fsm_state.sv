`include "chk_macros.svh"

module chk_fsm_state #(
  parameter int W              = 4,
  parameter bit RST_ACTIVE_LOW = 1'b1
)(
  input logic         clk, rst,
  input logic [W-1:0] state
);
  `CHK_DIS_DECL(rst)

  `CHK_ASSERT(a_state_onehot, clk, chk_dis, `CHK_ONEHOT(state))
  `CHK_NO_X  (a_state_no_x,   clk, chk_dis, state)
endmodule
