module rs_slice #(parameter int W = 8) (
  input  logic         clk, rst_n,
  // giriş (slave) tarafı
  input  logic         s_valid,
  output logic         s_ready,
  input  logic [W-1:0] s_data,
  // çıkış (master) tarafı
  output logic         m_valid,
  input  logic         m_ready,
  output logic [W-1:0] m_data
);
`ifdef BUG
  assign s_ready = 1'b1;                   // çıkış beklese de girişi kabul eder
`else
  assign s_ready = !m_valid || m_ready;    // çıkış boşsa veya boşalıyorsa kabul et
`endif

  always_ff @(posedge clk)
    if (!rst_n)
      m_valid <= 1'b0;
    else if (s_ready) begin
      m_valid <= s_valid;
      m_data  <= s_data;
    end
endmodule
