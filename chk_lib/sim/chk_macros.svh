`ifndef CHK_MACROS_SVH
`define CHK_MACROS_SVH
`include "chk_bitops.svh"

`define CHK_ASSERT(lbl, clk, dis, cond) \
  lbl: assert property (@(posedge clk) disable iff (dis) (cond)) else $error("[CHK] %m");
`define CHK_ASSUME(lbl, clk, dis, cond) \
  lbl: assume property (@(posedge clk) disable iff (dis) (cond)) else $error("[CHK] %m");
`define CHK_COVER(lbl, clk, dis, cond) \
  lbl: cover property (@(posedge clk) disable iff (dis) (cond));
`define CHK_NO_X(lbl, clk, dis, sig) \
  lbl: assert property (@(posedge clk) disable iff (dis) !$isunknown(sig)) else $error("[CHK] X: %m");
`endif