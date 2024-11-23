----------------------------------------------------------------------
--    VHDL Utilities Package 
--
--    Copyright (c) 1997 Artisan Components, Inc. All Rights Reserved.
--
--    $Author: gary $
--    $Date: 2004/06/21 18:41:08 $  
--    $Revision: 1.19 $
----------------------------------------------------------------------
library IEEE; 
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_textio.all;
    use IEEE.std_logic_arith.all;
--    use IEEE.VITAL_timing.all; 
--    use IEEE.VITAL_primitives.all;
--library STD;
--    use STD.STANDARD.all;
    use STD.TEXTIO.ALL;
    use STD.TextIO;

package vlibs is
    type X01ArrayT is array (natural range <>) of X01;
    type MEM_TYPE is array (natural range <>, natural range <>)  of std_logic;
    constant Unsigned : string := "Unsigned";
    constant MAX_DIGITS : integer := 20; 
    signal LastTime: time:= 0 ns;

    subtype SMALL_INT is INTEGER range 0 to 1;
    subtype int_string_buf is string(1 to MAX_DIGITS);
   
    -- Conversion operators
    function TO_STD_LOGIC_VECTOR(ARG: STD_LOGIC; SIZE: INTEGER) return STD_LOGIC_VECTOR;
    function All_X(s: STD_LOGIC_VECTOR) return BOOLEAN;
    function All_1(s: STD_LOGIC_VECTOR) return BOOLEAN;
    function All_0(s: STD_LOGIC_VECTOR) return BOOLEAN;
    function Is_1(s: STD_ULOGIC) return BOOLEAN;
    function is_same  ( l,r : std_logic_vector ) return boolean;
    function is_samex  ( l,r : std_logic ) return boolean;
    function is_samex  ( l,r : std_logic_vector ) return boolean;
    function is_samex  ( l,r : std_logic_vector; high,low : integer ) return boolean;
    function is_differentx  ( l,r : std_logic_vector ) return boolean;
    
    -- Print operators
    function IMAGE  (I  : Integer)          return string ;
    function IMAGE  (R  : Real)             return string ;
    function IMAGE  (B  : Boolean)          return string ;
    function IMAGE  (T  : time)             return string ;
    function IMAGE  (B  : Std_logic)        return string ;
    function IMAGE  (B  : Std_logic_Vector) return string ;
    function HIMAGE (B  : Std_logic_Vector) return string ;

    function VALUE (S : string) return Integer ;
    function VALUE (S : string) return Real ;
    function VALUE (S : string) return Boolean ;
    function VALUE (S : string) return time ;
    function VALUE (S : string) return Std_logic ;
    function VALUE (S : string) return Std_logic_Vector ;

    procedure PRINT (T : time; S : string);
    procedure PRINT (S : string);

    -- File operators
    procedure WRITE(l: inout line; val: in std_logic;
                    justify: in side:= right; field: in width:= 0);
    procedure WRITE(l: inout line; val: in std_logic_vector;
                    justify: in side:= right; field: in width:= 0);
    procedure READ(l: inout line; variable value: out std_logic);
    procedure READ(l: inout line; variable value: out std_logic_vector);
    function CONV_UNSIGNED_INTEGER(S: std_logic) return integer;
    function CONV_UNSIGNED_INTEGER(S: std_logic_vector) return integer;
    procedure COMPARE(l: inout line; data: in std_logic; str: in string);
    procedure COMPARE(l: inout line; data: in std_logic_vector; str: in string);
    procedure COMPARE_BIT(val: in std_logic; exp: in std_logic);
    procedure COMPARE_BIT(val: in std_logic; exp: in std_logic;variable err_cnt: inout integer);
    procedure WRITE_DONE(now_time: in time);
    function TO_STD_LOGIC(ch: CHARACTER) return std_logic;
    procedure CHECK_OUTPUT_X(val: in std_logic);
    procedure CHECK_OUTPUT_HIGH(val: in std_logic);
    procedure CHECK_OUTPUT_LOW(val: in std_logic);

    -- Memory operators
    procedure READ_MEM (Address: std_logic_vector; Data: out std_logic_vector; 
			variable MEM: in MEM_TYPE);
    procedure READ_MEM (Address: std_logic_vector; Data: out std_logic_vector; 
			variable MEM,ROWS: inout MEM_TYPE;RREN,RADD,RCA: in std_logic;CREN: in std_logic_vector;ColAddrWidth: in integer;write_mask: in boolean;Xlsb: in std_logic);
    procedure WRITE_MEM(Address: std_logic_vector; Data: std_logic_vector; 
			variable MEM: inout MEM_TYPE);
    procedure WRITE_MEM(Address: std_logic_vector; Data: std_logic_vector; 
			variable MEM: inout MEM_TYPE; DX: out boolean);
    procedure WRITE_MEM(Address: std_logic_vector; Data: std_logic_vector; 
			Mask: std_logic_vector; WPSIZE: integer; 
			variable MEM,ROWS: inout MEM_TYPE; DX: out boolean;RREN,RADD,RCA: in std_logic;CREN: in std_logic_vector;ColAddrWidth,MUX: in integer;Xlsb:in std_logic);
    procedure FILL_MEM(FileName: string; variable MEM: inout MEM_TYPE);
    procedure GET_MASKED_VALUE(Address: std_logic_vector; Data: std_logic_vector; 
			Mask: std_logic_vector; MaskWidth: integer; 
			variable MEM,ROWS: MEM_TYPE; NewData: out std_logic_vector;
			RREN,RADD: in std_logic;CREN: in std_logic_vector;
                        RCA: in std_logic; ColAddrWidth: in integer);
    procedure MEM_CONFLICT(variable MEM: out MEM_TYPE);
    procedure MEM_CONFLICT(variable MEM: out MEM_TYPE;CREN: in std_logic_vector);

    procedure X_OVERLAP_GET_MASKED_VALUE(Address: std_logic_vector; Data,OtherData: std_logic_vector; 
                			Mask_overlap, Mask,OtherMask: std_logic_vector; MaskWidth: integer; 
			variable MEM: MEM_TYPE; NewData: out std_logic_vector);
    procedure X_MASKED_VALUE(Address: std_logic_vector; Data: std_logic_vector; 
			Mask: std_logic_vector; MaskWidth: integer; 
			variable MEM: MEM_TYPE; NewData: out std_logic_vector);
    procedure X_UNMASKED_VALUE(Address: std_logic_vector; Data: std_logic_vector; 
			Mask,OtherMask: std_logic_vector; MaskWidth: integer; 
			variable MEM: MEM_TYPE; NewData: out std_logic_vector);
    function Same_Wr_Mask(Bus1,Bus2: std_logic_vector) return boolean;
    function iMin(L, R: INTEGER) return INTEGER;
end vlibs;

package body vlibs is

    function TO_STD_LOGIC_VECTOR(ARG: STD_LOGIC; SIZE: INTEGER) return STD_LOGIC_VECTOR is
        subtype rtype is STD_LOGIC_VECTOR (SIZE-1 downto 0);
        variable result: rtype;
        -- synopsys built_in SYN_ZERO_EXTEND
        -- synopsys subpgm_id 384
    begin
        -- synopsys synthesis_off
        result := rtype'(others => '0');
        result(0) := ARG;
        if (result(0) = 'X') then
            result := rtype'(others => 'X');
        end if;
        return result;
        -- synopsys synthesis_on
    end;

    function iMin(L, R: INTEGER) return INTEGER is
    begin
	if L < R then
	    return L;
	else
	    return R;
	end if;
    end;

  --------------------------------------------------------------------------
    type tbl_type is array (STD_ULOGIC) of STD_ULOGIC;
    constant tbl_BINARY : tbl_type :=
	('X', 'X', '0', '1', 'X', 'X', '0', '1', 'X');

    type tbl_mvl9_boolean is array (STD_ULOGIC) of boolean;
    constant IS_X : tbl_mvl9_boolean :=
        (true, true, false, false, true, true, false, false, true);



  --------------------------------------------------------------------------
    function MAKE_BINARY(A : STD_ULOGIC) return STD_ULOGIC is
    begin
	    if (IS_X(A)) then
--		assert false 
--		report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
--		severity warning;
	        return ('X');
	    end if;
	    return tbl_BINARY(A);
    end;

  --------------------------------------------------------------------------
    function MAKE_BINARY(A : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	variable one_bit : STD_ULOGIC;
	variable result : STD_LOGIC_VECTOR (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
--		    assert false 
--		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
--		    severity warning;
		    result := (others => 'X');
	            return result;
	        end if;
		result(i) := tbl_BINARY(A(i));
	    end loop;
	    return result;
    end;

  --------------------------------------------------------------------------
    FUNCTION All_X(s: std_logic_vector) RETURN  BOOLEAN IS
    BEGIN
        FOR i IN s'RANGE LOOP
            CASE s(i) IS
                WHEN 'L' | '0' | 'H' | '1' => RETURN FALSE;
                WHEN OTHERS => NULL;
            END CASE;
        END LOOP;
        RETURN TRUE;
    END;
  --------------------------------------------------------------------------
    FUNCTION All_1(s: std_logic_vector) RETURN  BOOLEAN IS
    BEGIN
        FOR i IN s'RANGE LOOP
            CASE s(i) IS
                WHEN 'L' | '0' | 'U' | 'X' => RETURN FALSE;
                WHEN OTHERS => NULL;
            END CASE;
        END LOOP;
        RETURN TRUE;
    END;
  --------------------------------------------------------------------------
    FUNCTION All_0(s: std_logic_vector) RETURN  BOOLEAN IS
    BEGIN
        FOR i IN s'RANGE LOOP
            CASE s(i) IS
                WHEN 'H' | '1' | 'U' | 'X' => RETURN FALSE;
                WHEN OTHERS => NULL;
            END CASE;
        END LOOP;
        RETURN TRUE;
    END;
  --------------------------------------------------------------------------

    FUNCTION Is_1(s: std_ulogic) RETURN  BOOLEAN IS
    BEGIN
            CASE s IS
                WHEN 'L' | '0' | 'U' | 'X' => RETURN FALSE;
                WHEN OTHERS => NULL;
            END CASE;
        RETURN TRUE;
    END;

  --------------------------------------------------------------------------
 function IMAGE(i : Integer) return string is
  variable l : TextIO.line ;
  variable s : string(1 to 80);
  variable r : Natural;
 begin
  TextIO.Write(l, i) ;
  r := l'length;
  TextIO.Read(l,s(1 to r));
  TextIO.Deallocate(l);
  return s(1 to r) ;
 end IMAGE  ;

  --------------------------------------------------------------------------
 function IMAGE(r : Real) return string is
  variable l : TextIO.line ;
  variable s : string(1 to 80);
  variable rr: Natural;
 begin
  TextIO.Write(l, r) ;
  rr:= l'length;
  TextIO.Read(l,s(1 to rr));
  TextIO.Deallocate(l);
  return s(1 to rr) ;
 end IMAGE  ;

  --------------------------------------------------------------------------
 function IMAGE(B : Boolean) return string is
 begin
  Case B is
    When False  => return "FALSE";
    When True   => return "TRUE";
  end Case;
 end IMAGE;

  --------------------------------------------------------------------------
 function IMAGE(t : time) return string Is
  variable l : TextIO.line ;
  variable s : string(1 to 80);
  variable r : Natural;
 begin
  TextIO.Write(l, t, UNIT => ns) ;
  r := l'length;
  TextIO.Read(l,s(1 to r));
  TextIO.Deallocate(l);
  return s(1 to r) ;
 end IMAGE  ;
 
  --------------------------------------------------------------------------
 function IMAGE(B : Std_logic) return string is
 begin
  if    B = 'X' Then return "X";
  elsif B = '0' Then return "0";
  elsif B = '1' Then return "1";
  elsif B = 'Z' Then return "Z";
  elsif B = 'W' Then return "X";
  elsif B = 'L' Then return "0";
  elsif B = 'H' Then return "1";
  elsif B = '-' Then return "X";
  else               return "X";
  end if;
 end IMAGE;

  --------------------------------------------------------------------------
 function IMAGE(B : Std_logic_Vector) return string is
  variable S : string (1 to B'Length);
  variable Index : Natural := 0;
 begin
  for K in B'range Loop
     Index := Index + 1;
     if    B(K) = 'X' Then S(Index) := 'X';
     elsif B(K) = '0' Then S(Index) := '0';
     elsif B(K) = '1' Then S(Index) := '1';
     elsif B(K) = 'Z' Then S(Index) := 'Z';
     elsif B(K) = 'W' Then S(Index) := 'X';
     elsif B(K) = 'L' Then S(Index) := '0';
     elsif B(K) = 'H' Then S(Index) := '1';
     elsif B(K) = '-' Then S(Index) := 'X';
     else                  S(Index) := 'X';
     end if;
  end Loop;
  return S;
 end IMAGE;

  --------------------------------------------------------------------------
 function HIMAGE(B : Std_logic_Vector) return string is
      variable L : TextIO.line;
 begin    
      HWRITE(L,B);
      return L.all;
 end HIMAGE;

  --------------------------------------------------------------------------
 function VALUE(s : string) return Integer is
   variable l : TextIO.line ;
   variable i : Integer ;
   variable ERR : Boolean := FALSE ;
   variable No_Int_Part : Boolean := TRUE ;
 begin
   if S'Length = 0 Then 
     ERR := TRUE;
   else
    for K in S'range Loop
     if ((S(K) = '+') or (S(K) = '-')) Then 
       if (K /= S'Left) Then 
         ERR := TRUE;
       end if;
     elsif ((S(K) > '9') or (S(K) < '0')) Then
       ERR := TRUE;
     else
       No_Int_Part := FALSE;
     end if;
    end Loop;
   end if;
   if ERR or No_Int_Part Then 
     assert false report " Argument badly formed for integer" severity warning;
     return 0;
   end if;
   TextIO.Write(l,string'(s));
   TextIO.Read(l,i) ;
   TextIO.Deallocate(l);
   return i ;
 end VALUE ;

  --------------------------------------------------------------------------
 function VALUE(s : string) return Real is
   variable l : TextIO.line ;
   variable r : Real ;
   variable One_Dot, ERR : Boolean := False;
   variable No_dec_part, No_Int_Part : Boolean := True;
 begin
  if S'Length < 3 Then 
    ERR := TRUE;
  else 
    for K in S'range Loop
       if ((S(K) = '+') or (S(K) = '-')) Then 
         if (K /= S'Left) Then 
           ERR := TRUE;
         end if;
       elsif (S(K) = '.') Then 
         if No_Int_part or One_Dot Then 
           ERR := TRUE;
         else 
           One_Dot := TRUE;
         end if;
       elsif (S(K) >= '0') and (S(K) <= '9') Then
         if One_Dot Then 
           No_Dec_Part := FALSE;
         else 
           No_Int_Part := FALSE;
         end if;
       else
         ERR := TRUE;
       end if;
    end Loop;
  end if;
  if ERR or No_Dec_Part or No_Int_Part Then 
    assert false report " Argument badly formed for real " severity warning;
    return 0.0;
  end if;
  TextIO.Write(l, string'(s));
  TextIO.Read(l, r) ;
  TextIO.Deallocate(l);
  return r ;
 end VALUE  ;

  --------------------------------------------------------------------------
 function VALUE(s : string) return Boolean is
   Constant UP : string(1 to S'Length) := (S);
 begin
  if UP = "TRUE"  Then 
    return True;
  elsif UP = "FALSE" Then
    return False;
  else 
    assert false report " Argument should be FALSE or TRUE " severity warning;
    return False;
  end if;
 end VALUE;

  --------------------------------------------------------------------------
 function VALUE(s : string) return time is
   variable l : TextIO.line ;
   variable t : time ;
   variable ERR, One_Dot, One_Blank : Boolean := False;
   variable No_Int_Part, No_Dec_Part : Boolean := True;
   variable Unit : string(1 to 3) := (Others => ' ');
   Constant S_Low : string(S'range) := (S);
 begin
  if S'Length < 3 Then
    ERR := TRUE;
  else 
    for K in S'range Loop
       if (S(K) = '-') Then 
         if (K /= S'Left) Then 
           ERR := TRUE;
           Exit;
         end if;
       elsif (S(K) = '.') Then 
         if No_Int_part or One_Dot Then 
           ERR := TRUE;
           Exit;
         else 
           One_Dot := TRUE;
         end if;
       elsif (S(K) >= '0') and (S(K) <= '9') Then 
         if One_Dot Then 
           No_Dec_Part := FALSE;
         else 
           No_Int_Part := FALSE;
         end if;
       elsif (S_Low(K) = 'f') or (S_Low(K) = 'p') or (S_Low(K) = 'n') or (S_Low(K) = 'u')
          or (S_Low(K) = 'm') or (S_Low(K) = 's') or (S_Low(K) = 'h') or (S_Low(K) = 'e')
          or (S_Low(K) = 'c') or (S_Low(K) = 'i') or (S_Low(K) = 'n') or (S_Low(K) = 'r')
          or (S_Low(K) = ' ') Then 
         if (No_Int_Part) or (One_Dot and No_Dec_Part) Then 
           ERR := TRUE;
           Exit;
         else 
           if S_Low(K) = ' ' Then 
             if One_Blank = True Then 
               ERR := TRUE;
               Exit;
             else 
               One_Blank := TRUE;
             end if;
           else 
             if Unit(3) /= ' ' Then 
               ERR := TRUE;
               Exit;
             end if;
             for K2 in 1 to 3 Loop
                if Unit(K2) = ' ' Then 
                  Unit(K2) := S_Low(K);
                  Exit;
                end if;
             end Loop;
           end if;
         end if;
       else 
         ERR := TRUE;
         Exit;
       end if;
     end Loop;
     if (Unit /= "fs ") and (Unit /= "ps ") and (Unit /= "ns ") and (Unit /= "us ") and 
        (Unit /= "ms ") and (Unit /= "sec") and (Unit /= "min") and (Unit /= "hr ") Then 
       ERR := TRUE;
     end if;
   end if;
   if ERR Then 
     assert false report " Argument badly formed for time" severity warning;
     return 0 ns;
   end if;
   TextIO.Write(l, string'(s));
   TextIO.Read(l, t) ;
   TextIO.Deallocate(l);
   return t ;
 end VALUE  ;

  --------------------------------------------------------------------------
 function VALUE (S : string) return Std_logic is
   variable L : TextIO.line ;
   variable C : Character ;
 begin
  if (S /= "U") and (S /= "X") and (S /= "0") and (S /= "1") and (S /= "Z") and
     (S /= "W") and (S /= "L") and (S /= "H") and (S /= "-") Then 
    assert false report " Argument badly formed for Std_logic" severity warning;
    return 'X';
  end if;
  TextIO.Write(L, string'(S));
  TextIO.Read(L, C) ;
  TextIO.Deallocate(L);
  if    C = '0' Then return '0';
  elsif C = '1' Then return '1';
  elsif C = 'Z' Then return 'Z';
  elsif C = 'W' Then return 'W';
  elsif C = 'L' Then return 'L';
  elsif C = 'H' Then return 'H';
  elsif C = 'U' Then return 'U';
  elsif C = '-' Then return '-';
  else               return 'X';
  end if;
 end VALUE;

  --------------------------------------------------------------------------
 function VALUE (S : string) return Std_Logic_Vector is
   variable L : TextIO.line ;
   variable STR : string (S'range);
   variable Result : Std_Logic_Vector (S'range);
   Constant All_X : Std_Logic_Vector(S'range) := (Others => 'X');
 begin
  for K in S'range Loop
    if (S(K) /= 'U') and (S(K) /= 'X') and (S(K) /= '0') and (S(K) /= '1') and (S(K) /= 'Z') and 
        (S(K) /= 'W') and (S(K) /= 'L') and (S(K) /= 'H') and (S(K) /= '-') Then 
       assert false report " Argument badly formed for Std_logic_vector" severity warning;
       return All_X;
     end if;
  end loop;
  TextIO.Write(L, string'(S));
  TextIO.Read(L, STR) ;
  TextIO.Deallocate(L);
  for K in STR'range Loop
     if    STR(K) = '0' Then Result(K) := '0';
     elsif STR(K) = '1' Then Result(K) := '1';
     elsif STR(K) = 'Z' Then Result(K) := 'Z';
     elsif STR(K) = 'W' Then Result(K) := 'W';
     elsif STR(K) = 'L' Then Result(K) := 'L';
     elsif STR(K) = 'H' Then Result(K) := 'H';
     elsif STR(K) = 'U' Then Result(K) := 'U';
     elsif STR(K) = '-' Then Result(K) := '-';
     else                    Result(K) := 'X';
     end if;
  end Loop;
  return Result;
 end VALUE;

  --------------------------------------------------------------------------
 procedure PRINT (T : time; S : string) is
  variable tempo : textIO.line;
 begin
  TextIO.write(tempo, T);
  TextIO.write(tempo, string'(" "));
  TextIO.write(tempo, S);
  TextIO.writeline(TextIO.output, tempo);
 end PRINT;

  --------------------------------------------------------------------------
 procedure PRINT (S : string) is
  variable tempo : TextIO.line;
 begin 
  TextIO.write(tempo, S);
  TextIO.writeline(TextIO.output, tempo); 
 end PRINT;

  --------------------------------------------------------------------------
  function TO_CHAR(val: std_logic) return CHARACTER IS
    variable RES: character;
    begin
      case(val) is
         when std_logic'( '1' ) => RES:= '1';
         when std_logic'( '0' ) => RES:= '0';
         when std_logic'( 'H' ) => RES:= '1';
         when std_logic'( 'L' ) => RES:= '0';
         when std_logic'( 'U' ) => RES:= 'x';
         when std_logic'( 'Z' ) => RES:= 'z';
         when std_logic'( '-' ) => RES:= '0';
         when others => RES:= 'x';
      end case;
      return res;
    end;

  --------------------------------------------------------------------------
  procedure WRITE(l: inout line; val: in std_logic;
                   	justify: in side:= right; field: in width:= 0) IS
    variable ins: character;
    begin
      ins:= TO_CHAR(val);
      WRITE(L, ins, justify, field);
    end;

  --------------------------------------------------------------------------
  procedure WRITE(l: inout line; val: in std_logic_vector;
                   	justify: in side:= right; field: in width:= 0) IS
    variable ins: CHARACTER;
    begin
      for i in val'range loop
        ins:= TO_CHAR(val(i));
        WRITE(L, ins, justify, field);
      end loop;
    end;

  --------------------------------------------------------------------------
  procedure COMPARE_BIT(val: in std_logic; exp: in std_logic) IS
    variable str1: string (1 to 15):= "Mismatch, time:";
    variable str2: string (1 to 11):= " simulated:";
    variable str3: string (1 to 10):= " expected:";
    variable str4: string (1 to 8):= "Done at ";
    file flush: text is out "STD_OUTPUT";
    variable l2: line;
    begin
      if val /= exp then
	write (l2, str1);
	write (l2, now, right, 12);
	write (l2, str2);
	write (l2, val);
	write (l2, str3);
	write (l2, exp);
	writeline (flush, l2);
      end if;
    end;

  --------------------------------------------------------------------------
  procedure COMPARE_BIT(val: in std_logic; exp: in std_logic; variable err_cnt: inout integer) IS
    variable str1: string (1 to 15):= "Mismatch, time:";
    variable str2: string (1 to 11):= " simulated:";
    variable str3: string (1 to 10):= " expected:";
    variable str4: string (1 to 8):= "Done at ";
    file flush: text is out "STD_OUTPUT";
    variable l2: line;
    begin
      if val /= exp then
        err_cnt := err_cnt + 1;
	write (l2, str1);
	write (l2, now, right, 12);
	write (l2, str2);
	write (l2, val);
	write (l2, str3);
	write (l2, exp);
	writeline (flush, l2);
      end if;
    end;

  --------------------------------------------------------------------------
  procedure CHECK_OUTPUT_X(val: in std_logic) IS
    variable str1: string (1 to 15):= "Mismatch, time:";
    variable str2: string (1 to 11):= " simulated:";
    variable str3: string (1 to 12):= " expected: x";
    file flush: text is out "STD_OUTPUT";
    variable l2: line;
    begin
      if (val /= 'X') then
        write (l2, str1);
        write (l2, now, right, 12);
        write (l2, str2);
        write (l2, val);
        write (l2, str3);
        writeline (flush, l2);
      end if;
    end;

  --------------------------------------------------------------------------
  procedure CHECK_OUTPUT_HIGH(val: in std_logic) IS
    variable str1: string (1 to 15):= "Mismatch, time:";
    variable str2: string (1 to 11):= " simulated:";
    variable str3: string (1 to 12):= " expected: 1";
    file flush: text is out "STD_OUTPUT";
    variable l2: line;
    begin
      if (val /= '1') then
        write (l2, str1);
        write (l2, now, right, 12);
        write (l2, str2);
        write (l2, val);
        write (l2, str3);
        writeline (flush, l2);
      end if;
    end;

  --------------------------------------------------------------------------
  procedure CHECK_OUTPUT_LOW(val: in std_logic) IS
    variable str1: string (1 to 15):= "Mismatch, time:";
    variable str2: string (1 to 11):= " simulated:";
    variable str3: string (1 to 12):= " expected: 0";
    file flush: text is out "STD_OUTPUT";
    variable l2: line;
    begin
      if (val /= '0') then
        write (l2, str1);
        write (l2, now, right, 12);
        write (l2, str2);
        write (l2, val);
        write (l2, str3);
        writeline (flush, l2);
      end if;
    end;

  --------------------------------------------------------------------------
  procedure WRITE_DONE(now_time: in time) IS
    file flush: text is out "STD_OUTPUT";
    variable l: line;
    variable str: string (1 to 8):= "Done at ";
    begin
      write (l, str);
      write (l, now_time);
      writeline (flush, l);
    end;

  --------------------------------------------------------------------------
  function TO_STD_LOGIC(ch: CHARACTER) return std_logic IS
    variable RES: std_logic;
    begin
      case ch IS
        when CHARACTER'( '1' ) => RES:= '1';
        when CHARACTER'( '0' ) => RES:= '0';
        when CHARACTER'( 'U' ) => RES:= 'U';
        when CHARACTER'( 'z' ) => RES:= 'Z';
        when OTHERS => RES:= 'X';
      end case;
      return RES;
    end;

  --------------------------------------------------------------------------
  procedure READ (l: inout line; variable value: out std_logic) IS
    variable in_ch: character;
    begin
      READ(l, in_ch);
      value:=TO_STD_LOGIC(in_ch);
    end;

  --------------------------------------------------------------------------
  procedure READ (l: inout line; variable value: out std_logic_vector) IS
    variable in_ch: character;
    begin
      for i in value'range loop
        READ(l, in_ch);
        value(i):=TO_STD_LOGIC(in_ch);
      end loop;
    end;
  --------------------------------------------------------------------------
  procedure COMPARE (l: inout line; data: in std_logic; str: in string) IS
    variable expected: std_logic;
    variable in_ch: character;
    begin
      READ(l, in_ch);
      expected:=TO_STD_LOGIC(in_ch);
      if(to_x01z(data)/=to_x01z(expected)) then
	PRINT(NOW, "Mismatch: Signal="&str&" Simulated="&IMAGE(data)&" - Expected="&IMAGE(expected)&"");
      end if;
    end;

  --------------------------------------------------------------------------
  procedure COMPARE (l: inout line; data: in std_logic_vector; str: in string) IS
    variable expected:std_logic_vector(data'range);
    variable in_ch: character;
    begin
      for i in expected'range loop
        READ(l, in_ch);
        expected(i):=TO_STD_LOGIC(in_ch);
      end loop;
      if(to_x01z(data)/=to_x01z(expected)) then
	PRINT(NOW, "Mismatch: Signal="&str&" Simulated="&IMAGE(data)&" - Expected="&IMAGE(expected)&"");
      end if;
    end;

  --------------------------------------------------------------------------
  function CONV_UNSIGNED_INTEGER(S: std_logic) return integer is
     variable result: integer:= 0;
     begin
        if (S = '1') then
           result := 1;
        elsif (S='X' or  S='U') then
 	   return -1;
        end if;
        return result;
   end CONV_UNSIGNED_INTEGER;

  --------------------------------------------------------------------------
  function CONV_UNSIGNED_INTEGER(S: std_logic_vector) return integer is
     variable result: integer:= 0;
     begin
       for i in 0 to S'length-1 loop
         if S(i)='1' then
           result:= result+2**i;
         elsif (S(i)='X' or  S(i)='U') then
 	   return -1;
         end if;
       end loop;
       return result;
   end CONV_UNSIGNED_INTEGER;

  --------------------------------------------------------------------------
    procedure READ_MEM (Address: std_logic_vector; Data: out std_logic_vector; 
			variable MEM: in MEM_TYPE) is
    variable AddrInt: integer:= -1;
    variable bit: std_logic;
    begin     
      AddrInt:= CONV_UNSIGNED_INTEGER(Address);
      if (AddrInt = -1 or AddrInt>=MEM'length(1) ) then
        --if(LastTime/=NOW) then
	--  assert false report "Invalid Address, Reading X's" severity WARNING ;
        --end if;
        for j in Data'range LOOP
          Data(j):='X';
        end loop;
      else
        for j in Data'range LOOP
          bit:= MEM(AddrInt, j);
          if (bit='U') then Data(j):= 'X';
          else		    Data(j):= bit;
          end if;
        end loop;
      end if;
    end READ_MEM ;

  --------------------------------------------------------------------------
    procedure READ_MEM (Address: std_logic_vector; Data: out std_logic_vector; 
			variable MEM,ROWS: inout MEM_TYPE;RREN,RADD,RCA: in std_logic;CREN: in std_logic_vector;ColAddrWidth: in integer;write_mask: in boolean;Xlsb: in std_logic) is
    variable AddrInt: integer:= -1;
    variable bit: std_logic;
    variable XCREN:boolean:= false;
    begin
      AddrInt:= CONV_UNSIGNED_INTEGER(Address);
      if (RREN='0') or (RREN='X') then -- the redundant rows are being addressed
         if ColAddrWidth > 0 then
            if RADD = '1' then AddrInt := CONV_UNSIGNED_INTEGER(Address(ColAddrWidth-1 downto 0)) + 2**ColAddrWidth;
            else               AddrInt := CONV_UNSIGNED_INTEGER(Address(ColAddrWidth-1 downto 0));
            end if;
            for j in 0 to ColAddrWidth-1 loop
               if address(j)='X' then AddrInt:=-1; end if;
            end loop;
         else
            if RADD = '1' then AddrInt := 1;
            else               AddrInt := 0;
            end if;
         end if;
      end if;
      for j in CREN'range loop
        if Is_X(CREN(j)) then XCREN := true; end if;
      end loop;
      if (AddrInt = -1 or AddrInt>=MEM'length(1) or Is_X(RREN) or (RREN='0' and Is_X(RADD)) or XCREN) then
        for j in Data'range LOOP
          Data(j):='X';
        end loop;
        if (RREN='0' and Is_X(RADD) and CREN(0)='0') or (Is_X(RREN) and CREN(0)='0') or ((AddrInt = -1) and CREN(0)='0') then 
           if RREN/='0' then
              for i in 0 to MEM'length(1)-1 LOOP
                  MEM(i,0) := 'X'; 
              end loop;
           end if;
           if RREN='0' then
              if RADD='1' then
                 for i in 2**ColAddrWidth to ROWS'length(1)-1 LOOP
                     ROWS(i,0) := 'X'; 
                 end loop;
              elsif RADD='0' then
                 for i in 0 to 2**ColAddrWidth-1 LOOP
                     ROWS(i,0) := 'X'; 
                 end loop;
              else
                 for i in 0 to ROWS'length(1)-1 LOOP
                     ROWS(i,0) := 'X'; 
                 end loop;
              end if;
           elsif RREN='X' then
              for i in 0 to ROWS'length(1)-1 LOOP
                  ROWS(i,0) := 'X'; 
              end loop;
           end if;
        end if;
        if XCREN then 
           if RREN='0' then    ROWS(AddrInt,0) := 'X'; 
           elsif RREN='1' then MEM(AddrInt,0) := 'X'; 
           else                MEM(CONV_UNSIGNED_INTEGER(Address),0) := 'X'; 
                               ROWS(AddrInt,0) := 'X'; 
           end if;
        end if;
      else
        if (RREN='0') then -- the redundant rows are being addressed
               for j in Data'range LOOP
                  if j=Data'high  and  CREN(j)='0' then
                     if RCA='0' then    bit := ROWS(AddrInt,j+1); 
                     elsif RCA='1' then bit := ROWS(AddrInt,j+2); 
                     else               bit := 'X'; 
                     end if;
                  elsif CREN(j)='0' then 
                     bit := ROWS(AddrInt,j+1);     
                     if j=0 and write_mask and Xlsb='X' then
                        ROWS(AddrInt,0) := 'X'; 
                     elsif j=0 and write_mask then
                        ROWS(AddrInt,0) := '0'; 
                     end if;
                  else        
                      bit := ROWS(AddrInt,j);     
                  end if;
                  if (bit='U') then Data(j):= 'X';
                  else	       Data(j):= bit;
                  end if;
               end loop;
        elsif (RREN='1') then
               for j in Data'range LOOP
                  if j=Data'high  and  CREN(j)='0' then
                     if RCA='0' then    bit := MEM(AddrInt,j+1); 
                     elsif RCA='1' then bit := MEM(AddrInt,j+2); 
                     else               bit := 'X'; 
                     end if;
                  elsif CREN(j)='0' then 
                      bit:= MEM(AddrInt, j+1); 
                     if j=0 and write_mask and Xlsb='X' then
                        MEM(AddrInt,0) := 'X'; 
                     elsif j=0 and write_mask then
                        MEM(AddrInt,0) := '0'; 
                     end if;
                  else    
                      bit:= MEM(AddrInt, j);
                  end if;
                  if (bit='U') then Data(j):= 'X';
                  else		    Data(j):= bit;
                  end if;
               end loop;
        end if;
      end if;
    end READ_MEM ;

  --------------------------------------------------------------------------
    procedure WRITE_MEM(Address: std_logic_vector; Data: std_logic_vector; 
			variable MEM: inout MEM_TYPE; DX: out boolean) is
    variable AddrTmp: integer:= -1;
    variable AddrStd: std_logic_vector(Address'range):= (others=>'1');
    variable bitx: boolean:=True;
    begin
      DX:=False;
      AddrTmp:= CONV_UNSIGNED_INTEGER(Address);
      if (AddrTmp<MEM'length(1)) then
         if (AddrTmp = -1) then
            MEM_CONFLICT(MEM);
         else
           for j in Data'range LOOP    
             MEM(AddrTmp, j):= Data(j);
             if(Data(j)/='X') then bitx:=False; end if;
           end loop;
           if(bitx) then
             DX:=True;
	     --assert false report "Invalid Data, Writing X's at Address "&IMAGE(AddrTmp)&""
             --		 severity WARNING ;
           end if;
         end if;
      end if;
    end WRITE_MEM ;
  --------------------------------------------------------------------------
    procedure WRITE_MEM(Address: std_logic_vector; Data: std_logic_vector; 
			Mask: std_logic_vector; WPSIZE: integer; 
			variable MEM,ROWS: inout MEM_TYPE; DX: out boolean;
                        RREN,RADD,RCA: in std_logic;CREN: in std_logic_vector;ColAddrWidth,MUX: in integer;
                        Xlsb: in std_logic) is
    variable AddrTmp1,AddrTmp,AddrInt,AddrInt1: integer:= -1;
    variable AddrStd: std_logic_vector(Address'range):= (others=>'1');
    variable bitx: boolean:=True;
    variable bit: std_logic;
    variable XCREN:boolean:= false;
    begin
      for j in CREN'range loop
        if Is_X(CREN(j)) then XCREN := true; end if;
      end loop;
      DX:=False;
      AddrInt:= CONV_UNSIGNED_INTEGER(Address);
      if ColAddrWidth > 0 and RREN='0' then
         if RADD = '1' then AddrInt := CONV_UNSIGNED_INTEGER(Address(ColAddrWidth-1 downto 0)) + 2**ColAddrWidth;
         else               AddrInt := CONV_UNSIGNED_INTEGER(Address(ColAddrWidth-1 downto 0));
         end if;
         for j in 0 to ColAddrWidth-1 loop
            if address(j)='X' then AddrInt:=-1; end if;
         end loop;
      elsif RREN='0' then
         if RADD = '1' then AddrInt := 1;
         else               AddrInt := 0;
         end if;
      end if;

      if (AddrInt<MEM'length(1)) then
         if (AddrInt = -1) and (RREN='1') then
            MEM_CONFLICT(MEM,CREN);
         elsif (AddrInt = -1) and (RREN='0') then
            if RADD='0' then
               for i in 0 to MUX-1 LOOP
                  for j in 0 to ROWS'length(2)-1 LOOP
                     ROWS(i,j):='X';
                  end loop;
              end loop;
            elsif RADD='1' then
               for i in 0 to MUX-1 LOOP
                  for j in 0 to ROWS'length(2)-1 LOOP
                     ROWS(MUX+i,j):='X';
                  end loop;
               end loop;
            else
               MEM_CONFLICT(ROWS,CREN);
            end if;
         elsif Is_X(RREN) then
            MEM_CONFLICT(MEM,CREN);
            MEM_CONFLICT(ROWS,CREN);
         elsif (RREN='0' and RADD='X') then
            MEM_CONFLICT(ROWS,CREN);
         else -- no X in control signals
            if (RREN='0') then
               for j in Data'range LOOP    
                  if j=Data'High and CREN(j)='0' and not(XCREN) then 
                     if RCA='0' then    ROWS(AddrInt, j+1):= Data(j); 
                     elsif RCA='1' then ROWS(AddrInt, j+2):= Data(j);
                     elsif mask(mask'high)='1' then ROWS(AddrInt, j+2):= 'X';ROWS(AddrInt, j+1):= 'X';
                     end  if;
                     if MUX>1 then
                        AddrTmp1 :=  AddrInt/MUX;
                        for n in 0 to MUX-1 LOOP
                           if RCA='0' then    ROWS((AddrTmp1*MUX + n), j+1):=  Data(j);
                           elsif RCA='1' then ROWS((AddrTmp1*MUX + n), j+2):=  Data(j);  
                           elsif mask(mask'high)='1' then ROWS((AddrTmp1*MUX + n), j+2):= 'X';ROWS((AddrTmp1*MUX + n), j+1):= 'X';
                           end  if;
                        end loop;                      
                     end if;
                  elsif j=Data'High and XCREN and mask(mask'high)='1' then 
                     if RCA='0' then    ROWS(AddrInt, j+1):= 'X'; ROWS(AddrInt, j):= 'X';
                     elsif RCA='1' then ROWS(AddrInt, j+2):= 'X'; ROWS(AddrInt, j):= 'X';
                     else               ROWS(AddrInt, j+2):= 'X';ROWS(AddrInt, j+1):= 'X'; ROWS(AddrInt, j):= 'X';
                     end  if;
                     if MUX>1 then
                        AddrTmp1 :=  AddrInt/MUX;
                        for n in 0 to MUX-1 LOOP
                           if RCA='0' then    ROWS((AddrTmp1*MUX + n), j+1):=  'X';
                           elsif RCA='1' then ROWS((AddrTmp1*MUX + n), j+2):=  'X';  
                           else               ROWS((AddrTmp1*MUX + n), j+2):= 'X';ROWS((AddrTmp1*MUX + n), j+1):= 'X';
                           end  if;
                        end loop;                      
                     end if;
                  elsif CREN(j)='0' or XCREN then 
                     if XCREN then
                         if mask(j/WPSIZE)='1' then
                            ROWS(AddrInt, j):= 'X';
                            ROWS(AddrInt, j+1):= 'X';
                         elsif j=0 and mask'high>0 then
                           ROWS(AddrInt, 0):= 'X';
                         end if;
                     else
                        ROWS(AddrInt, j+1):= Data(j);
                        if j=0 and Xlsb='X' and mask'high>0 then
                           ROWS(AddrInt, j):= 'X';
                        elsif j=0  and mask'high>0 then
                           ROWS(AddrInt, j):= '0';
                        end if;
                     end if;
                  else 
                     ROWS(AddrInt, j):= Data(j);
                     if j/=Data'High then
                        if (CREN(j+1)='0')and (mask(j/WPSIZE)='1') then
                           -- Overwrite only if the write_mask bit is active
                           ROWS(AddrInt, j+1):= Data(j);
                        elsif (CREN(j+1)='0')and (mask(j/WPSIZE)='X') then
                           ROWS(AddrInt, j+1):= 'X';
                        end if;
                     end if;
                  end if;
                  if(Data(j)/='X') then bitx:=False; end if;
               end loop;
               if(bitx) then
               DX:=True;
	       --assert false report "Invalid Data, Writing X's at Redundant Row Address "&IMAGE(AddrInt)&"" severity WARNING ;
               end if;
            else -- RREN is 1
              for j in Data'range LOOP    
                 if j=Data'High and CREN(j)='0' and not(XCREN) then 
                    if RCA='0' then    MEM(AddrInt, j+1):= Data(j);
                    elsif RCA='1' then MEM(AddrInt, j+2):= Data(j);
                    elsif mask(mask'high)='1' then MEM(AddrInt, j+2):= 'X';MEM(AddrInt, j+1):= 'X';
                    end  if;
                    if MUX>1 then
                       AddrTmp1 :=  AddrInt/MUX;
                       for n in 0 to MUX-1 LOOP
                          if RCA='0' then    MEM((AddrTmp1*MUX + n), j+1):= Data(j);
                          elsif RCA='1' then MEM((AddrTmp1*MUX + n), j+2):= Data(j);
                          elsif mask(mask'high)='1' then MEM((AddrTmp1*MUX + n), j+2):= 'X';MEM((AddrTmp1*MUX + n), j+1):= 'X';
                          end if;
                       end loop;                      
                    end if;
                 elsif j=Data'High and XCREN and mask(mask'high)='1' then 
                     if RCA='0' then    MEM(AddrInt, j+1):= 'X'; MEM(AddrInt, j):= 'X';
                     elsif RCA='1' then MEM(AddrInt, j+2):= 'X'; MEM(AddrInt, j):= 'X';
                     else               MEM(AddrInt, j+2):= 'X';MEM(AddrInt, j+1):= 'X'; MEM(AddrInt, j):= 'X';
                     end  if;
                     if MUX>1 then
                        AddrTmp1 :=  AddrInt/MUX;
                        for n in 0 to MUX-1 LOOP
                           if RCA='0' then    MEM((AddrTmp1*MUX + n), j+1):=  'X';
                           elsif RCA='1' then MEM((AddrTmp1*MUX + n), j+2):=  'X';  
                           else               MEM((AddrTmp1*MUX + n), j+2):= 'X';MEM((AddrTmp1*MUX + n), j+1):= 'X';
                           end  if;
                        end loop;                      
                     end  if;
                 elsif CREN(j)='0' or XCREN then 
                    if XCREN then
                        if mask(j/WPSIZE)='1' then
                           MEM(AddrInt, j):= 'X';
                           MEM(AddrInt, j+1):= 'X';
                        elsif j=0 and mask'high>0 then
                          MEM(AddrInt, 0):= 'X';
                        end if;
                    else
                       MEM(AddrInt, j+1):= Data(j);
                       if j=0 and Xlsb='X' and mask'high>0 then 
                          MEM(AddrInt, j):= 'X';
                       elsif j=0 and mask'high>0  then
                          MEM(AddrInt, j):= '0';
                       end if;
                    end if;
                else 
                    MEM(AddrInt, j):= Data(j);
                    if j/=Data'High then
                       if (CREN(j+1)='0')and (mask(j/WPSIZE)='1') then
                          MEM(AddrInt, j+1):= Data(j);
                       elsif (CREN(j+1)='0')and (mask(j/WPSIZE)='X') then
                          MEM(AddrInt, j+1):= 'X';
                       end if;
                    end if;
                 end if;
                 if(Data(j)/='X') then bitx:=False; end if;
              end loop;
            end if;
            if(bitx) then
               DX:=True;
	       --assert false report "Invalid Data, Writing X's at Address "&IMAGE(AddrInt)&"" severity WARNING ;
             end if;
         end if;
      end if;
    end WRITE_MEM ;
  --------------------------------------------------------------------------
    procedure WRITE_MEM(Address: std_logic_vector; Data: std_logic_vector; 
			variable MEM: inout MEM_TYPE) is
    variable Dx: boolean:=False;
    begin
      WRITE_MEM(Address, Data, MEM, Dx);
    end WRITE_MEM ;

  --------------------------------------------------------------------------
    procedure FILL_MEM(FileName: string; variable MEM: inout MEM_TYPE) is
    variable Dx: boolean:=False;
    file fdr: text is in FileName;
    variable l: textIO.line;
    variable Add: integer:=0;
    variable Data: std_logic_vector(MEM'length(2)-3 downto 0);
    variable in_ch: character;
    begin
        while not(endfile(fdr)) loop
          READLINE(fdr, l);
          for i in MEM'length(2)-3 downto 0 loop
            READ(l, in_ch);
	    Data(i):=TO_STD_LOGIC(in_ch);
    	  end loop;
          WRITE_MEM(conv_std_logic_vector(Add,MEM'Length(1)), Data, MEM);
          Add:=Add+1;
        end loop;
    end FILL_MEM;

  --------------------------------------------------------------------------
    procedure GET_MASKED_VALUE(Address: std_logic_vector; Data: std_logic_vector; 
			Mask: std_logic_vector; MaskWidth: integer; 
			variable MEM,ROWS: MEM_TYPE; NewData: out std_logic_vector;
                        RREN,RADD: in std_logic;CREN: in std_logic_vector;
                        RCA: in std_logic; ColAddrWidth: in integer) is
    variable AddrTmp, Msb, Lsb, i, m: integer:= -1;
    variable xcren: boolean := false;
    begin
      if RREN='1' then
         AddrTmp:= CONV_UNSIGNED_INTEGER(Address);
         for j in address'range loop
            if address(j)='X' then AddrTmp:=-1; end if;
         end loop;
      elsif RREN='0' then
         if ColAddrWidth > 0 then   
            if RADD = '1' then    AddrTmp := CONV_UNSIGNED_INTEGER(Address(ColAddrWidth-1 downto 0)) + 2**ColAddrWidth;
            elsif RADD = '0' then AddrTmp := CONV_UNSIGNED_INTEGER(Address(ColAddrWidth-1 downto 0));
            else                  AddrTmp := -1;
            end if;
         else
            if RADD = '1' then  AddrTmp := 1;
            elsif RADD='0' then AddrTmp := 0;
            else                  AddrTmp := -1;
            end if;
         end if;
         for j in 0 to ColAddrWidth-1 loop
            if address(j)='X' then AddrTmp:=-1; end if;
         end loop;
      else
         AddrTmp := -1;
      end if;
      NewData:=Data;
      for i in Data'range loop
          if CREN(i)='X' then xcren:= true; end if;
      end loop;
      if (AddrTmp<MEM'length(1) and AddrTmp>-1) then
        for i in Mask'range LOOP
          Lsb:=i*MaskWidth; Msb:=iMin(Lsb+MaskWidth-1, Data'length-1);
          for m in Msb downto Lsb LOOP
            if(Mask(i)='0')  then 
               if RREN='1' then
                  if m=Data'High and CREN(m)='0' then  
                     if RCA='1' then    NewData(m):=MEM(AddrTmp,m+2);
                     elsif RCA='0' then NewData(m):=MEM(AddrTmp,m+1);
                     else NewData(m):='X';
                     end if;
                  else
                     if CREN(m)='0' then NewData(m):=MEM(AddrTmp,m+1);
                     elsif CREN(m)='1' then NewData(m):=MEM(AddrTmp,m);
                     else NewData(m):='X';
                     end if;
                  end if;
               else -- RREN is 0
                  if m=Data'High and CREN(m)='0' then  
                     if RCA='1' then    NewData(m):=ROWS(AddrTmp,m+2);
                     elsif RCA='0' then NewData(m):=ROWS(AddrTmp,m+1);
                     else NewData(m):='X';
                     end if;
                  else
                     if CREN(m)='0' then NewData(m):=ROWS(AddrTmp,m+1);
                     elsif CREN(m)='1' then NewData(m):=ROWS(AddrTmp,m);
                     else NewData(m):='X';
                     end if;
                  end if;
               end if;
            elsif(Mask(i)='1' and xcren) or (Mask(i)/='1')  then 
                 NewData(m):='X';
            end if;
          end loop;
        end loop;
      elsif  Is_X(Address(0)) or AddrTmp=-1 then
        for i in Mask'range LOOP
          Lsb:=i*MaskWidth; Msb:=iMin(Lsb+MaskWidth-1, Data'length-1);
          for m in Msb downto Lsb LOOP
            if(Mask(i)/='1')  then 
              NewData(m):='X';
            end if;
          end loop;
        end loop;
      end if;
    end GET_MASKED_VALUE ;

  --------------------------------------------------------------------------
    procedure MEM_CONFLICT(variable MEM: out MEM_TYPE) is
   begin
       if(LastTime/=NOW) then
	 --assert false report "Invalid Address: Setting memory cells to X's from [0:"&IMAGE(MEM'length(1)-1)&"]"
	 --	 severity WARNING ;
       end if;
       for i in 0 to MEM'length(1)-1 LOOP
         for j in 0 to MEM'length(2)-1 LOOP
           MEM(i,j):= 'X';
         end loop;
       end loop;
    end MEM_CONFLICT;
  --------------------------------------------------------------------------
    procedure MEM_CONFLICT(variable MEM: out MEM_TYPE;CREN:in std_logic_vector) is
   begin
       if(LastTime/=NOW) then
	 --assert false report "Invalid Address: Setting memory cells to X's from [0:"&IMAGE(MEM'length(1)-1)&"]"
	 --	 severity WARNING ;
       end if;
       for i in 0 to MEM'length(1)-1 LOOP
         for j in 0 to MEM'length(2)-1 LOOP
           MEM(i,j):= 'X';
         end loop;
         --if CREN(0)='0' then
         --  MEM(i,0):= '0';
         --end  if;
       end loop;
    end MEM_CONFLICT;
  --------------------------------------------------------------------------
    procedure X_UNMASKED_VALUE(Address: std_logic_vector; Data: std_logic_vector; 
			Mask,OtherMask: std_logic_vector; MaskWidth: integer; 
			variable MEM: MEM_TYPE; NewData: out std_logic_vector) is
    variable AddrTmp, Msb, Lsb, i, m: integer:= -1;
    begin
      AddrTmp:= CONV_UNSIGNED_INTEGER(Address);
        for i in Mask'range LOOP
          Lsb:=i*MaskWidth; Msb:=iMin(Lsb+MaskWidth-1, Data'length-1);
          for m in Msb downto Lsb LOOP
            if(Mask(i)='1') then 
              NewData(m):=Data(m);
            elsif ((Mask(i)='0') and (OtherMask(i)='0')) then
                    NewData(m):=MEM(AddrTmp,m);
            elsif ((Mask(i)='0') and (OtherMask(i)='1')) then
              NewData(m):='X';
            else  
              NewData(m):='X';
            end if;
          end loop;
        end loop;
    end X_UNMASKED_VALUE ;

  --------------------------------------------------------------------------
    procedure X_MASKED_VALUE(Address: std_logic_vector; Data: std_logic_vector; 
			Mask: std_logic_vector; MaskWidth: integer; 
			variable MEM: MEM_TYPE; NewData: out std_logic_vector) is
    variable AddrTmp, Msb, Lsb, i, m: integer:= -1;
    begin
      AddrTmp:= CONV_UNSIGNED_INTEGER(Address);
      if (AddrTmp<MEM'length(1) and AddrTmp>-1) then
        for i in Mask'range LOOP
          Lsb:=i*MaskWidth; Msb:=iMin(Lsb+MaskWidth-1, Data'length-1);
          for m in Msb downto Lsb LOOP
            if(Mask(i)='0') then 
              NewData(m):=MEM(AddrTmp,m);
            else
              NewData(m):='X';
            end if;
          end loop;
        end loop;
      end if;
    end X_MASKED_VALUE ;
  --------------------------------------------------------------------------
    procedure X_OVERLAP_GET_MASKED_VALUE(Address: std_logic_vector; Data,OtherData: std_logic_vector; 
			Mask_overlap, Mask,OtherMask: std_logic_vector; MaskWidth: integer; 
			variable MEM: MEM_TYPE; NewData: out std_logic_vector) is
    variable AddrTmp, Msb, Lsb, i, m: integer:= -1;
    begin
      AddrTmp:= CONV_UNSIGNED_INTEGER(Address);
      if (AddrTmp<MEM'length(1) and AddrTmp>-1) then
        -- Retrive Data from memory that does not have write
        for i in Mask'range LOOP
          Lsb:=i*MaskWidth; Msb:=iMin(Lsb+MaskWidth-1, Data'length-1);
          for m in Msb downto Lsb LOOP
            if(Mask(i)='0') then 
              if (OtherMask(i)='0') then
                  NewData(m):=MEM(AddrTmp,m);
              elsif (OtherMask(i)='1') then
                  NewData(m):=OtherData(m);
              end if;
            elsif (Mask(i)='1') then
              NewData(m):=Data(m);
            else
              NewData(m):='X';
            end if;
          end loop;
        end loop;
        -- X'out bits where write masks overlap
        for i in Mask'range LOOP
          Lsb:=i*MaskWidth; Msb:=iMin(Lsb+MaskWidth-1, Data'length-1);
          for m in Msb downto Lsb LOOP
            if(Mask_overlap(i)='1') then 
              NewData(m):='X';
            end if;
          end loop;
        end loop;
      end if;
    end X_OVERLAP_GET_MASKED_VALUE ;

  -------------------------------------------------------------------    
    function is_same  ( l,r : std_logic_vector ) return boolean is
        alias lv : std_logic_vector ( 1 to l'length ) is l;
        alias rv : std_logic_vector ( 1 to r'length ) is r;
    begin
        if ( l'length /= r'length ) then
            assert false
            report "arguments of overloaded 'is_same' operator are not of the same length"
            severity failure;
            return false;
	else
            for i in l'range loop
	        if (l(i) /= r(i)) then return False; end if;
            end loop;
            return True;
	end if;
    end is_same;

  -------------------------------------------------------------------    
    function is_samex  ( l,r : std_logic ) return boolean is
        alias lv : std_logic is l;
        alias rv : std_logic is r;
    begin
       if ((l = 'X') or (r = 'X') or (l = r)) then
          return True;
       else
          return False;
       end if;
    end is_samex;

  -------------------------------------------------------------------    
    function is_samex  ( l,r : std_logic_vector ) return boolean is
        alias lv : std_logic_vector ( 1 to l'length ) is l;
        alias rv : std_logic_vector ( 1 to r'length ) is r;
    begin
        if ( l'length /= r'length ) then
            assert false
            report "arguments of overloaded 'is_samex' operator are not of the same length"
            severity failure;
            return false;
	else
            for i in l'range loop
	        if ((l(i) = 'X') or (r(i) = 'X') or (l(i) = r(i))) then
		   null;
		else
                   return False;
		end if;
            end loop;
            return True;
	end if;
    end is_samex;

  -------------------------------------------------------------------    
    function is_samex  ( l,r : std_logic_vector; high,low : integer ) return boolean is
        alias lv : std_logic_vector ( 1 to l'length ) is l;
        alias rv : std_logic_vector ( 1 to r'length ) is r;
    begin
        if ( l'length /= r'length ) then
            assert false
            report "arguments of overloaded 'is_samex' operator are not of the same length"
            severity failure;
            return false;
	else
            for i in high downto low loop
	        if ((l(i) = 'X') or (r(i) = 'X') or (l(i) = r(i))) then
		   null;
		else
                   return False;
		end if;
            end loop;
            return True;
	end if;
    end is_samex;

  -------------------------------------------------------------------    
    function is_differentx  ( l,r : std_logic_vector ) return boolean is
        alias lv : std_logic_vector ( 1 to l'length ) is l;
        alias rv : std_logic_vector ( 1 to r'length ) is r;
    begin
        if ( l'length /= r'length ) then
            assert false
            report "arguments of overloaded 'is_differentx' operator are not of the same length"
            severity failure;
            return false;
	else
            for i in l'range loop
	        if ((l(i) = 'X') or (r(i) = 'X') or (l(i) /= r(i))) then
		   return True;
		else
                   null;
		end if;
            end loop;
            return False;
	end if;
    end is_differentx;

  --------------------------------------------------------------------------

  function Same_Wr_Mask(Bus1,Bus2: std_logic_vector)return boolean is
      variable i : integer;
      variable match: boolean;
  begin 
      match := false;
      for i in Bus1'range LOOP
          if (Bus1(i) = '1') and (Bus2(i) = '1') then
              match := true;
          end if;
      end loop;
      return match;
  end;    

  end vlibs;
  
----------------------------------------------------------------------
--    End Vhdl Utilities Package 
----------------------------------------------------------------------

