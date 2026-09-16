`include "chk_macros.svh"

// AXI-Stream tarzı valid/ready kuralları
//   ASSUME=0 -> bir modülün ÇIKIŞINA bağla (modül kurala uymalı: assert)
//   ASSUME=1 -> bir modülün GİRİŞİNE bağla (çevre kurala uyar: assume)
module chk_valid_ready #(
  parameter int W              = 8,
  parameter bit ASSUME         = 1'b0,
  parameter bit RST_ACTIVE_LOW = 1'b1
)(
  input logic         clk, rst,
  input logic         valid, ready,
  input logic [W-1:0] data
);
  `CHK_DIS_DECL(rst)
  `CHK_PAST_VALID_DECL(clk)

  generate
    if (ASSUME) begin : g_assume
      `CHK_ASSUME_P(m_valid_hold, clk, chk_dis, `CHK_IMPL($past(valid && !ready), valid))
      `CHK_ASSUME_P(m_data_hold,  clk, chk_dis, `CHK_IMPL($past(valid && !ready), $stable(data)))
    end else begin : g_assert
      `CHK_ASSERT_P(a_valid_hold, clk, chk_dis, `CHK_IMPL($past(valid && !ready), valid))
      `CHK_ASSERT_P(a_data_hold,  clk, chk_dis, `CHK_IMPL($past(valid && !ready), $stable(data)))
    end
  endgenerate

  `CHK_COVER_P(c_xfer,            clk, chk_dis, valid && ready)
  `CHK_COVER_P(c_stall_then_xfer, clk, chk_dis, $past(valid && !ready) && valid && ready)
endmodule
