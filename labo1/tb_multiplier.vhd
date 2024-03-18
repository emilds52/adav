LIBRARY IEEE;
USE IEEE.std_logic_1164.all;            -- basic logic types

ENTITY tb_multiplier IS 
END tb_multiplier;

ARCHITECTURE behavior OF tb_multiplier IS
  
  COMPONENT multiplier IS
    GENERIC (
      DATA_WIDTH : integer := 24
    );
    PORT (
      A  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      B  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      Q  : out std_logic_vector(2*DATA_WIDTH-1 downto 0)
    );
  END COMPONENT;  
  
  -- Cambiar constante para diferentes configuraciones de test
  CONSTANT DATA_WIDTH : integer := 24; 
  SIGNAL A : std_logic_vector(DATA_WIDTH-1 downto 0);
  SIGNAL B : std_logic_vector(DATA_WIDTH-1 downto 0);
  SIGNAL Q : std_logic_vector(2*DATA_WIDTH-1 downto 0);

BEGIN

  UUT : multiplier
  GENERIC MAP (
    DATA_WIDTH => DATA_WIDTH
  )
  PORT MAP (
    A => A,
    B => B,
    Q => Q
  );
  
  Proc_gen_inputs : PROCESS BEGIN
    A <= (others => '0');
    B <= (others => '0');
    wait for 50ns;
    A <= "00000000" & "00000000" & "00000001";
    wait for 50ns;
    B <= "00000000" & "00000000" & "00000001";
    wait for 50ns;
    B <= "00000000" & "00000000" & "00111111";
    wait for 50ns;
    A <= "00000000" & "00000000" & "11001101";
    wait for 50ns;
    B <= "00000000" & "00001111" & "00000001";
    wait for 50ns;
    A <= "00000000" & "00000000" & "00000000";
    B <= "11111111" & "11111111" & "11111111";
    wait;
  END PROCESS;

END behavior;
