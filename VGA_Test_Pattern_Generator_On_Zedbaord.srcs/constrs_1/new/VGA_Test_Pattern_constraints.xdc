## Clock
set_property PACKAGE_PIN Y9 [get_ports {clk100MHz}];  # "GCLK"
set_property IOSTANDARD LVCMOS33 [get_ports clk100MHz]

# reset
set_property PACKAGE_PIN P16 [get_ports {reset}];  # "BTNC"
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## VGA BLue Channel
set_property PACKAGE_PIN Y21  [get_ports {vga_blue[0]}];  # "VGA-B1"
set_property PACKAGE_PIN Y20  [get_ports {vga_blue[1]}];  # "VGA-B2"
set_property PACKAGE_PIN AB20 [get_ports {vga_blue[2]}];  # "VGA-B3"
set_property PACKAGE_PIN AB19 [get_ports {vga_blue[3]}];  # "VGA-B4"
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[*]}]

## VGA Green Channel
set_property PACKAGE_PIN AB22 [get_ports {vga_green[0]}];  # "VGA-G1"
set_property PACKAGE_PIN AA22 [get_ports {vga_green[1]}];  # "VGA-G2"
set_property PACKAGE_PIN AB21 [get_ports {vga_green[2]}];  # "VGA-G3"
set_property PACKAGE_PIN AA21 [get_ports {vga_green[3]}];  # "VGA-G4"
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[*]}]

## VGA Horizontal Sync
set_property PACKAGE_PIN AA19 [get_ports {vga_hsync}];  # "VGA-HS"
set_property IOSTANDARD LVCMOS33 [get_ports vga_hsync]

## VGA_Red Channel
set_property PACKAGE_PIN V20  [get_ports {vga_red[0]}];  # "VGA-R1"
set_property PACKAGE_PIN U20  [get_ports {vga_red[1]}];  # "VGA-R2"
set_property PACKAGE_PIN V19  [get_ports {vga_red[2]}];  # "VGA-R3"
set_property PACKAGE_PIN V18  [get_ports {vga_red[3]}];  # "VGA-R4"
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[*]}]

## VGA Vertical Sync
set_property PACKAGE_PIN Y19  [get_ports {vga_vsync}];  # "VGA-VS"
set_property IOSTANDARD LVCMOS33 [get_ports vga_vsync]

## led view
set_property PACKAGE_PIN T22 [get_ports {led}];  # "LD0"
set_property IOSTANDARD LVCMOS33 [get_ports led]