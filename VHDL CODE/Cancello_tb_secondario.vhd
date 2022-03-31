--------------------------------------------------------------------------------

-- Company: 

-- Engineer:

--

-- Create Date:   16:53:05 01/12/2020

-- Design Name:   

-- Module Name:   /home/ise/TracciaN5/Cancello_tb_secondario.vhd

-- Project Name:  TracciaN5

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

USE ieee.std_logic_arith.ALL;



-- Uncomment the following library declaration if using

-- arithmetic functions with Signed or Unsigned values

--USE ieee.numeric_std.ALL;



ENTITY Cancello_tb_secondario IS

END Cancello_tb_secondario;

 

ARCHITECTURE behavior OF Cancello_tb_secondario IS 

 

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

 

	-- Function Integer to STD_LOGIC

	function to_std_logic(i : in integer) return std_logic is

	begin

		if i = 0 then

			return '0';

		end if;

		return '1';

	end function;



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

	

	variable i : integer :=0;

	variable tmp : std_logic_vector(1 downto 0);

	

	begin		

      RESET<='1';

      wait for 100 ns;	

		Reset<='0';

      wait for CLK_period*10;

		-- Testo Lo Stato S0 (combinazioni 0xx) 

		for i in 0 to 3 loop

		tmp:=conv_std_logic_vector(i,2);

		fotocellula<=tmp(1);

		sensore<=tmp(0);

		wait for CLK_period;

		end loop;

		-- Testo Lo Stato S0 (combinazioni 1x0)

		for i in 0 to 1 loop

		count:=0;

		fotocellula<=to_std_logic(i);

		sensore<='0';

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

		wait for CLK_period;

		end loop;

		count:=0;

		-- Testo Lo Stato S0 (combinazione 111)

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

		fotocellula<='1';

		sensore<='1';

		wait for CLK_period;

		count:=0;

		-- Testo Lo Stato S1 (combinazioni xx0)

		for i in 0 to 1 loop

		fotocellula<=to_std_logic(i);

		Sensore<='0';

		wait for CLK_period;

		end loop;

		-- Testo Lo Stato S1 (x11)

		fotocellula<='1';

		sensore<='1';

		wait for CLK_period;

		-- Testo Lo Stato S2 (combinazione xx0)

		for i in 0 to 1 loop

		wait for CLK_period*10;

		fotocellula<=to_std_logic(i);

		sensore<='0';

		wait for CLK_period;

		end loop;

		-- Testo Lo Stato S2 (combinazione x01)

		wait for CLK_period*10;

		fotocellula<='0';

		sensore<='1';

		wait for CLK_period;

		-- Testo Lo Stato S3 (combinazioni x00)

		fotocellula<='0';

		sensore<='0';

		wait for CLK_period;

		-- Testo Lo Stato S3 (combinazione x10)

		fotocellula<='1';

		sensore<='0';

		wait for CLK_period;

		-- Testo Lo Stato S4 (combinazioni xx1)

		for i in 0 to 1 loop

		wait for CLK_period*5;

		fotocellula<=to_std_logic(i);

		sensore<='1';

		wait for CLK_period;

		end loop;

		-- Testo Lo Stato S4 (combinazione x00)

		wait for CLK_period*5;

		fotocellula<='0';

		sensore<='0';

		wait for CLK_period;

		-- Uso Lo Stato S3 per andare in S4 e testare (combinazione x10)

		fotocellula<='1';

		sensore<='0';

		wait for CLK_period;

		-- Ritorno allo Stato S4 (combinazione x10)

		wait for CLK_period*5;

		fotocellula<='1';

		sensore<='0';

		wait for CLK_period;

		-- Testo Lo Stato S1 (combinazione x01)

		fotocellula<='0';

		sensore<='1';

		wait for CLK_period;

		-- Testo Lo Stato S2 (combinazione x11)

		wait for CLK_period*10;

		fotocellula<='1';

		sensore<='1';

		wait for CLK_period;

		-- Testo Lo Stato S3 (combinazione x01)

		fotocellula<='0';

		sensore<='1';

		wait for CLK_period;

		-- Testo Lo Stato S0 (combinazione 101)

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

		fotocellula<='0';

		sensore<='1';

		wait for CLK_period;

		count:=0;

		-- Uso Lo Stato S1 per andare in S2 e testare (combinazione 011)

		fotocellula<='1';

		sensore<='1';

		wait for CLK_period;

		-- Uso Lo Stato S2 per andare in S3 e testare (combinazione x11)

		wait for CLK_period*10;

		fotocellula<='1';

		sensore<='1';

		wait for CLK_period;

		-- Testo Lo Stato S3 (combinazione x11)

		fotocellula<='1';

		sensore<='1';

		wait for CLK_period;

		-- Mi Porto in S0 concludendo la testbench

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

