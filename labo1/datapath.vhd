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
  flags         : out std_logic_vector(7 downto 0) );
END datapath;

ARCHITECTURE behavior OF datapath IS

  signal tmp1,  tmp2,  tmp3,  tmp4,  tmp5  : std_logic_vector(23 downto 0);
  signal tmp6,  tmp7,  tmp8,  tmp9,  tmp10 : std_logic_vector(23 downto 0);
  signal tmp11, tmp12, tmp13, tmp14, tmp15 : std_logic_vector(23 downto 0);
  signal tmp16, tmp17, tmp18, tmp0         : std_logic_vector(23 downto 0);

  signal m_tmp1,  m_tmp2,  m_tmp3,  m_tmp4,  m_tmp5  : std_logic_vector(47 downto 0);
  signal m_tmp10, m_tmp11, m_tmp12, m_tmp13, m_tmp14 : std_logic_vector(47 downto 0);

  signal sv1,      sv2,      sv3,      sv4      : std_logic_vector(23 downto 0);
  signal sv1_comb, sv2_comb, sv3_comb, sv4_comb : std_logic_vector(23 downto 0);

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

-- +b1 = "00000000" & "00000100" & "11000000";   -- b1 > 0
-- +b2 = "00000000" & "00010011" & "00000010";   -- b2 > 0
-- +b3 = "00000000" & "00011100" & "10000011";   -- b3 > 0
-- +b4 = "00000000" & "00010011" & "00000010";   -- b4 > 0
-- +b5 = "00000000" & "00000100" & "11000000";   -- b5 > 0
-- 
-- +a1 = "00000001" & "00000000" & "00000000";   -- a1 > 0
-- -a2 = "00000001" & "10010010" & "00000101";   -- a2 < 0
-- +a3 = "00000001" & "01000110" & "10001110";   -- a3 > 0
-- -a4 = "00000000" & "01111100" & "00000001";   -- a4 < 0
-- +a5 = "00000000" & "00010011" & "10000001";   -- a5 > 0
-- 
-- inv_a1 = "00000001" & "00000000" & "00000000";   -- inv_a1 > 0
-- neg_a2 = "00000001" & "10010010" & "00000101";   -- neg_a2 > 0
-- neg_a3 = "11111110" & "10111001" & "01110010";   -- neg_a3 < 0
-- neg_a4 = "00000000" & "01111100" & "00000001";   -- neg_a4 > 0
-- neg_a5 = "11111111" & "11101100" & "01111111";   -- neg_a5 < 0


BEGIN  
  Proc_seq : PROCESS (reset, clk)
  BEGIN
    IF reset='0' THEN
      sv1 <= (others => '0');    sv2 <= (others => '0');
      sv3 <= (others => '0');    sv4 <= (others => '0');
    ELSIF (clk'event AND clk='1') THEN
      IF comandos(0)='1' THEN
        sv1 <= sv1_comb;   sv2 <= sv2_comb;
        sv3 <= sv3_comb;   sv4 <= sv4_comb;
      END IF; 
    END IF; 
  END PROCESS;

  flags <= (others => '0');

  tmp0   <= entradas;
  m_tmp1 <= tmp0 * b1;
  tmp1   <= m_tmp1(39 downto 16);
  m_tmp2 <= tmp0 * b2;
  tmp2   <= m_tmp2(39 downto 16);
  m_tmp3 <= tmp0 * b3;
  tmp3   <= m_tmp3(39 downto 16);
  m_tmp4 <= tmp0 * b4;
  tmp4   <= m_tmp4(39 downto 16);
  m_tmp5 <= tmp0 * b5;
  tmp5   <= m_tmp5(39 downto 16);

  tmp6 <= tmp4 + sv4;
  tmp7 <= tmp3 + sv3;
  tmp8 <= tmp2 + sv2;
  tmp9 <= tmp1 + sv1;

  m_tmp10 <= tmp9 * inv_a1;
  tmp10   <= m_tmp10(39 downto 16);
  m_tmp11 <= tmp10 * neg_a2;
  tmp11   <= m_tmp11(39 downto 16);
  m_tmp12 <= tmp10 * neg_a3;
  tmp12   <= m_tmp12(39 downto 16);
  m_tmp13 <= tmp10 * neg_a4;
  tmp13   <= m_tmp13(39 downto 16);
  m_tmp14 <= tmp10 * neg_a5;
  tmp14   <= m_tmp14(39 downto 16);

  tmp15 <= tmp8 + tmp11;
  tmp16 <= tmp7 + tmp12;
  tmp17 <= tmp6 + tmp13;
  tmp18 <= tmp5 + tmp14;

  sv4_comb <= tmp18;
  sv3_comb <= tmp17;
  sv2_comb <= tmp16;
  sv1_comb <= tmp15;

  salidas <= tmp10;
END behavior;
