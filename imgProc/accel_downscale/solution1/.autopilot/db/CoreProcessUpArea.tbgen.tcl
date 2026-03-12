set moduleName CoreProcessUpArea
set isTopModule 0
set isCombinational 0
set isDatapathOnly 1
set isPipelined 1
set pipeline_type function
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {CoreProcessUpArea}
set C_modelType { int 8 }
set C_modelArgList {
	{ A0 uint 8 regular  }
	{ B0 uint 8 regular  }
	{ A1 uint 8 regular  }
	{ B1 uint 8 regular  }
	{ Wx int 32 regular  }
	{ Wy int 32 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "A0", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "B0", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "A1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "B1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "Wx", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "Wy", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "ap_return", "interface" : "wire", "bitwidth" : 8} ]}
# RTL Port declarations: 
set portNum 10
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ A0 sc_in sc_lv 8 signal 0 } 
	{ B0 sc_in sc_lv 8 signal 1 } 
	{ A1 sc_in sc_lv 8 signal 2 } 
	{ B1 sc_in sc_lv 8 signal 3 } 
	{ Wx sc_in sc_lv 32 signal 4 } 
	{ Wy sc_in sc_lv 32 signal 5 } 
	{ ap_return sc_out sc_lv 8 signal -1 } 
	{ ap_ce sc_in sc_logic 1 ce -1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "A0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "A0", "role": "default" }} , 
 	{ "name": "B0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "B0", "role": "default" }} , 
 	{ "name": "A1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "A1", "role": "default" }} , 
 	{ "name": "B1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "B1", "role": "default" }} , 
 	{ "name": "Wx", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "Wx", "role": "default" }} , 
 	{ "name": "Wy", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "Wy", "role": "default" }} , 
 	{ "name": "ap_return", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "ap_return", "role": "default" }} , 
 	{ "name": "ap_ce", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "ce", "bundle":{"name": "ap_ce", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4"],
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
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_32ns_32ns_64_2_0_U68", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_32ns_10s_40_2_0_U69", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_32ns_9s_40_2_0_U70", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_32ns_9s_40_2_0_U71", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	CoreProcessUpArea {
		A0 {Type I LastRead 0 FirstWrite -1}
		B0 {Type I LastRead 0 FirstWrite -1}
		A1 {Type I LastRead 0 FirstWrite -1}
		B1 {Type I LastRead 0 FirstWrite -1}
		Wx {Type I LastRead 0 FirstWrite -1}
		Wy {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "5", "Max" : "5"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	A0 { ap_none {  { A0 in_data 0 8 } } }
	B0 { ap_none {  { B0 in_data 0 8 } } }
	A1 { ap_none {  { A1 in_data 0 8 } } }
	B1 { ap_none {  { B1 in_data 0 8 } } }
	Wx { ap_none {  { Wx in_data 0 32 } } }
	Wy { ap_none {  { Wy in_data 0 32 } } }
}
