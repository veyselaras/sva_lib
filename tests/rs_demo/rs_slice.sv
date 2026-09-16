module rs_slice #(parameter int W = 8) (
  input  logic         clk, rst_n,
  input  logic         s_valid,
  output logic         s_ready,
  input  logic [W-1:0] s_data,
  output logic         m_valid,
  input  logic         m_ready,
  output logic [W-1:0] m_data
);
`ifdef PASS
  // Pass-through: register yok, giriş doğrudan çıkışa
  assign s_ready = m_ready;
  assign m_valid = s_valid;
  assign m_data  = s_data;
`else
 `ifdef BUG
  assign s_ready = 1'b1;
 `else
  assign s_ready = !m_valid || m_ready;
 `endif
  always_ff @(posedge clk)
    if (!rst_n)
      m_valid <= 1'b0;
    else if (s_ready) begin
      m_valid <= s_valid;
      m_data  <= s_data;
    end
`endif
endmodule
