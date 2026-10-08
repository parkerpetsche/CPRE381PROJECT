#########################################################################
## Parker Petsche
## Software Engineering
## Iowa State University
#########################################################################
## tb_second_datapath.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the
## second datapath. It adds useful signals for testing
## functionality and debugging the system. It also formats
## the waveform and runs the simulation.
#########################################################################

# Setup the waveform with useful signals

# Add data inputs that are specific to this design. These are the ones set during our test cases.
add wave -noupdate -divider {Data Inputs}
add wave -noupdate -radix binary /tb_second_datapath/s_i_CLK
add wave -noupdate -radix binary /tb_second_datapath/s_i_RST
add wave -noupdate -radix unsigned /tb_second_datapath/s_RS1
add wave -noupdate -radix unsigned /tb_second_datapath/s_RS2
add wave -noupdate -radix unsigned /tb_second_datapath/s_RD
add wave -noupdate -radix hex /tb_second_datapath/s_i_Imm12
add wave -noupdate -radix hex /tb_second_datapath/s_i_Imm20
add wave -noupdate -radix binary /tb_second_datapath/s_ALU_src
add wave -noupdate -radix binary /tb_second_datapath/s_nAdd_Sub
add wave -noupdate -radix binary /tb_second_datapath/s_imm_type
add wave -noupdate -radix binary /tb_second_datapath/s_a_WE
add wave -noupdate -radix binary /tb_second_datapath/s_a_BE
add wave -noupdate -radix binary /tb_second_datapath/s_is_Mem
add wave -noupdate -radix binary /tb_second_datapath/s_r_WE


# Add data outputs that are specific to this design. These are the ones that we'll check for correctness.
add wave -noupdate -divider {Data Outputs}
add wave -noupdate -radix hex /tb_second_datapath/DUT/o_RS1
add wave -noupdate -radix hex /tb_second_datapath/DUT/o_RS2
add wave -noupdate -radix hex /tb_second_datapath/DUT/ext_out
add wave -noupdate -radix hex /tb_second_datapath/DUT/adder_out
add wave -noupdate -radix hex /tb_second_datapath/DUT/mem_read
add wave -noupdate -radix hex /tb_second_datapath/DUT/data_out



# Run long enough to execute all 25 test cases.
run 2500 ns
