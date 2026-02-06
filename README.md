# Hashcat Wordlist Runner (hc22000)

A simple but robust Bash wrapper for **Hashcat WPA/WPA2/WPA3 (hc22000)** cracking that:

- Iterates cleanly through multiple wordlists
- Supports `.txt` and `.tar.gz` wordlists
- Waits for **each list to fully complete**
- Detects **already-cracked hashes** via the potfile
- Stops immediately when a password is found
- Clearly prints the cracked result for easy copying

This script is designed to remove common pain points when running Hashcat in loops.

---

## ✨ Features

✅ Lists available `.hc22000` files before starting  
✅ Potfile pre-check (skips work if already cracked)  
✅ Sequential processing (no race conditions)  
✅ Supports compressed wordlists (`.tar.gz`)  
✅ Clean session handling  
✅ Clear **CRACKED / EXHAUSTED** status output  
✅ Automatically extracts and cleans up temp files  

---

## 📦 Requirements

- Linux / macOS
- `hashcat` (v6+ recommended)
- `tar`
- Bash

Check Hashcat is installed:

bash
hashcat --version

---

## Directory Layout 
```
.
├── run-hashcat.sh
├── plist/              # Wordlists live here
│   ├── rockyou.txt
│   ├── xato_net_passwords.txt
│   └── large_lists.tar.gz
├── capture.hc22000
```
------------------
🚀 Usage

1️⃣ Make the script executable:

chmod +x run-hashcat.sh


2️⃣ Place your .hc22000 file in the same directory

3️⃣ Place wordlists inside the plist/ directory

4️⃣ Run:

./run-hashcat.sh

-----------------


