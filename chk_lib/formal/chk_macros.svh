`ifndef CHK_MACROS_SVH
`define CHK_MACROS_SVH
`include "chk_bitops.svh"

`define CHK_ASSERT(lbl, clk, dis, cond) always @(posedge clk) if (!(dis)) lbl: assert (cond);
`define CHK_ASSUME(lbl, clk, dis, cond) always @(posedge clk) if (!(dis)) lbl: assume (cond);
`define CHK_COVER(lbl, clk, dis, cond)  always @(posedge clk) if (!(dis)) lbl: cover  (cond);
// formal 2 durumludur, X kontrolü yok
`define CHK_NO_X(lbl, clk, dis, sig)
`endif