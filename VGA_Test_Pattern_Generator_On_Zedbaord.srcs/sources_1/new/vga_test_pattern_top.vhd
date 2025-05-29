----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/28/2025 12:25:39 PM
-- Design Name: 
-- Module Name: vga_test_pattern_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

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
            clk_in1 => clk100MHz,
            clk_out1 => clk25MHz,
            resetn => '1',
            locked => locked
       );


    -- VGA timing and pattern generator
    vga_inst : entity work.vga_test_pattern 
        port map (
            clk25MHz => clk25MHz,
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
