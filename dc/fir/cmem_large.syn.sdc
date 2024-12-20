###################################################################

# Created by write_sdc on Sat Nov 23 16:46:09 2024

###################################################################
set sdc_version 1.7

set_units -time ns -resistance kOhm -capacitance pF -power mW -voltage V       \
-current mA
set_max_fanout 4 [current_design]
set_max_area 0
set_driving_cell -lib_cell INVX1TS [get_ports clk]
set_driving_cell -lib_cell INVX1TS [get_ports cen]
set_driving_cell -lib_cell INVX1TS [get_ports wen]
set_driving_cell -lib_cell INVX1TS [get_ports {a[5]}]
set_driving_cell -lib_cell INVX1TS [get_ports {a[4]}]
set_driving_cell -lib_cell INVX1TS [get_ports {a[3]}]
set_driving_cell -lib_cell INVX1TS [get_ports {a[2]}]
set_driving_cell -lib_cell INVX1TS [get_ports {a[1]}]
set_driving_cell -lib_cell INVX1TS [get_ports {a[0]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[15]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[14]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[13]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[12]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[11]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[10]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[9]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[8]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[7]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[6]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[5]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[4]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[3]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[2]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[1]}]
set_driving_cell -lib_cell INVX1TS [get_ports {d[0]}]
set_load -pin_load 0.005 [get_ports {q[15]}]
set_load -pin_load 0.005 [get_ports {q[14]}]
set_load -pin_load 0.005 [get_ports {q[13]}]
set_load -pin_load 0.005 [get_ports {q[12]}]
set_load -pin_load 0.005 [get_ports {q[11]}]
set_load -pin_load 0.005 [get_ports {q[10]}]
set_load -pin_load 0.005 [get_ports {q[9]}]
set_load -pin_load 0.005 [get_ports {q[8]}]
set_load -pin_load 0.005 [get_ports {q[7]}]
set_load -pin_load 0.005 [get_ports {q[6]}]
set_load -pin_load 0.005 [get_ports {q[5]}]
set_load -pin_load 0.005 [get_ports {q[4]}]
set_load -pin_load 0.005 [get_ports {q[3]}]
set_load -pin_load 0.005 [get_ports {q[2]}]
set_load -pin_load 0.005 [get_ports {q[1]}]
set_load -pin_load 0.005 [get_ports {q[0]}]
set_max_capacitance 0.005 [get_ports clk]
set_max_capacitance 0.005 [get_ports cen]
set_max_capacitance 0.005 [get_ports wen]
set_max_capacitance 0.005 [get_ports {a[5]}]
set_max_capacitance 0.005 [get_ports {a[4]}]
set_max_capacitance 0.005 [get_ports {a[3]}]
set_max_capacitance 0.005 [get_ports {a[2]}]
set_max_capacitance 0.005 [get_ports {a[1]}]
set_max_capacitance 0.005 [get_ports {a[0]}]
set_max_capacitance 0.005 [get_ports {d[15]}]
set_max_capacitance 0.005 [get_ports {d[14]}]
set_max_capacitance 0.005 [get_ports {d[13]}]
set_max_capacitance 0.005 [get_ports {d[12]}]
set_max_capacitance 0.005 [get_ports {d[11]}]
set_max_capacitance 0.005 [get_ports {d[10]}]
set_max_capacitance 0.005 [get_ports {d[9]}]
set_max_capacitance 0.005 [get_ports {d[8]}]
set_max_capacitance 0.005 [get_ports {d[7]}]
set_max_capacitance 0.005 [get_ports {d[6]}]
set_max_capacitance 0.005 [get_ports {d[5]}]
set_max_capacitance 0.005 [get_ports {d[4]}]
set_max_capacitance 0.005 [get_ports {d[3]}]
set_max_capacitance 0.005 [get_ports {d[2]}]
set_max_capacitance 0.005 [get_ports {d[1]}]
set_max_capacitance 0.005 [get_ports {d[0]}]
set_max_fanout 4 [get_ports clk]
set_max_fanout 4 [get_ports cen]
set_max_fanout 4 [get_ports wen]
set_max_fanout 4 [get_ports {a[5]}]
set_max_fanout 4 [get_ports {a[4]}]
set_max_fanout 4 [get_ports {a[3]}]
set_max_fanout 4 [get_ports {a[2]}]
set_max_fanout 4 [get_ports {a[1]}]
set_max_fanout 4 [get_ports {a[0]}]
set_max_fanout 4 [get_ports {d[15]}]
set_max_fanout 4 [get_ports {d[14]}]
set_max_fanout 4 [get_ports {d[13]}]
set_max_fanout 4 [get_ports {d[12]}]
set_max_fanout 4 [get_ports {d[11]}]
set_max_fanout 4 [get_ports {d[10]}]
set_max_fanout 4 [get_ports {d[9]}]
set_max_fanout 4 [get_ports {d[8]}]
set_max_fanout 4 [get_ports {d[7]}]
set_max_fanout 4 [get_ports {d[6]}]
set_max_fanout 4 [get_ports {d[5]}]
set_max_fanout 4 [get_ports {d[4]}]
set_max_fanout 4 [get_ports {d[3]}]
set_max_fanout 4 [get_ports {d[2]}]
set_max_fanout 4 [get_ports {d[1]}]
set_max_fanout 4 [get_ports {d[0]}]
set_ideal_network [get_ports clk]
create_clock [get_ports clk]  -period 2  -waveform {0 1}
set_clock_uncertainty 0  [get_clocks clk]
set_clock_transition -max -rise 0.01 [get_clocks clk]
set_clock_transition -max -fall 0.01 [get_clocks clk]
set_clock_transition -min -rise 0.01 [get_clocks clk]
set_clock_transition -min -fall 0.01 [get_clocks clk]
set_input_delay -clock clk  0.05  [get_ports cen]
set_input_delay -clock clk  0.05  [get_ports wen]
set_input_delay -clock clk  0.05  [get_ports {a[5]}]
set_input_delay -clock clk  0.05  [get_ports {a[4]}]
set_input_delay -clock clk  0.05  [get_ports {a[3]}]
set_input_delay -clock clk  0.05  [get_ports {a[2]}]
set_input_delay -clock clk  0.05  [get_ports {a[1]}]
set_input_delay -clock clk  0.05  [get_ports {a[0]}]
set_input_delay -clock clk  0.05  [get_ports {d[15]}]
set_input_delay -clock clk  0.05  [get_ports {d[14]}]
set_input_delay -clock clk  0.05  [get_ports {d[13]}]
set_input_delay -clock clk  0.05  [get_ports {d[12]}]
set_input_delay -clock clk  0.05  [get_ports {d[11]}]
set_input_delay -clock clk  0.05  [get_ports {d[10]}]
set_input_delay -clock clk  0.05  [get_ports {d[9]}]
set_input_delay -clock clk  0.05  [get_ports {d[8]}]
set_input_delay -clock clk  0.05  [get_ports {d[7]}]
set_input_delay -clock clk  0.05  [get_ports {d[6]}]
set_input_delay -clock clk  0.05  [get_ports {d[5]}]
set_input_delay -clock clk  0.05  [get_ports {d[4]}]
set_input_delay -clock clk  0.05  [get_ports {d[3]}]
set_input_delay -clock clk  0.05  [get_ports {d[2]}]
set_input_delay -clock clk  0.05  [get_ports {d[1]}]
set_input_delay -clock clk  0.05  [get_ports {d[0]}]
set_output_delay -clock clk  0.05  [get_ports {q[15]}]
set_output_delay -clock clk  0.05  [get_ports {q[14]}]
set_output_delay -clock clk  0.05  [get_ports {q[13]}]
set_output_delay -clock clk  0.05  [get_ports {q[12]}]
set_output_delay -clock clk  0.05  [get_ports {q[11]}]
set_output_delay -clock clk  0.05  [get_ports {q[10]}]
set_output_delay -clock clk  0.05  [get_ports {q[9]}]
set_output_delay -clock clk  0.05  [get_ports {q[8]}]
set_output_delay -clock clk  0.05  [get_ports {q[7]}]
set_output_delay -clock clk  0.05  [get_ports {q[6]}]
set_output_delay -clock clk  0.05  [get_ports {q[5]}]
set_output_delay -clock clk  0.05  [get_ports {q[4]}]
set_output_delay -clock clk  0.05  [get_ports {q[3]}]
set_output_delay -clock clk  0.05  [get_ports {q[2]}]
set_output_delay -clock clk  0.05  [get_ports {q[1]}]
set_output_delay -clock clk  0.05  [get_ports {q[0]}]
