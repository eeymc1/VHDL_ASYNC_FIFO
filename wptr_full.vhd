------------------wptr_full.vhd ------------------------------------------------
-- This module is completely synchronous to the read-clock domian
-- and contains the FIFO read pointer and empty-flag logic 

-----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity  wptr_full is 
	generic (ADDRSIZE : integer :=4);
	port (	wclk, wrst_n, winc: in  std_logic;
		wq2_rptr          : in  std_logic;
		waddr             : out std_logic_vector (ADDRSIZE-1 DOWNTO 0);
                wptr              : out std_logic;
		wfull             : out std_logic
	 );

end wptr_full;

-------------------------------------------------------------------------------

architecture rtl of wptr_full is 
begin 	
	variable wbinnext   : std_logic_vector (ADDRSIZE-1 DOWNTO 0);
	variable wgraynext : std_logic_vector (ADDRSIZE-1 DOWNTO 0);
	signal   wbin      : std_logic_vector (ADDRSIZE-1 DOWNTO 0);
	variable wfull_val : std_logic;	

	wbinnext  := wbin + (winc & ~wfull);
	wgraynext := (wbinnext >>1) ^ wbinnext;
        waddr     := wbin[ADDRSIZE-1:0];
	wfull_val := (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1],wq2_rptr[ADDRSIZE-2:0]});

	process (wclk, wrst_n)
	begin
	   if(wrst_n = '1') then 
		wbin <= 0;
		wptr <= 0;
	   elsif (wclk'event & wclk='1') then
		wbin <= wbinnext;
		wptr <= wgraynext;
	   end if;
	end process

	process (wclk, wrst_n) 
	begin 
	   if(wrst_n = '1') then
		wfull <= 0;
	   elsif (wclk'event and wclk ='1') then 
		wfull <= wfull_val;
	end if 
	end process

end rtl 

------------------------------------------------------------------------------------------
		
