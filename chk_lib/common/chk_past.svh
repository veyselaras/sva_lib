`ifndef CHK_PAST_SVH
`define CHK_PAST_SVH

// Mantıksal çıkarım: a doğruysa b de doğru olmalı (formal'da |-> yok)
`define CHK_IMPL(a, b) (!(a) || (b))

// Modül başına BİR KEZ çağrılır: ilk saat darbesinden sonra 1 olur
`define CHK_PAST_VALID_DECL(clk) \
  reg chk_past_valid = 1'b0; \
  always @(posedge clk) chk_past_valid <= 1'b1;

// $past güvenli mi: ilk darbe değil VE önceki darbede reset yoktu
`define CHK_PAST_OK(dis) (chk_past_valid && !$past(dis))

`endif
