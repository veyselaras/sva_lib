`ifndef CHK_MACROS_SVH
`define CHK_MACROS_SVH
`include "chk_bitops.svh"
`include "chk_past.svh"
`include "chk_reset.svh"

// ---- Tek darbelik kurallar ----
`define CHK_ASSERT(lbl, clk, dis, cond) \
  lbl: assert property (@(posedge clk) disable iff (dis) (cond)) else $error("[CHK] %m");
`define CHK_ASSUME(lbl, clk, dis, cond) \
  lbl: assume property (@(posedge clk) disable iff (dis) (cond)) else $error("[CHK] %m");
`define CHK_COVER(lbl, clk, dis, cond) \
  lbl: cover property (@(posedge clk) disable iff (dis) (cond));
`define CHK_NO_X(lbl, clk, dis, sig) \
  lbl: assert property (@(posedge clk) disable iff (dis) !$isunknown(sig)) else $error("[CHK] X: %m");

// ---- $past kullanan kurallar (CHK_PAST_VALID_DECL gerekir) ----
// Not: standart, disable iff içinde $past kullanımını yasaklar; bu yüzden şart öncülde
`define CHK_ASSERT_P(lbl, clk, dis, cond) \
  lbl: assert property (@(posedge clk) disable iff (dis) `CHK_PAST_OK(dis) |-> (cond)) else $error("[CHK] %m");
`define CHK_ASSUME_P(lbl, clk, dis, cond) \
  lbl: assume property (@(posedge clk) disable iff (dis) `CHK_PAST_OK(dis) |-> (cond)) else $error("[CHK] %m");
`define CHK_COVER_P(lbl, clk, dis, cond) \
  lbl: cover property (@(posedge clk) disable iff (dis) (`CHK_PAST_OK(dis) && (cond)));

`endif
