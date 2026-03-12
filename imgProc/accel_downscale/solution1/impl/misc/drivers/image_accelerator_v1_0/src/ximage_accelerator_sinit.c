// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "ximage_accelerator.h"

extern XImage_accelerator_Config XImage_accelerator_ConfigTable[];

XImage_accelerator_Config *XImage_accelerator_LookupConfig(u16 DeviceId) {
	XImage_accelerator_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XIMAGE_ACCELERATOR_NUM_INSTANCES; Index++) {
		if (XImage_accelerator_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XImage_accelerator_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XImage_accelerator_Initialize(XImage_accelerator *InstancePtr, u16 DeviceId) {
	XImage_accelerator_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XImage_accelerator_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XImage_accelerator_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

