set moduleName xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {xFResizeAreaDownScale<1080, 1920, 1, 0, 1, 1, 270, 480, 1920, 480>}
set C_modelType { void 0 }
set C_modelArgList {
	{ img_gray_433 int 8 regular {fifo 0 volatile }  }
	{ img_out_434 int 8 regular {fifo 1 volatile }  }
	{ p_read int 16 regular  }
	{ p_read1 int 16 regular  }
	{ p_read2 int 16 regular  }
	{ p_read3 int 16 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "img_gray_433", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "img_out_434", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "p_read2", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "p_read3", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 16
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ img_gray_433_dout sc_in sc_lv 8 signal 0 } 
	{ img_gray_433_empty_n sc_in sc_logic 1 signal 0 } 
	{ img_gray_433_read sc_out sc_logic 1 signal 0 } 
	{ img_out_434_din sc_out sc_lv 8 signal 1 } 
	{ img_out_434_full_n sc_in sc_logic 1 signal 1 } 
	{ img_out_434_write sc_out sc_logic 1 signal 1 } 
	{ p_read sc_in sc_lv 16 signal 2 } 
	{ p_read1 sc_in sc_lv 16 signal 3 } 
	{ p_read2 sc_in sc_lv 16 signal 4 } 
	{ p_read3 sc_in sc_lv 16 signal 5 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "img_gray_433_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "img_gray_433", "role": "dout" }} , 
 	{ "name": "img_gray_433_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_433", "role": "empty_n" }} , 
 	{ "name": "img_gray_433_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_433", "role": "read" }} , 
 	{ "name": "img_out_434_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "img_out_434", "role": "din" }} , 
 	{ "name": "img_out_434_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_434", "role": "full_n" }} , 
 	{ "name": "img_out_434_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_434", "role": "write" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "p_read2", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "p_read2", "role": "default" }} , 
 	{ "name": "p_read3", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "p_read3", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
		"CDFG" : "xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "556", "EstimateLatencyMax" : "2087114",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state84_pp1_iter8_stage0", "FromInitialIteration" : "ap_enable_reg_pp1_iter8", "FromInitialOperation" : "ap_enable_operation_462", "FromInitialSV" : "83", "FromFinalState" : "ap_enable_state85_pp1_iter9_stage0", "FromFinalIteration" : "ap_enable_reg_pp1_iter9", "FromFinalOperation" : "ap_enable_operation_507", "FromFinalSV" : "84", "FromAddress" : "ouput_buffer_V_0_0_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state86_pp1_iter10_stage0", "ToInitialIteration" : "ap_enable_reg_pp1_iter10", "ToInitialNextIteration" : "null", "ToInitialOperation" : "ap_enable_operation_517", "ToInitialSV" : "85", "ToFinalState" : "ap_enable_state86_pp1_iter10_stage0", "ToFinalIteration" : "ap_enable_reg_pp1_iter10", "ToFinalOperation" : "ap_enable_operation_517", "ToFinalSV" : "85", "ToAddress" : "ouput_buffer_V_0_0_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp1", "AddressWidth" : "9", "II" : "1", "Pragma" : "(C:/Vitis_Libraries/vision/L1/include\imgproc/xf_resize_down_area.hpp:692:115)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state84_pp1_iter8_stage0", "FromInitialIteration" : "ap_enable_reg_pp1_iter8", "FromInitialOperation" : "ap_enable_operation_462", "FromInitialSV" : "83", "FromFinalState" : "ap_enable_state85_pp1_iter9_stage0", "FromFinalIteration" : "ap_enable_reg_pp1_iter9", "FromFinalOperation" : "ap_enable_operation_507", "FromFinalSV" : "84", "FromAddress" : "ouput_buffer_V_0_0_address1", "FromType" : "R", "ToInitialState" : "ap_enable_state86_pp1_iter10_stage0", "ToInitialIteration" : "ap_enable_reg_pp1_iter10", "ToInitialNextIteration" : "null", "ToInitialOperation" : "ap_enable_operation_521", "ToInitialSV" : "85", "ToFinalState" : "ap_enable_state86_pp1_iter10_stage0", "ToFinalIteration" : "ap_enable_reg_pp1_iter10", "ToFinalOperation" : "ap_enable_operation_521", "ToFinalSV" : "85", "ToAddress" : "ouput_buffer_V_0_0_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp1", "AddressWidth" : "9", "II" : "1", "Pragma" : "(C:/Vitis_Libraries/vision/L1/include\imgproc/xf_resize_down_area.hpp:692:115)", "Type" : "WAR"},
			{"FromInitialState" : "ap_enable_state86_pp1_iter10_stage0", "FromInitialIteration" : "ap_enable_reg_pp1_iter10", "FromInitialOperation" : "ap_enable_operation_517", "FromInitialSV" : "85", "FromFinalState" : "ap_enable_state86_pp1_iter10_stage0", "FromFinalIteration" : "ap_enable_reg_pp1_iter10", "FromFinalOperation" : "ap_enable_operation_517", "FromFinalSV" : "85", "FromAddress" : "ouput_buffer_V_0_0_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state84_pp1_iter8_stage0", "ToInitialIteration" : "ap_enable_reg_pp1_iter8", "ToInitialNextIteration" : "ap_enable_reg_pp1_iter9", "ToInitialOperation" : "ap_enable_operation_462", "ToInitialSV" : "83", "ToFinalState" : "ap_enable_state85_pp1_iter9_stage0", "ToFinalIteration" : "ap_enable_reg_pp1_iter9", "ToFinalOperation" : "ap_enable_operation_507", "ToFinalSV" : "84", "ToAddress" : "ouput_buffer_V_0_0_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp1", "AddressWidth" : "9", "II" : "1", "Pragma" : "(C:/Vitis_Libraries/vision/L1/include\imgproc/xf_resize_down_area.hpp:692:115)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state84_pp1_iter8_stage0", "ap_enable_state85_pp1_iter9_stage0", "ap_enable_state86_pp1_iter10_stage0"]},
			{"FromInitialState" : "ap_enable_state86_pp1_iter10_stage0", "FromInitialIteration" : "ap_enable_reg_pp1_iter10", "FromInitialOperation" : "ap_enable_operation_517", "FromInitialSV" : "85", "FromFinalState" : "ap_enable_state86_pp1_iter10_stage0", "FromFinalIteration" : "ap_enable_reg_pp1_iter10", "FromFinalOperation" : "ap_enable_operation_517", "FromFinalSV" : "85", "FromAddress" : "ouput_buffer_V_0_0_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state86_pp1_iter10_stage0", "ToInitialIteration" : "ap_enable_reg_pp1_iter10", "ToInitialNextIteration" : "null", "ToInitialOperation" : "ap_enable_operation_521", "ToInitialSV" : "85", "ToFinalState" : "ap_enable_state86_pp1_iter10_stage0", "ToFinalIteration" : "ap_enable_reg_pp1_iter10", "ToFinalOperation" : "ap_enable_operation_521", "ToFinalSV" : "85", "ToAddress" : "ouput_buffer_V_0_0_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp1", "AddressWidth" : "9", "II" : "1", "Pragma" : "(C:/Vitis_Libraries/vision/L1/include\imgproc/xf_resize_down_area.hpp:692:115)", "Type" : "WAW"},
			{"FromInitialState" : "ap_enable_state86_pp1_iter10_stage0", "FromInitialIteration" : "ap_enable_reg_pp1_iter10", "FromInitialOperation" : "ap_enable_operation_521", "FromInitialSV" : "85", "FromFinalState" : "ap_enable_state86_pp1_iter10_stage0", "FromFinalIteration" : "ap_enable_reg_pp1_iter10", "FromFinalOperation" : "ap_enable_operation_521", "FromFinalSV" : "85", "FromAddress" : "ouput_buffer_V_0_0_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state84_pp1_iter8_stage0", "ToInitialIteration" : "ap_enable_reg_pp1_iter8", "ToInitialNextIteration" : "ap_enable_reg_pp1_iter9", "ToInitialOperation" : "ap_enable_operation_462", "ToInitialSV" : "83", "ToFinalState" : "ap_enable_state85_pp1_iter9_stage0", "ToFinalIteration" : "ap_enable_reg_pp1_iter9", "ToFinalOperation" : "ap_enable_operation_507", "ToFinalSV" : "84", "ToAddress" : "ouput_buffer_V_0_0_address1", "ToType" : "R", "PipelineBlock" : "ap_block_pp1", "AddressWidth" : "9", "II" : "1", "Pragma" : "(C:/Vitis_Libraries/vision/L1/include\imgproc/xf_resize_down_area.hpp:692:115)", "Type" : "RAW", "StateEnableSignalListForFifoShift" : ["ap_enable_state84_pp1_iter8_stage0", "ap_enable_state85_pp1_iter9_stage0", "ap_enable_state86_pp1_iter10_stage0"]},
			{"FromInitialState" : "ap_enable_state86_pp1_iter10_stage0", "FromInitialIteration" : "ap_enable_reg_pp1_iter10", "FromInitialOperation" : "ap_enable_operation_521", "FromInitialSV" : "85", "FromFinalState" : "ap_enable_state86_pp1_iter10_stage0", "FromFinalIteration" : "ap_enable_reg_pp1_iter10", "FromFinalOperation" : "ap_enable_operation_521", "FromFinalSV" : "85", "FromAddress" : "ouput_buffer_V_0_0_address0", "FromType" : "W", "ToInitialState" : "ap_enable_state86_pp1_iter10_stage0", "ToInitialIteration" : "ap_enable_reg_pp1_iter10", "ToInitialNextIteration" : "null", "ToInitialOperation" : "ap_enable_operation_517", "ToInitialSV" : "85", "ToFinalState" : "ap_enable_state86_pp1_iter10_stage0", "ToFinalIteration" : "ap_enable_reg_pp1_iter10", "ToFinalOperation" : "ap_enable_operation_517", "ToFinalSV" : "85", "ToAddress" : "ouput_buffer_V_0_0_address0", "ToType" : "W", "PipelineBlock" : "ap_block_pp1", "AddressWidth" : "9", "II" : "1", "Pragma" : "(C:/Vitis_Libraries/vision/L1/include\imgproc/xf_resize_down_area.hpp:692:115)", "Type" : "WAW"}],
		"Port" : [
			{"Name" : "img_gray_433", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "img_gray_433_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_out_434", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "img_out_434_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.ouput_buffer_V_0_0_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_32ns_16ns_32_36_seq_1_U40", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_32ns_16ns_32_36_seq_1_U41", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_32ns_16ns_32_36_seq_1_U42", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_17ns_8ns_9ns_24_4_1_U43", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_16ns_8ns_24_4_1_U44", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16ns_17ns_17ns_32_4_1_U45", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_16ns_17ns_32_4_1_U46", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16ns_16ns_17ns_32_4_1_U47", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_16ns_16ns_32_4_1_U48", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s {
		img_gray_433 {Type I LastRead 77 FirstWrite -1}
		img_out_434 {Type O LastRead -1 FirstWrite 85}
		p_read {Type I LastRead 35 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 35 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "556", "Max" : "2087114"}
	, {"Name" : "Interval", "Min" : "556", "Max" : "2087114"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "1", "EnableSignal" : "ap_enable_pp1"}
]}

set Spec2ImplPortList { 
	img_gray_433 { ap_fifo {  { img_gray_433_dout fifo_data 0 8 }  { img_gray_433_empty_n fifo_status 0 1 }  { img_gray_433_read fifo_update 1 1 } } }
	img_out_434 { ap_fifo {  { img_out_434_din fifo_data 1 8 }  { img_out_434_full_n fifo_status 0 1 }  { img_out_434_write fifo_update 1 1 } } }
	p_read { ap_none {  { p_read in_data 0 16 } } }
	p_read1 { ap_none {  { p_read1 in_data 0 16 } } }
	p_read2 { ap_none {  { p_read2 in_data 0 16 } } }
	p_read3 { ap_none {  { p_read3 in_data 0 16 } } }
}
