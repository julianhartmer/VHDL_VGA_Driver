
#create_clock -name sys_clock -period 10 [get_ports sys_clock]
          
          
set_property PACKAGE_PIN AB19 [get_ports b_0_0]
set_property PACKAGE_PIN AB20 [get_ports b_0_1]
set_property PACKAGE_PIN Y20  [get_ports b_0_2]
set_property PACKAGE_PIN Y21  [get_ports b_0_3]
set_property PACKAGE_PIN AA21 [get_ports g_0_0]
set_property PACKAGE_PIN AA22 [get_ports g_0_1]
set_property PACKAGE_PIN AB21 [get_ports g_0_2]
set_property PACKAGE_PIN AB22 [get_ports g_0_3]
set_property PACKAGE_PIN AA19 [get_ports h_sync_0]
set_property PACKAGE_PIN V18  [get_ports r_0_0]
set_property PACKAGE_PIN U20  [get_ports r_0_1]
set_property PACKAGE_PIN V20  [get_ports r_0_2]
set_property PACKAGE_PIN V19  [get_ports r_0_3]
set_property PACKAGE_PIN Y19  [get_ports v_sync_0]
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

