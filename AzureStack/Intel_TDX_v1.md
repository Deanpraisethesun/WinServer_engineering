### Intel TDX 的硬體需求與 BIOS 設定需求

#### **1. 硬體需求**
1. **CPU 處理器**  (我猜巢狀虛擬化的U都能啟用)
   - 需使用支援 Intel TDX 的 CPU 型號（需聯繫 Intel 銷售代表確認具體 SKU）。

2. **主機板配置**  
   - 需透過硬體跳線或 CPLD（複雜可程式邏輯裝置）調整設定（看 ODM/OEM 供應商設計形式）。

3. **記憶體規格_D5 ECC RDIMM**  
   - **類型**：DDR5 DIMM，需為 **10×4 ECC（錯誤校正碼記憶體）**。  
   - **完整性保護**：DDR5 RDIMM 需支援完整性保護。

4. **DIMM 配置**  
   - **最小配置**：所有通道 0 的插槽至少安裝 1 個 DIMM（1P8D或者2P16D）。  
   - **對稱性**：DIMM 必須在整合記憶體控制器之間對稱分佈。  
   - **全配置支援**：可支援 **16+0 DIMM**。

---

#### **2. BIOS 設定需求**
以下為 BIOS 中需啟用或調整的關鍵設定（不同主機板選單可能不同，建議聯繫供應商確認）：

| **BIOS 設定項目**               | **設定值**                     | **說明**                                                                 |
|-------------------------------|------------------------------|-------------------------------------------------------------------------|
| **Volatile Memory**           | `ILM`                        | 確保直接連接的 DDR5 記憶體支援 TDX 邏輯完整性、隔離與加密功能。                         |
| **Total Memory Encryption (TME)** | `Enable`                    | 啟用 Intel TME 以支援記憶體加密（TDX 的基礎技術）。                               |
| **TME Bypass**                | `Auto`                       | 允許非機密軟體使用未加密記憶體以提升效能。                                          |
| **TME Multi-Tenant (TME-MT)** | `Enable`                    | 啟用 128 個 TME-MK 加密金鑰，支援多租戶隔離。                                   |
| **Memory Integrity**          | `Disable`                    | 第 4 代 Intel Xeon Scalable 處理器（E-stepping）僅支援 TDX-LI，需停用此功能。    |
| **Intel TDX**                 | `Enable`                     | 核心選項，啟用 TDX 技術。                                                 |
| **TDX Key Split**             | `<非零值>`                   | 分配金鑰至 TME 多租戶與 TDX 之間（例如設為 `1`）。                               |
| **Software Guard Extension (SGX)** | `Enable`                 | 啟用 Intel SGX 以支援硬體 TCB 與遠端認證。                                   |

---

#### **注意事項**
- **DIMM 配置對稱性**：若配置不當（如非對稱安裝），可能導致 TDX 功能啟用失敗。  
- **BIOS 差異**：不同廠商（如 AMI、Insyde）的 BIOS 介面可能不同，建議參考 OEM/ODM 提供的具體指南。
  -**HPE:**
  Enabling or disabling Trust Domain Extension (TDX)
  Prerequisites
  Processor Physical Addressing is Default.
  Total Memory Encryption (TME) is Enabled.
  Total Memory Encryption Multi-Key (TME-MK) is Enabled.
  Intel(R) Software Guard Extensions (SGX) is Enabled.

    Procedure
    From the System Utilities screen, select System Configuration > BIOS/Platform Configuration (RBSU) > Server Security > Intel Security Options > Trust Domain Extension (TDX).
    Select a setting:
    Enabled
    Disabled (Default)
    Save your setting.

- **記憶體相容性**：需使用符合規格的 DDR5 ECC 記憶體，避免使用未經驗證的模組。  



