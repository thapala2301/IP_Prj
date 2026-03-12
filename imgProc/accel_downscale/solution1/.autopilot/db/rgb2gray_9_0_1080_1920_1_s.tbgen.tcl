set moduleName rgb2gray_9_0_1080_1920_1_s
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
set C_modelName {rgb2gray<9, 0, 1080, 1920, 1>}
set C_modelType { void 0 }
set C_modelArgList {
	{ img_in_432 int 24 regular {fifo 0 volatile }  }
	{ img_gray_433 int 8 regular {fifo 1 volatile }  }
	{ p_src_rows int 32 regular {fifo 0}  }
	{ p_src_cols int 32 regular {fifo 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "img_in_432", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "img_gray_433", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_src_rows", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_src_cols", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 19
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ img_in_432_dout sc_in sc_lv 24 signal 0 } 
	{ img_in_432_empty_n sc_in sc_logic 1 signal 0 } 
	{ img_in_432_read sc_out sc_logic 1 signal 0 } 
	{ img_gray_433_din sc_out sc_lv 8 signal 1 } 
	{ img_gray_433_full_n sc_in sc_logic 1 signal 1 } 
	{ img_gray_433_write sc_out sc_logic 1 signal 1 } 
	{ p_src_rows_dout sc_in sc_lv 32 signal 2 } 
	{ p_src_rows_empty_n sc_in sc_logic 1 signal 2 } 
	{ p_src_rows_read sc_out sc_logic 1 signal 2 } 
	{ p_src_cols_dout sc_in sc_lv 32 signal 3 } 
	{ p_src_cols_empty_n sc_in sc_logic 1 signal 3 } 
	{ p_src_cols_read sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "img_in_432_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "img_in_432", "role": "dout" }} , 
 	{ "name": "img_in_432_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_in_432", "role": "empty_n" }} , 
 	{ "name": "img_in_432_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_in_432", "role": "read" }} , 
 	{ "name": "img_gray_433_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "img_gray_433", "role": "din" }} , 
 	{ "name": "img_gray_433_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_433", "role": "full_n" }} , 
 	{ "name": "img_gray_433_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_433", "role": "write" }} , 
 	{ "name": "p_src_rows_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_src_rows", "role": "dout" }} , 
 	{ "name": "p_src_rows_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_rows", "role": "empty_n" }} , 
 	{ "name": "p_src_rows_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_rows", "role": "read" }} , 
 	{ "name": "p_src_cols_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_src_cols", "role": "dout" }} , 
 	{ "name": "p_src_cols_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_cols", "role": "empty_n" }} , 
 	{ "name": "p_src_cols_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_cols", "role": "read" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3"],
		"CDFG" : "rgb2gray_9_0_1080_1920_1_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2082241", "EstimateLatencyMax" : "2082241",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "img_in_432", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "img_in_432_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_gray_433", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "img_gray_433_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_src_rows", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_rows_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_src_cols", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_cols_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_8ns_15ns_22_4_1_U30", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_13ns_22ns_22_4_1_U31", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_16ns_22ns_23_4_1_U32", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	rgb2gray_9_0_1080_1920_1_s {
		img_in_432 {Type I LastRead 3 FirstWrite -1}
		img_gray_433 {Type O LastRead -1 FirstWrite 8}
		p_src_rows {Type I LastRead 0 FirstWrite -1}
		p_src_cols {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2082241", "Max" : "2082241"}
	, {"Name" : "Interval", "Min" : "2082241", "Max" : "2082241"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	img_in_432 { ap_fifo {  { img_in_432_dout fifo_data 0 24 }  { img_in_432_empty_n fifo_status 0 1 }  { img_in_432_read fifo_update 1 1 } } }
	img_gray_433 { ap_fifo {  { img_gray_433_din fifo_data 1 8 }  { img_gray_433_full_n fifo_status 0 1 }  { img_gray_433_write fifo_update 1 1 } } }
	p_src_rows { ap_fifo {  { p_src_rows_dout fifo_data 0 32 }  { p_src_rows_empty_n fifo_status 0 1 }  { p_src_rows_read fifo_update 1 1 } } }
	p_src_cols { ap_fifo {  { p_src_cols_dout fifo_data 0 32 }  { p_src_cols_empty_n fifo_status 0 1 }  { p_src_cols_read fifo_update 1 1 } } }
}
