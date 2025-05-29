----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/28/2025 11:42:34 AM
-- Design Name: VGA 640x480 Test Pattern Generator
-- Module Name: vga_test_pattern - Behavioral
-- Project Name: VGA_Test_PAttern_Zedbaord
-- Target Devices: Zedbaord Zynq-7000 (xc7z020clg484-1)
-- Tool Versions: Vivado 2024.2
-- Description:    
--     This module generates a 640x480 VGA video signal at 60 Hz. It creates
--     proper horizontal and vertical sync pulses, tracks the current pixel
--     and scanline positions, and outputs a static color bar test pattern 
--     across the screen using simple RGB assignments.
--
--     Timing is based on a 25 MHz pixel clock. When video is active (inside
--     the visible display area), red, green, and blue bars are drawn in 
--     thirds based on the horizontal pixel count.
--
--     The module is intended to demonstrate video signal
--     generation on FPGAs and how to interface digital logic with VGA.
-- 
-- Dependencies:   NONE
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Logic verified on ZedBoard with 25 MHz MMCM clock and 
--                 working test pattern displayed on external VGA monitor.
-- Additional Comments:
--     - Designed for standalone operation on ZedBoard PL (Programmable Logic)
--     - Can be extended to include animation, text overlays, or live data which will be interesting for future projects
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

entity vga_test_pattern is 
    Port ( clk25MHz : in STD_LOGIC;
           reset : in STD_LOGIC;
           vga_hsync : out STD_LOGIC;
           vga_vsync : out STD_LOGIC;
           vga_red : out STD_LOGIC_VECTOR(3 downto 0);
           vga_green : out STD_LOGIC_VECTOR(3 downto 0);
           vga_blue : out STD_LOGIC_VECTOR (3 downto 0));
end vga_test_pattern;

architecture Behavioral of vga_test_pattern is
    constant H_VISIBLE : integer := 640; -- where image will be shown
    constant H_FRONT : integer := 16; -- Idle before sync
    constant H_SYNC : integer := 96; -- HSYNC low
    constant H_BACK : integer := 48; -- idle after sync
    constant H_TOTAL : integer := 800; -- Full horizontal scan
    
    constant V_VISIBLE : integer := 480; -- where image is shown
    constant V_FRONT : integer := 10; -- idle before sync
    constant V_SYNC : integer := 2; -- VSYNC is low
    constant V_BACK : integer := 33; -- Idle after sync
    constant V_TOTAL : integer := 525; -- Full vertical scan
    
    signal hcount : integer range 0 to H_TOTAL - 1 := 0; -- used to track horizontal pixel position
    signal vcount : integer range 0 to V_TOTAL -1 := 0; -- used to track vertical pixel position
    
    signal video_on : std_logic; -- indicates when in visible area (1 when in visible area and 0 when not)
    
 
begin

    -- Horizontal counter
    process(clk25MHz)
    begin
        if rising_edge(clk25MHz) then -- every clock cycle
            if reset = '1' then -- if we have a reset
                hcount <= 0; -- reset the horizontal count
            elsif hcount = H_TOTAL - 1 then -- if hcount has reached its max 
                hcount <= 0; -- reset the hcount 
            else --
                hcount <= hcount + 1; -- increment till hcount is at max
            end if;
        end if;
    end process;
    
    -- Vertical Counter
    process(clk25MHz)
    begin
        if rising_edge(clk25MHz) then -- every clock cycle
            if reset = '1' then -- if reset
                vcount <= 0; -- reset the vertical counter
            elsif hcount = H_TOTAL - 1 then -- if hcount is max
                if vcount = V_TOTAL - 1 then -- if vcount is at max
                    vcount <= 0; -- reset vertical count
                else -- if there is still some vertical pixels to account for
                    vcount <= vcount + 1; -- increment by one
                end if;
            end if;
        end if;
     end process;
     
     -- Sync Signal Generation
     vga_hsync <= '1' when (hcount >= (H_VISIBLE + H_FRONT) and hcount < (H_VISIBLE + H_FRONT + H_SYNC)) else '0'; 
     vga_vsync <= '1' when (vcount >= (V_VISIBLE + V_FRONT) and vcount < (V_VISIBLE + V_FRONT + V_SYNC)) else '0';
     
     -- Enable signal for visible region
     video_on <= '1' when (hcount < H_VISIBLE and vcount < V_VISIBLE) else '0'; -- video_on is on when witihn visible regions
     
     -- RGB Test Pattern (vertical stripes)
     
     process(hcount, video_on)
     begin
        if video_on = '1' then -- if witihn visible boudaries
            if hcount < 213 then -- for first 212 horizontal pixels it is fully red
                vga_red <= "1111"; 
                vga_green <= "0000";
                vga_blue <= "0000";
            elsif hcount < 426 then -- if pixel range from 213 to 425 then pixels are green
                vga_red <= "0000";
                vga_green <= "1111";
                vga_blue <= "0000";
           else -- else for the rest of the visible horizontal pixels the color is blue
                vga_red <= "0000";
                vga_green <= "0000";
                vga_blue <= "1111";
           end if;
        else
            vga_red <= "0000";
            vga_green <= "0000";
            vga_blue <= "0000";
       end if;
     end process;
                

end Behavioral;
