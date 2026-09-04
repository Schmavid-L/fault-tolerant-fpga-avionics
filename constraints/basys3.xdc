## 100 MHz onboard clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]


## Center pushbutton -> reset
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]


## Switches
## SW0 -> enable
set_property PACKAGE_PIN V17 [get_ports enable]
set_property IOSTANDARD LVCMOS33 [get_ports enable]

## SW1 -> fault A
set_property PACKAGE_PIN V16 [get_ports fault_a]
set_property IOSTANDARD LVCMOS33 [get_ports fault_a]

## SW2 -> fault B
set_property PACKAGE_PIN W16 [get_ports fault_b]
set_property IOSTANDARD LVCMOS33 [get_ports fault_b]

## SW3 -> fault C
set_property PACKAGE_PIN W17 [get_ports fault_c]
set_property IOSTANDARD LVCMOS33 [get_ports fault_c]


## LEDs
## LED0 -> voted ACTIVE
set_property PACKAGE_PIN U16 [get_ports voted_active]
set_property IOSTANDARD LVCMOS33 [get_ports voted_active]

## LED1 -> voted SAFE
set_property PACKAGE_PIN E19 [get_ports voted_safe]
set_property IOSTANDARD LVCMOS33 [get_ports voted_safe]

## LED2 -> channel A disagreement
set_property PACKAGE_PIN U19 [get_ports fault_detect_a]
set_property IOSTANDARD LVCMOS33 [get_ports fault_detect_a]

## LED3 -> channel B disagreement
set_property PACKAGE_PIN V19 [get_ports fault_detect_b]
set_property IOSTANDARD LVCMOS33 [get_ports fault_detect_b]

## LED4 -> channel C disagreement
set_property PACKAGE_PIN W18 [get_ports fault_detect_c]
set_property IOSTANDARD LVCMOS33 [get_ports fault_detect_c]