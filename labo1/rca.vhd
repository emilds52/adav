library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA is
generic (
  DATA_WIDTH : integer := 24
);
port (
  A  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
  B  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
  Q  : out std_logic_vector(DATA_WIDTH-1 downto 0);
  Co : out std_logic
);
end RCA;

architecture structural of rca is 

  component full_adder is
  port(
    A   : in  std_logic;
    B   : in  std_logic;
    Cin : in  std_logic;
    Sum : out std_logic;
    Cout: out std_logic
  );
  end component;
  
  signal Carry_aux : std_logic_vector(DATA_WIDTH downto 0);

begin
  Carry_aux(0) <= '0';

  Full_adders_gen : for i in 0 to DATA_WIDTH-1 generate
  begin
    FA_i_INST: Full_adder
      port map (
        A      => A(i),
        B      => B(i),
        Cin    => Carry_aux(i),
        Sum    => Q(i),
        Cout   => Carry_aux(i+1) 
        );
  end generate;
  Co <= Carry_aux(DATA_WIDTH-1);
end architecture;
