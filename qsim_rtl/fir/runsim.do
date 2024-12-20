##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench
vlog +acc -incr ../../rtl/fir/alu.v 
vlog +acc -incr ./test_alu.v 

# Run Simulator 
vsim +acc -t ps -lib work alu_tb 
do waveformat.do   
run -all
