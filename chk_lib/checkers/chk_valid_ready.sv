`include "chk_macros.svh"

// Genel valid/ready (AXI-Stream tarzı) handshake checker'ı
//
// Sorumluluklar:
//   Kaynak (valid, data): p_valid_hold, p_data_hold, p_rst_valid_low
//   Alıcı  (ready)      : p_ready_timeout
//
// ASSUME=1: checker DUT'un GİRİŞİNDE (çevre kaynak, DUT alıcı)
//           -> kaynak kuralları assume, alıcı kuralları assert
// ASSUME=0: checker DUT'un ÇIKIŞINDA (DUT kaynak, çevre alıcı)
//           -> kaynak kuralları assert, alıcı kuralları assume
//
// Yan bantlar data'ya birleştirilir: .data({tlast, tkeep, tdata})
module chk_valid_ready #(
  parameter int W              = 8,
  parameter bit ASSUME         = 1'b0,
  parameter bit RST_ACTIVE_LOW = 1'b1,
  parameter bit RST_VALID_LOW  = 1'b1,  // reset darbesinin ardından valid=0 olmalı
  parameter int MAX_WAIT       = 0,     // >0: valid en fazla MAX_WAIT darbe bekleyebilir
  parameter bit COVER_EN       = 1'b1
)(
  input logic         clk, rst,
  input logic         valid, ready,
  input logic [W-1:0] data
);
  `CHK_DIS_DECL(rst)
  `CHK_PAST_VALID_DECL(clk)

  wire xfer  = valid &&  ready;
  wire stall = valid && !ready;

  // ---- Kaynak kuralları ----
  `CHK_PROP_P(ASSUME, p_valid_hold, clk, chk_dis, `CHK_IMPL($past(stall), valid))
  `CHK_PROP_P(ASSUME, p_data_hold,  clk, chk_dis, `CHK_IMPL($past(stall), $stable(data)))

  generate if (RST_VALID_LOW) begin : g_rst
    // Reset sırasında da çalışmalı: dis=0, ilk darbe koruması koşulun içinde
    `CHK_PROP(ASSUME, p_rst_valid_low, clk, 1'b0, `CHK_IMPL(chk_past_valid && $past(chk_dis), !valid))
  end endgenerate

  // ---- Alıcı kuralı: zaman aşımı ----
  generate if (MAX_WAIT > 0) begin : g_wait
    localparam int CW = $clog2(MAX_WAIT + 1);
    logic [CW-1:0] wait_cnt;   // şu ana kadar art arda kaç darbe beklendi

    always @(posedge clk)
      if (chk_dis || !stall)       wait_cnt <= '0;
      else if (wait_cnt < MAX_WAIT) wait_cnt <= wait_cnt + 1'b1;

    `CHK_PROP(!ASSUME, p_ready_timeout, clk, chk_dis, `CHK_IMPL(valid && (wait_cnt >= MAX_WAIT), ready))

    if (COVER_EN) begin : g_cov
      `CHK_COVER(c_max_wait_xfer, clk, chk_dis, xfer && (wait_cnt == MAX_WAIT))
    end
  end endgenerate

  // ---- X kontrolleri (sadece simülasyonda etkin) ----
  `CHK_NO_X   (p_valid_no_x, clk, chk_dis, valid)
  `CHK_NO_X   (p_ready_no_x, clk, chk_dis, ready)
  `CHK_NO_X_IF(p_data_no_x,  clk, chk_dis, valid, data)

  // ---- Cover'lar ----
  generate if (COVER_EN) begin : g_cover
    `CHK_COVER  (c_xfer,            clk, chk_dis, xfer)
    `CHK_COVER_P(c_stall_xfer,      clk, chk_dis, $past(stall) && xfer)
    `CHK_COVER_P(c_ready_first,     clk, chk_dis, $past(ready && !valid) && xfer)
    `CHK_COVER_P(c_back_to_back,    clk, chk_dis, $past(xfer) && xfer)
    `CHK_COVER_P(c_idle_after_xfer, clk, chk_dis, $past(xfer) && !valid)
  end endgenerate
endmodule
