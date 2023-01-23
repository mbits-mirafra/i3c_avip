library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    
package psl_vunit_pkg is
 
   -- Enumerated type declaration for FPU operands
      -- Will be used to make PSL properties more readable
  type fop_type_t IS (ADDt, SUBt, MULt, DIVt, SQRTt);

  constant ADDi : integer :=  fop_type_t'pos(ADDt);  -- ADDi has the value of 0
  constant SUBi : integer :=  fop_type_t'pos(SUBt);  -- SUBi has the value of 1
  constant MULi : integer :=  fop_type_t'pos(MULt);  -- MULi has the value of 2
  constant DIVi : integer :=  fop_type_t'pos(DIVt);  -- DIVi has the value of 3
  constant SQRi : integer :=  fop_type_t'pos(SQRTt); -- SQRi has the value of 4


   -- Enumerated type declaration for FPU rounding modes
      -- Will be used to make PSL properties more readable
  type fop_rmode_t IS (EVENt, ZEROt, UPt, DOWNt);

  constant EVENi : integer :=  fop_rmode_t'pos(EVENt); -- EVENi has the value of 0
  constant ZEROi : integer :=  fop_rmode_t'pos(ZEROt); -- ZEROi has the value of 1
  constant UPi   : integer :=  fop_rmode_t'pos(UPt);   -- UPi   has the value of 2
  constant DOWNi : integer :=  fop_rmode_t'pos(DOWNt); -- DOWNi has the value of 3

    -- Define pipeline delays for the FPU operands 
      -- NOTE : Add/Sub pipelines 1 more than specification
  constant ADD_PipeLine_Delayi : integer := 7;
  constant SUB_Pipeline_Delayi : integer := 7;
  constant MUL_Pipeline_Delayi : integer := 12;
  constant DIV_Pipeline_Delayi : integer := 35;
  constant SQR_Pipeline_Delayi : integer := 35;

   -- Type Conversion Functions
     function to_fop_type(s: std_logic_vector(2 downto 0)) return fop_type_t;
     function to_rmode_type(s: std_logic_vector(1 downto 0)) return fop_rmode_t;
 
 
   -- Enumerated type declaration for FPU IEE &%$ floating point operands
      -- Will be used to make PSL properties more readable
  type fop_data_t IS (POS_ZEROt, POS_DENORM_REALt, POS_NORM_REALt, POS_INFt, POS_SNANt, POS_QNANt, NEG_ZEROt, NEG_DENORM_REALt, NEG_NORM_REALt, NEG_INFt, NEG_SNANt, NEG_QNANt);
      -- Type Conversion Functions
  function to_fpdata_type(s: std_logic_vector(31 downto 0)) return fop_data_t;
 
end;


 
package body psl_vunit_pkg is    


   -- function to convert std_logic_vector type to enumerated type fop_type_t
      -- DUT fpu_op_i port is std_logic_vector(2 DOWNTO 0)
      -- No standard conversion functions available from std_logic vector to enumerated type
  function to_fop_type(s: std_logic_vector(2 downto 0)) return fop_type_t is
   variable result: fop_type_t;
  begin
     -- Examine passed parameter s (slv(2 downto 0)
     -- Return corresponding enumerated type
    case s is
     when "000"  => return ADDt;
     when "001"  => return SUBt;
     when "010"  => return MULt;
     when "011"  => return DIVt;
     when "100"  => return SQRTt;
     when others => report "Illegal Value in conversion function to_fop_type"
                    severity WARNING;
                    return ADDt;
    end case; 
  end;


   -- function to convert std_logic_vector type to enumerated type fop_rmode_t
      -- DUT rmode_i port is std_logic_vector(1 DOWNTO 0)
      -- No standard conversion functions available from std_logic vector to enumerated type
  function to_rmode_type(s: std_logic_vector(1 downto 0)) return fop_rmode_t is
   variable result: fop_rmode_t;
  begin
     -- Examine passed parameter s (slv(1 downto 0)
     -- Return corresponding enumerated type
    case s is
     when "00"  => return EVENt;
     when "01"  => return ZEROt;
     when "10"  => return UPt;
     when "11"  => return DOWNt;
     when others => report "Illegal Value in conversion function to_rmode_type"
                    severity WARNING;
                    return EVENt;
    end case; 
  end;




   -- function to convert std_logic_vector type to enumerated type fop_data_t
      -- No standard conversion functions available from std_logic vector to enumerated type
  function to_fpdata_type(s: std_logic_vector(31 downto 0)) return fop_data_t is
   variable result: fop_data_t;
   variable value_int : integer;
  begin
     -- Examine passed parameter s (slv(31 downto 0)
        -- cannot convert 32 bits to integer for use in case statement so ahve to loo kat MSB and repeat CASE for lower 31 bits
     -- Return corresponding enumerated type
     if s(31) = '0' then
        value_int := to_integer(unsigned(s(30 DOWNTO 0)));
        case value_int is
           when 0                        => return POS_ZEROt;
           when 1 to 8388607             => return POS_DENORM_REALt;
           when 8388608 to 2139095039    => return POS_NORM_REALt;
           when 2139095040               => return POS_INFt;
           when 2139095041 to 2143289343 => return POS_SNANt;
           when 2143289344 to 2147483647 => return POS_QNANt;
           when others => report "Illegal Value in conversion function to_fpdata_type"
                          severity ERROR;
                          return POS_ZEROt;
        end case; 
     else
        value_int := to_integer(unsigned(s(30 DOWNTO 0)));
        case value_int is
           when 0                        => return NEG_ZEROt;
           when 1 to 8388607             => return NEG_DENORM_REALt;
           when 8388608 to 2139095039    => return NEG_NORM_REALt;
           when 2139095040               => return NEG_INFt;
           when 2139095041 to 2143289343 => return NEG_SNANt;
           when 2143289344 to 2147483647 => return NEG_QNANt;
           when others => report "Illegal Value in conversion function to_fpdata_type"
                          severity ERROR;
                          return POS_ZEROt;
        end case; 
     end if;  
  end;


end package body;