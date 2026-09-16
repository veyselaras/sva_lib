module rs_formal_top (
  input logic       clk, rst_n,
  input logic       s_valid, m_ready,
  input logic [7:0] s_data
);
  logic       s_ready, m_valid;
  logic [7:0] m_data;

  rs_slice #(.W(8)) u_dut (.*);

  // Giriş: çevre kurala uyar -> assume
  chk_valid_ready #(.W(8), .ASSUME(1)) u_chk_in (
    .clk(clk), .rst(rst_n), .valid(s_valid), .ready(s_ready), .data(s_data));

  // Çıkış: tasarım kurala uymalı -> assert
  chk_valid_ready #(.W(8), .ASSUME(0)) u_chk_out (
    .clk(clk), .rst(rst_n), .valid(m_valid), .ready(m_ready), .data(m_data));

  initial assume (!rst_n);
endmodule
