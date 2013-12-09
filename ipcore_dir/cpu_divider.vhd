--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Filename: cpu_divider.vhd
-- /___/   /\     Timestamp: Sun Dec  8 23:11:23 2013
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -w -sim -ofmt vhdl ./tmp/_cg/cpu_divider.ngc ./tmp/_cg/cpu_divider.vhd 
-- Device	: 6slx16csg324-3
-- Input file	: ./tmp/_cg/cpu_divider.ngc
-- Output file	: ./tmp/_cg/cpu_divider.vhd
-- # of Entities	: 1
-- Design Name	: cpu_divider
-- Xilinx	: /opt/Xilinx/14.7/ISE_DS/ISE/
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------


-- synthesis translate_off
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity cpu_divider is
  port (
    ce : in STD_LOGIC := 'X'; 
    rfd : out STD_LOGIC; 
    clk : in STD_LOGIC := 'X'; 
    dividend : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
    quotient : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    divisor : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
    fractional : out STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end cpu_divider;

architecture STRUCTURE of cpu_divider is
  signal NlwRenamedSig_OI_rfd : STD_LOGIC; 
  signal blk00000003_sig000000da : STD_LOGIC; 
  signal blk00000003_sig000000d9 : STD_LOGIC; 
  signal blk00000003_sig000000d8 : STD_LOGIC; 
  signal blk00000003_sig000000d7 : STD_LOGIC; 
  signal blk00000003_sig000000d6 : STD_LOGIC; 
  signal blk00000003_sig000000d5 : STD_LOGIC; 
  signal blk00000003_sig000000d4 : STD_LOGIC; 
  signal blk00000003_sig000000d3 : STD_LOGIC; 
  signal blk00000003_sig000000d2 : STD_LOGIC; 
  signal blk00000003_sig000000d1 : STD_LOGIC; 
  signal blk00000003_sig000000d0 : STD_LOGIC; 
  signal blk00000003_sig000000cf : STD_LOGIC; 
  signal blk00000003_sig000000ce : STD_LOGIC; 
  signal blk00000003_sig000000cd : STD_LOGIC; 
  signal blk00000003_sig000000cc : STD_LOGIC; 
  signal blk00000003_sig000000cb : STD_LOGIC; 
  signal blk00000003_sig000000ca : STD_LOGIC; 
  signal blk00000003_sig000000c9 : STD_LOGIC; 
  signal blk00000003_sig000000c8 : STD_LOGIC; 
  signal blk00000003_sig000000c7 : STD_LOGIC; 
  signal blk00000003_sig000000c6 : STD_LOGIC; 
  signal blk00000003_sig000000c5 : STD_LOGIC; 
  signal blk00000003_sig000000c4 : STD_LOGIC; 
  signal blk00000003_sig000000c3 : STD_LOGIC; 
  signal blk00000003_sig000000c2 : STD_LOGIC; 
  signal blk00000003_sig000000c1 : STD_LOGIC; 
  signal blk00000003_sig000000c0 : STD_LOGIC; 
  signal blk00000003_sig000000bf : STD_LOGIC; 
  signal blk00000003_sig000000be : STD_LOGIC; 
  signal blk00000003_sig000000bd : STD_LOGIC; 
  signal blk00000003_sig000000bc : STD_LOGIC; 
  signal blk00000003_sig000000bb : STD_LOGIC; 
  signal blk00000003_sig000000ba : STD_LOGIC; 
  signal blk00000003_sig000000b9 : STD_LOGIC; 
  signal blk00000003_sig000000b8 : STD_LOGIC; 
  signal blk00000003_sig000000b7 : STD_LOGIC; 
  signal blk00000003_sig000000b6 : STD_LOGIC; 
  signal blk00000003_sig000000b5 : STD_LOGIC; 
  signal blk00000003_sig000000b4 : STD_LOGIC; 
  signal blk00000003_sig000000b3 : STD_LOGIC; 
  signal blk00000003_sig000000b2 : STD_LOGIC; 
  signal blk00000003_sig000000b1 : STD_LOGIC; 
  signal blk00000003_sig000000b0 : STD_LOGIC; 
  signal blk00000003_sig000000af : STD_LOGIC; 
  signal blk00000003_sig000000ae : STD_LOGIC; 
  signal blk00000003_sig000000ad : STD_LOGIC; 
  signal blk00000003_sig000000ac : STD_LOGIC; 
  signal blk00000003_sig000000ab : STD_LOGIC; 
  signal blk00000003_sig000000aa : STD_LOGIC; 
  signal blk00000003_sig000000a9 : STD_LOGIC; 
  signal blk00000003_sig000000a8 : STD_LOGIC; 
  signal blk00000003_sig000000a7 : STD_LOGIC; 
  signal blk00000003_sig000000a6 : STD_LOGIC; 
  signal blk00000003_sig000000a5 : STD_LOGIC; 
  signal blk00000003_sig000000a4 : STD_LOGIC; 
  signal blk00000003_sig000000a3 : STD_LOGIC; 
  signal blk00000003_sig000000a2 : STD_LOGIC; 
  signal blk00000003_sig000000a1 : STD_LOGIC; 
  signal blk00000003_sig000000a0 : STD_LOGIC; 
  signal blk00000003_sig0000009f : STD_LOGIC; 
  signal blk00000003_sig0000009e : STD_LOGIC; 
  signal blk00000003_sig0000009d : STD_LOGIC; 
  signal blk00000003_sig0000009c : STD_LOGIC; 
  signal blk00000003_sig0000009b : STD_LOGIC; 
  signal blk00000003_sig0000009a : STD_LOGIC; 
  signal blk00000003_sig00000099 : STD_LOGIC; 
  signal blk00000003_sig00000098 : STD_LOGIC; 
  signal blk00000003_sig00000097 : STD_LOGIC; 
  signal blk00000003_sig00000096 : STD_LOGIC; 
  signal blk00000003_sig00000095 : STD_LOGIC; 
  signal blk00000003_sig00000094 : STD_LOGIC; 
  signal blk00000003_sig00000093 : STD_LOGIC; 
  signal blk00000003_sig00000092 : STD_LOGIC; 
  signal blk00000003_sig00000091 : STD_LOGIC; 
  signal blk00000003_sig00000090 : STD_LOGIC; 
  signal blk00000003_sig0000008f : STD_LOGIC; 
  signal blk00000003_sig0000008e : STD_LOGIC; 
  signal blk00000003_sig0000008d : STD_LOGIC; 
  signal blk00000003_sig0000008c : STD_LOGIC; 
  signal blk00000003_sig0000008b : STD_LOGIC; 
  signal blk00000003_sig0000008a : STD_LOGIC; 
  signal blk00000003_sig00000089 : STD_LOGIC; 
  signal blk00000003_sig00000088 : STD_LOGIC; 
  signal blk00000003_sig00000087 : STD_LOGIC; 
  signal blk00000003_sig00000086 : STD_LOGIC; 
  signal blk00000003_sig00000085 : STD_LOGIC; 
  signal blk00000003_sig00000084 : STD_LOGIC; 
  signal blk00000003_sig00000083 : STD_LOGIC; 
  signal blk00000003_sig00000082 : STD_LOGIC; 
  signal blk00000003_sig00000081 : STD_LOGIC; 
  signal blk00000003_sig00000080 : STD_LOGIC; 
  signal blk00000003_sig0000007f : STD_LOGIC; 
  signal blk00000003_sig0000007e : STD_LOGIC; 
  signal blk00000003_sig0000007d : STD_LOGIC; 
  signal blk00000003_sig0000007c : STD_LOGIC; 
  signal blk00000003_sig0000007b : STD_LOGIC; 
  signal blk00000003_sig0000007a : STD_LOGIC; 
  signal blk00000003_sig00000079 : STD_LOGIC; 
  signal blk00000003_sig00000078 : STD_LOGIC; 
  signal blk00000003_sig00000077 : STD_LOGIC; 
  signal blk00000003_sig00000076 : STD_LOGIC; 
  signal blk00000003_sig00000075 : STD_LOGIC; 
  signal blk00000003_sig00000074 : STD_LOGIC; 
  signal blk00000003_sig00000073 : STD_LOGIC; 
  signal blk00000003_sig00000072 : STD_LOGIC; 
  signal blk00000003_sig00000071 : STD_LOGIC; 
  signal blk00000003_sig00000070 : STD_LOGIC; 
  signal blk00000003_sig0000006f : STD_LOGIC; 
  signal blk00000003_sig0000006e : STD_LOGIC; 
  signal blk00000003_sig0000006d : STD_LOGIC; 
  signal blk00000003_sig0000006c : STD_LOGIC; 
  signal blk00000003_sig0000006b : STD_LOGIC; 
  signal blk00000003_sig0000006a : STD_LOGIC; 
  signal blk00000003_sig00000069 : STD_LOGIC; 
  signal blk00000003_sig00000068 : STD_LOGIC; 
  signal blk00000003_sig00000067 : STD_LOGIC; 
  signal blk00000003_sig00000066 : STD_LOGIC; 
  signal blk00000003_sig00000065 : STD_LOGIC; 
  signal blk00000003_sig00000064 : STD_LOGIC; 
  signal blk00000003_sig00000063 : STD_LOGIC; 
  signal blk00000003_sig00000062 : STD_LOGIC; 
  signal blk00000003_sig00000061 : STD_LOGIC; 
  signal blk00000003_sig00000060 : STD_LOGIC; 
  signal blk00000003_sig0000005f : STD_LOGIC; 
  signal blk00000003_sig0000005e : STD_LOGIC; 
  signal blk00000003_sig0000005d : STD_LOGIC; 
  signal blk00000003_sig0000005c : STD_LOGIC; 
  signal blk00000003_sig0000005b : STD_LOGIC; 
  signal blk00000003_sig0000005a : STD_LOGIC; 
  signal blk00000003_sig00000059 : STD_LOGIC; 
  signal blk00000003_sig00000058 : STD_LOGIC; 
  signal blk00000003_sig00000057 : STD_LOGIC; 
  signal blk00000003_sig00000056 : STD_LOGIC; 
  signal blk00000003_sig00000055 : STD_LOGIC; 
  signal blk00000003_sig00000054 : STD_LOGIC; 
  signal blk00000003_sig00000053 : STD_LOGIC; 
  signal blk00000003_sig00000052 : STD_LOGIC; 
  signal blk00000003_sig00000051 : STD_LOGIC; 
  signal blk00000003_sig00000050 : STD_LOGIC; 
  signal blk00000003_sig0000004f : STD_LOGIC; 
  signal blk00000003_sig0000004e : STD_LOGIC; 
  signal blk00000003_sig0000004d : STD_LOGIC; 
  signal blk00000003_sig0000004c : STD_LOGIC; 
  signal blk00000003_sig0000004b : STD_LOGIC; 
  signal blk00000003_sig0000004a : STD_LOGIC; 
  signal blk00000003_sig00000049 : STD_LOGIC; 
  signal blk00000003_sig00000048 : STD_LOGIC; 
  signal blk00000003_sig00000047 : STD_LOGIC; 
  signal blk00000003_sig00000046 : STD_LOGIC; 
  signal blk00000003_sig00000045 : STD_LOGIC; 
  signal blk00000003_sig00000044 : STD_LOGIC; 
  signal blk00000003_sig00000043 : STD_LOGIC; 
  signal blk00000003_sig00000042 : STD_LOGIC; 
  signal blk00000003_sig00000041 : STD_LOGIC; 
  signal blk00000003_sig00000040 : STD_LOGIC; 
  signal blk00000003_sig0000003f : STD_LOGIC; 
  signal blk00000003_sig0000003e : STD_LOGIC; 
  signal blk00000003_sig0000003d : STD_LOGIC; 
  signal blk00000003_sig0000003c : STD_LOGIC; 
  signal blk00000003_sig0000003b : STD_LOGIC; 
  signal blk00000003_sig0000003a : STD_LOGIC; 
  signal blk00000003_sig00000039 : STD_LOGIC; 
  signal blk00000003_sig00000038 : STD_LOGIC; 
  signal blk00000003_sig00000037 : STD_LOGIC; 
  signal blk00000003_sig00000036 : STD_LOGIC; 
  signal blk00000003_sig00000035 : STD_LOGIC; 
  signal blk00000003_sig00000034 : STD_LOGIC; 
  signal blk00000003_sig00000033 : STD_LOGIC; 
  signal blk00000003_sig00000032 : STD_LOGIC; 
  signal blk00000003_sig00000031 : STD_LOGIC; 
  signal blk00000003_sig00000030 : STD_LOGIC; 
  signal blk00000003_sig0000002f : STD_LOGIC; 
  signal blk00000003_sig0000002e : STD_LOGIC; 
  signal blk00000003_sig0000002d : STD_LOGIC; 
  signal blk00000003_sig0000002c : STD_LOGIC; 
  signal blk00000003_sig0000002b : STD_LOGIC; 
  signal blk00000003_sig0000002a : STD_LOGIC; 
  signal blk00000003_sig00000029 : STD_LOGIC; 
  signal blk00000003_sig00000028 : STD_LOGIC; 
  signal blk00000003_sig00000027 : STD_LOGIC; 
  signal blk00000003_sig00000026 : STD_LOGIC; 
  signal blk00000003_sig00000025 : STD_LOGIC; 
  signal blk00000003_sig00000023 : STD_LOGIC; 
  signal NLW_blk00000001_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_blk00000002_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_blk00000003_blk00000061_O_UNCONNECTED : STD_LOGIC; 
  signal dividend_0 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal divisor_1 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal quotient_2 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal fractional_3 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
begin
  dividend_0(7) <= dividend(7);
  dividend_0(6) <= dividend(6);
  dividend_0(5) <= dividend(5);
  dividend_0(4) <= dividend(4);
  dividend_0(3) <= dividend(3);
  dividend_0(2) <= dividend(2);
  dividend_0(1) <= dividend(1);
  dividend_0(0) <= dividend(0);
  quotient(7) <= quotient_2(7);
  quotient(6) <= quotient_2(6);
  quotient(5) <= quotient_2(5);
  quotient(4) <= quotient_2(4);
  quotient(3) <= quotient_2(3);
  quotient(2) <= quotient_2(2);
  quotient(1) <= quotient_2(1);
  quotient(0) <= quotient_2(0);
  divisor_1(7) <= divisor(7);
  divisor_1(6) <= divisor(6);
  divisor_1(5) <= divisor(5);
  divisor_1(4) <= divisor(4);
  divisor_1(3) <= divisor(3);
  divisor_1(2) <= divisor(2);
  divisor_1(1) <= divisor(1);
  divisor_1(0) <= divisor(0);
  rfd <= NlwRenamedSig_OI_rfd;
  fractional(7) <= fractional_3(7);
  fractional(6) <= fractional_3(6);
  fractional(5) <= fractional_3(5);
  fractional(4) <= fractional_3(4);
  fractional(3) <= fractional_3(3);
  fractional(2) <= fractional_3(2);
  fractional(1) <= fractional_3(1);
  fractional(0) <= fractional_3(0);
  blk00000001 : VCC
    port map (
      P => NLW_blk00000001_P_UNCONNECTED
    );
  blk00000002 : GND
    port map (
      G => NLW_blk00000002_G_UNCONNECTED
    );
  blk00000003_blk000000cc : INV
    port map (
      I => blk00000003_sig00000044,
      O => blk00000003_sig0000005c
    );
  blk00000003_blk000000cb : INV
    port map (
      I => blk00000003_sig00000046,
      O => blk00000003_sig0000005d
    );
  blk00000003_blk000000ca : INV
    port map (
      I => blk00000003_sig00000048,
      O => blk00000003_sig0000005e
    );
  blk00000003_blk000000c9 : INV
    port map (
      I => blk00000003_sig0000004a,
      O => blk00000003_sig0000005f
    );
  blk00000003_blk000000c8 : INV
    port map (
      I => blk00000003_sig0000004c,
      O => blk00000003_sig00000060
    );
  blk00000003_blk000000c7 : INV
    port map (
      I => blk00000003_sig0000004e,
      O => blk00000003_sig00000061
    );
  blk00000003_blk000000c6 : INV
    port map (
      I => blk00000003_sig00000050,
      O => blk00000003_sig00000062
    );
  blk00000003_blk000000c5 : INV
    port map (
      I => blk00000003_sig00000052,
      O => blk00000003_sig00000063
    );
  blk00000003_blk000000c4 : INV
    port map (
      I => blk00000003_sig00000038,
      O => blk00000003_sig00000037
    );
  blk00000003_blk000000c3 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => NlwRenamedSig_OI_rfd,
      Q => blk00000003_sig000000da
    );
  blk00000003_blk000000c2 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000a4,
      I2 => blk00000003_sig00000039,
      O => blk00000003_sig000000a3
    );
  blk00000003_blk000000c1 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000a6,
      I2 => blk00000003_sig0000008e,
      O => blk00000003_sig000000a5
    );
  blk00000003_blk000000c0 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000a8,
      I2 => blk00000003_sig00000091,
      O => blk00000003_sig000000a7
    );
  blk00000003_blk000000bf : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000aa,
      I2 => blk00000003_sig00000094,
      O => blk00000003_sig000000a9
    );
  blk00000003_blk000000be : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000ac,
      I2 => blk00000003_sig00000097,
      O => blk00000003_sig000000ab
    );
  blk00000003_blk000000bd : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000ae,
      I2 => blk00000003_sig0000009a,
      O => blk00000003_sig000000ad
    );
  blk00000003_blk000000bc : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000b0,
      I2 => blk00000003_sig0000009d,
      O => blk00000003_sig000000af
    );
  blk00000003_blk000000bb : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000b2,
      I2 => blk00000003_sig000000a0,
      O => blk00000003_sig000000b1
    );
  blk00000003_blk000000ba : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000b4,
      I2 => blk00000003_sig000000a2,
      O => blk00000003_sig000000b3
    );
  blk00000003_blk000000b9 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000040,
      I2 => blk00000003_sig00000044,
      O => blk00000003_sig00000043
    );
  blk00000003_blk000000b8 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig0000003f,
      I2 => blk00000003_sig00000046,
      O => blk00000003_sig00000045
    );
  blk00000003_blk000000b7 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig0000003e,
      I2 => blk00000003_sig00000048,
      O => blk00000003_sig00000047
    );
  blk00000003_blk000000b6 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig0000003d,
      I2 => blk00000003_sig0000004a,
      O => blk00000003_sig00000049
    );
  blk00000003_blk000000b5 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig0000003c,
      I2 => blk00000003_sig0000004c,
      O => blk00000003_sig0000004b
    );
  blk00000003_blk000000b4 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig0000003b,
      I2 => blk00000003_sig0000004e,
      O => blk00000003_sig0000004d
    );
  blk00000003_blk000000b3 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig0000003a,
      I2 => blk00000003_sig00000050,
      O => blk00000003_sig0000004f
    );
  blk00000003_blk000000b2 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000052,
      I2 => blk00000003_sig00000039,
      O => blk00000003_sig00000051
    );
  blk00000003_blk000000b1 : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig000000a2,
      O => blk00000003_sig00000083
    );
  blk00000003_blk000000b0 : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig000000a0,
      O => blk00000003_sig00000081
    );
  blk00000003_blk000000af : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig0000009d,
      O => blk00000003_sig0000007f
    );
  blk00000003_blk000000ae : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig0000009a,
      O => blk00000003_sig0000007d
    );
  blk00000003_blk000000ad : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig00000097,
      O => blk00000003_sig0000007b
    );
  blk00000003_blk000000ac : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig00000094,
      O => blk00000003_sig00000079
    );
  blk00000003_blk000000ab : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig00000091,
      O => blk00000003_sig00000077
    );
  blk00000003_blk000000aa : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig0000008e,
      O => blk00000003_sig00000075
    );
  blk00000003_blk000000a9 : LUT3
    generic map(
      INIT => X"70"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig00000042,
      I2 => blk00000003_sig00000039,
      O => blk00000003_sig00000086
    );
  blk00000003_blk000000a8 : LUT3
    generic map(
      INIT => X"8F"
    )
    port map (
      I0 => blk00000003_sig00000042,
      I1 => ce,
      I2 => blk00000003_sig00000039,
      O => blk00000003_sig00000088
    );
  blk00000003_blk000000a7 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000a6,
      I1 => blk00000003_sig00000066,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000b6
    );
  blk00000003_blk000000a6 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000a8,
      I1 => blk00000003_sig00000068,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000bb
    );
  blk00000003_blk000000a5 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000aa,
      I1 => blk00000003_sig0000006a,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000bf
    );
  blk00000003_blk000000a4 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000ac,
      I1 => blk00000003_sig0000006c,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000c3
    );
  blk00000003_blk000000a3 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000ae,
      I1 => blk00000003_sig0000006e,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000c7
    );
  blk00000003_blk000000a2 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000b0,
      I1 => blk00000003_sig00000070,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000cb
    );
  blk00000003_blk000000a1 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000b2,
      I1 => blk00000003_sig00000072,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000cf
    );
  blk00000003_blk000000a0 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig000000b4,
      I1 => blk00000003_sig00000074,
      I2 => blk00000003_sig000000a4,
      O => blk00000003_sig000000d5
    );
  blk00000003_blk0000009f : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => blk00000003_sig00000076,
      I1 => blk00000003_sig00000087,
      O => blk00000003_sig0000008b
    );
  blk00000003_blk0000009e : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000078,
      I1 => blk00000003_sig00000065,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig0000008d
    );
  blk00000003_blk0000009d : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig0000007a,
      I1 => blk00000003_sig00000067,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig00000090
    );
  blk00000003_blk0000009c : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig0000007c,
      I1 => blk00000003_sig00000069,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig00000093
    );
  blk00000003_blk0000009b : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig0000007e,
      I1 => blk00000003_sig0000006b,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig00000096
    );
  blk00000003_blk0000009a : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000080,
      I1 => blk00000003_sig0000006d,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig00000099
    );
  blk00000003_blk00000099 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000082,
      I1 => blk00000003_sig0000006f,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig0000009c
    );
  blk00000003_blk00000098 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000084,
      I1 => blk00000003_sig00000071,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig0000009f
    );
  blk00000003_blk00000097 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000085,
      I1 => blk00000003_sig00000073,
      I2 => blk00000003_sig00000087,
      O => blk00000003_sig000000a1
    );
  blk00000003_blk00000096 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => ce,
      I1 => NlwRenamedSig_OI_rfd,
      O => blk00000003_sig00000053
    );
  blk00000003_blk00000095 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => ce,
      I1 => blk00000003_sig000000da,
      O => blk00000003_sig00000064
    );
  blk00000003_blk00000094 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => blk00000003_sig00000034,
      I1 => blk00000003_sig00000036,
      I2 => blk00000003_sig00000038,
      O => blk00000003_sig00000041
    );
  blk00000003_blk00000093 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => blk00000003_sig00000036,
      I1 => blk00000003_sig00000038,
      O => blk00000003_sig00000035
    );
  blk00000003_blk00000092 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000034,
      I1 => blk00000003_sig00000038,
      I2 => blk00000003_sig00000036,
      O => blk00000003_sig00000033
    );
  blk00000003_blk00000091 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000d6,
      Q => fractional_3(0)
    );
  blk00000003_blk00000090 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000d0,
      Q => fractional_3(1)
    );
  blk00000003_blk0000008f : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000cc,
      Q => fractional_3(2)
    );
  blk00000003_blk0000008e : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000c8,
      Q => fractional_3(3)
    );
  blk00000003_blk0000008d : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000c4,
      Q => fractional_3(4)
    );
  blk00000003_blk0000008c : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000c0,
      Q => fractional_3(5)
    );
  blk00000003_blk0000008b : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000bc,
      Q => fractional_3(6)
    );
  blk00000003_blk0000008a : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000b7,
      Q => fractional_3(7)
    );
  blk00000003_blk00000089 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000d4,
      Q => blk00000003_sig000000d9
    );
  blk00000003_blk00000088 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig000000d3,
      Q => blk00000003_sig000000d8
    );
  blk00000003_blk00000087 : MULT_AND
    port map (
      I0 => blk00000003_sig00000074,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000d7
    );
  blk00000003_blk00000086 : MULT_AND
    port map (
      I0 => blk00000003_sig00000072,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000d1
    );
  blk00000003_blk00000085 : MULT_AND
    port map (
      I0 => blk00000003_sig00000070,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000cd
    );
  blk00000003_blk00000084 : MULT_AND
    port map (
      I0 => blk00000003_sig0000006e,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000c9
    );
  blk00000003_blk00000083 : MULT_AND
    port map (
      I0 => blk00000003_sig0000006c,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000c5
    );
  blk00000003_blk00000082 : MULT_AND
    port map (
      I0 => blk00000003_sig0000006a,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000c1
    );
  blk00000003_blk00000081 : MULT_AND
    port map (
      I0 => blk00000003_sig00000068,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000bd
    );
  blk00000003_blk00000080 : MULT_AND
    port map (
      I0 => blk00000003_sig00000066,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000b8
    );
  blk00000003_blk0000007f : MULT_AND
    port map (
      I0 => blk00000003_sig00000023,
      I1 => blk00000003_sig000000a4,
      LO => blk00000003_sig000000d2
    );
  blk00000003_blk0000007e : MUXCY
    port map (
      CI => blk00000003_sig00000023,
      DI => blk00000003_sig000000d7,
      S => blk00000003_sig000000d5,
      O => blk00000003_sig000000ce
    );
  blk00000003_blk0000007d : XORCY
    port map (
      CI => blk00000003_sig00000023,
      LI => blk00000003_sig000000d5,
      O => blk00000003_sig000000d6
    );
  blk00000003_blk0000007c : XORCY
    port map (
      CI => blk00000003_sig000000b9,
      LI => blk00000003_sig00000023,
      O => blk00000003_sig000000d4
    );
  blk00000003_blk0000007b : MUXCY
    port map (
      CI => blk00000003_sig000000b9,
      DI => blk00000003_sig000000d2,
      S => blk00000003_sig00000023,
      O => blk00000003_sig000000d3
    );
  blk00000003_blk0000007a : MUXCY
    port map (
      CI => blk00000003_sig000000ce,
      DI => blk00000003_sig000000d1,
      S => blk00000003_sig000000cf,
      O => blk00000003_sig000000ca
    );
  blk00000003_blk00000079 : XORCY
    port map (
      CI => blk00000003_sig000000ce,
      LI => blk00000003_sig000000cf,
      O => blk00000003_sig000000d0
    );
  blk00000003_blk00000078 : MUXCY
    port map (
      CI => blk00000003_sig000000ca,
      DI => blk00000003_sig000000cd,
      S => blk00000003_sig000000cb,
      O => blk00000003_sig000000c6
    );
  blk00000003_blk00000077 : XORCY
    port map (
      CI => blk00000003_sig000000ca,
      LI => blk00000003_sig000000cb,
      O => blk00000003_sig000000cc
    );
  blk00000003_blk00000076 : MUXCY
    port map (
      CI => blk00000003_sig000000c6,
      DI => blk00000003_sig000000c9,
      S => blk00000003_sig000000c7,
      O => blk00000003_sig000000c2
    );
  blk00000003_blk00000075 : XORCY
    port map (
      CI => blk00000003_sig000000c6,
      LI => blk00000003_sig000000c7,
      O => blk00000003_sig000000c8
    );
  blk00000003_blk00000074 : MUXCY
    port map (
      CI => blk00000003_sig000000c2,
      DI => blk00000003_sig000000c5,
      S => blk00000003_sig000000c3,
      O => blk00000003_sig000000be
    );
  blk00000003_blk00000073 : XORCY
    port map (
      CI => blk00000003_sig000000c2,
      LI => blk00000003_sig000000c3,
      O => blk00000003_sig000000c4
    );
  blk00000003_blk00000072 : MUXCY
    port map (
      CI => blk00000003_sig000000be,
      DI => blk00000003_sig000000c1,
      S => blk00000003_sig000000bf,
      O => blk00000003_sig000000ba
    );
  blk00000003_blk00000071 : XORCY
    port map (
      CI => blk00000003_sig000000be,
      LI => blk00000003_sig000000bf,
      O => blk00000003_sig000000c0
    );
  blk00000003_blk00000070 : MUXCY
    port map (
      CI => blk00000003_sig000000ba,
      DI => blk00000003_sig000000bd,
      S => blk00000003_sig000000bb,
      O => blk00000003_sig000000b5
    );
  blk00000003_blk0000006f : XORCY
    port map (
      CI => blk00000003_sig000000ba,
      LI => blk00000003_sig000000bb,
      O => blk00000003_sig000000bc
    );
  blk00000003_blk0000006e : MUXCY
    port map (
      CI => blk00000003_sig000000b5,
      DI => blk00000003_sig000000b8,
      S => blk00000003_sig000000b6,
      O => blk00000003_sig000000b9
    );
  blk00000003_blk0000006d : XORCY
    port map (
      CI => blk00000003_sig000000b5,
      LI => blk00000003_sig000000b6,
      O => blk00000003_sig000000b7
    );
  blk00000003_blk0000006c : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000b3,
      Q => blk00000003_sig000000b4
    );
  blk00000003_blk0000006b : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000b1,
      Q => blk00000003_sig000000b2
    );
  blk00000003_blk0000006a : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000af,
      Q => blk00000003_sig000000b0
    );
  blk00000003_blk00000069 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000ad,
      Q => blk00000003_sig000000ae
    );
  blk00000003_blk00000068 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000ab,
      Q => blk00000003_sig000000ac
    );
  blk00000003_blk00000067 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000a9,
      Q => blk00000003_sig000000aa
    );
  blk00000003_blk00000066 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000a7,
      Q => blk00000003_sig000000a8
    );
  blk00000003_blk00000065 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000a5,
      Q => blk00000003_sig000000a6
    );
  blk00000003_blk00000064 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig000000a3,
      Q => blk00000003_sig000000a4
    );
  blk00000003_blk00000063 : MUXCY
    port map (
      CI => blk00000003_sig00000089,
      DI => blk00000003_sig00000085,
      S => blk00000003_sig000000a1,
      O => blk00000003_sig0000009e
    );
  blk00000003_blk00000062 : XORCY
    port map (
      CI => blk00000003_sig00000089,
      LI => blk00000003_sig000000a1,
      O => blk00000003_sig000000a2
    );
  blk00000003_blk00000061 : MUXCY
    port map (
      CI => blk00000003_sig0000008a,
      DI => blk00000003_sig00000076,
      S => blk00000003_sig0000008b,
      O => NLW_blk00000003_blk00000061_O_UNCONNECTED
    );
  blk00000003_blk00000060 : MUXCY
    port map (
      CI => blk00000003_sig0000009e,
      DI => blk00000003_sig00000084,
      S => blk00000003_sig0000009f,
      O => blk00000003_sig0000009b
    );
  blk00000003_blk0000005f : MUXCY
    port map (
      CI => blk00000003_sig0000009b,
      DI => blk00000003_sig00000082,
      S => blk00000003_sig0000009c,
      O => blk00000003_sig00000098
    );
  blk00000003_blk0000005e : MUXCY
    port map (
      CI => blk00000003_sig00000098,
      DI => blk00000003_sig00000080,
      S => blk00000003_sig00000099,
      O => blk00000003_sig00000095
    );
  blk00000003_blk0000005d : MUXCY
    port map (
      CI => blk00000003_sig00000095,
      DI => blk00000003_sig0000007e,
      S => blk00000003_sig00000096,
      O => blk00000003_sig00000092
    );
  blk00000003_blk0000005c : MUXCY
    port map (
      CI => blk00000003_sig00000092,
      DI => blk00000003_sig0000007c,
      S => blk00000003_sig00000093,
      O => blk00000003_sig0000008f
    );
  blk00000003_blk0000005b : MUXCY
    port map (
      CI => blk00000003_sig0000008f,
      DI => blk00000003_sig0000007a,
      S => blk00000003_sig00000090,
      O => blk00000003_sig0000008c
    );
  blk00000003_blk0000005a : MUXCY
    port map (
      CI => blk00000003_sig0000008c,
      DI => blk00000003_sig00000078,
      S => blk00000003_sig0000008d,
      O => blk00000003_sig0000008a
    );
  blk00000003_blk00000059 : XORCY
    port map (
      CI => blk00000003_sig0000009e,
      LI => blk00000003_sig0000009f,
      O => blk00000003_sig000000a0
    );
  blk00000003_blk00000058 : XORCY
    port map (
      CI => blk00000003_sig0000009b,
      LI => blk00000003_sig0000009c,
      O => blk00000003_sig0000009d
    );
  blk00000003_blk00000057 : XORCY
    port map (
      CI => blk00000003_sig00000098,
      LI => blk00000003_sig00000099,
      O => blk00000003_sig0000009a
    );
  blk00000003_blk00000056 : XORCY
    port map (
      CI => blk00000003_sig00000095,
      LI => blk00000003_sig00000096,
      O => blk00000003_sig00000097
    );
  blk00000003_blk00000055 : XORCY
    port map (
      CI => blk00000003_sig00000092,
      LI => blk00000003_sig00000093,
      O => blk00000003_sig00000094
    );
  blk00000003_blk00000054 : XORCY
    port map (
      CI => blk00000003_sig0000008f,
      LI => blk00000003_sig00000090,
      O => blk00000003_sig00000091
    );
  blk00000003_blk00000053 : XORCY
    port map (
      CI => blk00000003_sig0000008c,
      LI => blk00000003_sig0000008d,
      O => blk00000003_sig0000008e
    );
  blk00000003_blk00000052 : XORCY
    port map (
      CI => blk00000003_sig0000008a,
      LI => blk00000003_sig0000008b,
      O => blk00000003_sig00000039
    );
  blk00000003_blk00000051 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000088,
      Q => blk00000003_sig00000089
    );
  blk00000003_blk00000050 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000086,
      Q => blk00000003_sig00000087
    );
  blk00000003_blk0000004f : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000032,
      Q => blk00000003_sig00000085
    );
  blk00000003_blk0000004e : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000083,
      Q => blk00000003_sig00000084
    );
  blk00000003_blk0000004d : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000081,
      Q => blk00000003_sig00000082
    );
  blk00000003_blk0000004c : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000007f,
      Q => blk00000003_sig00000080
    );
  blk00000003_blk0000004b : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000007d,
      Q => blk00000003_sig0000007e
    );
  blk00000003_blk0000004a : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000007b,
      Q => blk00000003_sig0000007c
    );
  blk00000003_blk00000049 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000079,
      Q => blk00000003_sig0000007a
    );
  blk00000003_blk00000048 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000077,
      Q => blk00000003_sig00000078
    );
  blk00000003_blk00000047 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000075,
      Q => blk00000003_sig00000076
    );
  blk00000003_blk00000046 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig0000005b,
      Q => blk00000003_sig00000073
    );
  blk00000003_blk00000045 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig0000005a,
      Q => blk00000003_sig00000071
    );
  blk00000003_blk00000044 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000059,
      Q => blk00000003_sig0000006f
    );
  blk00000003_blk00000043 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000058,
      Q => blk00000003_sig0000006d
    );
  blk00000003_blk00000042 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000057,
      Q => blk00000003_sig0000006b
    );
  blk00000003_blk00000041 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000056,
      Q => blk00000003_sig00000069
    );
  blk00000003_blk00000040 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000055,
      Q => blk00000003_sig00000067
    );
  blk00000003_blk0000003f : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000054,
      Q => blk00000003_sig00000065
    );
  blk00000003_blk0000003e : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000073,
      Q => blk00000003_sig00000074
    );
  blk00000003_blk0000003d : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000071,
      Q => blk00000003_sig00000072
    );
  blk00000003_blk0000003c : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig0000006f,
      Q => blk00000003_sig00000070
    );
  blk00000003_blk0000003b : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig0000006d,
      Q => blk00000003_sig0000006e
    );
  blk00000003_blk0000003a : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig0000006b,
      Q => blk00000003_sig0000006c
    );
  blk00000003_blk00000039 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000069,
      Q => blk00000003_sig0000006a
    );
  blk00000003_blk00000038 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000067,
      Q => blk00000003_sig00000068
    );
  blk00000003_blk00000037 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000064,
      D => blk00000003_sig00000065,
      Q => blk00000003_sig00000066
    );
  blk00000003_blk00000036 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(0),
      Q => blk00000003_sig00000028
    );
  blk00000003_blk00000035 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(1),
      Q => blk00000003_sig00000027
    );
  blk00000003_blk00000034 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(2),
      Q => blk00000003_sig00000029
    );
  blk00000003_blk00000033 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(3),
      Q => blk00000003_sig0000002a
    );
  blk00000003_blk00000032 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(4),
      Q => blk00000003_sig0000002d
    );
  blk00000003_blk00000031 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(5),
      Q => blk00000003_sig0000002c
    );
  blk00000003_blk00000030 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(6),
      Q => blk00000003_sig0000002e
    );
  blk00000003_blk0000002f : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => dividend_0(7),
      Q => blk00000003_sig0000002f
    );
  blk00000003_blk0000002e : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000063,
      Q => quotient_2(0)
    );
  blk00000003_blk0000002d : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000062,
      Q => quotient_2(1)
    );
  blk00000003_blk0000002c : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000061,
      Q => quotient_2(2)
    );
  blk00000003_blk0000002b : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000060,
      Q => quotient_2(3)
    );
  blk00000003_blk0000002a : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000005f,
      Q => quotient_2(4)
    );
  blk00000003_blk00000029 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000005e,
      Q => quotient_2(5)
    );
  blk00000003_blk00000028 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000005d,
      Q => quotient_2(6)
    );
  blk00000003_blk00000027 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000005c,
      Q => quotient_2(7)
    );
  blk00000003_blk00000026 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(0),
      Q => blk00000003_sig0000005b
    );
  blk00000003_blk00000025 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(1),
      Q => blk00000003_sig0000005a
    );
  blk00000003_blk00000024 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(2),
      Q => blk00000003_sig00000059
    );
  blk00000003_blk00000023 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(3),
      Q => blk00000003_sig00000058
    );
  blk00000003_blk00000022 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(4),
      Q => blk00000003_sig00000057
    );
  blk00000003_blk00000021 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(5),
      Q => blk00000003_sig00000056
    );
  blk00000003_blk00000020 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(6),
      Q => blk00000003_sig00000055
    );
  blk00000003_blk0000001f : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000053,
      D => divisor_1(7),
      Q => blk00000003_sig00000054
    );
  blk00000003_blk0000001e : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig00000051,
      Q => blk00000003_sig00000052
    );
  blk00000003_blk0000001d : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig0000004f,
      Q => blk00000003_sig00000050
    );
  blk00000003_blk0000001c : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig0000004d,
      Q => blk00000003_sig0000004e
    );
  blk00000003_blk0000001b : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig0000004b,
      Q => blk00000003_sig0000004c
    );
  blk00000003_blk0000001a : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig00000049,
      Q => blk00000003_sig0000004a
    );
  blk00000003_blk00000019 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig00000047,
      Q => blk00000003_sig00000048
    );
  blk00000003_blk00000018 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig00000045,
      Q => blk00000003_sig00000046
    );
  blk00000003_blk00000017 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000042,
      D => blk00000003_sig00000043,
      Q => blk00000003_sig00000044
    );
  blk00000003_blk00000016 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => NlwRenamedSig_OI_rfd,
      Q => blk00000003_sig00000042
    );
  blk00000003_blk00000015 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000041,
      Q => NlwRenamedSig_OI_rfd
    );
  blk00000003_blk00000014 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000034,
      Q => blk00000003_sig00000031
    );
  blk00000003_blk00000013 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000036,
      Q => blk00000003_sig00000025
    );
  blk00000003_blk00000012 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000038,
      Q => blk00000003_sig00000026
    );
  blk00000003_blk00000011 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000003f,
      Q => blk00000003_sig00000040
    );
  blk00000003_blk00000010 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000003e,
      Q => blk00000003_sig0000003f
    );
  blk00000003_blk0000000f : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000003d,
      Q => blk00000003_sig0000003e
    );
  blk00000003_blk0000000e : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000003c,
      Q => blk00000003_sig0000003d
    );
  blk00000003_blk0000000d : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000003b,
      Q => blk00000003_sig0000003c
    );
  blk00000003_blk0000000c : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig0000003a,
      Q => blk00000003_sig0000003b
    );
  blk00000003_blk0000000b : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000039,
      Q => blk00000003_sig0000003a
    );
  blk00000003_blk0000000a : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000037,
      Q => blk00000003_sig00000038
    );
  blk00000003_blk00000009 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000035,
      Q => blk00000003_sig00000036
    );
  blk00000003_blk00000008 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => ce,
      D => blk00000003_sig00000033,
      Q => blk00000003_sig00000034
    );
  blk00000003_blk00000007 : MUXF7
    port map (
      I0 => blk00000003_sig00000030,
      I1 => blk00000003_sig0000002b,
      S => blk00000003_sig00000031,
      O => blk00000003_sig00000032
    );
  blk00000003_blk00000006 : LUT6
    generic map(
      INIT => X"FD75B931EC64A820"
    )
    port map (
      I0 => blk00000003_sig00000025,
      I1 => blk00000003_sig00000026,
      I2 => blk00000003_sig0000002c,
      I3 => blk00000003_sig0000002d,
      I4 => blk00000003_sig0000002e,
      I5 => blk00000003_sig0000002f,
      O => blk00000003_sig00000030
    );
  blk00000003_blk00000005 : LUT6
    generic map(
      INIT => X"FD75B931EC64A820"
    )
    port map (
      I0 => blk00000003_sig00000025,
      I1 => blk00000003_sig00000026,
      I2 => blk00000003_sig00000027,
      I3 => blk00000003_sig00000028,
      I4 => blk00000003_sig00000029,
      I5 => blk00000003_sig0000002a,
      O => blk00000003_sig0000002b
    );
  blk00000003_blk00000004 : GND
    port map (
      G => blk00000003_sig00000023
    );

end STRUCTURE;

-- synthesis translate_on
