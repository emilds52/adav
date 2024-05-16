LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE work.tipos.all;

ENTITY interfaz_entrada IS 
  GENERIC (
     k : integer := pa_k );
  PORT (
     reset, clk    : in std_logic;
     validacion    : in std_logic;
     data_in       : in LOGIC_ARRAY_T(k-1 downto 0)(23 downto 0);
     entradas      : out LOGIC_ARRAY_T(k-1 downto 0)(23 downto 0) );  
END interfaz_entrada;

ARCHITECTURE behavior OF interfaz_entrada IS
BEGIN  
      Proc_Captura : PROCESS (reset, clk)
      BEGIN
           IF reset='0' THEN
                entradas <= (others => (others => '0'));
           ELSIF (clk'event AND clk='1') THEN
                IF validacion = '1' THEN  
                     entradas <= data_in;
               END IF;
           END IF; 
      END PROCESS;
END behavior;
