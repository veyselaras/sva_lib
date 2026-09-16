`ifndef CHK_RESET_SVH
`define CHK_RESET_SVH

// Checker başına BİR KEZ çağrılır. Modülde RST_ACTIVE_LOW parametresi olmalı.
// Sonuç: reset aktifken 1 olan chk_dis sinyali (makroların dis argümanı)
`define CHK_DIS_DECL(rst) \
  wire chk_dis = RST_ACTIVE_LOW ? !(rst) : (rst);

`endif
