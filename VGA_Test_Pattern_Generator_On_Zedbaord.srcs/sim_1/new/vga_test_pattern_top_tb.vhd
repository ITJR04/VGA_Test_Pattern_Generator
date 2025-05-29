----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/28/2025 12:44:42 PM
-- Design Name: VGA Test Pattern Simulation Testbench
-- Module Name: vga_test_pattern_top_tb - Behavioral
-- Project Name: VGA_Test_Pattern_Zedboard
-- Target Devices: ZedBoard Zynq-7000 (xc7z020clg484-1)
-- Tool Versions: Vivado 2024.2, Vivado Simulator or GHDL
-- Description: 
--     This is a simple behavioral testbench for the top-level VGA pattern 
--     generator. It generates a 100 MHz input clock and provides a stimulus 
--     to observe the output VGA signals, including sync pulses and RGB data.
-- 
--     The testbench is used to verify signal correctness in simulation and 
--     to check timing waveform behavior of hsync, vsync, video_on, and RGB.
--     No external files or stimulus vectors are needed.
-- 
-- Dependencies: 
--     - vga_test_pattern_top.vhd
--     - vga_test_pattern.vhd
--     - clk_wiz_0 (abstracted out in testbench or replaced with process)
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Clock process added, waveform inspection verified
-- Additional Comments:
--     - RGB output can be checked visually in waveform viewer (e.g., GTKWave)
--     - Simulation time must be extended to see frame behavior (e.g., 1ms+)
--     - This testbench does not instantiate real Clocking Wizard IP — instead,
--       clk25MHz is mimicked for simulation purposes if need be
--
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

entity vga_test_pattern_top_tb is
--  Port ( );
end vga_test_pattern_top_tb;

architecture Behavioral of vga_test_pattern_top_tb is
    -- DUT singals
    signal clk25MHz : std_logic := '0';
    signal reset : std_logic := '0';
    signal hsync : std_logic;
    signal vsync : std_logic;
    signal red : std_logic_vector(3 downto 0);
    signal green : std_logic_vector(3 downto 0);
    signal blue : std_logic_vector(3 downto 0);
    
    constant CLK_period : time := 40 ns;
    component vga_test_pattern_top
        port (
            clk100MHz : in std_logic;
            reset : in std_logic;
            vga_hsync : out std_logic;
            vga_vsync : out std_logic;
            vga_red : out std_logic_vector(3 downto 0);
            vga_green : out std_logic_vector(3 downto 0);
            vga_blue : out std_logic_vector(3 downto 0)
       ); 
    end component;
begin
    -- clock generation
    clk_process : process
    begin
        while true loop
            clk25MHz <= '0';
            wait for CLK_PERIOD/2;
            clk25MHZ <= '1';
            wait for CLK_PERIOD/2;
       end loop;
   end process;
   
   -- UUT instatiation
   uut: vga_test_pattern_top
        port map (
            clk100MHz => clk25MHz,
            reset => reset,
            vga_hsync => hsync,
            vga_vsync => vsync,
            vga_red => red,
            vga_green => green,
            vga_blue => blue
        );
        
   -- Stimulus Process
   stim_proc: process
   begin
        -- Hold reset for a few cycles
        wait for 1 ms;
        reset <= '0';
        
        -- let it run for a few scanlines
        wait for 1 ms;
        
        -- end simulation
        wait;
    end process;
            

end Behavioral;
