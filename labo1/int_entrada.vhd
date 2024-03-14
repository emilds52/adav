LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY interfaz_entrada IS 
  PORT (
  reset, clk    : in std_logic;
  validacion    : in std_logic;
  data_in       : in std_logic_vector(23 downto 0); 
  entradas      : out std_logic_vector(23 downto 0) ); 
  ACK           : out std_logic;
END interfaz_entrada;

ARCHITECTURE behavior OF interfaz_entrada IS
  signal ACK_reg : std_logic;
BEGIN  
  Proc_Captura : PROCESS (reset, clk)
  BEGIN
    IF reset='0' THEN
      entradas <= (others => '0');
    ELSIF (clk'event AND clk='1') THEN
      entradas <= entradas;
      IF (validacion = '1' AND ACK_reg = '0') THEN  
        entradas <= data_in;
        ACK_reg  <= '1';
      ELSIF (validacion = '0' AND ACK_reg = '1') THEN
        ACK_reg <= '0';
      END IF;
    END IF; 
  END PROCESS;
END behavior;

ACK <= ACK_reg;
