// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "ximage_accelerator.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XImage_accelerator_CfgInitialize(XImage_accelerator *InstancePtr, XImage_accelerator_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XImage_accelerator_Start(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL) & 0x80;
    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XImage_accelerator_IsDone(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XImage_accelerator_IsIdle(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XImage_accelerator_IsReady(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XImage_accelerator_EnableAutoRestart(XImage_accelerator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XImage_accelerator_DisableAutoRestart(XImage_accelerator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_AP_CTRL, 0);
}

void XImage_accelerator_Set_in_rows(XImage_accelerator *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IN_ROWS_DATA, Data);
}

u32 XImage_accelerator_Get_in_rows(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IN_ROWS_DATA);
    return Data;
}

void XImage_accelerator_Set_in_cols(XImage_accelerator *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IN_COLS_DATA, Data);
}

u32 XImage_accelerator_Get_in_cols(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IN_COLS_DATA);
    return Data;
}

void XImage_accelerator_Set_out_rows(XImage_accelerator *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_OUT_ROWS_DATA, Data);
}

u32 XImage_accelerator_Get_out_rows(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_OUT_ROWS_DATA);
    return Data;
}

void XImage_accelerator_Set_out_cols(XImage_accelerator *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_OUT_COLS_DATA, Data);
}

u32 XImage_accelerator_Get_out_cols(XImage_accelerator *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_OUT_COLS_DATA);
    return Data;
}

void XImage_accelerator_InterruptGlobalEnable(XImage_accelerator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_GIE, 1);
}

void XImage_accelerator_InterruptGlobalDisable(XImage_accelerator *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_GIE, 0);
}

void XImage_accelerator_InterruptEnable(XImage_accelerator *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IER);
    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IER, Register | Mask);
}

void XImage_accelerator_InterruptDisable(XImage_accelerator *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IER);
    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IER, Register & (~Mask));
}

void XImage_accelerator_InterruptClear(XImage_accelerator *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_accelerator_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_ISR, Mask);
}

u32 XImage_accelerator_InterruptGetEnabled(XImage_accelerator *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_IER);
}

u32 XImage_accelerator_InterruptGetStatus(XImage_accelerator *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XImage_accelerator_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_ACCELERATOR_CONTROL_ADDR_ISR);
}

