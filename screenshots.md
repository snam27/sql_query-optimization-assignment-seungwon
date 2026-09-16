# 🚀 SQL Query Optimization Report

## 📊 Before vs After 비교

<table>
  <tr>
    <td align="center"><b>🔴 튜닝 전 (Before)</b></td>
    <td align="center"><b>🟢 튜닝 후 (After)</b></td>
  </tr>
  <tr>
    <td align="center">
      <img width="100%" alt="Before Plan" src="https://github.com/user-attachments/assets/29018891-1040-4e06-97ff-8b81f05ea115" />
    </td>
    <td align="center">
      <img width="100%" alt="After Plan" src="https://github.com/user-attachments/assets/1c981d96-ff22-46f7-8a92-c0f05c0af170" />
    </td>
  </tr>
</table>

---

## 💡 주요 개선 사항 (Summary)
* **Execution Time:** `112.791 ms` ➡️ `0.065 ms` (성능 대폭 향상)
* **Scan Method:** `Parallel Seq Scan` ➡️ `Bitmap Index Scan` (풀스캔 제거)
