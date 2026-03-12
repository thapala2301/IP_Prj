set moduleName resize_2_0_1080_1920_270_480_1_4_s
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
set C_modelName {resize<2, 0, 1080, 1920, 270, 480, 1, 4>}
set C_modelType { void 0 }
set C_modelArgList {
	{ img_gray_433 int 8 regular {fifo 0 volatile }  }
	{ img_out_434 int 8 regular {fifo 1 volatile }  }
	{ p_src_rows int 32 regular {fifo 0}  }
	{ p_src_cols int 32 regular {fifo 0}  }
	{ p_dst_rows int 32 regular {fifo 0}  }
	{ p_dst_cols int 32 regular {fifo 0}  }
	{ p_dst_rows_out int 32 regular {fifo 1}  }
	{ p_dst_cols_out int 32 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "img_gray_433", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "img_out_434", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_src_rows", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_src_cols", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_dst_rows", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_dst_cols", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_dst_rows_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_dst_cols_out", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 34
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
	{ img_gray_433_dout sc_in sc_lv 8 signal 0 } 
	{ img_gray_433_empty_n sc_in sc_logic 1 signal 0 } 
	{ img_gray_433_read sc_out sc_logic 1 signal 0 } 
	{ img_out_434_din sc_out sc_lv 8 signal 1 } 
	{ img_out_434_full_n sc_in sc_logic 1 signal 1 } 
	{ img_out_434_write sc_out sc_logic 1 signal 1 } 
	{ p_src_rows_dout sc_in sc_lv 32 signal 2 } 
	{ p_src_rows_empty_n sc_in sc_logic 1 signal 2 } 
	{ p_src_rows_read sc_out sc_logic 1 signal 2 } 
	{ p_src_cols_dout sc_in sc_lv 32 signal 3 } 
	{ p_src_cols_empty_n sc_in sc_logic 1 signal 3 } 
	{ p_src_cols_read sc_out sc_logic 1 signal 3 } 
	{ p_dst_rows_dout sc_in sc_lv 32 signal 4 } 
	{ p_dst_rows_empty_n sc_in sc_logic 1 signal 4 } 
	{ p_dst_rows_read sc_out sc_logic 1 signal 4 } 
	{ p_dst_cols_dout sc_in sc_lv 32 signal 5 } 
	{ p_dst_cols_empty_n sc_in sc_logic 1 signal 5 } 
	{ p_dst_cols_read sc_out sc_logic 1 signal 5 } 
	{ p_dst_rows_out_din sc_out sc_lv 32 signal 6 } 
	{ p_dst_rows_out_full_n sc_in sc_logic 1 signal 6 } 
	{ p_dst_rows_out_write sc_out sc_logic 1 signal 6 } 
	{ p_dst_cols_out_din sc_out sc_lv 32 signal 7 } 
	{ p_dst_cols_out_full_n sc_in sc_logic 1 signal 7 } 
	{ p_dst_cols_out_write sc_out sc_logic 1 signal 7 } 
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
 	{ "name": "img_gray_433_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "img_gray_433", "role": "dout" }} , 
 	{ "name": "img_gray_433_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_433", "role": "empty_n" }} , 
 	{ "name": "img_gray_433_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_gray_433", "role": "read" }} , 
 	{ "name": "img_out_434_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "img_out_434", "role": "din" }} , 
 	{ "name": "img_out_434_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_434", "role": "full_n" }} , 
 	{ "name": "img_out_434_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "img_out_434", "role": "write" }} , 
 	{ "name": "p_src_rows_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_src_rows", "role": "dout" }} , 
 	{ "name": "p_src_rows_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_rows", "role": "empty_n" }} , 
 	{ "name": "p_src_rows_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_rows", "role": "read" }} , 
 	{ "name": "p_src_cols_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_src_cols", "role": "dout" }} , 
 	{ "name": "p_src_cols_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_cols", "role": "empty_n" }} , 
 	{ "name": "p_src_cols_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_src_cols", "role": "read" }} , 
 	{ "name": "p_dst_rows_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_dst_rows", "role": "dout" }} , 
 	{ "name": "p_dst_rows_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_rows", "role": "empty_n" }} , 
 	{ "name": "p_dst_rows_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_rows", "role": "read" }} , 
 	{ "name": "p_dst_cols_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_dst_cols", "role": "dout" }} , 
 	{ "name": "p_dst_cols_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_cols", "role": "empty_n" }} , 
 	{ "name": "p_dst_cols_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_cols", "role": "read" }} , 
 	{ "name": "p_dst_rows_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_dst_rows_out", "role": "din" }} , 
 	{ "name": "p_dst_rows_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_rows_out", "role": "full_n" }} , 
 	{ "name": "p_dst_rows_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_rows_out", "role": "write" }} , 
 	{ "name": "p_dst_cols_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_dst_cols_out", "role": "din" }} , 
 	{ "name": "p_dst_cols_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_cols_out", "role": "full_n" }} , 
 	{ "name": "p_dst_cols_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_dst_cols_out", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "22"],
		"CDFG" : "resize_2_0_1080_1920_270_480_1_4_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "251", "EstimateLatencyMax" : "2087116",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "img_gray_433", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "22", "SubInstance" : "grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94", "Port" : "img_gray_433"},
					{"ID" : "1", "SubInstance" : "grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82", "Port" : "img_gray_433"}]},
			{"Name" : "img_out_434", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "22", "SubInstance" : "grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94", "Port" : "img_out_434"},
					{"ID" : "1", "SubInstance" : "grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82", "Port" : "img_out_434"}]},
			{"Name" : "p_src_rows", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_rows_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_src_cols", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_cols_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_rows", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_rows_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_cols", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_cols_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_cols_out_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82", "Parent" : "0", "Child" : ["2", "3", "4", "5", "6", "7", "8", "9", "11", "16", "17", "18", "19", "20", "21"],
		"CDFG" : "xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "249", "EstimateLatencyMax" : "138743",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
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
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.lbuf_in0_V_U", "Parent" : "1"},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.lbuf_in1_V_U", "Parent" : "1"},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.lbuf_in2_V_U", "Parent" : "1"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Hoffset_V_U", "Parent" : "1"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Voffset_V_U", "Parent" : "1"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Hweight_U", "Parent" : "1"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Vweight_U", "Parent" : "1"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_xFUDivAreaUp_fu_825", "Parent" : "1", "Child" : ["10"],
		"CDFG" : "xFUDivAreaUp",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "52", "EstimateLatencyMax" : "52",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "in_n", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_d", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "10", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_xFUDivAreaUp_fu_825.udiv_48ns_16ns_48_52_seq_1_U63", "Parent" : "9"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853", "Parent" : "1", "Child" : ["12", "13", "14", "15"],
		"CDFG" : "CoreProcessUpArea",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "5", "EstimateLatencyMin" : "5", "EstimateLatencyMax" : "5",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "1",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "A0", "Type" : "None", "Direction" : "I"},
			{"Name" : "B0", "Type" : "None", "Direction" : "I"},
			{"Name" : "A1", "Type" : "None", "Direction" : "I"},
			{"Name" : "B1", "Type" : "None", "Direction" : "I"},
			{"Name" : "Wx", "Type" : "None", "Direction" : "I"},
			{"Name" : "Wy", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "12", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_32ns_64_2_0_U68", "Parent" : "11"},
	{"ID" : "13", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_10s_40_2_0_U69", "Parent" : "11"},
	{"ID" : "14", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_9s_40_2_0_U70", "Parent" : "11"},
	{"ID" : "15", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_9s_40_2_0_U71", "Parent" : "11"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line0_0_V_0_xfExtractPixels_1_1_0_s_fu_863", "Parent" : "1",
		"CDFG" : "xfExtractPixels_1_1_0_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "1", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "1",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line0_1_V_0_xfExtractPixels_1_1_0_s_fu_870", "Parent" : "1",
		"CDFG" : "xfExtractPixels_1_1_0_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "1", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "1",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line1_0_V_0_xfExtractPixels_1_1_0_s_fu_877", "Parent" : "1",
		"CDFG" : "xfExtractPixels_1_1_0_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "1", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "1",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line1_1_V_0_xfExtractPixels_1_1_0_s_fu_884", "Parent" : "1",
		"CDFG" : "xfExtractPixels_1_1_0_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "1", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "1",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "20", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.mul_64s_17s_64_5_1_U81", "Parent" : "1"},
	{"ID" : "21", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.mul_64s_17s_64_5_1_U82", "Parent" : "1"},
	{"ID" : "22", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94", "Parent" : "0", "Child" : ["23", "24", "25", "26", "27", "28", "29", "30", "31", "32"],
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
	{"ID" : "23", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.ouput_buffer_V_0_0_U", "Parent" : "22"},
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.udiv_32ns_16ns_32_36_seq_1_U40", "Parent" : "22"},
	{"ID" : "25", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.udiv_32ns_16ns_32_36_seq_1_U41", "Parent" : "22"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.udiv_32ns_16ns_32_36_seq_1_U42", "Parent" : "22"},
	{"ID" : "27", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mac_muladd_17ns_8ns_9ns_24_4_1_U43", "Parent" : "22"},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mul_mul_16ns_8ns_24_4_1_U44", "Parent" : "22"},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mac_muladd_16ns_17ns_17ns_32_4_1_U45", "Parent" : "22"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mul_mul_16ns_17ns_32_4_1_U46", "Parent" : "22"},
	{"ID" : "31", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mac_muladd_16ns_16ns_17ns_32_4_1_U47", "Parent" : "22"},
	{"ID" : "32", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mul_mul_16ns_16ns_32_4_1_U48", "Parent" : "22"}]}


set ArgLastReadFirstWriteLatency {
	resize_2_0_1080_1920_270_480_1_4_s {
		img_gray_433 {Type I LastRead 77 FirstWrite -1}
		img_out_434 {Type O LastRead -1 FirstWrite 28}
		p_src_rows {Type I LastRead 0 FirstWrite -1}
		p_src_cols {Type I LastRead 0 FirstWrite -1}
		p_dst_rows {Type I LastRead 0 FirstWrite -1}
		p_dst_cols {Type I LastRead 0 FirstWrite -1}
		p_dst_rows_out {Type O LastRead -1 FirstWrite 0}
		p_dst_cols_out {Type O LastRead -1 FirstWrite 0}}
	xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s {
		img_gray_433 {Type I LastRead 18 FirstWrite -1}
		img_out_434 {Type O LastRead -1 FirstWrite 28}
		p_read {Type I LastRead 1 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 1 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}}
	xFUDivAreaUp {
		in_n {Type I LastRead 0 FirstWrite -1}
		in_d {Type I LastRead 0 FirstWrite -1}}
	CoreProcessUpArea {
		A0 {Type I LastRead 0 FirstWrite -1}
		B0 {Type I LastRead 0 FirstWrite -1}
		A1 {Type I LastRead 0 FirstWrite -1}
		B1 {Type I LastRead 0 FirstWrite -1}
		Wx {Type I LastRead 0 FirstWrite -1}
		Wy {Type I LastRead 0 FirstWrite -1}}
	xfExtractPixels_1_1_0_s {
		p_read1 {Type I LastRead 0 FirstWrite -1}}
	xfExtractPixels_1_1_0_s {
		p_read1 {Type I LastRead 0 FirstWrite -1}}
	xfExtractPixels_1_1_0_s {
		p_read1 {Type I LastRead 0 FirstWrite -1}}
	xfExtractPixels_1_1_0_s {
		p_read1 {Type I LastRead 0 FirstWrite -1}}
	xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s {
		img_gray_433 {Type I LastRead 77 FirstWrite -1}
		img_out_434 {Type O LastRead -1 FirstWrite 85}
		p_read {Type I LastRead 35 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 35 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "251", "Max" : "2087116"}
	, {"Name" : "Interval", "Min" : "251", "Max" : "2087116"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	img_gray_433 { ap_fifo {  { img_gray_433_dout fifo_data 0 8 }  { img_gray_433_empty_n fifo_status 0 1 }  { img_gray_433_read fifo_update 1 1 } } }
	img_out_434 { ap_fifo {  { img_out_434_din fifo_data 1 8 }  { img_out_434_full_n fifo_status 0 1 }  { img_out_434_write fifo_update 1 1 } } }
	p_src_rows { ap_fifo {  { p_src_rows_dout fifo_data 0 32 }  { p_src_rows_empty_n fifo_status 0 1 }  { p_src_rows_read fifo_update 1 1 } } }
	p_src_cols { ap_fifo {  { p_src_cols_dout fifo_data 0 32 }  { p_src_cols_empty_n fifo_status 0 1 }  { p_src_cols_read fifo_update 1 1 } } }
	p_dst_rows { ap_fifo {  { p_dst_rows_dout fifo_data 0 32 }  { p_dst_rows_empty_n fifo_status 0 1 }  { p_dst_rows_read fifo_update 1 1 } } }
	p_dst_cols { ap_fifo {  { p_dst_cols_dout fifo_data 0 32 }  { p_dst_cols_empty_n fifo_status 0 1 }  { p_dst_cols_read fifo_update 1 1 } } }
	p_dst_rows_out { ap_fifo {  { p_dst_rows_out_din fifo_data 1 32 }  { p_dst_rows_out_full_n fifo_status 0 1 }  { p_dst_rows_out_write fifo_update 1 1 } } }
	p_dst_cols_out { ap_fifo {  { p_dst_cols_out_din fifo_data 1 32 }  { p_dst_cols_out_full_n fifo_status 0 1 }  { p_dst_cols_out_write fifo_update 1 1 } } }
}
