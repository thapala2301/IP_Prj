# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_control {
in_rows { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 16
	offset_end 23
}
in_cols { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 24
	offset_end 31
}
out_rows { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 32
	offset_end 39
}
out_cols { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 40
	offset_end 47
}
ap_start { }
ap_done { }
ap_ready { }
ap_idle { }
}
dict set axilite_register_dict control $port_control


