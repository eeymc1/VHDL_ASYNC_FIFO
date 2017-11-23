----------------------------------------------------------------
------------------sync_r2w.vhd(component)-----------------------
-- this is a synchronizer module that is used to synchronize the 
-- read pointer into the write-clock domain. the synchronized read
-- pointer will be used by the wptr-full module to generate the 
-- FIFO full conidtion. 

----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------

entity sync_r2w is 
	port (  rptr     :in  std_logic;
		wclk     :in  std_logic;
		wrst_n   :in  std_logic;
		wq2_rptr :out std_logic
	      );

end sync_r2w;

-------------------------------------------------------------

architecture rtl of sync_r2w is 
	signal rptr_reg: std_logic;
begin 
	process (wclk,wrst_n)
	begin 
	   if (wrst_n = '1')then 
		rptr_reg <= (others =>'0');
		wq2_rptr <= (others =>'0');
	   elsif (wclk'event and wclk ='1')then
		rptr_reg <= rptr;
		wq2_rptr <= rptr_reg;
	   end if; 
	end process;		
end rtl;

---------------------------------------------------------------



