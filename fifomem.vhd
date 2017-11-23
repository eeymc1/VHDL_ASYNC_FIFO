
---------fifomem.vhd (component)-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity fifomem is 
       generic( DATASIZE  integer := 8; -- MEMORY DATA WORD WIDTH
       		ADDRSIZE  integer := 4; -- MEMORY ADDRESS WIDTH
		WORDS     integer := 8);
       port   ( wdata	          : in std_logic_vector (DATASIZE-1 DOWNTO 0);
       	        waddr,raddr       : in std_logic_vector (ADDRSIZE-1 DOWNTO 0);
	        wclken,wfull,wclk : in std_logic;       	  
	        rdata	          : out std_logic_vector(DATASIZE-1 DOWNTO 0);
	    );
end fifomem;

---------------------------------------------------------------------------

architecture rtl of fifomem is 
	type vector_array is array (0 to WORDS-1);
	     std_logic_vector (DATASIZE-1 DOWNTO 0);
	signal memory: vector_array;

begin 
	process (wclk)
	      	begin
		if (wclk'event and wclk ='1')then
		   if (wclken and wfull ='0')then
			memory[waddr] <= wdata;
		   end if;
		end if;
	end process;
	rdata <= memory[raddr];
end rtl;

---------------------------------------------------------------------------


