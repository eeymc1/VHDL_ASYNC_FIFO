------------------rptr_empty.vhd ---------------------------------------------
-- this module generate empty flag
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity  rptr_empty is 
	generic (ADDRSIZE : integer :=4);
	port (	rclk, rrst_n, rinc: in  std_logic;
		rq2_wptr          : in  std_logic;
		raddr             : out std_logic_vector (ADDRSIZE-1 DOWNTO 0);
                rptr              : out std_logic;
		rempty            : out std_logic;
	 );

end ;

-------------------------------------------------------------------------------

architecture rtl of rptr_empty is 
begin 	
	variable rbinnext   : std_logic_vector (ADDRSIZE-1 DOWNTO 0);
	variable rgraynext  : std_logic_vector (ADDRSIZE-1 DOWNTO 0);
	signal   rbin       : std_logic_vector (ADDRSIZE-1 DOWNTO 0);
	variable rempty_val : std_logic;	

	rbinnext   := rbin + (rinc & ~empty);
	rgraynext  := (rbinnext >>1) ^ rbinnext;
        raddr      := rbin[ADDRSIZE-1:0];
	rempty_val := (rgraynext = rq2_wptr);

	process (rclk, rrst_n)
	begin
	   if(rrst_n = '1') then 
		rbin <= 0;
		rptr <= 0;
	   elsif (rclk'event & rclk='1') then
		rbin <= rbinnext;
		rptr <= rgraynext;
	   end if;
	end process

	process (rclk, rrst_n) 
	begin 
	   if(rrst_n = '1') then
		rempty <= 0;
	   elsif (rclk'event and rclk ='1') then 
		rempty <= rempty_val;
	end if 
	end process

end rtl 

------------------------------------------------------------------------------------------
		
