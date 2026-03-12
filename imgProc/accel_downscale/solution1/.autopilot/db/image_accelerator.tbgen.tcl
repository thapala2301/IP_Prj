set moduleName image_accelerator
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {image_accelerator}
set C_modelType { void 0 }
set C_modelArgList {
	{ video_in_V_data_V int 24 regular {axi_s 0 volatile  { video_in Data } }  }
	{ video_in_V_keep_V int 3 regular {axi_s 0 volatile  { video_in Keep } }  }
	{ video_in_V_strb_V int 3 regular {axi_s 0 volatile  { video_in Strb } }  }
	{ video_in_V_user_V int 1 regular {axi_s 0 volatile  { video_in User } }  }
	{ video_in_V_last_V int 1 regular {axi_s 0 volatile  { video_in Last } }  }
	{ video_in_V_id_V int 1 regular {axi_s 0 volatile  { video_in ID } }  }
	{ video_in_V_dest_V int 1 regular {axi_s 0 volatile  { video_in Dest } }  }
	{ video_out_V_data_V int 8 regular {axi_s 1 volatile  { video_out Data } }  }
	{ video_out_V_keep_V int 1 regular {axi_s 1 volatile  { video_out Keep } }  }
	{ video_out_V_strb_V int 1 regular {axi_s 1 volatile  { video_out Strb } }  }
	{ video_out_V_user_V int 1 regular {axi_s 1 volatile  { video_out User } }  }
	{ video_out_V_last_V int 1 regular {axi_s 1 volatile  { video_out Last } }  }
	{ video_out_V_id_V int 1 regular {axi_s 1 volatile  { video_out ID } }  }
	{ video_out_V_dest_V int 1 regular {axi_s 1 volatile  { video_out Dest } }  }
	{ in_rows int 32 regular {axi_slave 0}  }
	{ in_cols int 32 regular {axi_slave 0}  }
	{ out_rows int 32 regular {axi_slave 0}  }
	{ out_cols int 32 regular {axi_slave 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "video_in_V_data_V", "interface" : "axis", "bitwidth" : 24, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_in.V.data.V","cData": "int24","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_in_V_keep_V", "interface" : "axis", "bitwidth" : 3, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_in.V.keep.V","cData": "int3","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_in_V_strb_V", "interface" : "axis", "bitwidth" : 3, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_in.V.strb.V","cData": "int3","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_in_V_user_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_in.V.user.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_in_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_in.V.last.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_in_V_id_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_in.V.id.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_in_V_dest_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_in.V.dest.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_out_V_data_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_out.V.data.V","cData": "char","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_out_V_keep_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_out.V.keep.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_out_V_strb_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_out.V.strb.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_out_V_user_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_out.V.user.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_out_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_out.V.last.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_out_V_id_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_out.V.id.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "video_out_V_dest_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "video_out.V.dest.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "in_rows", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "in_rows","cData": "int","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":16}, "offset_end" : {"in":23}} , 
 	{ "Name" : "in_cols", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "in_cols","cData": "int","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":24}, "offset_end" : {"in":31}} , 
 	{ "Name" : "out_rows", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "out_rows","cData": "int","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":32}, "offset_end" : {"in":39}} , 
 	{ "Name" : "out_cols", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "out_cols","cData": "int","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":40}, "offset_end" : {"in":47}} ]}
# RTL Port declarations: 
set portNum 38
set portList { 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
	{ video_in_TDATA sc_in sc_lv 24 signal 0 } 
	{ video_in_TKEEP sc_in sc_lv 3 signal 1 } 
	{ video_in_TSTRB sc_in sc_lv 3 signal 2 } 
	{ video_in_TUSER sc_in sc_lv 1 signal 3 } 
	{ video_in_TLAST sc_in sc_lv 1 signal 4 } 
	{ video_in_TID sc_in sc_lv 1 signal 5 } 
	{ video_in_TDEST sc_in sc_lv 1 signal 6 } 
	{ video_out_TDATA sc_out sc_lv 8 signal 7 } 
	{ video_out_TKEEP sc_out sc_lv 1 signal 8 } 
	{ video_out_TSTRB sc_out sc_lv 1 signal 9 } 
	{ video_out_TUSER sc_out sc_lv 1 signal 10 } 
	{ video_out_TLAST sc_out sc_lv 1 signal 11 } 
	{ video_out_TID sc_out sc_lv 1 signal 12 } 
	{ video_out_TDEST sc_out sc_lv 1 signal 13 } 
	{ video_in_TVALID sc_in sc_logic 1 invld 6 } 
	{ video_in_TREADY sc_out sc_logic 1 inacc 6 } 
	{ video_out_TVALID sc_out sc_logic 1 outvld 13 } 
	{ video_out_TREADY sc_in sc_logic 1 outacc 13 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"image_accelerator","role":"start","value":"0","valid_bit":"0"},{"name":"image_accelerator","role":"continue","value":"0","valid_bit":"4"},{"name":"image_accelerator","role":"auto_start","value":"0","valid_bit":"7"},{"name":"in_rows","role":"data","value":"16"},{"name":"in_cols","role":"data","value":"24"},{"name":"out_rows","role":"data","value":"32"},{"name":"out_cols","role":"data","value":"40"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"image_accelerator","role":"start","value":"0","valid_bit":"0"},{"name":"image_accelerator","role":"done","value":"0","valid_bit":"1"},{"name":"image_accelerator","role":"idle","value":"0","valid_bit":"2"},{"name":"image_accelerator","role":"ready","value":"0","valid_bit":"3"},{"name":"image_accelerator","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "video_in_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "video_in_V_data_V", "role": "default" }} , 
 	{ "name": "video_in_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "video_in_V_keep_V", "role": "default" }} , 
 	{ "name": "video_in_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "video_in_V_strb_V", "role": "default" }} , 
 	{ "name": "video_in_TUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_in_V_user_V", "role": "default" }} , 
 	{ "name": "video_in_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_in_V_last_V", "role": "default" }} , 
 	{ "name": "video_in_TID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_in_V_id_V", "role": "default" }} , 
 	{ "name": "video_in_TDEST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_in_V_dest_V", "role": "default" }} , 
 	{ "name": "video_out_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "video_out_V_data_V", "role": "default" }} , 
 	{ "name": "video_out_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_out_V_keep_V", "role": "default" }} , 
 	{ "name": "video_out_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_out_V_strb_V", "role": "default" }} , 
 	{ "name": "video_out_TUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_out_V_user_V", "role": "default" }} , 
 	{ "name": "video_out_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_out_V_last_V", "role": "default" }} , 
 	{ "name": "video_out_TID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_out_V_id_V", "role": "default" }} , 
 	{ "name": "video_out_TDEST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "video_out_V_dest_V", "role": "default" }} , 
 	{ "name": "video_in_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "video_in_V_dest_V", "role": "default" }} , 
 	{ "name": "video_in_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "video_in_V_dest_V", "role": "default" }} , 
 	{ "name": "video_out_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "video_out_V_dest_V", "role": "default" }} , 
 	{ "name": "video_out_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "video_out_V_dest_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "11", "15", "48", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72"],
		"CDFG" : "image_accelerator",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2082245", "EstimateLatencyMax" : "2087118",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"InputProcess" : [
			{"ID" : "2", "Name" : "Block_split1_proc_U0"}],
		"OutputProcess" : [
			{"ID" : "48", "Name" : "xfMat2AXIvideo_8_0_270_480_1_U0"}],
		"Port" : [
			{"Name" : "video_in_V_data_V", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "AXIvideo2xfMat_24_9_1080_1920_1_U0", "Port" : "AXI_video_strm_V_data_V"}]},
			{"Name" : "video_in_V_keep_V", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "AXIvideo2xfMat_24_9_1080_1920_1_U0", "Port" : "AXI_video_strm_V_keep_V"}]},
			{"Name" : "video_in_V_strb_V", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "AXIvideo2xfMat_24_9_1080_1920_1_U0", "Port" : "AXI_video_strm_V_strb_V"}]},
			{"Name" : "video_in_V_user_V", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "AXIvideo2xfMat_24_9_1080_1920_1_U0", "Port" : "AXI_video_strm_V_user_V"}]},
			{"Name" : "video_in_V_last_V", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "AXIvideo2xfMat_24_9_1080_1920_1_U0", "Port" : "AXI_video_strm_V_last_V"}]},
			{"Name" : "video_in_V_id_V", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "AXIvideo2xfMat_24_9_1080_1920_1_U0", "Port" : "AXI_video_strm_V_id_V"}]},
			{"Name" : "video_in_V_dest_V", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "AXIvideo2xfMat_24_9_1080_1920_1_U0", "Port" : "AXI_video_strm_V_dest_V"}]},
			{"Name" : "video_out_V_data_V", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "48", "SubInstance" : "xfMat2AXIvideo_8_0_270_480_1_U0", "Port" : "AXI_video_strm_V_data_V"}]},
			{"Name" : "video_out_V_keep_V", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "48", "SubInstance" : "xfMat2AXIvideo_8_0_270_480_1_U0", "Port" : "AXI_video_strm_V_keep_V"}]},
			{"Name" : "video_out_V_strb_V", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "48", "SubInstance" : "xfMat2AXIvideo_8_0_270_480_1_U0", "Port" : "AXI_video_strm_V_strb_V"}]},
			{"Name" : "video_out_V_user_V", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "48", "SubInstance" : "xfMat2AXIvideo_8_0_270_480_1_U0", "Port" : "AXI_video_strm_V_user_V"}]},
			{"Name" : "video_out_V_last_V", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "48", "SubInstance" : "xfMat2AXIvideo_8_0_270_480_1_U0", "Port" : "AXI_video_strm_V_last_V"}]},
			{"Name" : "video_out_V_id_V", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "48", "SubInstance" : "xfMat2AXIvideo_8_0_270_480_1_U0", "Port" : "AXI_video_strm_V_id_V"}]},
			{"Name" : "video_out_V_dest_V", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "48", "SubInstance" : "xfMat2AXIvideo_8_0_270_480_1_U0", "Port" : "AXI_video_strm_V_dest_V"}]},
			{"Name" : "in_rows", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_cols", "Type" : "None", "Direction" : "I"},
			{"Name" : "out_rows", "Type" : "None", "Direction" : "I"},
			{"Name" : "out_cols", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.control_s_axi_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Block_split1_proc_U0", "Parent" : "0",
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
			{"Name" : "img_in_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "3", "DependentChan" : "56", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_in_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_in_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "3", "DependentChan" : "57", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_in_cols_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_gray_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "15", "DependentChan" : "58", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_gray_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_gray_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "15", "DependentChan" : "59", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_gray_cols_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_out_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "15", "DependentChan" : "60", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_out_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_out_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "15", "DependentChan" : "61", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_out_cols_out_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0", "Parent" : "0", "Child" : ["4", "5", "6", "7", "8", "9", "10"],
		"CDFG" : "AXIvideo2xfMat_24_9_1080_1920_1_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "3", "EstimateLatencyMax" : "2080084",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"StartSource" : "2",
		"StartFifo" : "start_for_AXIvideo2xfMat_24_9_1080_1920_1_U0_U",
		"Port" : [
			{"Name" : "img_in_432", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "11", "DependentChan" : "62", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "img_in_432_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "AXI_video_strm_V_data_V", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "video_in_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "AXI_video_strm_V_keep_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "AXI_video_strm_V_strb_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "AXI_video_strm_V_user_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "AXI_video_strm_V_last_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "AXI_video_strm_V_id_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "AXI_video_strm_V_dest_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "img_1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "56", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_2", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "57", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_1_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "11", "DependentChan" : "63", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_1_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_2_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "11", "DependentChan" : "64", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_2_out_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0.regslice_both_AXI_video_strm_V_data_V_U", "Parent" : "3"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0.regslice_both_AXI_video_strm_V_keep_V_U", "Parent" : "3"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0.regslice_both_AXI_video_strm_V_strb_V_U", "Parent" : "3"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0.regslice_both_AXI_video_strm_V_user_V_U", "Parent" : "3"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0.regslice_both_AXI_video_strm_V_last_V_U", "Parent" : "3"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0.regslice_both_AXI_video_strm_V_id_V_U", "Parent" : "3"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.AXIvideo2xfMat_24_9_1080_1920_1_U0.regslice_both_AXI_video_strm_V_dest_V_U", "Parent" : "3"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.rgb2gray_9_0_1080_1920_1_U0", "Parent" : "0", "Child" : ["12", "13", "14"],
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
		"StartSource" : "3",
		"StartFifo" : "start_for_rgb2gray_9_0_1080_1920_1_U0_U",
		"Port" : [
			{"Name" : "img_in_432", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "3", "DependentChan" : "62", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "img_in_432_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_gray_433", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "15", "DependentChan" : "65", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "img_gray_433_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_src_rows", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "3", "DependentChan" : "63", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_rows_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_src_cols", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "3", "DependentChan" : "64", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_cols_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.rgb2gray_9_0_1080_1920_1_U0.mul_mul_8ns_15ns_22_4_1_U30", "Parent" : "11"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.rgb2gray_9_0_1080_1920_1_U0.mac_muladd_8ns_13ns_22ns_22_4_1_U31", "Parent" : "11"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.rgb2gray_9_0_1080_1920_1_U0.mac_muladd_8ns_16ns_22ns_23_4_1_U32", "Parent" : "11"},
	{"ID" : "15", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0", "Parent" : "0", "Child" : ["16", "37"],
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
		"StartSource" : "2",
		"StartFifo" : "start_for_resize_2_0_1080_1920_270_480_1_4_U0_U",
		"Port" : [
			{"Name" : "img_gray_433", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "11", "DependentChan" : "65", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94", "Port" : "img_gray_433"},
					{"ID" : "16", "SubInstance" : "grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82", "Port" : "img_gray_433"}]},
			{"Name" : "img_out_434", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "48", "DependentChan" : "66", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94", "Port" : "img_out_434"},
					{"ID" : "16", "SubInstance" : "grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82", "Port" : "img_out_434"}]},
			{"Name" : "p_src_rows", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "58", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_rows_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_src_cols", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "59", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_src_cols_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_rows", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "60", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_rows_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_cols", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "61", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_cols_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_rows_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "48", "DependentChan" : "67", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_rows_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_dst_cols_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "48", "DependentChan" : "68", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "p_dst_cols_out_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82", "Parent" : "15", "Child" : ["17", "18", "19", "20", "21", "22", "23", "24", "26", "31", "32", "33", "34", "35", "36"],
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
	{"ID" : "17", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.lbuf_in0_V_U", "Parent" : "16"},
	{"ID" : "18", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.lbuf_in1_V_U", "Parent" : "16"},
	{"ID" : "19", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.lbuf_in2_V_U", "Parent" : "16"},
	{"ID" : "20", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Hoffset_V_U", "Parent" : "16"},
	{"ID" : "21", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Voffset_V_U", "Parent" : "16"},
	{"ID" : "22", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Hweight_U", "Parent" : "16"},
	{"ID" : "23", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.Vweight_U", "Parent" : "16"},
	{"ID" : "24", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_xFUDivAreaUp_fu_825", "Parent" : "16", "Child" : ["25"],
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
	{"ID" : "25", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_xFUDivAreaUp_fu_825.udiv_48ns_16ns_48_52_seq_1_U63", "Parent" : "24"},
	{"ID" : "26", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853", "Parent" : "16", "Child" : ["27", "28", "29", "30"],
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
	{"ID" : "27", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_32ns_64_2_0_U68", "Parent" : "26"},
	{"ID" : "28", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_10s_40_2_0_U69", "Parent" : "26"},
	{"ID" : "29", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_9s_40_2_0_U70", "Parent" : "26"},
	{"ID" : "30", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.grp_CoreProcessUpArea_fu_853.mul_32ns_9s_40_2_0_U71", "Parent" : "26"},
	{"ID" : "31", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line0_0_V_0_xfExtractPixels_1_1_0_s_fu_863", "Parent" : "16",
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
	{"ID" : "32", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line0_1_V_0_xfExtractPixels_1_1_0_s_fu_870", "Parent" : "16",
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
	{"ID" : "33", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line1_0_V_0_xfExtractPixels_1_1_0_s_fu_877", "Parent" : "16",
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
	{"ID" : "34", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.line1_1_V_0_xfExtractPixels_1_1_0_s_fu_884", "Parent" : "16",
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
	{"ID" : "35", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.mul_64s_17s_64_5_1_U81", "Parent" : "16"},
	{"ID" : "36", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaUpScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_82.mul_64s_17s_64_5_1_U82", "Parent" : "16"},
	{"ID" : "37", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94", "Parent" : "15", "Child" : ["38", "39", "40", "41", "42", "43", "44", "45", "46", "47"],
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
	{"ID" : "38", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.ouput_buffer_V_0_0_U", "Parent" : "37"},
	{"ID" : "39", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.udiv_32ns_16ns_32_36_seq_1_U40", "Parent" : "37"},
	{"ID" : "40", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.udiv_32ns_16ns_32_36_seq_1_U41", "Parent" : "37"},
	{"ID" : "41", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.udiv_32ns_16ns_32_36_seq_1_U42", "Parent" : "37"},
	{"ID" : "42", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mac_muladd_17ns_8ns_9ns_24_4_1_U43", "Parent" : "37"},
	{"ID" : "43", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mul_mul_16ns_8ns_24_4_1_U44", "Parent" : "37"},
	{"ID" : "44", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mac_muladd_16ns_17ns_17ns_32_4_1_U45", "Parent" : "37"},
	{"ID" : "45", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mul_mul_16ns_17ns_32_4_1_U46", "Parent" : "37"},
	{"ID" : "46", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mac_muladd_16ns_16ns_17ns_32_4_1_U47", "Parent" : "37"},
	{"ID" : "47", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.resize_2_0_1080_1920_270_480_1_4_U0.grp_xFResizeAreaDownScale_1080_1920_1_0_1_1_270_480_1920_480_s_fu_94.mul_mul_16ns_16ns_32_4_1_U48", "Parent" : "37"},
	{"ID" : "48", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0", "Parent" : "0", "Child" : ["49", "50", "51", "52", "53", "54", "55"],
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
		"StartSource" : "15",
		"StartFifo" : "start_for_xfMat2AXIvideo_8_0_270_480_1_U0_U",
		"Port" : [
			{"Name" : "img_out_434", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "15", "DependentChan" : "66", "DependentChanDepth" : "2", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "img_out_434_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "15", "DependentChan" : "67", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "img_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "img_2", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "15", "DependentChan" : "68", "DependentChanDepth" : "2", "DependentChanType" : "2",
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
	{"ID" : "49", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0.regslice_both_AXI_video_strm_V_data_V_U", "Parent" : "48"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0.regslice_both_AXI_video_strm_V_keep_V_U", "Parent" : "48"},
	{"ID" : "51", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0.regslice_both_AXI_video_strm_V_strb_V_U", "Parent" : "48"},
	{"ID" : "52", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0.regslice_both_AXI_video_strm_V_user_V_U", "Parent" : "48"},
	{"ID" : "53", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0.regslice_both_AXI_video_strm_V_last_V_U", "Parent" : "48"},
	{"ID" : "54", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0.regslice_both_AXI_video_strm_V_id_V_U", "Parent" : "48"},
	{"ID" : "55", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.xfMat2AXIvideo_8_0_270_480_1_U0.regslice_both_AXI_video_strm_V_dest_V_U", "Parent" : "48"},
	{"ID" : "56", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_in_rows_c_U", "Parent" : "0"},
	{"ID" : "57", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_in_cols_c_U", "Parent" : "0"},
	{"ID" : "58", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_gray_rows_c_U", "Parent" : "0"},
	{"ID" : "59", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_gray_cols_c_U", "Parent" : "0"},
	{"ID" : "60", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_out_rows_c_U", "Parent" : "0"},
	{"ID" : "61", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_out_cols_c_U", "Parent" : "0"},
	{"ID" : "62", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_in_data_U", "Parent" : "0"},
	{"ID" : "63", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_in_rows_c11_U", "Parent" : "0"},
	{"ID" : "64", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_in_cols_c12_U", "Parent" : "0"},
	{"ID" : "65", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_gray_data_U", "Parent" : "0"},
	{"ID" : "66", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_out_data_U", "Parent" : "0"},
	{"ID" : "67", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_out_rows_c13_U", "Parent" : "0"},
	{"ID" : "68", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.img_out_cols_c14_U", "Parent" : "0"},
	{"ID" : "69", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_AXIvideo2xfMat_24_9_1080_1920_1_U0_U", "Parent" : "0"},
	{"ID" : "70", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_resize_2_0_1080_1920_270_480_1_4_U0_U", "Parent" : "0"},
	{"ID" : "71", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_rgb2gray_9_0_1080_1920_1_U0_U", "Parent" : "0"},
	{"ID" : "72", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_xfMat2AXIvideo_8_0_270_480_1_U0_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	image_accelerator {
		video_in_V_data_V {Type I LastRead 6 FirstWrite -1}
		video_in_V_keep_V {Type I LastRead 6 FirstWrite -1}
		video_in_V_strb_V {Type I LastRead 6 FirstWrite -1}
		video_in_V_user_V {Type I LastRead 6 FirstWrite -1}
		video_in_V_last_V {Type I LastRead 6 FirstWrite -1}
		video_in_V_id_V {Type I LastRead 6 FirstWrite -1}
		video_in_V_dest_V {Type I LastRead 6 FirstWrite -1}
		video_out_V_data_V {Type O LastRead -1 FirstWrite 3}
		video_out_V_keep_V {Type O LastRead -1 FirstWrite 3}
		video_out_V_strb_V {Type O LastRead -1 FirstWrite 3}
		video_out_V_user_V {Type O LastRead -1 FirstWrite 3}
		video_out_V_last_V {Type O LastRead -1 FirstWrite 3}
		video_out_V_id_V {Type O LastRead -1 FirstWrite 3}
		video_out_V_dest_V {Type O LastRead -1 FirstWrite 3}
		in_rows {Type I LastRead 0 FirstWrite -1}
		in_cols {Type I LastRead 0 FirstWrite -1}
		out_rows {Type I LastRead 0 FirstWrite -1}
		out_cols {Type I LastRead 0 FirstWrite -1}}
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
		img_out_cols_out {Type O LastRead -1 FirstWrite 0}}
	AXIvideo2xfMat_24_9_1080_1920_1_s {
		img_in_432 {Type O LastRead -1 FirstWrite 5}
		AXI_video_strm_V_data_V {Type I LastRead 6 FirstWrite -1}
		AXI_video_strm_V_keep_V {Type I LastRead 6 FirstWrite -1}
		AXI_video_strm_V_strb_V {Type I LastRead 6 FirstWrite -1}
		AXI_video_strm_V_user_V {Type I LastRead 6 FirstWrite -1}
		AXI_video_strm_V_last_V {Type I LastRead 6 FirstWrite -1}
		AXI_video_strm_V_id_V {Type I LastRead 6 FirstWrite -1}
		AXI_video_strm_V_dest_V {Type I LastRead 6 FirstWrite -1}
		img_1 {Type I LastRead 0 FirstWrite -1}
		img_2 {Type I LastRead 0 FirstWrite -1}
		img_1_out {Type O LastRead -1 FirstWrite 0}
		img_2_out {Type O LastRead -1 FirstWrite 0}}
	rgb2gray_9_0_1080_1920_1_s {
		img_in_432 {Type I LastRead 3 FirstWrite -1}
		img_gray_433 {Type O LastRead -1 FirstWrite 8}
		p_src_rows {Type I LastRead 0 FirstWrite -1}
		p_src_cols {Type I LastRead 0 FirstWrite -1}}
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
		p_read3 {Type I LastRead 0 FirstWrite -1}}
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
	{"Name" : "Latency", "Min" : "2082245", "Max" : "2087118"}
	, {"Name" : "Interval", "Min" : "2082242", "Max" : "2087117"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	video_in_V_data_V { axis {  { video_in_TDATA in_data 0 24 } } }
	video_in_V_keep_V { axis {  { video_in_TKEEP in_data 0 3 } } }
	video_in_V_strb_V { axis {  { video_in_TSTRB in_data 0 3 } } }
	video_in_V_user_V { axis {  { video_in_TUSER in_data 0 1 } } }
	video_in_V_last_V { axis {  { video_in_TLAST in_data 0 1 } } }
	video_in_V_id_V { axis {  { video_in_TID in_data 0 1 } } }
	video_in_V_dest_V { axis {  { video_in_TDEST in_data 0 1 }  { video_in_TVALID in_vld 0 1 }  { video_in_TREADY in_acc 1 1 } } }
	video_out_V_data_V { axis {  { video_out_TDATA out_data 1 8 } } }
	video_out_V_keep_V { axis {  { video_out_TKEEP out_data 1 1 } } }
	video_out_V_strb_V { axis {  { video_out_TSTRB out_data 1 1 } } }
	video_out_V_user_V { axis {  { video_out_TUSER out_data 1 1 } } }
	video_out_V_last_V { axis {  { video_out_TLAST out_data 1 1 } } }
	video_out_V_id_V { axis {  { video_out_TID out_data 1 1 } } }
	video_out_V_dest_V { axis {  { video_out_TDEST out_data 1 1 }  { video_out_TVALID out_vld 1 1 }  { video_out_TREADY out_acc 0 1 } } }
}

set busDeadlockParameterList { 
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
