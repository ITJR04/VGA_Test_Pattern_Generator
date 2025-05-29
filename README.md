🖼️ VGA Test Pattern Generator on ZedBoard Zynq-7000  
This project implements a VGA signal generator in VHDL on the ZedBoard Zynq-7000. It outputs a 640×480 resolution signal at 60 Hz using precise horizontal and vertical synchronization timing to display a static test pattern of red, green, and blue vertical color bars on a VGA monitor. The design is fully implemented in the PL (Programmable Logic) and uses a 25 MHz pixel clock derived from the ZedBoard’s 100 MHz system clock via a Clocking Wizard IP.

---

📦 Project Details

- **Top Module**: `vga_test_pattern_top`
- **Clock Input**: 100 MHz onboard oscillator
- **Clock Output**: 25 MHz pixel clock (generated with MMCM)
- **Video Output**: VGA (Red, Green, Blue signals + HSYNC, VSYNC)
- **Reset Pin**: SW5 (T18) — active-high synchronous reset (used only in debug, optional)
- **Design Goal**: Demonstrate VGA video signal generation using accurate timing counters and RGB output from an FPGA

---

🛠️ Tools Used

- Vivado Design Suite (Vivado 2024.2)
- Clocking Wizard IP (for 25 MHz VGA pixel clock)
- VHDL for hardware description
- VGA-compatible Monitor and VGA Cable
- Optional: Vivado Simulator / GTKWave for waveform viewing

---

📐 How the Design Works  
The design generates precise VGA timing for 640×480 resolution at 60 Hz:

- **Pixel Clock**: 25 MHz, created using a Clocking Wizard (from 100 MHz input)
- **Horizontal Timing**: 800 total pixels per line (640 active, 160 blanking)
- **Vertical Timing**: 525 total lines per frame (480 active, 45 blanking)
- Two counters (`hcount`, `vcount`) track the current pixel and line positions.
- HSYNC and VSYNC are generated based on standard VGA timing specs.
- Red, green, and blue outputs are activated in thirds of the screen width to create vertical color bars.

🔴 Left third of screen: RED  
🟢 Middle third: GREEN  
🔵 Right third: BLUE  

---

➕ Clock Debug Behavior 

To verify that the Clocking Wizard is locked and VGA timing is running:

- LD0 (U14) is connected to the `locked` signal from the Clocking Wizard.
- LED ON = Clock is valid and video signal is active
- LED OFF = Clocking Wizard has not locked (check reset or input clock)

---

🔌 Vivado Build & Program Steps

**Open Project in Vivado**
- Launch Vivado
- create a new RTL project
- add the source files given in this repository to the project you opened up
  
**Run Synthesis & Implementation**
- Click "Run Synthesis"
- Click "Run Implementation"
- Review timing report (ensure design meets 25 MHz clock timing)

**Generate Bitstream**
- Click "Generate Bitstream"

**Program the FPGA**
- Connect your ZedBoard via JTAG
- Go to "Open Hardware Manager" → Open Target → Auto Connect
- Click "Program Device" and select the generated `.bit` file

**Observe Output**
- Connect a VGA monitor to the ZedBoard
- Set monitor input to VGA (640×480 @ 60 Hz)
- You should see 3 vertical color bars (Red, Green, Blue)
- LD0 (U14) should be lit to confirm clock lock

---

✅ This project reinforces real-time digital video generation, clean pixel timing logic, clock domain management with MMCMs, and hardware-level debugging on FPGAs using the ZedBoard Zynq-7000.
