`include "chk_macros.svh"

// AXI-Stream tarzı valid/ready kuralları
//   ASSUME=0 -> bir modülün ÇIKIŞINA bağla (modül kurala uymalı: assert)
//   ASSUME=1 -> bir modülün GİRİŞİNE bağla (çevre kurala uyar: assume)
module chk_valid_ready #(
  parameter int W      = 8,
  parameter bit ASSUME = 1'b0
)(
  input logic         clk, rst_n,
  input logic         valid, ready,
  input logic [W-1:0] data
);
  `CHK_PAST_VALID_DECL(clk)

  generate
    if (ASSUME) begin : g_assume
      `CHK_ASSUME_P(m_valid_hold, clk, !rst_n, `CHK_IMPL($past(valid && !ready), valid))
      `CHK_ASSUME_P(m_data_hold,  clk, !rst_n, `CHK_IMPL($past(valid && !ready), $stable(data)))
    end else begin : g_assert
      `CHK_ASSERT_P(a_valid_hold, clk, !rst_n, `CHK_IMPL($past(valid && !ready), valid))
      `CHK_ASSERT_P(a_data_hold,  clk, !rst_n, `CHK_IMPL($past(valid && !ready), $stable(data)))
    end
  endgenerate

  // Senaryolar gerçekten oluşuyor mu? (ortam aşırı kısıtlanmış mı kontrolü)
  `CHK_COVER_P(c_xfer,            clk, !rst_n, valid && ready)
  `CHK_COVER_P(c_stall_then_xfer, clk, !rst_n, $past(valid && !ready) && valid && ready)
endmodule
