`ifndef CHK_MACROS_SVH
`define CHK_MACROS_SVH
`include "chk_bitops.svh"
`include "chk_past.svh"
`include "chk_reset.svh"

// ---- Tek darbelik kurallar ----
`define CHK_ASSERT(lbl, clk, dis, cond) always @(posedge clk) if (!(dis)) lbl: assert (cond);
`define CHK_ASSUME(lbl, clk, dis, cond) always @(posedge clk) if (!(dis)) lbl: assume (cond);
`define CHK_COVER(lbl, clk, dis, cond)  always @(posedge clk) if (!(dis)) lbl: cover  (cond);

// Formal 2 durumludur, X kontrolü yok: bilerek boş
`define CHK_NO_X(lbl, clk, dis, sig)

// ---- $past kullanan kurallar (CHK_PAST_VALID_DECL gerekir) ----
`define CHK_ASSERT_P(lbl, clk, dis, cond) always @(posedge clk) if (`CHK_PAST_OK(dis) && !(dis)) lbl: assert (cond);
`define CHK_ASSUME_P(lbl, clk, dis, cond) always @(posedge clk) if (`CHK_PAST_OK(dis) && !(dis)) lbl: assume (cond);
`define CHK_COVER_P(lbl, clk, dis, cond)  always @(posedge clk) if (`CHK_PAST_OK(dis) && !(dis)) lbl: cover  (cond);

`endif
