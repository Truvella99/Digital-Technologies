----------------------------------------------------------------------------------

-- Company: 

-- Engineer: 

-- 

-- Create Date:    13:01:47 01/18/2020 

-- Design Name: 

-- Module Name:    Cancello - Behavioral 

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



entity Cancello is

    Port ( COL : in  STD_LOGIC_VECTOR (2 downto 0);

           ROW : in  STD_LOGIC_VECTOR (3 downto 0);

           Fotocellula : in  STD_LOGIC;

           Sensore : in  STD_LOGIC;

           CLK : in  STD_LOGIC;

           RESET : in  STD_LOGIC;

           count_S2_debug : out  STD_LOGIC_VECTOR (3 downto 0);

           count_S4_debug : out  STD_LOGIC_VECTOR (2 downto 0);

           state_debug : out  STD_LOGIC_VECTOR (2 downto 0);

           Lampeggiante : out  STD_LOGIC;

           Motore : out  STD_LOGIC);

end Cancello;



architecture Behavioral of Cancello is

Component Riconoscitore_Sequenza port (COL : in STD_LOGIC_VECTOR (2 downto 0);

													ROW : in STD_LOGIC_VECTOR (3 downto 0);

													CLK : in STD_LOGIC;

													RESET : in STD_LOGIC;

													state_debug : out  STD_LOGIC_VECTOR (3 downto 0);

													Tastierino_Out : out  STD_LOGIC);

end component;



type stato is (S0,S1,S2,S3,S4);

signal current_state,next_state : stato;

signal Timeover_S2,Timeover_S4 : std_logic;

signal count_S2,ncount_S2 : integer range 0 to 10;

signal count_S4,ncount_S4 : integer range 0 to 5;

-- Segnale di appoggio per abilitare il lampeggiante e uscita del tastierino

signal Enable : STD_LOGIC;
signal Tastierino_state_debug : STD_LOGIC_VECTOR (3 downto 0);

signal Tastierino_Out : STD_LOGIC;
signal RESET_Tastierino : STD_LOGIC :='0';

-- Segnali per processo lampeggiante (Inizializzo toggle ad 1 per comodità nelle forme d'onda)

--constant max_count : natural := 1;

--signal count : natural range 0 to max_count;

signal toggle : STD_LOGIC :='1';



begin

RC : Riconoscitore_Sequenza port map (COL,ROW,CLK,RESET_Tastierino,Tastierino_state_debug,Tastierino_Out);
--Processo Sincrono (registro dello stato corrente)

process (clk)

begin

if (rising_edge(clk)) then

	if(reset='1') then

		current_state<=S0;

		count_S2<=0;

		count_S4<=0;

	else

		current_state<=next_state;

		count_S2<=ncount_S2;

		count_S4<=ncount_S4;

	end if;

end if;

end process;


--Processo di Transizione di Stato

process (current_state,Fotocellula,Sensore,Timeover_S2,Timeover_S4,Tastierino_Out)

begin

	case (current_state) is 

					when S0=>
						RESET_Tastierino<='0';

						if (Tastierino_Out='1' and Sensore='1') then --In fase di apertura non mi interessa della fotocellula,apro lo stesso

							next_state<=S1;

						else 

							next_state<=S0;

						end if;

						state_debug<=conv_std_logic_vector(stato'POS(current_state),3);

					when S1=>
						RESET_Tastierino<='1';

						if (Sensore='1') then

							next_state<=S2;

						else 

							next_state<=S1;

						end if;

						state_debug<=conv_std_logic_vector(stato'POS(current_state),3);

					when S2=>
						RESET_Tastierino<='1';

						if (Timeover_S2='1' and Sensore='1') then

							next_state<=S3;

						else

							next_state<=S2;

						end if;

						state_debug<=conv_std_logic_vector(stato'POS(current_state),3);						

					when S3=>
						RESET_Tastierino<='1';

						if (Sensore='1') then

							next_state<=S0;
						elsif (Fotocellula='0' and Sensore='0') then

							next_state<=S3;

						else 

							next_state<=S4;

						end if;

						state_debug<=conv_std_logic_vector(stato'POS(current_state),3);

					when S4=>
						RESET_Tastierino<='1';

						if (Timeover_S4='0') then

							next_state<=S4;

						elsif (Sensore='1') then

							next_state<=S4;

						elsif (Fotocellula='1' and Sensore='0') then

							next_state<=S1;

						else

							next_state<=S3;

						end if;

						state_debug<=conv_std_logic_vector(stato'POS(current_state),3);

					when others=>
						RESET_Tastierino<='1';

						next_state<=S0;

		end case;

end process;



-- Processo di Output (Uscita Motore)

process (current_state)

begin

	case (current_state) is

		when S0 =>  Enable<='0'; Motore<='0'; 	

		when S1 =>  Enable<='1'; Motore<='1';

		when S2 =>  Enable<='0'; Motore<='0';

		when S3 =>  Enable<='1'; Motore<='1';

		when S4 =>  Enable<='0'; Motore<='0';

		when others => Enable<='0'; Motore<='0';		

	end case;

end process;





-- Processo di Output (Uscita Lampeggiante)

process(CLK)

begin

if(rising_edge(CLK)) then

		--if (count=max_count-1) then

		toggle<= not toggle;

		--count<=0;

		--else

		--count<=count +1;

		--end if;

	end if;

end process;

Lampeggiante<=toggle and Enable;



-- Processo Timer Stato S2

Timer_S2:process(current_state,count_S2)

begin 

	if (current_state=S2) then

			if (count_S2=10) then

				ncount_S2<=0;

				timeover_S2<='1';

			else 

				ncount_S2<=count_S2+1;

				timeover_S2<='0';

			end if;

	else

		ncount_S2<=0;

		timeover_S2<='0';

	end if;

end process;



count_S2_debug<=conv_std_logic_vector(count_S2,4);



-- Processo Timer Stato S4

Timer_S4:process(current_state,count_S4)

begin

	if (current_state=S4) then

			if (count_S4=5) then

				ncount_S4<=0;

				timeover_S4<='1';

			else 

				ncount_S4<=count_S4+1;

				timeover_S4<='0';

			end if;

	else

		ncount_S4<=0;

		timeover_S4<='0';

	end if;

end process;



count_S4_debug<=conv_std_logic_vector(count_S4,3);



end Behavioral;