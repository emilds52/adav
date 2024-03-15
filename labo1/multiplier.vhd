LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY multiplier IS
GENERIC (
  DATA_WIDTH : integer := 24
);
PORT (
  A  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
  B  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
  Q  : out std_logic_vector(2*DATA_WIDTH-1 downto 0)
);
END multiplier;

ARCHITECTURE structural OF multiplier IS

  COMPONENT full_adder IS
  PORT (
    A   : in  std_logic;
    B   : in  std_logic;
    Cin : in  std_logic;
    Sum : out std_logic;
    Cout: out std_logic
  );
  END COMPONENT;

  COMPONENT half_adder IS
  PORT (
    A   : in  std_logic;
    B   : in  std_logic;
    Sum : out std_logic;
    Cout: out std_logic
  );
  END COMPONENT;
  
  TYPE PARTIAL_PRODUCTS_T IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC;
  SIGNAL pps : PARTIAL_PRODUCTS_T(DATA_WIDTH-1 downto 0, DATA_WIDTH-1 downto 0);

BEGIN
  -- Generate partial products: 
  pps_proc : PROCESS(ALL) BEGIN
    pp_row : FOR i IN 0 TO DATA_WIDTH-1 LOOP 
      pp_col : FOR j IN 0 TO DATA_WIDTH-1 LOOP
        pps(i, j) <= A(i) AND B(j);
      END LOOP;
    END LOOP;
  END PROCESS;
  
  -- Generate Adders
  row_gen : FOR i IN 0 TO DATA_WIDTH-1 GENERATE
    IF (i = '0') GENERATE
      HA_i_INST : half_adder
        PORT MAP (
          A    => ,
          B    => ,
          Sum  => Q(1),
          Cout => ,
        );
    ELSIF i = 'DATA_WIDTH-1' GENERATE

    END GENERATE;
  END GENERATE;
  
  Q(0) <= pps(0,0);

END ARCHITECTURE;
