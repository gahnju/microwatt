---------------------------------------------------------------------
--  Copyright (c) 2017 by IBM , Inc.  All rights reserved.
--                   IBM confidential
--
--  $Source: $
--  $Revision: $
--  $State: $
--  $Date: $
--  $Author: $
--  $Locker:  $
--
--  Change log at the bottom of this file
---------------------------------------------------------------------
-- ******************************************************************
--  PROJECT:     Hub Reduction Logic
--  MODULE:      CommonDef
--  DESCRIPTION: Package for declaring common constants / functions
--                       used across the design.
--
--               Instantiated_by:
--
--  ENGINEER:    Bharat Sukhwani
--  CREATED:     Nov 29, 2017
-- ******************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_unsigned.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;
use ieee.math_real.all;
use ieee.std_logic_misc.all;

package CommonDef is

  function get_hstring (value : STD_ULOGIC_VECTOR) return STRING ;
  function or_reduce(val: STD_ULOGIC_VECTOR) return STD_ULOGIC;
  function and_reduce(val: STD_ULOGIC_VECTOR) return STD_ULOGIC;
  procedure get_hread(l: inout line; value: out std_logic_vector);

end CommonDef;

package body CommonDef is
  function get_hstring (value : STD_ULOGIC_VECTOR) return STRING is
    constant result_length : NATURAL := (value'length+3)/4;
    variable pad           : STD_ULOGIC_VECTOR(1 to result_length*4 - value'length);
    variable padded_value  : STD_ULOGIC_VECTOR(1 to result_length*4);
    variable result        : STRING(1 to result_length);
    variable quad          : STD_ULOGIC_VECTOR(1 to 4);
  begin
    if value (value'left) = 'Z' then
      pad := (others => 'Z');
    else
      pad := (others => '0');
    end if;
    padded_value := pad & value;
    for i in 1 to result_length loop
      quad := To_X01Z(padded_value(4*i-3 to 4*i));
      case quad is
        when x"0"   => result(i) := '0';
        when x"1"   => result(i) := '1';
        when x"2"   => result(i) := '2';
        when x"3"   => result(i) := '3';
        when x"4"   => result(i) := '4';
        when x"5"   => result(i) := '5';
        when x"6"   => result(i) := '6';
        when x"7"   => result(i) := '7';
        when x"8"   => result(i) := '8';
        when x"9"   => result(i) := '9';
        when x"A"   => result(i) := 'A';
        when x"B"   => result(i) := 'B';
        when x"C"   => result(i) := 'C';
        when x"D"   => result(i) := 'D';
        when x"E"   => result(i) := 'E';
        when x"F"   => result(i) := 'F';
        when "ZZZZ" => result(i) := 'Z';
        when others => result(i) := 'X';
      end case;
    end loop;
    return result;
  end function get_hstring;

  function or_reduce(val: STD_ULOGIC_VECTOR) return STD_ULOGIC is
      variable res: STD_ULOGIC;
  begin
      for i in val'range loop
          if i = val'left then
              res := val(i);
          else
              res := res OR val(i);
          end if;
          exit when res = '1';
      end loop;
      return res;
  end function or_reduce;

  function and_reduce(val: STD_ULOGIC_VECTOR) return STD_ULOGIC is
      variable res: STD_ULOGIC;
  begin
      for i in val'range loop
          if i = val'left then
              res := val(i);
          else
              res := res AND val(i);
          end if;
          exit when res = '0';
      end loop;
      return res;
  end function and_reduce;
  
  procedure get_hread(l: inout line; value: out std_logic_vector) is
      variable c : character;
      variable ok : boolean;
      variable i : integer := 0;
      variable hex_val : std_logic_vector(3 downto 0);
  begin
    while i < value'high loop
        read(l, c);
   
        case c is
            when '0' => hex_val := "0000";
            when '1' => hex_val := "0001";
            when '2' => hex_val := "0010";
            when '3' => hex_val := "0011";
            when '4' => hex_val := "0100";
            when '5' => hex_val := "0101";
            when '6' => hex_val := "0110";
            when '7' => hex_val := "0111";
            when '8' => hex_val := "1000";
            when '9' => hex_val := "1001";
            when 'A' | 'a' => hex_val := "1010";
            when 'B' | 'b' => hex_val := "1011";
            when 'C' | 'c' => hex_val := "1100";
            when 'D' | 'd' => hex_val := "1101";
            when 'E' | 'e' => hex_val := "1110";
            when 'F' | 'f' => hex_val := "1111";
   
            when others =>
                hex_val := "XXXX";
                assert false report "Found non-hex character '" & c & "'";
        end case;
   
        value(value'high - i downto value'high - i - 3) := hex_val;
        i := i + 4;
    end loop;
  end procedure;
end CommonDef;