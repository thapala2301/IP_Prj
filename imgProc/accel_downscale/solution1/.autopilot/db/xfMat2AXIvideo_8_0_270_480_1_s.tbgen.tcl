set moduleName xfMat2AXIvideo_8_0_270_480_1_s
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
set C_modelName {xfMat2AXIvideo<8, 0, 270, 480, 1>}
set C_modelType { void 0 }
set C_modelArgList {
	{ img_out_434 int 8 regular {fifo 0 volatile }  }
	{ img_1 int 32 regular {fifo 0}  }
	{ img_2 int 32 regular {fifo 0}  }
	{ AXI_video_strm_V_data_V int 8 regular {axi_s 1 volatile  { video_out Data } }  }
	{ AXI_video_strm_V_keep_V int 1 regular {axi_s 1 volatile  { video_out Keep } }  }
	{ AXI_video_strm_V_strb_V int 1 regular {axi_s 1 volatile  { video_out Strb } }  }
	{ AXI_video_strm_V_user_V int 1 regular {axi_s 1 volatile  { video_out User } }  }
	{ AXI_video_strm_V_last_V int 1 regular {axi_s 1 volatile  { video_out Last } }  }
	{ AXI_video_strm_V_id_V int 1 regular {axi_s 1 volatile  { video_out ID } }  }
	{ AXI_video_strm_V_dest_V int 1 regular {axi_s 1 volatile  { video_out Dest } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "img_out_434", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "img_1", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "img_2", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "AXI_video_strm_V_data_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "AXI_video_strm_V_keep_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "AXI_video_strm_V_strb_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "AXI_video_strm_V_user_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "AXI_video_strm_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "AXI_video_strm_V_id_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "AXI_video_strm_V_dest_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 25
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ img_out_434_dout sc_in sc_lv 8 signal 0 } 
	{ img_out_434_empty_n sc_in sc_logic 1 signal 0 } 
	{ img_out_434_read sc_out sc_logic 1 signal 0 } 
	{ img_1_dout sc_in sc_lv 32 signal 1 } 
	{ img_1_empty_n sc_in sc_logic 1 signal 1 } 
	{ img_1_read sc_out sc_logic 1 signal 1 } 
	{ img_2_dout sc_in sc_lv 32 signal 2 } 
	{ img_2_empty_n sc_in sc_logic 1 signal 2 } 
	{ img_2_read sc_out sc_logic 1 signal 2 } 
	{ video_out_TDATA sc_out sc_lv 8 signal 3 } 
	{ video_out_TVALID sc_out sc_logic 1 outvld 9 } 
	{ video_out_TREADY sc_in sc_logic 1 outacc 9 } 
	{ video_out_TKEEP sc_out sc_lv 1 signal 4 } 
	{ video_out_TSTRB sc_out sc_lv 1 signal 5 } 
	{ video_out_TUSER sc_out sc_lv 1 signal 6 } 
	{ video_out_TLAST sc_out sc_lv 1 signal 7 } 
	{ video_out_TID sc_out sc_lv 1 signal 8 } 
	{ video_out_TDEST sc_out sc_lv 1 signal 9 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "img_out_434_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "img_out_434", "role": "dout" }} , 
 	{ "name": "img_out_434_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_434", "role": "empty_n" }} , 
 	{ "name": "img_out_434_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_434", "role": "read" }} , 
 	{ "name": "img_1_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_1", "role": "dout" }} , 
 	{ "name": "img_1_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_1", "role": "empty_n" }} , 
 	{ "name": "img_1_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_1", "role": "read" }} , 
 	{ "name": "img_2_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "img_2", "role": "dout" }} , 
 	{ "name": "img_2_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_2", "role": "empty_n" }} , 
 	{ "name": "img_2_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_2", "role": "read" }} , 
 	{ "name": "video_out_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "AXI_video_strm_V_data_V", "role": "default" }} , 
 	{ "name": "video_out_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "AXI_video_strm_V_dest_V", "role": "default" }} , 
 	{ "name": "video_out_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "AXI_video_strm_V_dest_V", "role": "default" }} , 
 	{ "name": "video_out_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "AXI_video_strm_V_keep_V", "role": "default" }} , 
 	{ "name": "video_out_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "AXI_video_strm_V_strb_V", "role": "default" }} , 
 	{ "name": "video_out_TUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "AXI_video_strm_V_user_V", "role": "default" }} , 
 	{ "name": "video_out_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "AXI_video_strm_V_last_V", "role": "default" }} , 
 	{ "name": "video_out_TID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "AXI_video_strm_V_id_V", "role": "default" }} , 
 	{ "name": "video_out_TDEST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "AXI_video_strm_V_dest_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7"],
		"CDFG" : "xfMat2AXIvideo_8_0_270_480_1_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "130681",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "img_out_434", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "img_out_434_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_2", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "AXI_video_strm_V_data_V", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "video_out_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "AXI_video_strm_V_keep_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "AXI_video_strm_V_strb_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "AXI_video_strm_V_user_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "AXI_video_strm_V_last_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "AXI_video_strm_V_id_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "AXI_video_strm_V_dest_V", "Type" : "Axis", "Direction" : "O"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_AXI_video_strm_V_data_V_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_AXI_video_strm_V_keep_V_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_AXI_video_strm_V_strb_V_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_AXI_video_strm_V_user_V_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_AXI_video_strm_V_last_V_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_AXI_video_strm_V_id_V_U", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_AXI_video_strm_V_dest_V_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	xfMat2AXIvideo_8_0_270_480_1_s {
		img_out_434 {Type I LastRead 3 FirstWrite -1}
		img_1 {Type I LastRead 0 FirstWrite -1}
		img_2 {Type I LastRead 0 FirstWrite -1}
		AXI_video_strm_V_data_V {Type O LastRead -1 FirstWrite 3}
		AXI_video_strm_V_keep_V {Type O LastRead -1 FirstWrite 3}
		AXI_video_strm_V_strb_V {Type O LastRead -1 FirstWrite 3}
		AXI_video_strm_V_user_V {Type O LastRead -1 FirstWrite 3}
		AXI_video_strm_V_last_V {Type O LastRead -1 FirstWrite 3}
		AXI_video_strm_V_id_V {Type O LastRead -1 FirstWrite 3}
		AXI_video_strm_V_dest_V {Type O LastRead -1 FirstWrite 3}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "130681"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "130681"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	img_out_434 { ap_fifo {  { img_out_434_dout fifo_data 0 8 }  { img_out_434_empty_n fifo_status 0 1 }  { img_out_434_read fifo_update 1 1 } } }
	img_1 { ap_fifo {  { img_1_dout fifo_data 0 32 }  { img_1_empty_n fifo_status 0 1 }  { img_1_read fifo_update 1 1 } } }
	img_2 { ap_fifo {  { img_2_dout fifo_data 0 32 }  { img_2_empty_n fifo_status 0 1 }  { img_2_read fifo_update 1 1 } } }
	AXI_video_strm_V_data_V { axis {  { video_out_TDATA out_data 1 8 } } }
	AXI_video_strm_V_keep_V { axis {  { video_out_TKEEP out_data 1 1 } } }
	AXI_video_strm_V_strb_V { axis {  { video_out_TSTRB out_data 1 1 } } }
	AXI_video_strm_V_user_V { axis {  { video_out_TUSER out_data 1 1 } } }
	AXI_video_strm_V_last_V { axis {  { video_out_TLAST out_data 1 1 } } }
	AXI_video_strm_V_id_V { axis {  { video_out_TID out_data 1 1 } } }
	AXI_video_strm_V_dest_V { axis {  { video_out_TVALID out_vld 1 1 }  { video_out_TREADY out_acc 0 1 }  { video_out_TDEST out_data 1 1 } } }
}
