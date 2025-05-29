----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/28/2025 11:42:34 AM
-- Design Name: 
-- Module Name: vga_test_pattern - Behavioral
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
    constant H_VISIBLE : integer := 640;
    constant H_FRONT : integer := 16;
    constant H_SYNC : integer := 96;
    constant H_BACK : integer := 48;
    constant H_TOTAL : integer := 800;
    
    constant V_VISIBLE : integer := 480;
    constant V_FRONT : integer := 10;
    constant V_SYNC : integer := 2;
    constant V_BACK : integer := 33;
    constant V_TOTAL : integer := 525;
    
    signal hcount : integer range 0 to H_TOTAL - 1 := 0;
    signal vcount : integer range 0 to V_TOTAL -1 := 0;
    
    signal video_on : std_logic;
    
 
begin

    -- Horizontal counter
    process(clk25MHz)
    begin
        if rising_edge(clk25MHz) then
            if reset = '1' then
                hcount <= 0;
            elsif hcount = H_TOTAL - 1 then
                hcount <= 0;
            else
                hcount <= hcount + 1;
            end if;
        end if;
    end process;
    
    -- Vertical Counter
    process(clk25MHz)
    begin
        if rising_edge(clk25MHz) then
            if reset = '1' then
                vcount <= 0;
            elsif hcount = H_TOTAL - 1 then
                if vcount = V_TOTAL - 1 then
                    vcount <= 0;
                else
                    vcount <= vcount + 1;
                end if;
            end if;
        end if;
     end process;
     
     -- Sync Signal Generation
     vga_hsync <= '1' when (hcount >= (H_VISIBLE + H_FRONT) and hcount < (H_VISIBLE + H_FRONT + H_SYNC)) else '0';
     vga_vsync <= '1' when (vcount >= (V_VISIBLE + V_FRONT) and vcount < (V_VISIBLE + V_FRONT + V_SYNC)) else '0';
     
     -- Enable signal for visible region
     video_on <= '1' when (hcount < H_VISIBLE and vcount < V_VISIBLE) else '0';
     
     -- RGB Test Pattern (vertical stripes)
     
     process(hcount, video_on)
     begin
        if video_on = '1' then
            if hcount < 213 then
                vga_red <= "1111";
                vga_green <= "0000";
                vga_blue <= "0000";
            elsif hcount < 426 then
                vga_red <= "0000";
                vga_green <= "1111";
                vga_blue <= "0000";
           else
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
