LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE work.tipos.all;

ENTITY interfaz_salida IS 
  GENERIC (
     k : integer := pa_k );
  PORT (
     reset, clk     : in std_logic;
           fin      : in std_logic;
           salidas  : in LOGIC_ARRAY_T(k-1 downto 0)(23 downto 0);
           data_out : out LOGIC_ARRAY_T(k-1 downto 0)(23 downto 0);
           valid_out: out std_logic );
END interfaz_salida;

ARCHITECTURE behavior OF interfaz_salida IS
BEGIN  
      Proc_Entrega : PROCESS (reset, clk) BEGIN
           IF reset='0' THEN
                data_out <= (others => (others => '0'));    valid_out <= '0';
           ELSIF (clk'event AND clk='1') THEN
                valid_out <= '0';
                IF fin = '1' THEN  
                     data_out <= salidas;
                     valid_out <= '1';
               END IF;
           END IF; 
      END PROCESS;
END behavior;
