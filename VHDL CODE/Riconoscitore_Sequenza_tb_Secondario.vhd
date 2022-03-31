--------------------------------------------------------------------------------

-- Company: 

-- Engineer:

--

-- Create Date:   09:40:52 12/29/2019

-- Design Name:   

-- Module Name:   /home/ise/TracciaN5/Riconoscitore_Sequenza_tb_Secondario.vhd

-- Project Name:  TracciaN5

-- Target Device:  

-- Tool versions:  

-- Description:   

-- 

-- VHDL Test Bench Created by ISE for module: Riconoscitore_Sequenza

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

 

ENTITY Riconoscitore_Sequenza_tb_Secondario IS

END Riconoscitore_Sequenza_tb_Secondario;

 

ARCHITECTURE behavior OF Riconoscitore_Sequenza_tb_Secondario IS 

 

    -- Component Declaration for the Unit Under Test (UUT)

 

    COMPONENT Riconoscitore_Sequenza

    PORT(

         COL : IN  std_logic_vector(2 downto 0);

         ROW : IN  std_logic_vector(3 downto 0);

         CLK : IN  std_logic;

         RESET : IN  std_logic;
			state_debug : out  STD_LOGIC_VECTOR (3 downto 0);

         Tastierino_Out : OUT  std_logic

        );

    END COMPONENT;

    



   --Inputs

   signal COL : std_logic_vector(2 downto 0) := (others => '0');

   signal ROW : std_logic_vector(3 downto 0) := (others => '0');

   signal CLK : std_logic := '0';

   signal RESET : std_logic := '0';



 	--Outputs
	signal state_debug : STD_LOGIC_VECTOR (3 downto 0);

   signal Tastierino_Out : std_logic;



	-- Variabile per contare le pressioni del tasto

	shared variable count : integer :=0;

	-- Variabile per contare le transizioni 

	shared variable number_trans : integer :=0;

	-- Variabili per conteggio e assegnazione sequenza (corretta e non)

	shared variable i : integer :=0;

	signal Sequenza : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');

	constant Sequenza_Corretta : STD_LOGIC_VECTOR (6 downto 0) :="0100001";

   

	-- Clock period definitions

   constant CLK_period : time := 10 ns;

 

BEGIN

 

	-- Instantiate the Unit Under Test (UUT)

   uut: Riconoscitore_Sequenza PORT MAP (

          COL => COL,

          ROW => ROW,

          CLK => CLK,

          RESET => RESET,
			 state_debug => state_debug,

          Tastierino_Out => Tastierino_Out

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

      -- hold reset state for 100 ns.

		RESET<='1';

      wait for 100 ns;	

		RESET<='0';

      wait for CLK_period*10;

		-- Testo il Nodo S0, per farlo passo per tutto il percorso sbagliato, quindi testo anche gli stati sbagliati, 

		-- permanendo per un periodo di clock in più con la combinazione i-esima

		Sequenza<="0000000";

		wait for clk_period;

		for i in 1 to 32 loop

			number_trans := i;

			count:=0;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period*2;

			count := count + 1;

			Sequenza<="0000000";

			wait for clk_period*2;

			

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period*2;

			count := count + 1;

			Sequenza<="0000000";

			wait for clk_period*2;



			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period*2;

			count := count + 1;

			Sequenza<="0000000";

			wait for clk_period*2;

		end loop;

		

		for i in 34 to 127 loop

			number_trans := i;

			count:=0;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period*2;

			count := count + 1;

			Sequenza<="0000000";

			wait for clk_period*2;

			

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period*2;

			count := count + 1;

			Sequenza<="0000000";

			wait for clk_period*2;



			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period*2;

			count := count + 1;

			Sequenza<="0000000";

			wait for clk_period*2;

		end loop;

		-- Ora testo l'unica combinazione rimasta per gli stati sbagliati, testandoli definitivamente, ripercorrendo il percorso errato

			number_trans := 128;

			count:=0;

			count := count + 1;

			Sequenza<="0000001";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period*2;

			

			Sequenza<=Sequenza_Corretta;

			wait for clk_period*2;

			count := count + 1;

			Sequenza<="0000000";

			wait for clk_period*2;



			Sequenza<=Sequenza_Corretta;

			wait for clk_period*2;

			count := count + 1;

			-- Mi sposto in S0 e Permango nello stato

			Sequenza<="0000000";

			wait for clk_period*2;

			count:=0;

			-- Mi sposto in S0_Att_Giusto e Permango nello stato

			Sequenza<=Sequenza_Corretta;

			wait for clk_period*2;

			-- Testo Il Nodo S0Att_Giusto (Tranne che per 0000000) (non metto clk_period*2 perchè gli stati sbagliati li ho già testati)

			for i in 1 to 32 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			

			count:=0;

			--Mi riporto da S0 in S0Att_Giusto e continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			

			end loop;

			

			for i in 34 to 127 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			

			count:=0;

			--Mi riporto da S0 in S0Att_Giusto e continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			

			end loop;

			number_trans:=128;

			-- Testo l'ultima combinazione per S0att_giusto, cioè 0000000,transitando in S1_giusto, e permanendo in quello stato

			Sequenza<="0000000";

			wait for clk_period*2;

			-- Testo Il Nodo S1_Giusto

			count:=1;

			for i in 1 to 32 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=1;

			

			--Mi riporto da S0 in S1_Giusto e continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			end loop;

			

			for i in 34 to 127 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=1;

			

			--Mi riporto da S0 in S1_Giusto e continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			end loop;

			count:=0;

			number_trans:=128;

			--Testo l'ultima combinazione per S1_Giusto andando in S1att_giusto e permanendo in quello stato

			Sequenza<=Sequenza_Corretta;

			wait for clk_period*2;

			--Testo il Nodo S1att_Giusto

			count:=1;

			for i in 1 to 32 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=1;

			

			-- Mi Riporto Da S0 ad S1att_giusto, e poi continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			end loop;

			

			for i in 34 to 127 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=1;

			

			-- Mi Riporto Da S0 ad S1att_giusto, e poi continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			end loop;

			

			count:=0;

			number_trans:=128;

			--Testo l'ultima combinazione per S1att_Giusto andando in S2_giusto e permanendo in quello stato

			Sequenza<="0000000";

			wait for clk_period*2;

			--Testo il Nodo S2_giusto

			count:=2;

			for i in 1 to 32 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=2;

			--Mi Riporto da S0 a S2_giusto e poi continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			end loop;

			

			for i in 34 to 127 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=2;

			--Mi Riporto da S0 a S2_giusto e poi continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			end loop;

			

			count:=0;

			number_trans:=128;

			--Testo l'ultima combinazione per S2_Giusto andando in S2att_giusto e permanendo in quello stato

			Sequenza<=Sequenza_Corretta;

			wait for clk_period*2;

			-- Testo Il Nodo S2att_giusto

			count:=2;

			for i in 1 to 32 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=2;

			--Mi Riporto da S0 ad S2att_giusto e poi continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			end loop;

			

			for i in 34 to 127 loop

			number_trans:=i;

			Sequenza<=conv_std_logic_vector(i,7);

			wait for clk_period;

			count:= count + 1;

			Sequenza<="0000000";

			wait for clk_period;

			count:=2;

			--Mi Riporto da S0 ad S2att_giusto e poi continuo a testare

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			Sequenza<="0000000";

			wait for clk_period;

			Sequenza<=Sequenza_Corretta;

			wait for clk_period;

			end loop;

			

			count:=0;

			number_trans:=128;			

			--Testo l'ultima combinazione per S2att_Giusto andando in S0 concludendo la testbench

			Sequenza<="0000000";

			wait for clk_period;

			

      wait;

   end process;









Debug: process (RESET,COL,ROW,Tastierino_Out)

constant Sequenza_Col : STD_LOGIC_VECTOR (2 downto 0) := "010";

constant Sequenza_Row : STD_LOGIC_VECTOR (3 downto 0) :="0001";



begin

if (RESET='1')  then report "Fase di Reset" severity note;

else

	if (state_debug="1001" and count=0 and Tastierino_Out='1' and COL="000" and ROW="0000" and number_trans=128) then

	report "Ho Riconosciuto La Sequenza Corretta" severity note;

	elsif (state_debug="0000" and count=0 and COL="000" and ROW="0000" and (number_trans=128 or number_trans=0)) then 

	report "Permango in S0" severity note;

	elsif (state_debug="0001" and count=0 and COL="000" and ROW="0000" and number_trans=128) then 
	report "Passo da S0Att_Giusto ad S1_Giusto e Permango in S1_Giusto" severity note;

	elsif (state_debug="0101" and count=0 and COL="000" and ROW="0000" and number_trans=128) then
	report "Passo da S1Att_Giusto ad S2_Giusto e Permango in S2_Giusto" severity note;

	elsif (state_debug="0000" and count=0 and COL=Sequenza_Col and ROW=Sequenza_Row and number_trans=128) then 

	report "Passo Da S0 ad S0att_giusto e Permango in S0att_giusto" severity note;

	elsif (state_debug="0011" and count=0 and COL=Sequenza_Col and ROW=Sequenza_Row and number_trans=128) then 

	report "Passo da S1_Giusto ad S1att_giusto e Permango in S1_att_giusto" severity note;
	elsif (state_debug="0111" and count=0 and COL=Sequenza_Col and ROW=Sequenza_Row and number_trans=128) then 

	report "Passo da S2_giusto ad S2_att_giusto e Permango in S2_att_giusto" severity note;

	elsif (count/=3 and (COL/=Sequenza_Col or ROW/=Sequenza_Row)) then 

	report "Testo il percorso errato" severity note;

	elsif (count/=3 and COL=Sequenza_Col and ROW=Sequenza_Row) then 

	report "Testo il percorso errato (Combinazione 33)" severity note;

	elsif (count=3 and COL="000" and ROW="0000") then 

	report "Combinazione testata, transizione numero " & integer'image(number_trans)  severity note; 

	else report "C' una transizione Scorretta" severity warning;

	end if;

end if;

end process Debug;



END;