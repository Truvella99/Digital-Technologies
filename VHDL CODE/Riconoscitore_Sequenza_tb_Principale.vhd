--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:26:46 01/18/2020
-- Design Name:   
-- Module Name:   /home/ise/Progetto/Riconoscitore_Sequenza_tb_Principale.vhd
-- Project Name:  Progetto
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Riconoscitore_Sequenza_tb_Principale IS
END Riconoscitore_Sequenza_tb_Principale;
 
ARCHITECTURE behavior OF Riconoscitore_Sequenza_tb_Principale IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Riconoscitore_Sequenza
    PORT(
         COL : IN  std_logic_vector(2 downto 0);
         ROW : IN  std_logic_vector(3 downto 0);
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         state_debug : OUT  std_logic_vector(3 downto 0);
         Tastierino_Out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal COL : std_logic_vector(2 downto 0) := (others => '0');
   signal ROW : std_logic_vector(3 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';

 	--Outputs
   signal state_debug : std_logic_vector(3 downto 0);
   signal Tastierino_Out : std_logic;

	-- Variabili per assegnazione sequenza (corretta e non)
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
      RESET<='1';
      wait for 100 ns;	
		RESET<='0';
      wait for CLK_period*10;
		Sequenza<=Sequenza_Corretta;
		wait for CLK_period;
		Sequenza<="0000000";
		wait for CLK_period;
		Sequenza<=Sequenza_Corretta;
		wait for CLK_period;
		Sequenza<="0000000";
		wait for CLK_period;
		Sequenza<=Sequenza_Corretta;
		wait for CLK_period;
		Sequenza<="0000000";
      wait;
   end process;

END;
