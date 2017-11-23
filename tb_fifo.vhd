----------------------------------------------------------------------------------
-------------------------testbench for the fifo-----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


----------------------------------------------------------------------------------

entity tb_fifo is 
end tb_fifo;

architecture test of tb_fifo is 

	constant wclk_period : time := 100 ns;
	constant rclk_period : time := 50 ns;

	--signal used to end simulator when we finished submitting our test cases
	signal sim_finished : boolean := false;

	--fifo generics
	constant DSISE : integer := 8;
	constant ASIZE : integer := 4;

        --fifo ports
	signal wclk   : std_logic;
	signal winc   : std_logic;
	signal wrst_n : std_logic;
	signal rclk   : std_logic;
	signal rinc   : std_logic;
	signal rrst_n : std_logic;
	signal wfull  : std_logic;
	signal rempty : std_logic;
	signal wdata  : std_logic_vector (DSIZE-1 DOWNTO 0);
	signal rdata  : std_logic_vector (DSIZE-1 DOWNTO 0);

begin 

	--instantiate DUT
	dut: entity work.fifo
	generic map ( 	DSIZE => DSIZE, ASIZE => ASIZE)
	port map    ( 	wclk  => wclk,
		      	winc  => winc,
			wrst_n=> wrst_n,
			rclk  => rclk,
			rinc  => rinc,
			rrst_n=> rrst_n,
			wfull => wfull,
			rempty=> rempty,
			wdata => wdata,
			rdata => rdata
		    );

	--generate wclk signal 
	wclk_generation : process
	begin 
	   if not sim_finished then 
		wclk <= '1';
		wait for wclk_period / 2;
		wclk <= '0';
		wait for wclk_period / 2;
	   else 
		wait;
	   end if;
	end process wclk_generation;

	--generate rclk signal 
	rclk_generation : process
	begin 
	   if not sim_finished then 
		rclk <= '1';
		wait for rclk_period / 2;
		rclk <= '0';
		wait for rclk_period / 2;
	   else 
		wait;
	   end if;
	end process rclk_generation;
	
	-- test fifo 
	simulation : process
		-- reset generation 
		procedure async_reset is 
		begin 
  		   wait until rising_edge(wclk)
		   wait for wclk_period / 4;
		   	wrst_n <= '1';
			rrst_n <= '1';
		   wait for wclk_period / 2;
		   	wrst_n <= '0';
			rrst_n <= '0';
		end procedure async_wreset;
	
		
		procedure check       (constant wdata_in1   : in natural;
				       constant res_expected: in natural) is
			variable res:natural; 
		begin 
			wait until rising_edge (wclk);
			wdata <= std_logic_vector (to_unsigned (wdata_in1,wdata'length));
			winc  <= '1';

			wait until rising_edge (wclk);
			wdata <= (others => '0');
			winc  <='0';
			
			wait until rising_edge (rclk);
			rinc  <='1';
			wait until rising_edge (rclk);
			--check output against expected result
			res:= to_ingeter(unsigned(rdata);
			assert res=res_expected
			report 	"Unexpected result: " &
				"wdata =" & integer'image(wdata_in1) & ";"&
				"rdata =" & integer'image(res)       & ";"&
				"rdata_expected = " & integer'image(res_expected)
			severity error;
			
		end procedure check;
	begin
		--default values
		wdata   <= (others => '0');
		winc    <= '0';
		wclk    <= '0';
		wrst_n  <= '0';
		rclk    <= '0';
		rinc    <= '0';
		rrst_n  <= '0';
		wait for wclk_period;

		--reset the circuit
		async_reset;

		check(10,10);

	end process simulation;
end architecture test;





