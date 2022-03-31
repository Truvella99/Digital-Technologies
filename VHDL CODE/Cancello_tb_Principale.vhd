--------------------------------------------------------------------------------

-- Company: 

-- Engineer:

--

-- Create Date:   13:19:39 01/18/2020

-- Design Name:   

-- Module Name:   /home/ise/Progetto/Cancello_tb_principale.vhd

-- Project Name:  Progetto

-- Target Device:  

-- Tool versions:  

-- Description:   

-- 

-- VHDL Test Bench Created by ISE for module: Cancello

-- 

-- Dependencies:

-- 

-- Revision:

-- Revision 0.01 - File Created

-- Additional Comments:

--

-- Notes: 

-- This testbench has been automatically generated using types std_logic and

-- std_logic_vector for the ports of the unit under test.  Xilinx recommends

-- that these types always be used for the top-level I/O of a design in order

-- to guarantee that the testbench will bind correctly to the post-implementation 

-- simulation model.

--------------------------------------------------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;

 

-- Uncomment the following library declaration if using

-- arithmetic functions with Signed or Unsigned values

--USE ieee.numeric_std.ALL;

 

ENTITY Cancello_tb_principale IS

END Cancello_tb_principale;

 

ARCHITECTURE behavior OF Cancello_tb_principale IS 

 

    -- Component Declaration for the Unit Under Test (UUT)

 

    COMPONENT Cancello

    PORT(

         COL : IN  std_logic_vector(2 downto 0);

         ROW : IN  std_logic_vector(3 downto 0);

         Fotocellula : IN  std_logic;

         Sensore : IN  std_logic;

         CLK : IN  std_logic;

         RESET : IN  std_logic;

         count_S2_debug : OUT  std_logic_vector(3 downto 0);

         count_S4_debug : OUT  std_logic_vector(2 downto 0);

         state_debug : OUT  std_logic_vector(2 downto 0);

         Lampeggiante : OUT  std_logic;

         Motore : OUT  std_logic

        );

    END COMPONENT;

    



   --Inputs

   signal COL : std_logic_vector(2 downto 0) := (others => '0');

   signal ROW : std_logic_vector(3 downto 0) := (others => '0');

   signal Fotocellula : std_logic := '0';

   signal Sensore : std_logic := '0';

   signal CLK : std_logic := '0';

   signal RESET : std_logic := '0';



 	--Outputs

   signal count_S2_debug : std_logic_vector(3 downto 0);

   signal count_S4_debug : std_logic_vector(2 downto 0);

   signal state_debug : std_logic_vector(2 downto 0);

   signal Lampeggiante : std_logic;

   signal Motore : std_logic;

	

	-- Variabili per la TestBench

	signal Sequenza : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');

	constant Sequenza_Corretta : STD_LOGIC_VECTOR (6 downto 0) :="0100001";

	-- Variabile per contare le pressioni del tasto

	shared variable count : integer :=0;



   -- Clock period definitions

   constant CLK_period : time := 10 ns;


-- function std_logic_vector to string
	function to_string ( a: std_logic_vector) return string is
	variable b : string (1 to a'length) := (others => NUL);
	variable stri : integer := 1;
	begin
	for i in a'range loop
		b(stri) := std_logic'image(a((i))) (2);
		stri:= stri+1;
	end loop;
		return b;
	end function;
	

BEGIN

 

	-- Instantiate the Unit Under Test (UUT)

   uut: Cancello PORT MAP (

          COL => COL,

          ROW => ROW,

          Fotocellula => Fotocellula,

          Sensore => Sensore,

          CLK => CLK,

          RESET => RESET,

          count_S2_debug => count_S2_debug,

          count_S4_debug => count_S4_debug,

          state_debug => state_debug,

          Lampeggiante => Lampeggiante,

          Motore => Motore

        );



	COL<=Sequenza(6) & Sequenza(5) & Sequenza(4);

	ROW<=Sequenza(3) & Sequenza(2) & Sequenza(1) & Sequenza(0);



   -- Clock process definitions

   CLK_process :process

   begin

		CLK <= '0';

		wait for CLK_period/2;

		CLK <= '1';

		wait for CLK_period/2;

   end process;

 



   -- Stimulus process

   stim_proc: process

   begin		

      RESET<='1';

      wait for 100 ns;	

		RESET<='0';

      wait for CLK_period*10;

		-- Vado in S1 inserendo la sequenza corretta e alzando il sensore

		count:=0;

		Sequenza<=Sequenza_Corretta;

		wait for CLK_period;

		count:=count+1;

		Sequenza<="0000000";

		wait for CLK_period;

		Sequenza<=Sequenza_Corretta;

		wait for CLK_period;

		count:=count+1;

		Sequenza<="0000000";

		wait for CLK_period;

		Sequenza<=Sequenza_Corretta;

		wait for CLK_period;

		count:=count+1;

		Sequenza<="0000000";

		Sensore<='1';

		wait for CLK_period;

		count:=0;

		-- Permango in S1 con Sensore Basso

		Sensore<='0';

		wait for CLK_period;

		-- Vado in S2 con Sensore Alto

		Sensore<='1';

		wait for CLK_period;

		--Attendo 10 cicli di clock

		wait for CLK_period*10;

		-- Vado in S3

		wait for CLK_period;

		-- Permango in S3 con Sensore Basso

		Sensore<='0';

		wait for CLK_period;

		-- Ritorno ad S0

		Sensore<='1';

		wait for CLK_period;

      wait;

   end process;



Debug: process(RESET,state_debug,count_S2_debug,count_S4_debug)



begin

if (RESET='1') then

report "fase di reset" severity note;
elsif (state_debug="000" and sensore='1') then 

report "Vado in S0" severity note;

elsif (state_debug="000" and ((count=0) or (count=3 and Sensore='0'))) then 

report "Stato S0" severity note;

elsif ((state_debug="001" and sensore='1' and count=3) or (state_debug="001" and fotocellula='1' and sensore='0' and count_S4_debug="000")) then 

report "Vado in S1" severity note;

elsif (state_debug="001" and sensore='0') then

report "Stato S1" severity note;

elsif (state_debug="010" and sensore='1' and count_S2_debug="0000") then

report "Vado in S2" severity note;

elsif (state_debug="010" and sensore='0' and count_S2_debug="0000") then

report "Stato S2 : Sensore fine corsa non attivo (combinazione impossibile)" severity note;

elsif (state_debug="010") then 

report "Stato S2 : Il Conteggio dei colpi di clock  ad : " &to_string(count_S2_debug) severity note;

elsif ((state_debug="011" and count_S2_debug="0000") or (state_debug="011" and fotocellula='0' and sensore='0' and count_S4_debug="000")) then

report "Vado in S3" severity note;

elsif (state_debug="011" and sensore='0' and fotocellula='0') then

report "Stato S3" severity note;

elsif (state_debug="100" and fotocellula='1' and sensore='0' and count_S4_debug="000") then

report "Vado in S4" severity note;

elsif (state_debug="100" and sensore='1' and count_S4_debug="000") then

report "Stato S4 : Sensore fine corsa attivo (combinazione impossibile)" severity note;

elsif (state_debug="100") then

report "Stato S4 : Il Conteggio dei colpi di clock  ad : " &to_string(count_S4_debug) severity note;

else

report "Transizione Scorretta" severity error;

end if;

end process;



END;