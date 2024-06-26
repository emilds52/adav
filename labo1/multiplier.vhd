LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
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
  
  TYPE LOGIC_ARRAY_T IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC;
  SIGNAL pps       : LOGIC_ARRAY_T(DATA_WIDTH*2-1 downto 0, DATA_WIDTH*2-1 downto 0);
  SIGNAL sum_aux   : LOGIC_ARRAY_T(DATA_WIDTH*2-3 downto 0, DATA_WIDTH*2-2 downto 0);
  SIGNAL carry_aux : LOGIC_ARRAY_T(DATA_WIDTH*2-2 downto 0, DATA_WIDTH*2-1 downto 0);
  SIGNAL A_ext     : std_logic_vector(DATA_WIDTH*2-1 downto 0);
  SIGNAL B_ext     : std_logic_vector(DATA_WIDTH*2-1 downto 0);
  SIGNAL Q_tmp     : std_logic_vector(DATA_WIDTH*4-1 downto 0);

BEGIN

  A_ext <= std_logic_vector(resize(signed(A), A_ext'length));
  B_ext <= std_logic_vector(resize(signed(B), B_ext'length));

  -- Generate partial products: 
  pps_proc : PROCESS(ALL) BEGIN
    pp_row : FOR i IN 0 TO DATA_WIDTH*2-1 LOOP 
      pp_col : FOR j IN 0 TO DATA_WIDTH*2-1 LOOP
        pps(i, j) <= A_ext(i) AND B_ext(j);
      END LOOP;
    END LOOP;
  END PROCESS;
  
  -- Generate Adders
  row_gen : FOR i IN 0 TO DATA_WIDTH*2-2 GENERATE
    row_gen_if : IF i = 0 GENERATE
      -- First row is special
      HA_i_INST : half_adder
      PORT MAP (
        A    => pps(1,0),
        B    => pps(0,1),
        Sum  => Q_tmp(1),
        Cout => carry_aux(0,0)
      );
      fa_first_gen : FOR j IN 0 TO DATA_WIDTH*2-3 GENERATE
        FA_i_INST : full_adder
        PORT MAP (
          A    => pps(2,j),
          B    => pps(1,j+1),
          Cin  => pps(0,j+2),
          Sum  => sum_aux(0,j),
          Cout => carry_aux(0,j+1)
        );
      END GENERATE;
      HA_end_INST : half_adder
      PORT MAP (
        A    => pps(2,DATA_WIDTH*2-3),
        B    => pps(1,DATA_WIDTH*2-2),
        Sum  => sum_aux(0, DATA_WIDTH*2-2),
        Cout => carry_aux(0,DATA_WIDTH*2-1)
      );
    ELSIF (i = DATA_WIDTH*2-2) GENERATE
      -- Generate final row
      HA_i_INST : half_adder
      PORT MAP (
        A    => carry_aux(i-1,0),
        B    => sum_aux(i-1,0),
        Sum  => Q_tmp(i+1),
        Cout => carry_aux(i,0)
      );
      fa_last_gen : FOR j IN 0 TO DATA_WIDTH*2-3 GENERATE
        FA_i_INST : full_adder
        PORT MAP (
          A    => carry_aux(i,j),
          B    => sum_aux(i-1,j),
          Cin  => carry_aux(i-1,j+1),
          Sum  => Q_tmp(i+j+2),
          Cout => carry_aux(i,j+1)
        );
      END GENERATE;
      HA_end_INST : half_adder
      PORT MAP (
        A    => pps(DATA_WIDTH*2-1,DATA_WIDTH*2-1),
        B    => carry_aux(i,DATA_WIDTH*2-2),
        Sum  => Q_tmp(2*DATA_WIDTH*2-2),
        Cout => Q_tmp(2*DATA_WIDTH*2-1)
      );
    ELSE GENERATE
      -- Generate all other rows
      HA_i_INST : half_adder
      PORT MAP (
        A    => carry_aux(i-1,0),
        B    => sum_aux(i-1,0),
        Sum  => Q_tmp(i+1),
        Cout => carry_aux(i,0)
      );
      fa_normal_gen : FOR j IN 0 TO DATA_WIDTH*2-3 GENERATE
        FA_i_INST : full_adder
        PORT MAP (
          A    => pps(i+2,j),
          B    => sum_aux(i-1,j+1),
          Cin  => carry_aux(i-1,j+1),
          Sum  => sum_aux(i,j),
          Cout => carry_aux(i,j+1)
        );
      END GENERATE;
      FA_end_INST : full_adder
      PORT MAP (
        A    => pps(i+1,DATA_WIDTH*2-1),
        B    => pps(i+2,DATA_WIDTH*2-2),
        Cin  => carry_aux(i-1,DATA_WIDTH*2-2),
        Sum  => sum_aux(i, DATA_WIDTH*2-2), 
        Cout => carry_aux(i, DATA_WIDTH*2-1)
      );
    END GENERATE;
  END GENERATE;
  
  Q_tmp(0) <= pps(0,0);
  Q <= Q_tmp(DATA_WIDTH*2-1 downto 0);

END ARCHITECTURE;
