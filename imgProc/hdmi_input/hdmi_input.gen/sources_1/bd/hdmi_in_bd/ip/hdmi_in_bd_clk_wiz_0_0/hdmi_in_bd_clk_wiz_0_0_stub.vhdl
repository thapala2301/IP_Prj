-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Thu Feb 26 17:34:15 2026
-- Host        : Archit-Vivobook running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/imgProc/hdmi_input/hdmi_input.gen/sources_1/bd/hdmi_in_bd/ip/hdmi_in_bd_clk_wiz_0_0/hdmi_in_bd_clk_wiz_0_0_stub.vhdl
-- Design      : hdmi_in_bd_clk_wiz_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hdmi_in_bd_clk_wiz_0_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end hdmi_in_bd_clk_wiz_0_0;

architecture stub of hdmi_in_bd_clk_wiz_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,locked,clk_in1";
begin
end;
