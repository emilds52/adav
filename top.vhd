LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY top IS 
  PORT (
     reset, clk      : in std_logic;
     validacion      : in std_logic;
     data_in         : in std_logic_vector(23 downto 0); 
     data_out        : out std_logic_vector(23 downto 0);  
     valid_out       : out std_logic );
END top;


ARCHITECTURE behavior OF top IS

COMPONENT datapath IS 
  PORT (
     reset, clk    : in std_logic;
     comandos      : in std_logic_vector(7 downto 0);
     entradas      : in std_logic_vector(23 downto 0);  
     salidas       : out std_logic_vector(23 downto 0);  
     flags         : out std_logic_vector(7 downto 0) );
END component;

COMPONENT control IS 
  PORT (
     reset, clk    : in std_logic;
     validacion    : in std_logic;
     flags         : in  std_logic_vector(7 downto 0);
     comandos      : out std_logic_vector(7 downto 0);
     fin           : out std_logic );
END component;

COMPONENT interfaz_entrada IS 
  PORT (
     reset, clk      : in std_logic;
     validacion      : in std_logic;
     data_in         : in std_logic_vector(23 downto 0); 
     entradas        : out std_logic_vector(23 downto 0) ); 
END component;

COMPONENT interfaz_salida IS 
  PORT (
     reset, clk      : in std_logic;
     fin             : in std_logic;
     salidas         : in std_logic_vector(23 downto 0);  
     data_out        : out std_logic_vector(23 downto 0);  
     valid_out       : out std_logic );
END component;


  SIGNAL entradas, salidas : std_logic_vector(23 downto 0);
  SIGNAL comandos, flags : std_logic_vector(7 downto 0);
  SIGNAL fin : std_logic;

  
BEGIN  


U1 : datapath 
     PORT MAP (reset => reset, clk => clk, 
     comandos => comandos, entradas => entradas, salidas => salidas, flags => flags );

U2 : control 
     PORT MAP (reset => reset, clk => clk, 
     validacion => validacion, comandos => comandos, flags => flags, fin => fin );

U3 : interfaz_entrada  
     PORT MAP (reset => reset, clk => clk, 
     validacion => validacion, data_in => data_in, entradas => entradas );

U4 : interfaz_salida  
     PORT MAP (reset => reset, clk => clk, 
     fin => fin, salidas => salidas, data_out => data_out, valid_out => valid_out );

	 
END behavior;
