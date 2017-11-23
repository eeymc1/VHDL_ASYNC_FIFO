----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------

package my_components is 

----------------------------------------------------------
component fifomem is 
	generic (DATASIZE : integer := 8;
		 ADDRSIZE : integer := 4;
		 WORDS    : integer := 8);
	port    (wdata            : in std_logic_vector (DATASIZE-1 DOWNTO 0);
		 waddr,raddr      : in std_logic_vector (DATASIZE-1 DOWNTO 0);
		 wclken,wfull,wclk: in std_logic;
		 rdata            : out std_logic_vector(DATASIZE-1 DOWNTO 0)
		
	);

end component; 
----------------------------------------------------------
component sync_r2w is 

	port (  rptr     :in  std_logic;
		wclk     :in  std_logic;
		wrst_n   :in  std_logic;
		wq2_rptr :in  std_logic

	);
end component; 
----------------------------------------------------------
component sync_w2r is 

	port (  wptr      :in std_logic;
		rclk      : in std_logic;
		rrst_n    : in std_logic;
		rq2_wptr  : out std_logic
	
	);
end component; 
----------------------------------------------------------
component rptr_empty is 
	generic (ADDRSIZE : integer:= 4);
	port (  rclk,rrst_n,rinc : in std_logic;
		rq2_wptr         : in std_logic;
		raddr		 : out std_logic_vector (ADDRSIZE-1 DOWNTO 0);
		rptr		 : out std_logic;
		rempty		 : out std_logic
	);
	
end component; 
----------------------------------------------------------
component wptr_empty is 
	generic (ADDRSIZE : integer := 4);
	port (	wclk,wrst_n,winc: in std_logic;
		wq2_rptr	: in std_logic;
		waddr		: out std_logic_vector (ADDRSIZE-1 DOWNTO 0);
		wptr		: out std_logic;
		wfull		: out std_logic
	
	);
end component; 
----------------------------------------------------------

end my_components;

----------------------------------------------------------
