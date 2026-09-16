`ifndef CHK_ROLE_SVH
`define CHK_ROLE_SVH

// asm=1 -> assume, asm=0 -> assert
// asm bir parametre ifadesi olmalı; seçim elaboration'da yapılır, runtime maliyeti yok
`define CHK_PROP(asm, lbl, clk, dis, cond) \
  if (asm) begin \
    `CHK_ASSUME(lbl, clk, dis, cond) \
  end else begin \
    `CHK_ASSERT(lbl, clk, dis, cond) \
  end

`define CHK_PROP_P(asm, lbl, clk, dis, cond) \
  if (asm) begin \
    `CHK_ASSUME_P(lbl, clk, dis, cond) \
  end else begin \
    `CHK_ASSERT_P(lbl, clk, dis, cond) \
  end

`endif
