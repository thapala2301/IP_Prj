// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - enable ap_done interrupt (Read/Write)
//        bit 1  - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - ap_done (COR/TOW)
//        bit 1  - ap_ready (COR/TOW)
//        others - reserved
// 0x10 : Data signal of in_rows
//        bit 31~0 - in_rows[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of in_cols
//        bit 31~0 - in_cols[31:0] (Read/Write)
// 0x1c : reserved
// 0x20 : Data signal of out_rows
//        bit 31~0 - out_rows[31:0] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of out_cols
//        bit 31~0 - out_cols[31:0] (Read/Write)
// 0x2c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL       0x00
#define XIMAGE_ACCELERATOR_CONTROL_ADDR_GIE           0x04
#define XIMAGE_ACCELERATOR_CONTROL_ADDR_IER           0x08
#define XIMAGE_ACCELERATOR_CONTROL_ADDR_ISR           0x0c
#define XIMAGE_ACCELERATOR_CONTROL_ADDR_IN_ROWS_DATA  0x10
#define XIMAGE_ACCELERATOR_CONTROL_BITS_IN_ROWS_DATA  32
#define XIMAGE_ACCELERATOR_CONTROL_ADDR_IN_COLS_DATA  0x18
#define XIMAGE_ACCELERATOR_CONTROL_BITS_IN_COLS_DATA  32
#define XIMAGE_ACCELERATOR_CONTROL_ADDR_OUT_ROWS_DATA 0x20
#define XIMAGE_ACCELERATOR_CONTROL_BITS_OUT_ROWS_DATA 32
#define XIMAGE_ACCELERATOR_CONTROL_ADDR_OUT_COLS_DATA 0x28
#define XIMAGE_ACCELERATOR_CONTROL_BITS_OUT_COLS_DATA 32

