`ifndef CHK_BITOPS_SVH
`define CHK_BITOPS_SVH
// x & (x-1) en düşük 1 bitini siler; sonuç 0 ise en fazla bir bit 1'dir
`define CHK_ONEHOT0(x)  (((x) & ((x) - 1'b1)) == 0)
`define CHK_ONEHOT(x)   (((x) != 0) && `CHK_ONEHOT0(x))
`endif