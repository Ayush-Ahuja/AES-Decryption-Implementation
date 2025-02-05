# AES-Decryption-Implementation

# **AES-128 Decryption Hardware Implementation on FPGA**   

## **Overview**  
This project implements **AES-128 decryption** in **VHDL**, designed for execution on an **FPGA (Basys3)**. The implementation follows the **standard AES decryption flow**, including the **InvSubBytes, InvShiftRows, InvMixColumns, and AddRoundKey** operations using **GF(2⁸) arithmetic**. An FSM (Finite State Machine) controls memory access, and the decrypted plaintext is displayed on a **seven-segment display**.  

## **Features**  
✅ **AES-128 decryption core** with hardware-optimized operations.  
✅ **Finite State Machine (FSM)-controlled memory access** for efficient execution.  
✅ **GF(2⁸) arithmetic operations** implemented for cryptographic processing.  
✅ **RAM/ROM integration** for key storage and efficient round key management.  
✅ **Basys3 FPGA deployment** with output visualization on a **seven-segment display**.  

## **Implementation Details**  
- **Language:** VHDL  
- **FPGA Board:** Basys3 (Xilinx Artix-7)  
- **AES Mode:** ECB (Electronic Codebook)  
- **Clock Frequency:** 100 MHz  

### **Decryption Flow**  
1️⃣ **AddRoundKey** – Initial XOR with the round key.  
2️⃣ **InvShiftRows** – Row-wise byte shifting in reverse order.  
3️⃣ **InvSubBytes** – Byte-wise substitution using an inverse S-Box.  
4️⃣ **InvMixColumns** – Column mixing using GF(2⁸) arithmetic.  
5️⃣ **AddRoundKey** – Final round key XOR to produce plaintext.  
6️⃣ **Display Output** – Decrypted plaintext is shown on the **seven-segment display**.  

## **Project Structure**  
📂 **src/** – Contains all VHDL source files.  
📂 **testbench/** – VHDL testbenches for functional verification.  
📂 **docs/** – Block diagrams, explanations, and technical documentation.  
📂 **bitstream/** – FPGA bitstream files for direct deployment.  

## **Applications**  
🔹 **Secure embedded systems** – Hardware-accelerated decryption for IoT & security applications.  
🔹 **Cryptographic accelerators** – Optimized decryption for **secure communication protocols**.  
🔹 **FPGA-based security research** – Exploration of **hardware-optimized cryptographic primitives**.  

## **Future Enhancements**  
🚀 Support for **AES-192 & AES-256 decryption**.  
🚀 Implementation of **CBC, GCM, and CTR encryption modes**.  
🚀 **Side-channel attack resistance** (e.g., power analysis countermeasures).   

## **References**  
📄 AES Standard: [FIPS-197](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)  
📄 Xilinx FPGA Docs: [Xilinx Artix-7 Reference](https://www.xilinx.com/products/silicon-devices/fpga/artix-7.html)  

---

This README provides **clear explanations, setup instructions, and future work**, making it ideal for GitHub. Let me know if you want to modify anything! 🚀
