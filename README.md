# chk_lib: Simülasyon ve Formal için Ortak Assertion Kütüphanesi

Aynı checker modülleri hem xsim (UVM, `bind`) hem de SymbiYosys (açık kaynak Yosys) ile kullanılır.

## Klasör yapısı

```
formal_proj/
├── chk_lib/
│   ├── common/      chk_bitops.svh, chk_past.svh, chk_reset.svh, chk_role.svh
│   ├── formal/      chk_macros.svh   (Yosys/sby için)
│   ├── sim/         chk_macros.svh   (xsim için, henüz test edilmedi)
│   └── checkers/    chk_fsm_state.sv, chk_valid_ready.sv
└── tests/
    ├── fsm_demo/    onehot FSM testleri
    └── rs_demo/     register slice testleri
```

Formal ve simülasyon makroları aynı isimdedir. Hangisinin kullanılacağını include path seçer, checker'lar ortaktır.
`sim` ve `formal` klasörleri asla aynı komutta birlikte verilmemelidir.

```bash
# Yosys
read_verilog -formal -sv -I chk_lib/common -I chk_lib/formal <dosyalar>

# xsim
xvlog -sv -i chk_lib/common -i chk_lib/sim <dosyalar>
```

sby kullanırken include dosyaları `[files]` bölümüne eklenmelidir (common altındaki tüm .svh dosyaları ve formal/chk_macros.svh).

## Yardımcı makrolar (`common/`)

| Makro | Ne yapar |
|---|---|
| `CHK_ONEHOT0(x)` | En fazla bir bit 1 mi (`$onehot0` yerine) |
| `CHK_ONEHOT(x)` | Tam bir bit 1 mi (`$onehot` yerine) |
| `CHK_IMPL(a, b)` | "a ise b" çıkarımı (`!a \|\| b`) |
| `CHK_PAST_VALID_DECL(clk)` | İlk darbeden sonra 1 olan `chk_past_valid` flop'u |
| `CHK_PAST_OK(dis)` | `$past` güvenli mi: ilk darbe değil, önceki darbede reset yok |
| `CHK_DIS_DECL(rst)` | `RST_ACTIVE_LOW`'a göre reset aktifken 1 olan `chk_dis` sinyali |
| `CHK_PROP` / `CHK_PROP_P` | Parametreye göre assume ya da assert üretir |

## Assertion makroları (`formal/` ve `sim/`)

| Makro | Tür | Not |
|---|---|---|
| `CHK_ASSERT`, `CHK_ASSUME`, `CHK_COVER` | assert / assume / cover | Tek darbelik kurallar |
| `CHK_ASSERT_P`, `CHK_ASSUME_P`, `CHK_COVER_P` | assert / assume / cover | `$past`, `$stable` içeren kurallar |
| `CHK_NO_X` | assert | Sinyalde X/Z yok (formal'da boş) |
| `CHK_NO_X_IF` | assert | Koşul sağlanınca X/Z yok (formal'da boş) |

Kural: koşulda `$past`, `$stable`, `$rose`, `$fell` varsa `_P` varyantı kullanılır.

## Checker'lar

### chk_fsm_state

Parametreler: `W`, `RST_ACTIVE_LOW`

| Etiket | Tür | Açıklama |
|---|---|---|
| `a_state_onehot` | assert | State her zaman onehot |
| `a_state_no_x` | assert | State'te X yok (sadece sim) |

### chk_valid_ready

Parametreler: `W`, `ASSUME`, `RST_ACTIVE_LOW`, `RST_VALID_LOW`, `MAX_WAIT`, `COVER_EN`

`ASSUME=1` checker'ı DUT girişine, `ASSUME=0` çıkışına bağlamak içindir.
Kaynak kuralları bu parametreye göre, alıcı kuralı tersine göre assume/assert olur.
Yan bantlar data'ya birleştirilir: `.data({tlast, tkeep, tdata})`

| Etiket | Sahibi | Açıklama |
|---|---|---|
| `p_valid_hold` | Kaynak | Bekleyen valid kabul edilmeden düşmez |
| `p_data_hold` | Kaynak | Bekleyen data kabul edilene kadar sabit |
| `p_rst_valid_low` | Kaynak | Reset sonrası valid=0 |
| `p_ready_timeout` | Alıcı | Valid en fazla `MAX_WAIT` darbe bekler (0 = kapalı) |
| `p_valid_no_x`, `p_ready_no_x`, `p_data_no_x` | - | X/Z kontrolleri (sadece sim) |
| `c_xfer` | cover | Transfer oluyor |
| `c_stall_xfer` | cover | Bekleyip transfer |
| `c_ready_first` | cover | Ready önce hazır, anında transfer |
| `c_back_to_back` | cover | Art arda transfer |
| `c_idle_after_xfer` | cover | Transfer sonrası valid düşebiliyor |
| `c_max_wait_xfer` | cover | Zaman aşımı sınırında transfer |

## Testler

| Test | Görevler | Doğruladığı |
|---|---|---|
| fsm_demo | `prove`, `bug`, `prove_ah`, `bug_ah` | Onehot kuralı ve iki reset polaritesi |
| rs_demo | `prove`, `bug`, `cover` | Valid/ready kuralları, hata yakalama, 12/12 cover |
| rs_demo | `pass`, `pass_noenv` | Assume'un ispata etkisi |
| rs_demo | `wait`, `wait_bug` | Zaman aşımı ve rol değişimi |

Çalıştırma:

```bash
cd tests/rs_demo  && sby -f rs.sby  2>&1 | grep -E "DONE|failed assertion"
cd tests/fsm_demo && sby -f fsm.sby 2>&1 | grep -E "DONE|failed assertion"
```

Beklenen: `prove*`, `pass`, `wait`, `cover` görevleri PASS; `bug*`, `pass_noenv`, `wait_bug` görevleri FAIL.

## Açık işler

- Simülasyon makrolarının xsim'de derlenip test edilmesi
- Veri bütünlüğü checker'ı (`$anyconst` ile)
- req/ack (4 fazlı) handshake checker'ı
- valid-only (geri basınçsız) akış checker'ı
