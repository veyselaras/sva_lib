module rs_formal_top (
  input logic       clk, rst_n,
  input logic       s_valid, m_ready,
  input logic [7:0] s_data
);
`ifdef WAIT_BUG
  localparam int IN_WAIT = 1, OUT_WAIT = 2;   // giriş sınırı çıkıştan sıkı: FAIL beklenir
`elsif WAIT
  localparam int IN_WAIT = 2, OUT_WAIT = 2;
`else
  localparam int IN_WAIT = 0, OUT_WAIT = 0;   // zaman aşımı kapalı
`endif

  logic       s_ready, m_valid;
  logic [7:0] m_data;

  rs_slice #(.W(8)) u_dut (.*);

`ifndef NO_ENV
  // Giriş: çevre kaynak (assume), DUT alıcı (zaman aşımı assert)
  chk_valid_ready #(.W(8), .ASSUME(1), .MAX_WAIT(IN_WAIT)) u_chk_in (
    .clk(clk), .rst(rst_n), .valid(s_valid), .ready(s_ready), .data(s_data));
`endif

  // Çıkış: DUT kaynak (assert), çevre alıcı (zaman aşımı assume)
  chk_valid_ready #(.W(8), .ASSUME(0), .MAX_WAIT(OUT_WAIT)) u_chk_out (
    .clk(clk), .rst(rst_n), .valid(m_valid), .ready(m_ready), .data(m_data));

  initial assume (!rst_n);
endmodule
