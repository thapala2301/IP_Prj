// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XIMAGE_ACCELERATOR_H
#define XIMAGE_ACCELERATOR_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "ximage_accelerator_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_BaseAddress;
} XImage_accelerator_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XImage_accelerator;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XImage_accelerator_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XImage_accelerator_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XImage_accelerator_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XImage_accelerator_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XImage_accelerator_Initialize(XImage_accelerator *InstancePtr, u16 DeviceId);
XImage_accelerator_Config* XImage_accelerator_LookupConfig(u16 DeviceId);
int XImage_accelerator_CfgInitialize(XImage_accelerator *InstancePtr, XImage_accelerator_Config *ConfigPtr);
#else
int XImage_accelerator_Initialize(XImage_accelerator *InstancePtr, const char* InstanceName);
int XImage_accelerator_Release(XImage_accelerator *InstancePtr);
#endif

void XImage_accelerator_Start(XImage_accelerator *InstancePtr);
u32 XImage_accelerator_IsDone(XImage_accelerator *InstancePtr);
u32 XImage_accelerator_IsIdle(XImage_accelerator *InstancePtr);
u32 XImage_accelerator_IsReady(XImage_accelerator *InstancePtr);
void XImage_accelerator_EnableAutoRestart(XImage_accelerator *InstancePtr);
void XImage_accelerator_DisableAutoRestart(XImage_accelerator *InstancePtr);

void XImage_accelerator_Set_in_rows(XImage_accelerator *InstancePtr, u32 Data);
u32 XImage_accelerator_Get_in_rows(XImage_accelerator *InstancePtr);
void XImage_accelerator_Set_in_cols(XImage_accelerator *InstancePtr, u32 Data);
u32 XImage_accelerator_Get_in_cols(XImage_accelerator *InstancePtr);
void XImage_accelerator_Set_out_rows(XImage_accelerator *InstancePtr, u32 Data);
u32 XImage_accelerator_Get_out_rows(XImage_accelerator *InstancePtr);
void XImage_accelerator_Set_out_cols(XImage_accelerator *InstancePtr, u32 Data);
u32 XImage_accelerator_Get_out_cols(XImage_accelerator *InstancePtr);

void XImage_accelerator_InterruptGlobalEnable(XImage_accelerator *InstancePtr);
void XImage_accelerator_InterruptGlobalDisable(XImage_accelerator *InstancePtr);
void XImage_accelerator_InterruptEnable(XImage_accelerator *InstancePtr, u32 Mask);
void XImage_accelerator_InterruptDisable(XImage_accelerator *InstancePtr, u32 Mask);
void XImage_accelerator_InterruptClear(XImage_accelerator *InstancePtr, u32 Mask);
u32 XImage_accelerator_InterruptGetEnabled(XImage_accelerator *InstancePtr);
u32 XImage_accelerator_InterruptGetStatus(XImage_accelerator *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
