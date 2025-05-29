----------------------------------------------------------------------------------
-- Company: Universtiy of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/28/2025 12:25:39 PM
-- Design Name: VGA Test Pattern Top-Level 
-- Module Name: vga_test_pattern_top - Behavioral
-- Project Name: VGA_Test_Pattern_Zedboard
-- Target Devices: Zedboard Zynq-7000 (xc7z020clg484-1)
-- Tool Versions: Vivado 2024.2
-- Description: 
--     This is the top-level wrapper module for the VGA test pattern project.
--     It connects the 100 MHz onboard oscillator to a Clocking Wizard IP core
--     to generate the 25 MHz VGA pixel clock, instantiates the test pattern
--     generator, and drives output signals to VGA pins and onboard led.
-- 
--     led is used to display the status of the clock lock signal from the 
--     MMCM to aid debugging. VGA sync and RGB signals are output through 
--     dedicated ports connected to the VGA DAC. ( it helped me to figure out what my problem was)
-- 
-- Dependencies: 
--     clk_wiz_0 (IP block for 25 MHz clock generation)
--     vga_test_pattern.vhd
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Integrated Clocking Wizard and video core for VGA output
-- Additional Comments:
--     Be sure resetn is tied high or appropriately handled in hardware
--     Requires monitor to support 640x480 @ 60 Hz over VGA
--     Designed to be simulated and synthesized independently
--     in my VGA output i used a AOC C24G1 monitor to display the pattern

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_test_pattern_top is
  Port (
        clk100MHz : in std_logic;
        reset : in std_logic;
        vga_hsync : out std_logic;
        vga_vsync : out std_logic;
        led : out STD_LOGIC;
        vga_red : out std_logic_vector(3 downto 0);
        vga_green : out std_logic_vector(3 downto 0);
        vga_blue : out std_logic_vector(3 downto 0)     
  );
end vga_test_pattern_top;

architecture Behavioral of vga_test_pattern_top is
    -- Clocking wizards signals
    signal clk25MHz : std_logic;
    signal locked : std_logic;
    -- CLocking Wizard component declaration
    component clk_wiz_0
        port (
            clk_in1 : in std_logic;
            clk_out1 : out std_logic;
            resetn : in std_logic;
            locked : out std_logic);
    end component;
    
    -- VGA signals
    signal pixel_r : std_logic_vector(3 downto 0);
    signal pixel_g : std_logic_vector(3 downto 0);
    signal pixel_b : std_logic_vector(3 downto 0);
    
begin
    -- Instantiation of CLocking Wizard
    clkgen : clk_wiz_0
        port map (
            clk_in1 => clk100MHz, -- input clock of 100MHz
            clk_out1 => clk25MHz, -- output clock to be divided via PLL to 25MHz
            resetn => '1',
            locked => locked
       );


    -- VGA timing and pattern generator
    vga_inst : entity work.vga_test_pattern 
        port map (
            clk25MHz => clk25MHz, -- uses the 25MHz clock
            reset => reset, 
            vga_hsync => vga_hsync,
            vga_vsync => vga_vsync,
            vga_red => pixel_r,
            vga_green => pixel_g,
            vga_blue => pixel_b
        );
        
    -- connected output signals
    vga_red <= pixel_r; 
    vga_green <= pixel_g;
    vga_blue <= pixel_b;
    led <= locked; -- to see if the generated clock is stable
end Behavioral;
