LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY control IS 
  PORT (
  reset, clk    : in std_logic;
  validacion    : in std_logic;
  flags         : in  std_logic_vector(7 downto 0);
  comandos      : out std_logic_vector(7 downto 0);
  fin           : out std_logic );
END control;

ARCHITECTURE behavior OF control IS
  CONSTANT ck0  : integer := 0;  CONSTANT ck1  : integer := 1;
  CONSTANT ck2  : integer := 2;  CONSTANT ck3  : integer := 3;
  CONSTANT ck4  : integer := 4;  CONSTANT ck5  : integer := 5;
  CONSTANT ck6  : integer := 6;  CONSTANT ck7  : integer := 7;
  CONSTANT ck8  : integer := 8;  CONSTANT ck9  : integer := 9;
  CONSTANT ck10 : integer := 10; CONSTANT ck11 : integer := 11;
  signal estado : integer;
BEGIN  
  Proc_Estado : PROCESS (reset, clk)
  BEGIN
    IF reset='0' THEN
      estado <= 0;
    ELSIF (clk'event AND clk='1') THEN
      IF ((estado = ck0 AND validacion = '0') OR (estado = ck11)) THEN 
        estado <= ck0; 
      ELSE 
        estado <= estado + 1;
      END IF;
    END IF;
  END PROCESS;

  Proc_Comandos : PROCESS (all)
  BEGIN
    IF reset='0' THEN     comandos <= "00000000";   fin <= '0';      
    ELSE   
      comandos <= "00000000";     fin <= '0';
      CASE estado IS
        WHEN ck0  => comandos <= "00000000";
        WHEN ck1  => comandos <= "00000001";
        WHEN ck2  => comandos <= "00000010";
        WHEN ck3  => comandos <= "00000011";
        WHEN ck4  => comandos <= "00000100";
        WHEN ck5  => comandos <= "00000101";
        WHEN ck6  => comandos <= "00000110";
        WHEN ck7  => comandos <= "00000111"; 
        WHEN ck8  => comandos <= "00001000"; 
        WHEN ck9  => comandos <= "00001001"; 
        WHEN ck10 => comandos <= "00001010"; 
        WHEN ck11 => comandos <= "00001011"; fin <= '1';
        WHEN others => 
      END CASE;
    END IF; 
  END PROCESS;
END behavior;
