# Automat SGR - Microcontroller Project

---

## 📜 Description

The **SGR-Automat** implemented on the 8086 microprocessor simulates a recycling machine for metal, plastic, and glass containers.  
The program allows the user to:

- Enter the type and volume of containers  
- Validate the inputs  
- Count accepted containers  
- Release a financial guarantee based on the number of containers processed  

---

## ⚙️ Functionality

1. **Program Initialization:**  
   - Sets the data segment  
   - Displays the title message  
   - Waits for ENTER to start  

2. **Timing / Delay:**  
   - Waits 3 seconds using BIOS clock ticks  

3. **Container Input:**  
   - Reads container type (`m` = metal, `p` = plastic, `s` = glass)  
   - Reads volume (1, 3, or 5 liters)  
   - Increments valid container counter  

4. **Process Completion:**  
   - Displays total number of accepted containers  
   - Allows guarantee release with SPACE key  
   - Handles program exit  

---

## 🛠 Technical Details

- **Display Messages:** DOS `int 21h`, function `09h`  
- **Read Keyboard:** DOS `int 21h`, function `08h`  
- **Delay / Timing:** BIOS `int 1Ah` for clock ticks  
- **Input Validation:** Direct ASCII comparison  
- **Counter Management:** `inc byte ptr` for counting  
- **Program Exit:** DOS `int 21h` function `4C00h`  

---

## 💡 Optimizations Suggestions

- Table-based validation for volume/type to simplify logic  
- Hardware timer for more precise delays  
- Improved display formatting for better user interaction  

---

## 🚀 Getting Started

To run this project, you can use **VDOSPlus (DOS for Windows)**:

1. Clone the repository:  
```bash
git clone https://github.com/Aurasj/SGR-Automat
cd SGR-Automat
```

2. Open VDOSPlus.
3. Navigate to the 8086 folder (or wherever the source is):
```bash
cd 8086
```
4. Assemble the program with TASM (Turbo Assembler):
```bash
tasm sgr.asm
```
5. Link the program with TLINK:
```bash
tlink sgr.obj
```
6. Run the executable:
```bash
sgr
```
7. Follow the on-screen instructions to enter container type and volume, and see the program output

---

👨‍💻 Author

Iancu Aurelian (Github: Aurasj)

---

## 🔓 Usage

This project is free to use, modify, and share.  
Feel free to clone this repository and use it for learning or personal projects.

