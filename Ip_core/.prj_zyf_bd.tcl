
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku040-ffva1156-2-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:axis_dwidth_converter:1.1\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:axis_clock_converter:1.1\
xilinx.com:user:tcpip_core:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:user:spi_io:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:user:fifo_top:1.0\
xilinx.com:user:mdyFmcAd9653_top:1.0\
xilinx.com:user:trigger:1.0\
ustc:user:ddr_ctrl_top:2.1\
xilinx.com:ip:axi_bram_ctrl:4.1\
ustc:awg1.0:cpu_ram:1.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: mb_lmb
proc create_hier_cell_mb_lmb { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mb_lmb() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst LMB_Rst

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net dlmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net ilmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB] [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT]

  # Create port connections
  connect_bd_net -net LMB_Rst_1 [get_bd_pins LMB_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net Net [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_ram
proc create_hier_cell_cpu_ram { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_ram() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 cmu2cpu_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 cpu2cmu_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cpu_bram_S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cpu_ram_S_AXI


  # Create pins
  create_bd_pin -dir I cmu_clk
  create_bd_pin -dir I cmu_rstn
  create_bd_pin -dir I cpu_clk
  create_bd_pin -dir O cpu_ram_intr_o
  create_bd_pin -dir I cpu_rstn
  create_bd_pin -dir I -type rst rst

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: axis_clock_converter_1, and set properties
  set axis_clock_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_1 ]

  # Create instance: cpu_ram_0, and set properties
  set cpu_ram_0 [ create_bd_cell -type ip -vlnv ustc:awg1.0:cpu_ram:1.0 cpu_ram_0 ]
  set_property -dict [ list \
   CONFIG.DEBUG {true} \
 ] $cpu_ram_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins cpu_ram_0/bram_a]
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/M_AXIS] [get_bd_intf_pins cpu_ram_0/s_axis]
  connect_bd_intf_net -intf_net axis_clock_converter_1_M_AXIS [get_bd_intf_pins cpu2cmu_axis] [get_bd_intf_pins axis_clock_converter_1/M_AXIS]
  connect_bd_intf_net -intf_net cmu2cpu_axis_1 [get_bd_intf_pins cmu2cpu_axis] [get_bd_intf_pins axis_clock_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net cpu_bram_S_AXI_1 [get_bd_intf_pins cpu_bram_S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net cpu_ram_0_m_axis [get_bd_intf_pins axis_clock_converter_1/S_AXIS] [get_bd_intf_pins cpu_ram_0/m_axis]
  connect_bd_intf_net -intf_net cpu_ram_S_AXI_1 [get_bd_intf_pins cpu_ram_S_AXI] [get_bd_intf_pins cpu_ram_0/S_AXI]

  # Create port connections
  connect_bd_net -net cmu_clk_1 [get_bd_pins cmu_clk] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins axis_clock_converter_1/m_axis_aclk]
  connect_bd_net -net cmu_rstn_1 [get_bd_pins cmu_rstn] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins axis_clock_converter_1/m_axis_aresetn]
  connect_bd_net -net cpu_clk_1 [get_bd_pins cpu_clk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axis_clock_converter_0/m_axis_aclk] [get_bd_pins axis_clock_converter_1/s_axis_aclk] [get_bd_pins cpu_ram_0/S_AXI_aclk] [get_bd_pins cpu_ram_0/clk]
  connect_bd_net -net cpu_ram_0_intr_o [get_bd_pins cpu_ram_intr_o] [get_bd_pins cpu_ram_0/intr_o]
  connect_bd_net -net cpu_rstn_1 [get_bd_pins cpu_rstn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axis_clock_converter_0/m_axis_aresetn] [get_bd_pins axis_clock_converter_1/s_axis_aresetn] [get_bd_pins cpu_ram_0/S_AXI_aresetn]
  connect_bd_net -net rst_1 [get_bd_pins rst] [get_bd_pins cpu_ram_0/rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: MEM_TOP
proc create_hier_cell_MEM_TOP { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_MEM_TOP() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_daq2mem_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4_0


  # Create pins
  create_bd_pin -dir I c0_sys_clk_n
  create_bd_pin -dir I c0_sys_clk_p
  create_bd_pin -dir O -type clk cpu_clk
  create_bd_pin -dir I -type rst cpu_rstn
  create_bd_pin -dir I -type clk daq_clk
  create_bd_pin -dir I -type rst daq_rstn
  create_bd_pin -dir I -type clk eth_clk
  create_bd_pin -dir I -type rst eth_rstn
  create_bd_pin -dir O -type clk mem_clk
  create_bd_pin -dir O -type rst mem_rstn
  create_bd_pin -dir I -type rst sys_rst

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: axis_clock_converter_1, and set properties
  set axis_clock_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_1 ]

  # Create instance: axis_interconnect_0, and set properties
  set axis_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.ARB_ON_MAX_XFERS {0} \
   CONFIG.ARB_ON_TLAST {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_FIFO_DEPTH {32} \
   CONFIG.S01_FIFO_DEPTH {32} \
 ] $axis_interconnect_0

  # Create instance: ddr_ctrl_top_1, and set properties
  set ddr_ctrl_top_1 [ create_bd_cell -type ip -vlnv ustc:user:ddr_ctrl_top:2.1 ddr_ctrl_top_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins c0_ddr4_0] [get_bd_intf_pins ddr_ctrl_top_1/c0_ddr4]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins ddr_ctrl_top_1/S_AXI]
  connect_bd_intf_net -intf_net S_daq2mem_axis_1 [get_bd_intf_pins S_daq2mem_axis] [get_bd_intf_pins axis_clock_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/M_AXIS] [get_bd_intf_pins axis_interconnect_0/S01_AXIS]
  connect_bd_intf_net -intf_net axis_clock_converter_1_M_AXIS [get_bd_intf_pins axis_clock_converter_1/M_AXIS] [get_bd_intf_pins axis_interconnect_0/S00_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_0_M00_AXIS [get_bd_intf_pins axis_interconnect_0/M00_AXIS] [get_bd_intf_pins ddr_ctrl_top_1/S_AXIS]
  connect_bd_intf_net -intf_net ddr_ctrl_top_1_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins ddr_ctrl_top_1/M_AXIS]
  connect_bd_intf_net -intf_net udp_2_mem_process_0_m_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_clock_converter_1/S_AXIS]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins mem_clk] [get_bd_pins axis_clock_converter_0/m_axis_aclk] [get_bd_pins axis_clock_converter_1/m_axis_aclk] [get_bd_pins axis_interconnect_0/ACLK] [get_bd_pins axis_interconnect_0/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S01_AXIS_ACLK] [get_bd_pins ddr_ctrl_top_1/AXIS_ACLK] [get_bd_pins ddr_ctrl_top_1/ui_clk]
  connect_bd_net -net Net [get_bd_pins eth_clk] [get_bd_pins axis_clock_converter_1/s_axis_aclk]
  connect_bd_net -net Net1 [get_bd_pins eth_rstn] [get_bd_pins axis_clock_converter_1/s_axis_aresetn]
  connect_bd_net -net c0_sys_clk_n_1 [get_bd_pins c0_sys_clk_n] [get_bd_pins ddr_ctrl_top_1/c0_sys_clk_n]
  connect_bd_net -net c0_sys_clk_p_1 [get_bd_pins c0_sys_clk_p] [get_bd_pins ddr_ctrl_top_1/c0_sys_clk_p]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins cpu_clk] [get_bd_pins ddr_ctrl_top_1/S_AXI_aclk] [get_bd_pins ddr_ctrl_top_1/cpu_clk]
  connect_bd_net -net daq_clk_1 [get_bd_pins daq_clk] [get_bd_pins axis_clock_converter_0/s_axis_aclk]
  connect_bd_net -net daq_rstn_1 [get_bd_pins daq_rstn] [get_bd_pins axis_clock_converter_0/s_axis_aresetn]
  connect_bd_net -net ddr_ctrl_top_0_ui_rst_n [get_bd_pins mem_rstn] [get_bd_pins axis_clock_converter_0/m_axis_aresetn] [get_bd_pins axis_clock_converter_1/m_axis_aresetn] [get_bd_pins axis_interconnect_0/ARESETN] [get_bd_pins axis_interconnect_0/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S01_AXIS_ARESETN] [get_bd_pins ddr_ctrl_top_1/AXIS_ARESETN] [get_bd_pins ddr_ctrl_top_1/ui_rst_n]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins cpu_rstn] [get_bd_pins ddr_ctrl_top_1/S_AXI_aresetn]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_reset [get_bd_pins sys_rst] [get_bd_pins ddr_ctrl_top_1/sys_rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DAQ_TOP
proc create_hier_cell_DAQ_TOP { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DAQ_TOP() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_DAQ

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_rd_axis


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 AD1_CSB
  create_bd_pin -dir O -from 0 -to 0 ADC_SCLK
  create_bd_pin -dir O -from 0 -to 0 ADC_SDIO
  create_bd_pin -dir I -from 0 -to 0 CLK_200M_N
  create_bd_pin -dir I -from 0 -to 0 CLK_200M_P
  create_bd_pin -dir I -from 0 -to 0 EXT_PLL_LOCK
  create_bd_pin -dir O -from 0 -to 0 F_CLK_SEL
  create_bd_pin -dir O -from 3 -to 0 LED
  create_bd_pin -dir I -from 0 -to 0 PLL_CLK_N
  create_bd_pin -dir I -from 0 -to 0 PLL_CLK_P
  create_bd_pin -dir O -from 0 -to 0 PLL_CS
  create_bd_pin -dir O -from 0 -to 0 PLL_RESETN
  create_bd_pin -dir O -from 0 -to 0 PLL_SCLK
  create_bd_pin -dir O -from 0 -to 0 PLL_SDIO
  create_bd_pin -dir I -from 0 -to 0 PLL_SDO
  create_bd_pin -dir I -from 9 -to 0 ad9653_ifc_n_0
  create_bd_pin -dir I -from 9 -to 0 ad9653_ifc_p_0
  create_bd_pin -dir O -from 0 -to 0 adc_sync_0
  create_bd_pin -dir I cpu_clk
  create_bd_pin -dir I cpu_rstn
  create_bd_pin -dir O -from 0 -to 0 daq_clk
  create_bd_pin -dir O -from 0 -to 0 daq_rstn
  create_bd_pin -dir I external_trig_0
  create_bd_pin -dir I -type rst reset

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]

  # Create instance: fifo_top_0, and set properties
  set fifo_top_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:fifo_top:1.0 fifo_top_0 ]

  # Create instance: mdyFmcAd9653_top_0, and set properties
  set mdyFmcAd9653_top_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:mdyFmcAd9653_top:1.0 mdyFmcAd9653_top_0 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: trigger_0, and set properties
  set trigger_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:trigger:1.0 trigger_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_DAQ_1 [get_bd_intf_pins S_AXI_DAQ] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins trigger_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins fifo_top_0/S_AXI]
  connect_bd_intf_net -intf_net fifo_top_0_rd_axis [get_bd_intf_pins m_rd_axis] [get_bd_intf_pins fifo_top_0/rd_axis]
  connect_bd_intf_net -intf_net trigger_0_M_AXI [get_bd_intf_pins fifo_top_0/trigger_axis] [get_bd_intf_pins trigger_0/M_AXI]

  # Create port connections
  connect_bd_net -net CLK_200M_N_1 [get_bd_pins CLK_200M_N] [get_bd_pins mdyFmcAd9653_top_0/CLK_200M_N]
  connect_bd_net -net CLK_200M_P_1 [get_bd_pins CLK_200M_P] [get_bd_pins mdyFmcAd9653_top_0/CLK_200M_P]
  connect_bd_net -net EXT_PLL_LOCK_1 [get_bd_pins EXT_PLL_LOCK] [get_bd_pins mdyFmcAd9653_top_0/EXT_PLL_LOCK]
  connect_bd_net -net PLL_CLK_N_1 [get_bd_pins PLL_CLK_N] [get_bd_pins mdyFmcAd9653_top_0/PLL_CLK_N]
  connect_bd_net -net PLL_CLK_P_1 [get_bd_pins PLL_CLK_P] [get_bd_pins mdyFmcAd9653_top_0/PLL_CLK_P]
  connect_bd_net -net PLL_SDO_1 [get_bd_pins PLL_SDO] [get_bd_pins mdyFmcAd9653_top_0/PLL_SDO]
  connect_bd_net -net ad9653_ifc_n_0_1 [get_bd_pins ad9653_ifc_n_0] [get_bd_pins mdyFmcAd9653_top_0/ad9653_ifc_n]
  connect_bd_net -net ad9653_ifc_p_0_1 [get_bd_pins ad9653_ifc_p_0] [get_bd_pins mdyFmcAd9653_top_0/ad9653_ifc_p]
  connect_bd_net -net cpu_clk_1 [get_bd_pins cpu_clk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins fifo_top_0/S_AXI_aclk] [get_bd_pins trigger_0/S_AXI_aclk]
  connect_bd_net -net cpu_rstn_1 [get_bd_pins cpu_rstn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins fifo_top_0/S_AXI_aresetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins trigger_0/S_AXI_aresetn]
  connect_bd_net -net external_trig_0_1 [get_bd_pins external_trig_0] [get_bd_pins trigger_0/external_trig]
  connect_bd_net -net mdyFmcAd9653_top_0_AD1_CSB [get_bd_pins AD1_CSB] [get_bd_pins mdyFmcAd9653_top_0/AD1_CSB]
  connect_bd_net -net mdyFmcAd9653_top_0_ADC_SCLK [get_bd_pins ADC_SCLK] [get_bd_pins mdyFmcAd9653_top_0/ADC_SCLK]
  connect_bd_net -net mdyFmcAd9653_top_0_ADC_SDIO [get_bd_pins ADC_SDIO] [get_bd_pins mdyFmcAd9653_top_0/ADC_SDIO]
  connect_bd_net -net mdyFmcAd9653_top_0_ADC_SYNC [get_bd_pins adc_sync_0] [get_bd_pins mdyFmcAd9653_top_0/ADC_SYNC]
  connect_bd_net -net mdyFmcAd9653_top_0_F_CLK_SEL [get_bd_pins F_CLK_SEL] [get_bd_pins mdyFmcAd9653_top_0/F_CLK_SEL]
  connect_bd_net -net mdyFmcAd9653_top_0_LED [get_bd_pins LED] [get_bd_pins mdyFmcAd9653_top_0/LED]
  connect_bd_net -net mdyFmcAd9653_top_0_PLL_CS [get_bd_pins PLL_CS] [get_bd_pins mdyFmcAd9653_top_0/PLL_CS]
  connect_bd_net -net mdyFmcAd9653_top_0_PLL_RESETN [get_bd_pins PLL_RESETN] [get_bd_pins mdyFmcAd9653_top_0/PLL_RESETN]
  connect_bd_net -net mdyFmcAd9653_top_0_PLL_SCLK [get_bd_pins PLL_SCLK] [get_bd_pins mdyFmcAd9653_top_0/PLL_SCLK]
  connect_bd_net -net mdyFmcAd9653_top_0_PLL_SDIO [get_bd_pins PLL_SDIO] [get_bd_pins mdyFmcAd9653_top_0/PLL_SDIO]
  connect_bd_net -net mdyFmcAd9653_top_0_clk_125M [get_bd_pins daq_clk] [get_bd_pins fifo_top_0/clk] [get_bd_pins mdyFmcAd9653_top_0/clk_125M] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins trigger_0/clk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins daq_rstn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins fifo_top_0/rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CPU_TOP
proc create_hier_cell_CPU_TOP { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_CPU_TOP() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO2_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M10_AXI_DAQ

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 cmu2cpu_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 cpu2cmu_axis


  # Create pins
  create_bd_pin -dir I cmu_clk
  create_bd_pin -dir I cmu_rstn
  create_bd_pin -dir I -type clk cpu_clk
  create_bd_pin -dir O -from 0 -to 0 -type rst cpu_rstn
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 2 -to 0 gpo_0
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset
  create_bd_pin -dir O -from 2 -to 0 spi_clks_0
  create_bd_pin -dir O -from 2 -to 0 spi_csns_0
  create_bd_pin -dir I -from 2 -to 0 spi_sdis_0
  create_bd_pin -dir O -from 2 -to 0 spi_sdos_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {8} \
   CONFIG.C_GPIO_WIDTH {8} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]
  set_property -dict [ list \
   CONFIG.C_DEFAULT_VALUE {0xFF} \
   CONFIG.C_GPO_WIDTH {3} \
   CONFIG.C_SCL_INERTIAL_DELAY {5} \
   CONFIG.C_SDA_INERTIAL_DELAY {5} \
 ] $axi_iic_0

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_SS_BITS {3} \
 ] $axi_quad_spi_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: cpu_ram
  create_hier_cell_cpu_ram $hier_obj cpu_ram

  # Create instance: mb_lmb
  create_hier_cell_mb_lmb $hier_obj mb_lmb

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property -dict [ list \
   CONFIG.C_DBG_MEM_ACCESS {0} \
   CONFIG.C_DBG_REG_ACCESS {0} \
   CONFIG.C_S_AXI_ADDR_WIDTH {4} \
   CONFIG.C_USE_UART {1} \
 ] $mdm_0

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_AREA_OPTIMIZED {0} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_D_AXI {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {11} \
 ] $microblaze_0_axi_periph

  # Create instance: rst_clk_wiz_100M, and set properties
  set rst_clk_wiz_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_100M ]

  # Create instance: spi_io_0, and set properties
  set spi_io_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:spi_io:1.0 spi_io_0 ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins GPIO_0] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins GPIO2_0] [get_bd_intf_pins axi_gpio_0/GPIO2]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins IIC_0] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_intc_0_interrupt [get_bd_intf_pins axi_intc_0/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
  connect_bd_intf_net -intf_net cpu_ram_cpu2udp_axis [get_bd_intf_pins cpu2cmu_axis] [get_bd_intf_pins cpu_ram/cpu2cmu_axis]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_0 [get_bd_intf_pins mdm_0/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins mb_lmb/DLMB] [get_bd_intf_pins microblaze_0/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins mb_lmb/ILMB] [get_bd_intf_pins microblaze_0/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins mdm_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins cpu_ram/cpu_bram_S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins cpu_ram/cpu_ram_S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins axi_quad_spi_0/AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins M10_AXI_DAQ] [get_bd_intf_pins microblaze_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net udp2cpu_axis_1 [get_bd_intf_pins cmu2cpu_axis] [get_bd_intf_pins cpu_ram/cmu2cpu_axis]

  # Create port connections
  connect_bd_net -net LMB_Rst_1 [get_bd_pins cpu_ram/rst] [get_bd_pins mb_lmb/LMB_Rst] [get_bd_pins rst_clk_wiz_100M/bus_struct_reset]
  connect_bd_net -net Net [get_bd_pins axi_quad_spi_0/sck_i] [get_bd_pins axi_quad_spi_0/sck_o] [get_bd_pins spi_io_0/spi_clk]
  connect_bd_net -net Net1 [get_bd_pins axi_quad_spi_0/io0_i] [get_bd_pins axi_quad_spi_0/io0_o] [get_bd_pins spi_io_0/spi_sdo]
  connect_bd_net -net Net2 [get_bd_pins axi_quad_spi_0/ss_i] [get_bd_pins axi_quad_spi_0/ss_o] [get_bd_pins spi_io_0/spi_csn]
  connect_bd_net -net axi_iic_0_gpo [get_bd_pins gpo_0] [get_bd_pins axi_iic_0/gpo]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins cpu_clk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins cpu_ram/cpu_clk] [get_bd_pins mb_lmb/LMB_Clk] [get_bd_pins mdm_0/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/M09_ACLK] [get_bd_pins microblaze_0_axi_periph/M10_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_100M/slowest_sync_clk]
  connect_bd_net -net cpu_ram_cpu_ram_intr_o [get_bd_pins cpu_ram/cpu_ram_intr_o] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net ddr_ctrl_top_0_ui_rst_n [get_bd_pins ext_reset_in] [get_bd_pins rst_clk_wiz_100M/ext_reset_in]
  connect_bd_net -net mdm_0_Debug_SYS_Rst [get_bd_pins mdm_0/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_100M/mb_debug_sys_rst]
  connect_bd_net -net mdm_0_Interrupt [get_bd_pins mdm_0/Interrupt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net rst_clk_wiz_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_clk_wiz_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins cpu_rstn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins cpu_ram/cpu_rstn] [get_bd_pins mdm_0/S_AXI_ARESETN] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] [get_bd_pins microblaze_0_axi_periph/M10_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_reset [get_bd_pins peripheral_reset] [get_bd_pins rst_clk_wiz_100M/peripheral_reset]
  connect_bd_net -net spi_io_0_spi_clks [get_bd_pins spi_clks_0] [get_bd_pins spi_io_0/spi_clks]
  connect_bd_net -net spi_io_0_spi_csns [get_bd_pins spi_csns_0] [get_bd_pins spi_io_0/spi_csns]
  connect_bd_net -net spi_io_0_spi_sdi [get_bd_pins axi_quad_spi_0/io1_i] [get_bd_pins spi_io_0/spi_sdi]
  connect_bd_net -net spi_io_0_spi_sdos [get_bd_pins spi_sdos_0] [get_bd_pins spi_io_0/spi_sdos]
  connect_bd_net -net spi_sdis_0_1 [get_bd_pins spi_sdis_0] [get_bd_pins spi_io_0/spi_sdis]
  connect_bd_net -net udp_clk_1 [get_bd_pins cmu_clk] [get_bd_pins cpu_ram/cmu_clk]
  connect_bd_net -net udp_rstn_1 [get_bd_pins cmu_rstn] [get_bd_pins cpu_ram/cmu_rstn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: COMM_TOP
proc create_hier_cell_COMM_TOP { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_COMM_TOP() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 cmu2cpu_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 cmu2mem_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cmu_S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 cpu2cmu_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt_sfp_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_sfp_refclk_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 mem2cmu_axis


  # Create pins
  create_bd_pin -dir I clk_125mhz
  create_bd_pin -dir I -type rst cpu_rstn
  create_bd_pin -dir O -type clk eth_clk
  create_bd_pin -dir O -type rst eth_rstn
  create_bd_pin -dir I -type clk mem_clk
  create_bd_pin -dir I -type rst mem_rstn

  # Create instance: cmu2cpu_fifo, and set properties
  set cmu2cpu_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 cmu2cpu_fifo ]

  # Create instance: cmu2cpu_width_conv, and set properties
  set cmu2cpu_width_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 cmu2cpu_width_conv ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.S_TDATA_NUM_BYTES {8} \
 ] $cmu2cpu_width_conv

  # Create instance: cmu2mem_width_conv, and set properties
  set cmu2mem_width_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 cmu2mem_width_conv ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.M_TDATA_NUM_BYTES {64} \
   CONFIG.S_TDATA_NUM_BYTES {8} \
 ] $cmu2mem_width_conv

  # Create instance: cpu2cmu_fifo, and set properties
  set cpu2cmu_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 cpu2cmu_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_MODE {2} \
 ] $cpu2cmu_fifo

  # Create instance: cpu2cmu_width_conv, and set properties
  set cpu2cmu_width_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 cpu2cmu_width_conv ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $cpu2cmu_width_conv

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_OF_PROBES {9} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_0

  # Create instance: ila_1, and set properties
  set ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_1 ]
  set_property -dict [ list \
   CONFIG.C_NUM_OF_PROBES {9} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_1

  # Create instance: ila_2, and set properties
  set ila_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_2 ]
  set_property -dict [ list \
   CONFIG.C_NUM_OF_PROBES {9} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_2

  # Create instance: mem2cmu_clock_conv, and set properties
  set mem2cmu_clock_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 mem2cmu_clock_conv ]

  # Create instance: mem2cmu_width_conv, and set properties
  set mem2cmu_width_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 mem2cmu_width_conv ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {0} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {64} \
 ] $mem2cmu_width_conv

  # Create instance: tcpip_core_0, and set properties
  set tcpip_core_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:tcpip_core:1.0 tcpip_core_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins mem2cmu_clock_conv/M_AXIS] [get_bd_intf_pins mem2cmu_width_conv/S_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins cpu2cmu_fifo/M_AXIS] [get_bd_intf_pins tcpip_core_0/tcp0_s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets axis_dwidth_converter_0_M_AXIS] [get_bd_intf_pins cpu2cmu_fifo/M_AXIS] [get_bd_intf_pins ila_2/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_1_M00_AXIS [get_bd_intf_pins cmu2mem_axis] [get_bd_intf_pins cmu2mem_width_conv/M_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets axis_interconnect_1_M00_AXIS] [get_bd_intf_pins cmu2mem_axis] [get_bd_intf_pins ila_0/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net cmu2cpu_dido_M_AXIS [get_bd_intf_pins cmu2cpu_fifo/M_AXIS] [get_bd_intf_pins cmu2cpu_width_conv/S_AXIS]
  connect_bd_intf_net -intf_net cmu2cpu_width_conv_M_AXIS [get_bd_intf_pins cmu2cpu_axis] [get_bd_intf_pins cmu2cpu_width_conv/M_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets cmu2cpu_width_conv_M_AXIS] [get_bd_intf_pins cmu2cpu_axis] [get_bd_intf_pins ila_1/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net cmu_S_AXI_1 [get_bd_intf_pins cmu_S_AXI] [get_bd_intf_pins tcpip_core_0/S_AXI]
  connect_bd_intf_net -intf_net cpu2cmu_axis_1 [get_bd_intf_pins cpu2cmu_axis] [get_bd_intf_pins cpu2cmu_width_conv/S_AXIS]
  connect_bd_intf_net -intf_net cpu2cmu_width_conv_M_AXIS [get_bd_intf_pins cpu2cmu_fifo/S_AXIS] [get_bd_intf_pins cpu2cmu_width_conv/M_AXIS]
  connect_bd_intf_net -intf_net ddr_ctrl_top_0_M_AXIS [get_bd_intf_pins mem2cmu_axis] [get_bd_intf_pins mem2cmu_clock_conv/S_AXIS]
  connect_bd_intf_net -intf_net gt_sfp_refclk_0_1 [get_bd_intf_pins gt_sfp_refclk_0] [get_bd_intf_pins tcpip_core_0/gt_sfp_refclk]
  connect_bd_intf_net -intf_net mem2cmu_width_conv_M_AXIS [get_bd_intf_pins mem2cmu_width_conv/M_AXIS] [get_bd_intf_pins tcpip_core_0/tcp1_s_axis]
  connect_bd_intf_net -intf_net tcpip_core_0_gt_sfp [get_bd_intf_pins gt_sfp_0] [get_bd_intf_pins tcpip_core_0/gt_sfp]
  connect_bd_intf_net -intf_net tcpip_core_0_tcp0_m_axis [get_bd_intf_pins cmu2cpu_fifo/S_AXIS] [get_bd_intf_pins tcpip_core_0/tcp0_m_axis]
  connect_bd_intf_net -intf_net tcpip_core_0_tcp1_m_axis [get_bd_intf_pins cmu2mem_width_conv/S_AXIS] [get_bd_intf_pins tcpip_core_0/tcp1_m_axis]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins mem_clk] [get_bd_pins mem2cmu_clock_conv/s_axis_aclk]
  connect_bd_net -net Net [get_bd_pins eth_clk] [get_bd_pins cmu2cpu_fifo/s_axis_aclk] [get_bd_pins cmu2cpu_width_conv/aclk] [get_bd_pins cmu2mem_width_conv/aclk] [get_bd_pins cpu2cmu_fifo/s_axis_aclk] [get_bd_pins cpu2cmu_width_conv/aclk] [get_bd_pins ila_0/clk] [get_bd_pins ila_1/clk] [get_bd_pins ila_2/clk] [get_bd_pins mem2cmu_clock_conv/m_axis_aclk] [get_bd_pins mem2cmu_width_conv/aclk] [get_bd_pins tcpip_core_0/axis_aclk]
  connect_bd_net -net Net1 [get_bd_pins eth_rstn] [get_bd_pins cmu2cpu_fifo/s_axis_aresetn] [get_bd_pins cmu2cpu_width_conv/aresetn] [get_bd_pins cmu2mem_width_conv/aresetn] [get_bd_pins cpu2cmu_fifo/s_axis_aresetn] [get_bd_pins cpu2cmu_width_conv/aresetn] [get_bd_pins mem2cmu_clock_conv/m_axis_aresetn] [get_bd_pins mem2cmu_width_conv/aresetn] [get_bd_pins tcpip_core_0/axis_aresetn]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins clk_125mhz] [get_bd_pins tcpip_core_0/S_AXI_aclk] [get_bd_pins tcpip_core_0/clk_125mhz]
  connect_bd_net -net ddr_ctrl_top_0_ui_rst_n [get_bd_pins mem_rstn] [get_bd_pins mem2cmu_clock_conv/s_axis_aresetn]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins cpu_rstn] [get_bd_pins tcpip_core_0/S_AXI_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set GPIO2_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO2_0 ]

  set GPIO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0 ]

  set IIC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC ]

  set c0_ddr4_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4_0 ]

  set gt_sfp_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt_sfp_0 ]

  set gt_sfp_refclk_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_sfp_refclk_0 ]


  # Create ports
  set AD1_CSB [ create_bd_port -dir O -from 0 -to 0 AD1_CSB ]
  set ADC_SCLK [ create_bd_port -dir O -from 0 -to 0 ADC_SCLK ]
  set ADC_SDIO [ create_bd_port -dir O -from 0 -to 0 ADC_SDIO ]
  set CLK_200MM_N [ create_bd_port -dir I CLK_200MM_N ]
  set CLK_200MM_P [ create_bd_port -dir I CLK_200MM_P ]
  set EXT_PLL_LOCK [ create_bd_port -dir I -from 0 -to 0 EXT_PLL_LOCK ]
  set F_CLK_SEL [ create_bd_port -dir O -from 0 -to 0 F_CLK_SEL ]
  set LED [ create_bd_port -dir O -from 3 -to 0 LED ]
  set PLL_CLK_N [ create_bd_port -dir I -from 0 -to 0 PLL_CLK_N ]
  set PLL_CLK_P [ create_bd_port -dir I -from 0 -to 0 PLL_CLK_P ]
  set PLL_CS [ create_bd_port -dir O -from 0 -to 0 PLL_CS ]
  set PLL_RESETN [ create_bd_port -dir O -from 0 -to 0 PLL_RESETN ]
  set PLL_SCLK [ create_bd_port -dir O -from 0 -to 0 PLL_SCLK ]
  set PLL_SDIO [ create_bd_port -dir O -from 0 -to 0 PLL_SDIO ]
  set PLL_SDO [ create_bd_port -dir I -from 0 -to 0 PLL_SDO ]
  set ad9653_ifc_n_0 [ create_bd_port -dir I -from 9 -to 0 ad9653_ifc_n_0 ]
  set ad9653_ifc_p_0 [ create_bd_port -dir I -from 9 -to 0 ad9653_ifc_p_0 ]
  set adc_sync_0 [ create_bd_port -dir O -from 0 -to 0 adc_sync_0 ]
  set c0_sys_clk_n [ create_bd_port -dir I c0_sys_clk_n ]
  set c0_sys_clk_p [ create_bd_port -dir I c0_sys_clk_p ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset
  set spi_clks_0 [ create_bd_port -dir O -from 2 -to 0 spi_clks_0 ]
  set spi_csns_0 [ create_bd_port -dir O -from 2 -to 0 spi_csns_0 ]
  set spi_sdis_0 [ create_bd_port -dir I -from 2 -to 0 spi_sdis_0 ]
  set spi_sdos_0 [ create_bd_port -dir O -from 2 -to 0 spi_sdos_0 ]
  set trig_input [ create_bd_port -dir I trig_input ]

  # Create instance: COMM_TOP
  create_hier_cell_COMM_TOP [current_bd_instance .] COMM_TOP

  # Create instance: CPU_TOP
  create_hier_cell_CPU_TOP [current_bd_instance .] CPU_TOP

  # Create instance: DAQ_TOP
  create_hier_cell_DAQ_TOP [current_bd_instance .] DAQ_TOP

  # Create instance: MEM_TOP
  create_hier_cell_MEM_TOP [current_bd_instance .] MEM_TOP

  # Create instance: rst_inv, and set properties
  set rst_inv [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 rst_inv ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $rst_inv

  # Create interface connections
  connect_bd_intf_net -intf_net COMM_TOP_cmu2cpu_axis [get_bd_intf_pins COMM_TOP/cmu2cpu_axis] [get_bd_intf_pins CPU_TOP/cmu2cpu_axis]
  connect_bd_intf_net -intf_net CPU_TOP_GPIO2_0 [get_bd_intf_ports GPIO2_0] [get_bd_intf_pins CPU_TOP/GPIO2_0]
  connect_bd_intf_net -intf_net CPU_TOP_GPIO_0 [get_bd_intf_ports GPIO_0] [get_bd_intf_pins CPU_TOP/GPIO_0]
  connect_bd_intf_net -intf_net CPU_TOP_IIC_0 [get_bd_intf_ports IIC] [get_bd_intf_pins CPU_TOP/IIC_0]
  connect_bd_intf_net -intf_net CPU_TOP_M10_AXI_DAQ [get_bd_intf_pins CPU_TOP/M10_AXI_DAQ] [get_bd_intf_pins DAQ_TOP/S_AXI_DAQ]
  connect_bd_intf_net -intf_net CPU_TOP_cpu2udp_axis [get_bd_intf_pins COMM_TOP/cpu2cmu_axis] [get_bd_intf_pins CPU_TOP/cpu2cmu_axis]
  connect_bd_intf_net -intf_net MEM_TOP_c0_ddr4_0 [get_bd_intf_ports c0_ddr4_0] [get_bd_intf_pins MEM_TOP/c0_ddr4_0]
  connect_bd_intf_net -intf_net S_daq2mem_axis_1 [get_bd_intf_pins DAQ_TOP/m_rd_axis] [get_bd_intf_pins MEM_TOP/S_daq2mem_axis]
  connect_bd_intf_net -intf_net ddr_ctrl_top_0_M_AXIS [get_bd_intf_pins COMM_TOP/mem2cmu_axis] [get_bd_intf_pins MEM_TOP/M_AXIS]
  connect_bd_intf_net -intf_net gt_sfp_refclk_0_1 [get_bd_intf_ports gt_sfp_refclk_0] [get_bd_intf_pins COMM_TOP/gt_sfp_refclk_0]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins CPU_TOP/M00_AXI] [get_bd_intf_pins MEM_TOP/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins COMM_TOP/cmu_S_AXI] [get_bd_intf_pins CPU_TOP/M02_AXI]
  connect_bd_intf_net -intf_net udp_2_mem_process_0_m_axis [get_bd_intf_pins COMM_TOP/cmu2mem_axis] [get_bd_intf_pins MEM_TOP/S_AXIS]
  connect_bd_intf_net -intf_net udp_eth_0_gt_sfp [get_bd_intf_ports gt_sfp_0] [get_bd_intf_pins COMM_TOP/gt_sfp_0]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins COMM_TOP/mem_clk] [get_bd_pins MEM_TOP/mem_clk]
  connect_bd_net -net CLK_200MM_N_1 [get_bd_ports CLK_200MM_N] [get_bd_pins DAQ_TOP/CLK_200M_N]
  connect_bd_net -net CLK_200MM_P_1 [get_bd_ports CLK_200MM_P] [get_bd_pins DAQ_TOP/CLK_200M_P]
  connect_bd_net -net CPU_TOP_spi_clks_0 [get_bd_ports spi_clks_0] [get_bd_pins CPU_TOP/spi_clks_0]
  connect_bd_net -net CPU_TOP_spi_csns_0 [get_bd_ports spi_csns_0] [get_bd_pins CPU_TOP/spi_csns_0]
  connect_bd_net -net CPU_TOP_spi_sdos_0 [get_bd_ports spi_sdos_0] [get_bd_pins CPU_TOP/spi_sdos_0]
  connect_bd_net -net DAQ_TOP_AD1_CSB [get_bd_ports AD1_CSB] [get_bd_pins DAQ_TOP/AD1_CSB]
  connect_bd_net -net DAQ_TOP_ADC_SCLK [get_bd_ports ADC_SCLK] [get_bd_pins DAQ_TOP/ADC_SCLK]
  connect_bd_net -net DAQ_TOP_ADC_SDIO [get_bd_ports ADC_SDIO] [get_bd_pins DAQ_TOP/ADC_SDIO]
  connect_bd_net -net DAQ_TOP_F_CLK_SEL [get_bd_ports F_CLK_SEL] [get_bd_pins DAQ_TOP/F_CLK_SEL]
  connect_bd_net -net DAQ_TOP_LED [get_bd_ports LED] [get_bd_pins DAQ_TOP/LED]
  connect_bd_net -net DAQ_TOP_PLL_CS [get_bd_ports PLL_CS] [get_bd_pins DAQ_TOP/PLL_CS]
  connect_bd_net -net DAQ_TOP_PLL_RESETN [get_bd_ports PLL_RESETN] [get_bd_pins DAQ_TOP/PLL_RESETN]
  connect_bd_net -net DAQ_TOP_PLL_SCLK [get_bd_ports PLL_SCLK] [get_bd_pins DAQ_TOP/PLL_SCLK]
  connect_bd_net -net DAQ_TOP_PLL_SDIO [get_bd_ports PLL_SDIO] [get_bd_pins DAQ_TOP/PLL_SDIO]
  connect_bd_net -net DAQ_TOP_adc_sync_0 [get_bd_ports adc_sync_0] [get_bd_pins DAQ_TOP/adc_sync_0]
  connect_bd_net -net DAQ_TOP_daq_rstn [get_bd_pins DAQ_TOP/daq_rstn] [get_bd_pins MEM_TOP/daq_rstn]
  connect_bd_net -net EXT_PLL_LOCK_0_1 [get_bd_ports EXT_PLL_LOCK] [get_bd_pins DAQ_TOP/EXT_PLL_LOCK]
  connect_bd_net -net Net [get_bd_pins COMM_TOP/eth_clk] [get_bd_pins CPU_TOP/cmu_clk] [get_bd_pins MEM_TOP/eth_clk]
  connect_bd_net -net Net1 [get_bd_pins COMM_TOP/eth_rstn] [get_bd_pins CPU_TOP/cmu_rstn] [get_bd_pins MEM_TOP/eth_rstn]
  connect_bd_net -net PLL_CLK_N_0_1 [get_bd_ports PLL_CLK_N] [get_bd_pins DAQ_TOP/PLL_CLK_N]
  connect_bd_net -net PLL_CLK_P_0_1 [get_bd_ports PLL_CLK_P] [get_bd_pins DAQ_TOP/PLL_CLK_P]
  connect_bd_net -net PLL_SDO_0_1 [get_bd_ports PLL_SDO] [get_bd_pins DAQ_TOP/PLL_SDO]
  connect_bd_net -net ad9653_ifc_n_0_1 [get_bd_ports ad9653_ifc_n_0] [get_bd_pins DAQ_TOP/ad9653_ifc_n_0]
  connect_bd_net -net ad9653_ifc_p_0_1 [get_bd_ports ad9653_ifc_p_0] [get_bd_pins DAQ_TOP/ad9653_ifc_p_0]
  connect_bd_net -net c0_sys_clk_n_1 [get_bd_ports c0_sys_clk_n] [get_bd_pins MEM_TOP/c0_sys_clk_n]
  connect_bd_net -net c0_sys_clk_p_1 [get_bd_ports c0_sys_clk_p] [get_bd_pins MEM_TOP/c0_sys_clk_p]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins COMM_TOP/clk_125mhz] [get_bd_pins CPU_TOP/cpu_clk] [get_bd_pins DAQ_TOP/cpu_clk] [get_bd_pins MEM_TOP/cpu_clk]
  connect_bd_net -net daq_clk_1 [get_bd_pins DAQ_TOP/daq_clk] [get_bd_pins MEM_TOP/daq_clk]
  connect_bd_net -net ddr_ctrl_top_0_ui_rst_n [get_bd_pins COMM_TOP/mem_rstn] [get_bd_pins MEM_TOP/mem_rstn]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins CPU_TOP/ext_reset_in] [get_bd_pins DAQ_TOP/reset] [get_bd_pins rst_inv/Res]
  connect_bd_net -net external_trig_0_1 [get_bd_ports trig_input] [get_bd_pins DAQ_TOP/external_trig_0]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins rst_inv/Op1]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins COMM_TOP/cpu_rstn] [get_bd_pins CPU_TOP/cpu_rstn] [get_bd_pins DAQ_TOP/cpu_rstn] [get_bd_pins MEM_TOP/cpu_rstn]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_reset [get_bd_pins CPU_TOP/peripheral_reset] [get_bd_pins MEM_TOP/sys_rst]
  connect_bd_net -net spi_sdis_0_1 [get_bd_ports spi_sdis_0] [get_bd_pins CPU_TOP/spi_sdis_0]

  # Create address segments
  assign_bd_address -offset 0x00170000 -range 0x00002000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/cpu_ram/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00150000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/axi_quad_spi_0/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00160000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00180000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/cpu_ram/cpu_ram_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs MEM_TOP/ddr_ctrl_top_1/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/mb_lmb/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x001B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs DAQ_TOP/fifo_top_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Instruction] [get_bd_addr_segs CPU_TOP/mb_lmb/ilmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x00190000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs CPU_TOP/mdm_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs COMM_TOP/tcpip_core_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x001A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CPU_TOP/microblaze_0/Data] [get_bd_addr_segs DAQ_TOP/trigger_0/S_AXI/reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


