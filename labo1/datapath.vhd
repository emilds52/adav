LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_signed.all;
USE work.tipos.all;

ENTITY datapath IS 
  GENERIC (
           k : integer := pa_k );
  PORT (
  reset, clk    : in std_logic;
  comandos      : in std_logic_vector(7 downto 0);
  entradas      : in LOGIC_ARRAY_24_T(k-1 downto 0);  
  salidas       : out LOGIC_ARRAY_24_T(k-1 downto 0);
  flags         : out std_logic_vector(7 downto 0) );
END datapath;

ARCHITECTURE behavior OF datapath IS

  signal tmp1,  tmp2,  tmp3,  tmp4,  tmp5  : LOGIC_ARRAY_24_T(k-1 downto 0);
  signal tmp6,  tmp7,  tmp8,  tmp9,  tmp10 : LOGIC_ARRAY_24_T(k-1 downto 0);
  signal tmp11, tmp12, tmp13, tmp14, tmp15 : LOGIC_ARRAY_24_T(k-1 downto 0);
  signal tmp16, tmp17, tmp18, tmp0         : LOGIC_ARRAY_24_T(k-1 downto 0);

  signal m_tmp1,  m_tmp2,  m_tmp3,  m_tmp4,  m_tmp5  : LOGIC_ARRAY_48_T(k-1 downto 0);
  signal m_tmp10, m_tmp11, m_tmp12, m_tmp13, m_tmp14 : LOGIC_ARRAY_48_T(k-1 downto 0);

  signal sv1,      sv2,      sv3,      sv4      : LOGIC_ARRAY_24_T(k-1 downto 0);
  signal sv1_reg,  sv2_reg,  sv3_reg,  sv4_reg  : STD_LOGIC_VECTOR(23 downto 0);
  signal sv1_comb, sv2_comb, sv3_comb, sv4_comb : LOGIC_ARRAY_24_T(k-1 downto 0);

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
  Proc_seq : PROCESS (reset, clk)
  BEGIN
    IF reset='0' THEN
      sv1_reg <= (others => '0');    sv2_reg <= (others => '0');
      sv3_reg <= (others => '0');    sv4_reg <= (others => '0');
    ELSIF (clk'event AND clk='1') THEN
      IF comandos(0)='1' THEN
        sv1_reg <= sv1_comb(k-1);   sv2_reg <= sv2_comb(k-1); -- Solo tener delay en el último (antes de retiming)
        sv3_reg <= sv3_comb(k-1);   sv4_reg <= sv4_comb(k-1);
      END IF; 
    END IF; 
  END PROCESS;

  flags <= (others => '0');

  proc_sv : PROCESS(all) BEGIN
    IF (k > 1) THEN -- Si k=1 todo tiene delay y se hace arriba
      loop_sv : FOR i IN 0 to k-2 LOOP
        sv1(i) <= sv1_comb(i);
        sv2(i) <= sv2_comb(i);
        sv3(i) <= sv3_comb(i);
        sv4(i) <= sv4_comb(i);
      END LOOP;
    END IF;
    sv1(k-1) <= sv1_reg;
    sv2(k-1) <= sv2_reg;
    sv3(k-1) <= sv3_reg;
    sv4(k-1) <= sv4_reg;
  END PROCESS;

  proc_unfolding : PROCESS(all) BEGIN
    loop_unfolding : FOR i IN 0 TO k-1 LOOP
      tmp0(i)   <= entradas(i);
      m_tmp1(i) <= tmp0(i) * b1;
      tmp1(i)   <= m_tmp1(i)(39 downto 16);
      m_tmp2(i) <= tmp0(i) * b2;
      tmp2(i)   <= m_tmp2(i)(39 downto 16);
      m_tmp3(i) <= tmp0(i) * b3;
      tmp3(i)   <= m_tmp3(i)(39 downto 16);
      m_tmp4(i) <= tmp0(i) * b4;
      tmp4(i)   <= m_tmp4(i)(39 downto 16);
      m_tmp5(i) <= tmp0(i) * b5;
      tmp5(i)   <= m_tmp5(i)(39 downto 16);

      -- Los SVs van al siguiente índice, menos el k-1 que va al primero y con delay
      IF (i = 0) THEN 
        tmp6(0) <= tmp4(0) + sv4(k-1);
        tmp7(0) <= tmp3(0) + sv3(k-1);
        tmp8(0) <= tmp2(0) + sv2(k-1);
        tmp9(0) <= tmp1(0) + sv1(k-1);
      ELSE
        tmp6(i) <= tmp4(i) + sv4(i-1);
        tmp7(i) <= tmp3(i) + sv3(i-1);
        tmp8(i) <= tmp2(i) + sv2(i-1);
        tmp9(i) <= tmp1(i) + sv1(i-1);
      END IF;

      m_tmp10(i) <= tmp9(i) * inv_a1;
      tmp10(i)   <= m_tmp10(i)( 39 downto 16);
      m_tmp11(i) <= tmp10(i) * neg_a2;
      tmp11(i)   <= m_tmp11(i)(39 downto 16);
      m_tmp12(i) <= tmp10(i) * neg_a3;
      tmp12(i)   <= m_tmp12(i)(39 downto 16);
      m_tmp13(i) <= tmp10(i) * neg_a4;
      tmp13(i)   <= m_tmp13(i)(39 downto 16);
      m_tmp14(i) <= tmp10(i) * neg_a5;
      tmp14(i)   <= m_tmp14(i)(39 downto 16);

      tmp15(i) <= tmp8(i) + tmp11(i);
      tmp16(i) <= tmp7(i) + tmp12(i);
      tmp17(i) <= tmp6(i) + tmp13(i);
      tmp18(i) <= tmp5(i) + tmp14(i);

      sv4_comb(i) <= tmp18(i);
      sv3_comb(i) <= tmp17(i);
      sv2_comb(i) <= tmp16(i);
      sv1_comb(i) <= tmp15(i);

      salidas(i) <= tmp10(i);
    END LOOP;
  END PROCESS;
END behavior;
