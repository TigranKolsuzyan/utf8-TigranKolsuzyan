public static int decode()
{

   // - let b = bytes_to_read (v_1)
   // - if b == -1, break from LOOP
   // - eliminate the framing bits from v_1
   // - read v_1 hexadecimal values, let v_2, v_3, v_4 be those values
   // - validate each of the values are continuation bytes
   //   * if any are not continuation bytes then break from LOOP
   // - eliminate the framing bytes from v2, etc
   // - reassemble the values v_1, ... v_4, as appropriate, into v
   // - print v as a hexadecimal value

  int i;
  int b;
  String v_1;
  mips.read_s();
  v_1 = mips.retval();
  b = bytes_to_read(v_1);
  for(i = 0; i < b; i++)
  {

    if(b == -1)
    {
      break;
    }

    mips.read_s();
    v_1 = mips.retval();
    b = bytes_to_read(v_1);

    if(b == 1)
    {
      v_1 = v_1 & 0x7F
    }
    else if(b == 2)
    {
      v_1 = v_1 & 0x7F
    }


  }

}



public static int isContinuation(int value) {
    // format of value: | ff dd dddd |
    //   where  'f' denotes a framing bit
    //   where  'd' denotes a data bit

    int retval;
 
    retval = -1;
    // eliminate the data bits from value
    value = value & 0xC0;  // 0xC0 == 0b1100 0000

    // ensure the frame bits are "10"
    if (value == 0x80) {   // 0x80 == 0b1000 0000
     retval = 0;
    }
    return retval;
}







public static int bytes_to_read(int v)
{
   if(v >= 0x0000 && v <= 0x7F)
   {
    return 1;
   }
   else if(v >= 0x0080 && v <= 0x7FF)
   {
    return 2;
   }
   else if(v >= 0x0800 && v <= 0xFFFF)
   {
    return 3;
   }
   else if(v >= 0x1000 && v <= 0x10FFFF)
   {
    return 4;
   }
   else
   {
    return -1;
   }
}  
