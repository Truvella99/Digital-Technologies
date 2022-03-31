----------------------------------------------------------------------------------

-- Company: 

-- Engineer: 

-- 

-- Create Date:    13:10:16 01/18/2020 

-- Design Name: 

-- Module Name:    Riconoscitore_Sequenza - Behavioral 

-- Project Name: 

-- Target Devices: 

-- Tool versions: 

-- Description: 

--

-- Dependencies: 

--

-- Revision: 

-- Revision 0.01 - File Created

-- Additional Comments: 

--

----------------------------------------------------------------------------------

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using

-- arithmetic functions with Signed or Unsigned values

--use IEEE.NUMERIC_STD.ALL;



-- Uncomment the following library declaration if instantiating

-- any Xilinx primitives in this code.

--library UNISIM;

--use UNISIM.VComponents.all;



entity Riconoscitore_Sequenza is

    Port ( COL : in  STD_LOGIC_VECTOR (2 downto 0);

           ROW : in  STD_LOGIC_VECTOR (3 downto 0);

           CLK : in  STD_LOGIC;

           RESET : in  STD_LOGIC;

           state_debug : out  STD_LOGIC_VECTOR (3 downto 0);

           Tastierino_Out : out  STD_LOGIC);

end Riconoscitore_Sequenza;



architecture Behavioral of Riconoscitore_Sequenza is

type stato is (S0,S0att_giusto,S0att_sbagliato,S1_giusto,S1_sbagliato,S1att_giusto,S1att_sbagliato,S2_giusto,S2_sbagliato,S2att_giusto,S2att_sbagliato);

signal current_state,next_state : stato;



begin

--Processo Sincrono (registro dello stato corrente)

process (clk)

begin

if (rising_edge(clk)) then

	if(reset='1') then

		current_state<=S0;

	else

		current_state<=next_state;

	end if;

end if;

end process;

--Processo di Transizione di Stato e di Output(Separo l'assegnazione fra stati e l'assegnazione delle uscite con 2 if separati per una migliore leggibilità del codice) 



process (current_state,COL,ROW)

constant sequenza_col : STD_LOGIC_VECTOR (2 downto 0) := "010";

constant sequenza_row : STD_LOGIC_VECTOR (3 downto 0) := "0001";



begin

case (current_state) is 

		when S0 =>

			if (COL=sequenza_col and ROW=sequenza_row) then

				next_state<=S0att_giusto;

			elsif (COL="000" and ROW="0000") then 

				next_state<=S0;

			else 

				next_state<=S0att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S0att_giusto=>

			if (COL=sequenza_col and ROW=sequenza_row) then

				next_state<=S0att_giusto;

			elsif (COL="000" and ROW="0000") then

				next_state<=S1_giusto;

			else 

				next_state<=S0att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S1_giusto=> 

			if (COL=sequenza_col and ROW=sequenza_row) then

				next_state<=S1att_giusto;

			elsif (COL="000" and ROW="0000") then

				next_state<=S1_giusto;

			else

				next_state<=S1att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S1att_giusto=>

			if (COL=sequenza_col and ROW=sequenza_row) then

				next_state<=S1att_giusto;

			elsif (COL="000" and ROW="0000") then 

				next_state<=S2_giusto;

			else

				next_state<=S1att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S2_giusto=>

			if (COL=sequenza_col and ROW=sequenza_row) then

				next_state<=S2att_giusto;

			elsif (COL="000" and ROW="0000") then

				next_state<=S2_giusto;

			else 

				next_state<=S2att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S2att_giusto=>

			if (COL=sequenza_col and ROW=sequenza_row) then

				next_state<=S2att_giusto;

			elsif (COL="000" and ROW="0000") then

				next_state<=S0;

			else 

				next_state<=S2att_sbagliato;

			end if;

			if (COL="000" and ROW="0000") then

				Tastierino_Out<='1';

			else 

				Tastierino_Out<='0';

			end if;

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S0att_sbagliato=>

			if (COL="000" and ROW="0000") then

				next_state<=S1_sbagliato;

			else 

				next_state<=S0att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S1_sbagliato =>

			if (COL="000" and ROW="0000") then

				next_state<=S1_sbagliato;

			else 

				next_state<=S1att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S1att_sbagliato =>

			if (COL="000" and ROW="0000") then

				next_state<=S2_sbagliato;

			else 

				next_state<=S1att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S2_sbagliato =>

			if (COL="000" and ROW="0000") then

				next_state<=S2_sbagliato;

			else 

				next_state<=S2att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when S2att_sbagliato =>

			if (COL="000" and ROW="0000") then

				next_state<=S0;

			else 

				next_state<=S2att_sbagliato;

			end if;

				Tastierino_Out<='0';

				state_debug<=conv_std_logic_vector(stato'POS(current_state),4);

		when others =>

			next_state<=S0;

			Tastierino_Out<='0';

end case;

end process;

end Behavioral;



