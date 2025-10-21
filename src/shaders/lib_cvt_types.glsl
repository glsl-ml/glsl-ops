// convert between fundamental types

/*
Support matrix

FP32 <=> BF16
*/

uint fn_cvt_fp32_to_bf16_x2(vec2 val) {
  uint o;
  o = val.x & MASK_16_HI;
  o = o | ((val.y & MASK_16_HI) >> 16);
  return o;
}

vec2 fn_cvt_fp32_to_bf16_x2(uint val) {
  vec2 o;
  o.x = (val & MASK_16_HI);
  o.y = (val & MASK_16_LO) << 16;
  return o;
}

// FP32 to FP16
uint fn_cvt_fp32_to_fp16_lo(float val) {
  uint v = floatBitsToUint(val);
  #define FP32_SIGN_MASK = 0x80000000u;
  #define FP32_EXPONENT_MASK = 0x7f800000u;
  #define FP32_MANTISSA_MASK = 0x007fffffu;

  #define FP16_EXPONENT_MAX = 0x47800000u;

  uint sign = v & FP32_SIGN_MASK;
  uint exp = v & FP32_EXPONENT_MASK;
  uint man = v & FP32_MANTISSA_MASK;

  // FP16 can only hold highest integer value of 65536
  if(exp >= FP16_EXPONENT_MAX) {
    // FP32 value is Nan
    /// https://www.corsix.org/content/converting-fp32-to-fp16
    if((exp == FP32_EXPONENT_MASK) && (sign != 0)) {
      
    }
  }
}

// FP32 to FP16 x2
uint fn_cvt_fp32_to_fp16_x2(vec2 val) {
  uint o;
  
}
