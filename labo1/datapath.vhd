LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_signed.all;

ENTITY datapath IS 
  PORT (
  reset, clk    : in std_logic;
  comandos      : in std_logic_vector(7 downto 0);
  entradas      : in std_logic_vector(23 downto 0);  
  salidas       : out std_logic_vector(23 downto 0);  
  flags         : out std_logic_vector(7 downto 0)
);
END datapath;

ARCHITECTURE behavior OF datapath IS

  -- Entidades
  COMPONENT RCA IS
  GENERIC (
    DATA_WIDTH : integer := 24
  );
  PORT (
    A  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    B  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Q  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Co : out std_logic
  );
  END COMPONENT;
  -- Señales y registros
  signal reg1,      reg2,      reg3,      reg4,      reg5      : std_logic_vector(23 downto 0);
  signal reg1_comb, reg2_comb, reg3_comb, reg4_comb, reg5_comb : std_logic_vector(23 downto 0);

  signal mulA, mulB, mulQ, sumA, sumB, sumQ : std_logic_vector(23 downto 0);
  signal m_mulQ                             : std_logic_vector(47 downto 0);

  signal sv1,      sv2,      sv3,      sv4      : std_logic_vector(23 downto 0);
  signal sv1_comb, sv2_comb, sv3_comb, sv4_comb : std_logic_vector(23 downto 0);

  -- Constantes
  constant b1 : std_logic_vector(23 downto 0) := "00000000" & "00000100" & "11000000";
  constant b2 : std_logic_vector(23 downto 0) := "00000000" & "00010011" & "00000010";
  constant b3 : std_logic_vector(23 downto 0) := "00000000" & "00011100" & "10000011";
  constant b4 : std_logic_vector(23 downto 0) := "00000000" & "00010011" & "00000010";
  constant b5 : std_logic_vector(23 downto 0) := "00000000" & "00000100" & "11000000";

  constant inv_a1 : std_logic_vector(23 downto 0) := "00000001" & "00000000" & "00000000";
  constant neg_a2 : std_logic_vector(23 downto 0) := "00000001" & "10010010" & "00000101";
  constant neg_a3 : std_logic_vector(23 downto 0) := "11111110" & "10111001" & "01110010";
  constant neg_a4 : std_logic_vector(23 downto 0) := "00000000" & "01111100" & "00000001";
  constant neg_a5 : std_logic_vector(23 downto 0) := "11111111" & "11101100" & "01111111";

BEGIN  

  sumador : RCA
  generic map (
    DATA_WIDTH => 24
  )
  port map (
    A  => sumA,
    B  => sumB,
    Q  => sumQ,
    Co => open
  );

Proc_seq : PROCESS (reset, clk) BEGIN
  IF reset='0' THEN
    sv1  <= (others => '0');
    sv2  <= (others => '0');
    sv3  <= (others => '0');
    sv4  <= (others => '0');
    reg1 <= (others => '0');
    reg2 <= (others => '0');
    reg3 <= (others => '0');
    reg4 <= (others => '0');
    reg5 <= (others => '0');
  ELSIF (clk'event AND clk='1') THEN
    sv1  <= sv1_comb;
    sv2  <= sv2_comb;
    sv3  <= sv3_comb;
    sv4  <= sv4_comb; 
    reg1 <= reg1_comb;
    reg2 <= reg2_comb;
    reg3 <= reg3_comb;
    reg4 <= reg4_comb;
    reg5 <= reg5_comb;
  END IF; 
END PROCESS;

-- Multiplexores
PROCESS(all) IS BEGIN
  -- Retener valor de registros por defecto:
  sv1_comb  <= sv1;
  sv2_comb  <= sv2;
  sv3_comb  <= sv3;
  sv4_comb  <= sv4;
  reg1_comb <= reg1;
  reg2_comb <= reg2;
  reg3_comb <= reg3;
  reg4_comb <= reg4;
  reg5_comb <= reg5;
  -- Entrada 0 por defecto
  mulA <= (others => '0');
  mulB <= (others => '0');
  sumA <= (others => '0');
  sumB <= (others => '0');
  CASE comandos(3 downto 0) IS
    WHEN "0000" =>
      mulA      <= entradas;
      mulB      <= b1;
      reg1_comb <= mulQ;
    WHEN "0001" =>
      mulA      <= entradas;
      mulB      <= b2;
      reg1_comb <= mulQ;
      sumA      <= reg1;
      sumB      <= sv1;
      reg2_comb <= sumQ;
    WHEN "0011" =>
      mulA      <= entradas;
      mulB      <= b3;
      reg1_comb <= mulQ;
      sumA      <= reg1;
      sumB      <= sv2;
      reg3_comb <= sumQ; 
    WHEN "0100" =>
      mulA      <= entradas;
      mulB      <= b4;
      reg1_comb <= mulQ;
      sumA      <= reg1;
      sumB      <= sv3;
      reg4_comb <= sumQ;
    WHEN "0101" =>
      mulA      <= reg2;
      mulB      <= inv_a1;
      reg2_comb <= mulQ;
      sumA      <= reg1;
      sumB      <= sv4;
      reg5_comb <= sumQ;
    WHEN "0110" =>
      mulA      <= reg2;
      mulB      <= neg_a2;
      reg1_comb <= mulQ;
    WHEN "0111" =>
      mulA      <= reg2;
      mulB      <= neg_a3;
      reg1_comb <= mulQ;
      sumA      <= reg3;
      sumB      <= reg1;
      sv1_comb  <= sumQ;
    WHEN "1000" =>
      mulA      <= reg2;
      mulB      <= neg_a4;
      reg1_comb <= mulQ;
      sumA      <= reg4;
      sumB      <= reg1;
      sv2_comb  <= sumQ;
    WHEN "1001" =>
      mulA      <= reg2;
      mulB      <= neg_a5;
      reg1_comb <= mulQ;
      sumA      <= reg5;
      sumB      <= reg1;
      sv3_comb  <= sumQ;
    WHEN "1010" =>
      mulA      <= entradas;
      mulB      <= b5;
      reg3_comb <= mulQ;
    WHEN "1011" =>
      sumA      <= reg3;
      sumB      <= reg1;
      sv4_comb  <= sumQ;
    WHEN others =>
  END CASE;
END PROCESS;

m_mulQ <= mulA * mulB;
mulQ   <= m_mulQ(39 downto 16);

flags <= (others => '0');

salidas <= reg2; -- A partir del ciclo 5. Registrarlo?

END behavior;
