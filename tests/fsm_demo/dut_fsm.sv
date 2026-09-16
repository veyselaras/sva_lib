module dut_fsm (input logic clk, rst_n, go, output logic [3:0] state);
  always_ff @(posedge clk)
    if (!rst_n)  state <= 4'b0001;
    else if (go)
`ifdef BUG
      state <= (state == 4'b1000) ? 4'b0011 : (state << 1);
`else
      state <= (state == 4'b1000) ? 4'b0001 : (state << 1);
`endif
endmodule