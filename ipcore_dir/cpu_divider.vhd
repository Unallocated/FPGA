--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Filename: cpu_divider.vhd
-- /___/   /\     Timestamp: Sun Dec  8 22:30:49 2013
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
  signal blk00000003_sig00000024 : STD_LOGIC; 
  signal blk00000003_sig00000022 : STD_LOGIC; 
  signal NLW_blk00000001_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_blk00000002_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_blk00000003_blk00000059_O_UNCONNECTED : STD_LOGIC; 
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
  blk00000003_blk000000b8 : INV
    port map (
      I => blk00000003_sig00000042,
      O => blk00000003_sig000000be
    );
  blk00000003_blk000000b7 : INV
    port map (
      I => blk00000003_sig00000043,
      O => blk00000003_sig000000bf
    );
  blk00000003_blk000000b6 : INV
    port map (
      I => blk00000003_sig00000044,
      O => blk00000003_sig000000c0
    );
  blk00000003_blk000000b5 : INV
    port map (
      I => blk00000003_sig00000045,
      O => blk00000003_sig000000c1
    );
  blk00000003_blk000000b4 : INV
    port map (
      I => blk00000003_sig00000046,
      O => blk00000003_sig000000c2
    );
  blk00000003_blk000000b3 : INV
    port map (
      I => blk00000003_sig00000047,
      O => blk00000003_sig000000c3
    );
  blk00000003_blk000000b2 : INV
    port map (
      I => blk00000003_sig00000048,
      O => blk00000003_sig000000c4
    );
  blk00000003_blk000000b1 : INV
    port map (
      I => blk00000003_sig00000049,
      O => blk00000003_sig000000c5
    );
  blk00000003_blk000000b0 : INV
    port map (
      I => blk00000003_sig00000037,
      O => blk00000003_sig00000036
    );
  blk00000003_blk000000af : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000091,
      I1 => blk00000003_sig00000053,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig0000009a
    );
  blk00000003_blk000000ae : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000092,
      I1 => blk00000003_sig00000055,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig0000009f
    );
  blk00000003_blk000000ad : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000093,
      I1 => blk00000003_sig00000057,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig000000a3
    );
  blk00000003_blk000000ac : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000094,
      I1 => blk00000003_sig00000059,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig000000a7
    );
  blk00000003_blk000000ab : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000095,
      I1 => blk00000003_sig0000005b,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig000000ab
    );
  blk00000003_blk000000aa : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000096,
      I1 => blk00000003_sig0000005d,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig000000af
    );
  blk00000003_blk000000a9 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000097,
      I1 => blk00000003_sig0000005f,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig000000b3
    );
  blk00000003_blk000000a8 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000098,
      I1 => blk00000003_sig00000061,
      I2 => blk00000003_sig00000090,
      O => blk00000003_sig000000b9
    );
  blk00000003_blk000000a7 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => blk00000003_sig00000063,
      I1 => blk00000003_sig00000074,
      O => blk00000003_sig00000078
    );
  blk00000003_blk000000a6 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000065,
      I1 => blk00000003_sig00000052,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig0000007a
    );
  blk00000003_blk000000a5 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000067,
      I1 => blk00000003_sig00000054,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig0000007d
    );
  blk00000003_blk000000a4 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000069,
      I1 => blk00000003_sig00000056,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig00000080
    );
  blk00000003_blk000000a3 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig0000006b,
      I1 => blk00000003_sig00000058,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig00000083
    );
  blk00000003_blk000000a2 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig0000006d,
      I1 => blk00000003_sig0000005a,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig00000086
    );
  blk00000003_blk000000a1 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig0000006f,
      I1 => blk00000003_sig0000005c,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig00000089
    );
  blk00000003_blk000000a0 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000071,
      I1 => blk00000003_sig0000005e,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig0000008c
    );
  blk00000003_blk0000009f : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => blk00000003_sig00000072,
      I1 => blk00000003_sig00000060,
      I2 => blk00000003_sig00000074,
      O => blk00000003_sig0000008e
    );
  blk00000003_blk0000009e : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => blk00000003_sig00000033,
      I1 => blk00000003_sig00000035,
      I2 => blk00000003_sig00000037,
      O => blk00000003_sig00000040
    );
  blk00000003_blk0000009d : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => blk00000003_sig00000035,
      I1 => blk00000003_sig00000037,
      O => blk00000003_sig00000034
    );
  blk00000003_blk0000009c : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig0000007e,
      O => blk00000003_sig00000064
    );
  blk00000003_blk0000009b : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig00000081,
      O => blk00000003_sig00000066
    );
  blk00000003_blk0000009a : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig00000084,
      O => blk00000003_sig00000068
    );
  blk00000003_blk00000099 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig00000087,
      O => blk00000003_sig0000006a
    );
  blk00000003_blk00000098 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig0000008a,
      O => blk00000003_sig0000006c
    );
  blk00000003_blk00000097 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig0000008d,
      O => blk00000003_sig0000006e
    );
  blk00000003_blk00000096 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig0000008f,
      O => blk00000003_sig00000070
    );
  blk00000003_blk00000095 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig00000038,
      O => blk00000003_sig00000073
    );
  blk00000003_blk00000094 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig0000007b,
      O => blk00000003_sig00000062
    );
  blk00000003_blk00000093 : LUT2
    generic map(
      INIT => X"B"
    )
    port map (
      I0 => blk00000003_sig00000041,
      I1 => blk00000003_sig00000038,
      O => blk00000003_sig00000075
    );
  blk00000003_blk00000092 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => blk00000003_sig00000033,
      I1 => blk00000003_sig00000037,
      I2 => blk00000003_sig00000035,
      O => blk00000003_sig00000032
    );
  blk00000003_blk00000091 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000c5,
      Q => quotient_2(0)
    );
  blk00000003_blk00000090 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000c4,
      Q => quotient_2(1)
    );
  blk00000003_blk0000008f : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000c3,
      Q => quotient_2(2)
    );
  blk00000003_blk0000008e : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000c2,
      Q => quotient_2(3)
    );
  blk00000003_blk0000008d : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000c1,
      Q => quotient_2(4)
    );
  blk00000003_blk0000008c : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000c0,
      Q => quotient_2(5)
    );
  blk00000003_blk0000008b : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000bf,
      Q => quotient_2(6)
    );
  blk00000003_blk0000008a : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000be,
      Q => quotient_2(7)
    );
  blk00000003_blk00000089 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000ba,
      Q => fractional_3(0)
    );
  blk00000003_blk00000088 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000b4,
      Q => fractional_3(1)
    );
  blk00000003_blk00000087 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000b0,
      Q => fractional_3(2)
    );
  blk00000003_blk00000086 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000ac,
      Q => fractional_3(3)
    );
  blk00000003_blk00000085 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000a8,
      Q => fractional_3(4)
    );
  blk00000003_blk00000084 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000a4,
      Q => fractional_3(5)
    );
  blk00000003_blk00000083 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000a0,
      Q => fractional_3(6)
    );
  blk00000003_blk00000082 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000009b,
      Q => fractional_3(7)
    );
  blk00000003_blk00000081 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000b8,
      Q => blk00000003_sig000000bd
    );
  blk00000003_blk00000080 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig000000b7,
      Q => blk00000003_sig000000bc
    );
  blk00000003_blk0000007f : MULT_AND
    port map (
      I0 => blk00000003_sig00000061,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000bb
    );
  blk00000003_blk0000007e : MULT_AND
    port map (
      I0 => blk00000003_sig0000005f,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000b5
    );
  blk00000003_blk0000007d : MULT_AND
    port map (
      I0 => blk00000003_sig0000005d,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000b1
    );
  blk00000003_blk0000007c : MULT_AND
    port map (
      I0 => blk00000003_sig0000005b,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000ad
    );
  blk00000003_blk0000007b : MULT_AND
    port map (
      I0 => blk00000003_sig00000059,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000a9
    );
  blk00000003_blk0000007a : MULT_AND
    port map (
      I0 => blk00000003_sig00000057,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000a5
    );
  blk00000003_blk00000079 : MULT_AND
    port map (
      I0 => blk00000003_sig00000055,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000a1
    );
  blk00000003_blk00000078 : MULT_AND
    port map (
      I0 => blk00000003_sig00000053,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig0000009c
    );
  blk00000003_blk00000077 : MULT_AND
    port map (
      I0 => blk00000003_sig00000022,
      I1 => blk00000003_sig00000090,
      LO => blk00000003_sig000000b6
    );
  blk00000003_blk00000076 : MUXCY
    port map (
      CI => blk00000003_sig00000022,
      DI => blk00000003_sig000000bb,
      S => blk00000003_sig000000b9,
      O => blk00000003_sig000000b2
    );
  blk00000003_blk00000075 : XORCY
    port map (
      CI => blk00000003_sig00000022,
      LI => blk00000003_sig000000b9,
      O => blk00000003_sig000000ba
    );
  blk00000003_blk00000074 : XORCY
    port map (
      CI => blk00000003_sig0000009d,
      LI => blk00000003_sig00000022,
      O => blk00000003_sig000000b8
    );
  blk00000003_blk00000073 : MUXCY
    port map (
      CI => blk00000003_sig0000009d,
      DI => blk00000003_sig000000b6,
      S => blk00000003_sig00000022,
      O => blk00000003_sig000000b7
    );
  blk00000003_blk00000072 : MUXCY
    port map (
      CI => blk00000003_sig000000b2,
      DI => blk00000003_sig000000b5,
      S => blk00000003_sig000000b3,
      O => blk00000003_sig000000ae
    );
  blk00000003_blk00000071 : XORCY
    port map (
      CI => blk00000003_sig000000b2,
      LI => blk00000003_sig000000b3,
      O => blk00000003_sig000000b4
    );
  blk00000003_blk00000070 : MUXCY
    port map (
      CI => blk00000003_sig000000ae,
      DI => blk00000003_sig000000b1,
      S => blk00000003_sig000000af,
      O => blk00000003_sig000000aa
    );
  blk00000003_blk0000006f : XORCY
    port map (
      CI => blk00000003_sig000000ae,
      LI => blk00000003_sig000000af,
      O => blk00000003_sig000000b0
    );
  blk00000003_blk0000006e : MUXCY
    port map (
      CI => blk00000003_sig000000aa,
      DI => blk00000003_sig000000ad,
      S => blk00000003_sig000000ab,
      O => blk00000003_sig000000a6
    );
  blk00000003_blk0000006d : XORCY
    port map (
      CI => blk00000003_sig000000aa,
      LI => blk00000003_sig000000ab,
      O => blk00000003_sig000000ac
    );
  blk00000003_blk0000006c : MUXCY
    port map (
      CI => blk00000003_sig000000a6,
      DI => blk00000003_sig000000a9,
      S => blk00000003_sig000000a7,
      O => blk00000003_sig000000a2
    );
  blk00000003_blk0000006b : XORCY
    port map (
      CI => blk00000003_sig000000a6,
      LI => blk00000003_sig000000a7,
      O => blk00000003_sig000000a8
    );
  blk00000003_blk0000006a : MUXCY
    port map (
      CI => blk00000003_sig000000a2,
      DI => blk00000003_sig000000a5,
      S => blk00000003_sig000000a3,
      O => blk00000003_sig0000009e
    );
  blk00000003_blk00000069 : XORCY
    port map (
      CI => blk00000003_sig000000a2,
      LI => blk00000003_sig000000a3,
      O => blk00000003_sig000000a4
    );
  blk00000003_blk00000068 : MUXCY
    port map (
      CI => blk00000003_sig0000009e,
      DI => blk00000003_sig000000a1,
      S => blk00000003_sig0000009f,
      O => blk00000003_sig00000099
    );
  blk00000003_blk00000067 : XORCY
    port map (
      CI => blk00000003_sig0000009e,
      LI => blk00000003_sig0000009f,
      O => blk00000003_sig000000a0
    );
  blk00000003_blk00000066 : MUXCY
    port map (
      CI => blk00000003_sig00000099,
      DI => blk00000003_sig0000009c,
      S => blk00000003_sig0000009a,
      O => blk00000003_sig0000009d
    );
  blk00000003_blk00000065 : XORCY
    port map (
      CI => blk00000003_sig00000099,
      LI => blk00000003_sig0000009a,
      O => blk00000003_sig0000009b
    );
  blk00000003_blk00000064 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000008f,
      Q => blk00000003_sig00000098
    );
  blk00000003_blk00000063 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000008d,
      Q => blk00000003_sig00000097
    );
  blk00000003_blk00000062 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000008a,
      Q => blk00000003_sig00000096
    );
  blk00000003_blk00000061 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000087,
      Q => blk00000003_sig00000095
    );
  blk00000003_blk00000060 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000084,
      Q => blk00000003_sig00000094
    );
  blk00000003_blk0000005f : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000081,
      Q => blk00000003_sig00000093
    );
  blk00000003_blk0000005e : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000007e,
      Q => blk00000003_sig00000092
    );
  blk00000003_blk0000005d : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000007b,
      Q => blk00000003_sig00000091
    );
  blk00000003_blk0000005c : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000038,
      Q => blk00000003_sig00000090
    );
  blk00000003_blk0000005b : MUXCY
    port map (
      CI => blk00000003_sig00000076,
      DI => blk00000003_sig00000072,
      S => blk00000003_sig0000008e,
      O => blk00000003_sig0000008b
    );
  blk00000003_blk0000005a : XORCY
    port map (
      CI => blk00000003_sig00000076,
      LI => blk00000003_sig0000008e,
      O => blk00000003_sig0000008f
    );
  blk00000003_blk00000059 : MUXCY
    port map (
      CI => blk00000003_sig00000077,
      DI => blk00000003_sig00000063,
      S => blk00000003_sig00000078,
      O => NLW_blk00000003_blk00000059_O_UNCONNECTED
    );
  blk00000003_blk00000058 : MUXCY
    port map (
      CI => blk00000003_sig0000008b,
      DI => blk00000003_sig00000071,
      S => blk00000003_sig0000008c,
      O => blk00000003_sig00000088
    );
  blk00000003_blk00000057 : MUXCY
    port map (
      CI => blk00000003_sig00000088,
      DI => blk00000003_sig0000006f,
      S => blk00000003_sig00000089,
      O => blk00000003_sig00000085
    );
  blk00000003_blk00000056 : MUXCY
    port map (
      CI => blk00000003_sig00000085,
      DI => blk00000003_sig0000006d,
      S => blk00000003_sig00000086,
      O => blk00000003_sig00000082
    );
  blk00000003_blk00000055 : MUXCY
    port map (
      CI => blk00000003_sig00000082,
      DI => blk00000003_sig0000006b,
      S => blk00000003_sig00000083,
      O => blk00000003_sig0000007f
    );
  blk00000003_blk00000054 : MUXCY
    port map (
      CI => blk00000003_sig0000007f,
      DI => blk00000003_sig00000069,
      S => blk00000003_sig00000080,
      O => blk00000003_sig0000007c
    );
  blk00000003_blk00000053 : MUXCY
    port map (
      CI => blk00000003_sig0000007c,
      DI => blk00000003_sig00000067,
      S => blk00000003_sig0000007d,
      O => blk00000003_sig00000079
    );
  blk00000003_blk00000052 : MUXCY
    port map (
      CI => blk00000003_sig00000079,
      DI => blk00000003_sig00000065,
      S => blk00000003_sig0000007a,
      O => blk00000003_sig00000077
    );
  blk00000003_blk00000051 : XORCY
    port map (
      CI => blk00000003_sig0000008b,
      LI => blk00000003_sig0000008c,
      O => blk00000003_sig0000008d
    );
  blk00000003_blk00000050 : XORCY
    port map (
      CI => blk00000003_sig00000088,
      LI => blk00000003_sig00000089,
      O => blk00000003_sig0000008a
    );
  blk00000003_blk0000004f : XORCY
    port map (
      CI => blk00000003_sig00000085,
      LI => blk00000003_sig00000086,
      O => blk00000003_sig00000087
    );
  blk00000003_blk0000004e : XORCY
    port map (
      CI => blk00000003_sig00000082,
      LI => blk00000003_sig00000083,
      O => blk00000003_sig00000084
    );
  blk00000003_blk0000004d : XORCY
    port map (
      CI => blk00000003_sig0000007f,
      LI => blk00000003_sig00000080,
      O => blk00000003_sig00000081
    );
  blk00000003_blk0000004c : XORCY
    port map (
      CI => blk00000003_sig0000007c,
      LI => blk00000003_sig0000007d,
      O => blk00000003_sig0000007e
    );
  blk00000003_blk0000004b : XORCY
    port map (
      CI => blk00000003_sig00000079,
      LI => blk00000003_sig0000007a,
      O => blk00000003_sig0000007b
    );
  blk00000003_blk0000004a : XORCY
    port map (
      CI => blk00000003_sig00000077,
      LI => blk00000003_sig00000078,
      O => blk00000003_sig00000038
    );
  blk00000003_blk00000049 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000075,
      Q => blk00000003_sig00000076
    );
  blk00000003_blk00000048 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000073,
      Q => blk00000003_sig00000074
    );
  blk00000003_blk00000047 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000031,
      Q => blk00000003_sig00000072
    );
  blk00000003_blk00000046 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000070,
      Q => blk00000003_sig00000071
    );
  blk00000003_blk00000045 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000006e,
      Q => blk00000003_sig0000006f
    );
  blk00000003_blk00000044 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000006c,
      Q => blk00000003_sig0000006d
    );
  blk00000003_blk00000043 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000006a,
      Q => blk00000003_sig0000006b
    );
  blk00000003_blk00000042 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000068,
      Q => blk00000003_sig00000069
    );
  blk00000003_blk00000041 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000066,
      Q => blk00000003_sig00000067
    );
  blk00000003_blk00000040 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000064,
      Q => blk00000003_sig00000065
    );
  blk00000003_blk0000003f : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000062,
      Q => blk00000003_sig00000063
    );
  blk00000003_blk0000003e : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000051,
      Q => blk00000003_sig00000060
    );
  blk00000003_blk0000003d : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000050,
      Q => blk00000003_sig0000005e
    );
  blk00000003_blk0000003c : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000004f,
      Q => blk00000003_sig0000005c
    );
  blk00000003_blk0000003b : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000004e,
      Q => blk00000003_sig0000005a
    );
  blk00000003_blk0000003a : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000004d,
      Q => blk00000003_sig00000058
    );
  blk00000003_blk00000039 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000004c,
      Q => blk00000003_sig00000056
    );
  blk00000003_blk00000038 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000004b,
      Q => blk00000003_sig00000054
    );
  blk00000003_blk00000037 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000004a,
      Q => blk00000003_sig00000052
    );
  blk00000003_blk00000036 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000060,
      Q => blk00000003_sig00000061
    );
  blk00000003_blk00000035 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000005e,
      Q => blk00000003_sig0000005f
    );
  blk00000003_blk00000034 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000005c,
      Q => blk00000003_sig0000005d
    );
  blk00000003_blk00000033 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000005a,
      Q => blk00000003_sig0000005b
    );
  blk00000003_blk00000032 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000058,
      Q => blk00000003_sig00000059
    );
  blk00000003_blk00000031 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000056,
      Q => blk00000003_sig00000057
    );
  blk00000003_blk00000030 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000054,
      Q => blk00000003_sig00000055
    );
  blk00000003_blk0000002f : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000052,
      Q => blk00000003_sig00000053
    );
  blk00000003_blk0000002e : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(0),
      Q => blk00000003_sig00000027
    );
  blk00000003_blk0000002d : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(1),
      Q => blk00000003_sig00000026
    );
  blk00000003_blk0000002c : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(2),
      Q => blk00000003_sig00000028
    );
  blk00000003_blk0000002b : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(3),
      Q => blk00000003_sig00000029
    );
  blk00000003_blk0000002a : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(4),
      Q => blk00000003_sig0000002c
    );
  blk00000003_blk00000029 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(5),
      Q => blk00000003_sig0000002b
    );
  blk00000003_blk00000028 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(6),
      Q => blk00000003_sig0000002d
    );
  blk00000003_blk00000027 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => dividend_0(7),
      Q => blk00000003_sig0000002e
    );
  blk00000003_blk00000026 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(0),
      Q => blk00000003_sig00000051
    );
  blk00000003_blk00000025 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(1),
      Q => blk00000003_sig00000050
    );
  blk00000003_blk00000024 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(2),
      Q => blk00000003_sig0000004f
    );
  blk00000003_blk00000023 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(3),
      Q => blk00000003_sig0000004e
    );
  blk00000003_blk00000022 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(4),
      Q => blk00000003_sig0000004d
    );
  blk00000003_blk00000021 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(5),
      Q => blk00000003_sig0000004c
    );
  blk00000003_blk00000020 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(6),
      Q => blk00000003_sig0000004b
    );
  blk00000003_blk0000001f : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => NlwRenamedSig_OI_rfd,
      D => divisor_1(7),
      Q => blk00000003_sig0000004a
    );
  blk00000003_blk0000001e : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000038,
      Q => blk00000003_sig00000049
    );
  blk00000003_blk0000001d : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig00000039,
      Q => blk00000003_sig00000048
    );
  blk00000003_blk0000001c : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000003a,
      Q => blk00000003_sig00000047
    );
  blk00000003_blk0000001b : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000003b,
      Q => blk00000003_sig00000046
    );
  blk00000003_blk0000001a : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000003c,
      Q => blk00000003_sig00000045
    );
  blk00000003_blk00000019 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000003d,
      Q => blk00000003_sig00000044
    );
  blk00000003_blk00000018 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000003e,
      Q => blk00000003_sig00000043
    );
  blk00000003_blk00000017 : FDE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => blk00000003_sig00000041,
      D => blk00000003_sig0000003f,
      Q => blk00000003_sig00000042
    );
  blk00000003_blk00000016 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => NlwRenamedSig_OI_rfd,
      Q => blk00000003_sig00000041
    );
  blk00000003_blk00000015 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000040,
      Q => NlwRenamedSig_OI_rfd
    );
  blk00000003_blk00000014 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000033,
      Q => blk00000003_sig00000030
    );
  blk00000003_blk00000013 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000035,
      Q => blk00000003_sig00000024
    );
  blk00000003_blk00000012 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000037,
      Q => blk00000003_sig00000025
    );
  blk00000003_blk00000011 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000003e,
      Q => blk00000003_sig0000003f
    );
  blk00000003_blk00000010 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000003d,
      Q => blk00000003_sig0000003e
    );
  blk00000003_blk0000000f : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000003c,
      Q => blk00000003_sig0000003d
    );
  blk00000003_blk0000000e : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000003b,
      Q => blk00000003_sig0000003c
    );
  blk00000003_blk0000000d : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig0000003a,
      Q => blk00000003_sig0000003b
    );
  blk00000003_blk0000000c : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000039,
      Q => blk00000003_sig0000003a
    );
  blk00000003_blk0000000b : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000038,
      Q => blk00000003_sig00000039
    );
  blk00000003_blk0000000a : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000036,
      Q => blk00000003_sig00000037
    );
  blk00000003_blk00000009 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000034,
      Q => blk00000003_sig00000035
    );
  blk00000003_blk00000008 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => blk00000003_sig00000032,
      Q => blk00000003_sig00000033
    );
  blk00000003_blk00000007 : MUXF7
    port map (
      I0 => blk00000003_sig0000002f,
      I1 => blk00000003_sig0000002a,
      S => blk00000003_sig00000030,
      O => blk00000003_sig00000031
    );
  blk00000003_blk00000006 : LUT6
    generic map(
      INIT => X"FD75B931EC64A820"
    )
    port map (
      I0 => blk00000003_sig00000024,
      I1 => blk00000003_sig00000025,
      I2 => blk00000003_sig0000002b,
      I3 => blk00000003_sig0000002c,
      I4 => blk00000003_sig0000002d,
      I5 => blk00000003_sig0000002e,
      O => blk00000003_sig0000002f
    );
  blk00000003_blk00000005 : LUT6
    generic map(
      INIT => X"FD75B931EC64A820"
    )
    port map (
      I0 => blk00000003_sig00000024,
      I1 => blk00000003_sig00000025,
      I2 => blk00000003_sig00000026,
      I3 => blk00000003_sig00000027,
      I4 => blk00000003_sig00000028,
      I5 => blk00000003_sig00000029,
      O => blk00000003_sig0000002a
    );
  blk00000003_blk00000004 : GND
    port map (
      G => blk00000003_sig00000022
    );

end STRUCTURE;

-- synthesis translate_on
