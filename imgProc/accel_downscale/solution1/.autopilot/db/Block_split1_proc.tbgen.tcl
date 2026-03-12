set moduleName Block_split1_proc
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 1
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {Block_.split1_proc}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_rows int 32 regular  }
	{ in_cols int 32 regular  }
	{ out_rows int 32 regular  }
	{ out_cols int 32 regular  }
	{ img_in_rows_out int 32 regular {fifo 1}  }
	{ img_in_cols_out int 32 regular {fifo 1}  }
	{ img_gray_rows_out int 32 regular {fifo 1}  }
	{ img_gray_cols_out int 32 regular {fifo 1}  }
	{ img_out_rows_out int 32 regular {fifo 1}  }
	{ img_out_cols_out int 32 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_rows", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_cols", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "out_rows", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "out_cols", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "img_in_rows_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "img_in_cols_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "img_gray_rows_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "img_gray_cols_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "img_out_rows_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "img_out_cols_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 32
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ in_rows sc_in sc_lv 32 signal 0 } 
	{ in_cols sc_in sc_lv 32 signal 1 } 
	{ out_rows sc_in sc_lv 32 signal 2 } 
	{ out_cols sc_in sc_lv 32 signal 3 } 
	{ img_in_rows_out_din sc_out sc_lv 32 signal 4 } 
	{ img_in_rows_out_full_n sc_in sc_logic 1 signal 4 } 
	{ img_in_rows_out_write sc_out sc_logic 1 signal 4 } 
	{ img_in_cols_out_din sc_out sc_lv 32 signal 5 } 
	{ img_in_cols_out_full_n sc_in sc_logic 1 signal 5 } 
	{ img_in_cols_out_write sc_out sc_logic 1 signal 5 } 
	{ img_gray_rows_out_din sc_out sc_lv 32 signal 6 } 
	{ img_gray_rows_out_full_n sc_in sc_logic 1 signal 6 } 
	{ img_gray_rows_out_write sc_out sc_logic 1 signal 6 } 
	{ img_gray_cols_out_din sc_out sc_lv 32 signal 7 } 
	{ img_gray_cols_out_full_n sc_in sc_logic 1 signal 7 } 
	{ img_gray_cols_out_write sc_out sc_logic 1 signal 7 } 
	{ img_out_rows_out_din sc_out sc_lv 32 signal 8 } 
	{ img_out_rows_out_full_n sc_in sc_logic 1 signal 8 } 
	{ img_out_rows_out_write sc_out sc_logic 1 signal 8 } 
	{ img_out_cols_out_din sc_out sc_lv 32 signal 9 } 
	{ img_out_cols_out_full_n sc_in sc_logic 1 signal 9 } 
	{ img_out_cols_out_write sc_out sc_logic 1 signal 9 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "in_rows", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_rows", "role": "default" }} , 
 	{ "name": "in_cols", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_cols", "role": "default" }} , 
 	{ "name": "out_rows", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_rows", "role": "default" }} , 
 	{ "name": "out_cols", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_cols", "role": "default" }} , 
 	{ "name": "img_in_rows_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_in_rows_out", "role": "din" }} , 
 	{ "name": "img_in_rows_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_in_rows_out", "role": "full_n" }} , 
 	{ "name": "img_in_rows_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_in_rows_out", "role": "write" }} , 
 	{ "name": "img_in_cols_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_in_cols_out", "role": "din" }} , 
 	{ "name": "img_in_cols_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_in_cols_out", "role": "full_n" }} , 
 	{ "name": "img_in_cols_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_in_cols_out", "role": "write" }} , 
 	{ "name": "img_gray_rows_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_gray_rows_out", "role": "din" }} , 
 	{ "name": "img_gray_rows_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_rows_out", "role": "full_n" }} , 
 	{ "name": "img_gray_rows_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_rows_out", "role": "write" }} , 
 	{ "name": "img_gray_cols_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_gray_cols_out", "role": "din" }} , 
 	{ "name": "img_gray_cols_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_cols_out", "role": "full_n" }} , 
 	{ "name": "img_gray_cols_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_cols_out", "role": "write" }} , 
 	{ "name": "img_out_rows_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_out_rows_out", "role": "din" }} , 
 	{ "name": "img_out_rows_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_rows_out", "role": "full_n" }} , 
 	{ "name": "img_out_rows_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_rows_out", "role": "write" }} , 
 	{ "name": "img_out_cols_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_out_cols_out", "role": "din" }} , 
 	{ "name": "img_out_cols_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_cols_out", "role": "full_n" }} , 
 	{ "name": "img_out_cols_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_cols_out", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "",
		"CDFG" : "Block_split1_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "in_rows", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_cols", "Type" : "None", "Direction" : "I"},
			{"Name" : "out_rows", "Type" : "None", "Direction" : "I"},
			{"Name" : "out_cols", "Type" : "None", "Direction" : "I"},
			{"Name" : "img_in_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_in_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_in_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_in_cols_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_gray_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_gray_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_gray_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_gray_cols_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_out_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_out_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_out_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_out_cols_out_blk_n", "Type" : "RtlSignal"}]}]}]}


set ArgLastReadFirstWriteLatency {
	Block_split1_proc {
		in_rows {Type I LastRead 0 FirstWrite -1}
		in_cols {Type I LastRead 0 FirstWrite -1}
		out_rows {Type I LastRead 0 FirstWrite -1}
		out_cols {Type I LastRead 0 FirstWrite -1}
		img_in_rows_out {Type O LastRead -1 FirstWrite 0}
		img_in_cols_out {Type O LastRead -1 FirstWrite 0}
		img_gray_rows_out {Type O LastRead -1 FirstWrite 0}
		img_gray_cols_out {Type O LastRead -1 FirstWrite 0}
		img_out_rows_out {Type O LastRead -1 FirstWrite 0}
		img_out_cols_out {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "0", "Max" : "0"}
	, {"Name" : "Interval", "Min" : "0", "Max" : "0"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_rows { ap_none {  { in_rows in_data 0 32 } } }
	in_cols { ap_none {  { in_cols in_data 0 32 } } }
	out_rows { ap_none {  { out_rows in_data 0 32 } } }
	out_cols { ap_none {  { out_cols in_data 0 32 } } }
	img_in_rows_out { ap_fifo {  { img_in_rows_out_din fifo_data 1 32 }  { img_in_rows_out_full_n fifo_status 0 1 }  { img_in_rows_out_write fifo_update 1 1 } } }
	img_in_cols_out { ap_fifo {  { img_in_cols_out_din fifo_data 1 32 }  { img_in_cols_out_full_n fifo_status 0 1 }  { img_in_cols_out_write fifo_update 1 1 } } }
	img_gray_rows_out { ap_fifo {  { img_gray_rows_out_din fifo_data 1 32 }  { img_gray_rows_out_full_n fifo_status 0 1 }  { img_gray_rows_out_write fifo_update 1 1 } } }
	img_gray_cols_out { ap_fifo {  { img_gray_cols_out_din fifo_data 1 32 }  { img_gray_cols_out_full_n fifo_status 0 1 }  { img_gray_cols_out_write fifo_update 1 1 } } }
	img_out_rows_out { ap_fifo {  { img_out_rows_out_din fifo_data 1 32 }  { img_out_rows_out_full_n fifo_status 0 1 }  { img_out_rows_out_write fifo_update 1 1 } } }
	img_out_cols_out { ap_fifo {  { img_out_cols_out_din fifo_data 1 32 }  { img_out_cols_out_full_n fifo_status 0 1 }  { img_out_cols_out_write fifo_update 1 1 } } }
}
