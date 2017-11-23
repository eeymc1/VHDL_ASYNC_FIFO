


--------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.my_components.all;

--------------------------------------------------------------------

entity FIFO is
Generic (DSIZE :=8;  -- FIFO data width
	 ASIZE :=4); -- FIFO address width
	 
	port (wdata : in STD_LOGIC_VECTOR (DSIZE-1 DOWNTO 0);
	      winc  : in STD_LOGIC;
	      wclk  : in STD_LOGIC;
              wrst_n: in STD_LOGIC;
	      rinc  : in STD_LOGIC;
              rclk  : in STD_LOGIC;
              rrst_n: in STD_LOGIC;
              
	      rdata : out STD_LOGIC_VECTOR (DSIZE-1 DOWNTO 0);
	      wfull : out STD_LOGIC;
	      rempty: out STD_LOGIC
	);
end FIFO;
---------------------------------------------------------------------
architecture rtl of FIFO is 

	signal waddr: STD_LOGIC_VECTOR (ASIZE-1 DOWNTO 0);
	signal raddr: STD_LOGIC_VECTOR (ASIZE-1 DOWNTO 0);

begin
	u1: component fifomem    port map (wdata   => wdata,
					   waddr   => waddr,
					   raddr   => raddr,
					   wclken  => wclken,
					   wfull   => wfull,
					   wclk	   => wclk,
					   rdata   => rdata
					);
---------------------------------------------------------------------
	u2: component sync_r2w   port map( rptr    => rptr,
					   wclk    => wclk,
					   wrst_n  => wrst_n,
					   wq2_rptr=> wq2_rptr
					);
---------------------------------------------------------------------
	u3: component sync_w2r   port map( wptr    => wptr,
					   rclk    => rclk,
					   rrst_n  => rrst_n,
					   rq2_wptr=> rq2_wptr
					);
---------------------------------------------------------------------
	u4: component rptr_empty port map( rclk    => rclk,
					   rrst_n  => rrst_n,
					   rinc    => rinc,
					   rptr    => rptr,
					   rempty  => rempty
					);
--------------------------------------------------------------------
	u5: component wptr_empty port map( wclk    => wclk,
					   wrst_n  => wrst_n,
					   winc    => winc,
					   wq2_rptr=> wq2_rptr,
					   waddr   => waddr,
					   wptr    => wptr,
					   wfull   => wfull
					);
--------------------------------------------------------------------
end rtl;

 

