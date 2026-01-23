# 🚀 CyberLog – Legal Device Log Monitor (Flutter + Firebase)

CyberLog is a **Flutter-based Android application** that collects **legal device logs** and synchronizes them to **Firebase Firestore** with optional authentication and a cyber-themed UI.

This project is **100% Google Play policy compliant** — no root access, no system-level log scraping.

---

## ✨ Features

- 🔐 Email & Password Authentication
- ➡️ Skip Login (Local Mode)
- ☁️ Firestore Sync (Per User)
- 💾 Local Storage Fallback
- 📱 Legal Device Logs Collection
- 🗑 Delete Logs

---

## 📋 Logged Data (100% Legal)

✔ App lifecycle events  
✔ Battery status & charging state  
✔ Network connectivity changes  
✔ Device information (model, brand, Android version)  
✔ Crash and runtime errors  

❌ No system logs  
❌ No other apps’ logs  
❌ No kernel logs  
❌ No private user data  

---

## 📁 Firestore Structure

```text
users
 └── {uid}
     └── device_logs
         ├── text: "[12:30] Battery Changed: charging"
         └── time: Timestamp
```
<img width="1238" height="605" alt="image" src="https://github.com/user-attachments/assets/e03d2df0-311b-481f-8b54-ca9da984be5c" />


![WhatsApp Image 2026-01-23 at 13 44 21](https://github.com/user-attachments/assets/f1962b65-d3c5-4892-abf6-3763fbf6baa1)
![WhatsApp Image 2026-01-23 at 13 44 21 (2)](https://github.com/user-attachments/assets/e7b16ffd-b652-4993-8e69-1377e8e22e4c)
![WhatsApp Image 2026-01-23 at 13 44 21 (1)](https://github.com/user-attachments/assets/23765894-8578-4ce3-aec5-5c44e490a806)

