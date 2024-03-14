LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY interfaz_salida IS 
  PORT (
  reset, clk : in std_logic;
  fin        : in std_logic;
  salidas    : in std_logic_vector(23 downto 0);
  ACK        : in std_logic;
  data_out   : out std_logic_vector(23 downto 0);
  valid_out  : out std_logic );
END interfaz_salida;

ARCHITECTURE behavior OF interfaz_salida IS
  signal valid_out_reg : std_logic;
BEGIN  
Proc_Entrega : PROCESS (reset, clk) BEGIN
  IF reset='0' THEN
    data_out <= (others => '0');    valid_out_reg <= '0';
  ELSIF (clk'event AND clk='1') THEN    
    IF fin = '1' THEN  
      data_out  <= salidas;
      valid_out_reg <= '1';
    ELSIF ACK = '1' AND valid_out_reg = '1' THEN
      valid_out_reg <= '0';
    END IF;
  END IF; 
END PROCESS;

valid_out <= valid_out_reg;

END behavior;
