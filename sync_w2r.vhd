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

entity sync_w2r is 
	port (  wptr     :in  std_logic;
		rclk     :in  std_logic;
		rrst_n   :in  std_logic;
		rq2_wptr :out std_logic
	      );

end sync_w2r;

-------------------------------------------------------------

architecture rtl of sync_w2r is 
	signal wptr_reg: std_logic;
begin 
	process (rclk,rrst_n)
	begin 
	   if (rrst_n = '1')then 
		wptr_reg <= (others =>'0');
		rq2_wptr <= (others =>'0');
	   elsif (rclk'event and rclk ='1')then
		wptr_reg <= wptr;
		rq2_wptr <= wptr_reg;
	   end if; 
	end process;		
end rtl;

---------------------------------------------------------------



