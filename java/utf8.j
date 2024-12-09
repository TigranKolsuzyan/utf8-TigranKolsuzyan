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
  int v_1;
  int v_2;
  int v_3;
  int v_4;
  int count = 0;

  while(true)
  {

    //figuring out how many bytes
    mips.read_x();
    v_1 = mips.retval();
    b = bytes_to_read(v_1);

    //if its done
    if(b == -1) break;


    //one byte
    if (b == 1) 
    {
      v_1 = v_1 & 0x7F; // Keep 7 bits for single-byte character


      //printing the final decoding
      mips.print_x(v_1);
      mips.print_ci('\n');
      count = count + 1;
    }





    //two byte 
    else if (b == 2) 
    {
      v_1 = v_1 & 0x1F; // Keep 5 bits for two-byte character


      //reading for v_2
      mips.read_x();
      v_2 = mips.retval();
      if(isContinuation(v_2) == 1) break;
      v_2 = v_2 & 0x2F;

      //shifting in the mantissa
      v_1 = v_1 << 6;
      v_2 = v_2 << 0;

      //printing the final decoding
      v_1 = v_1 | v_2;
      mips.print_x(v_1);
      mips.print_ci('\n');
      count = count + 1;
    } 



    //three bytes
    else if (b == 3) 
    {
      v_1 = v_1 & 0x0F; // Keep 4 bits for three-byte character


      //reading for v_2
      mips.read_x();
      v_2 = mips.retval();
      if(isContinuation(v_2) == 1) break;
      v_2 = v_2 &  0x2F;

      //reading for v_3
      mips.read_x();
      v_3 = mips.retval();
      if(isContinuation(v_3) == 1) break;
      v_3 = v_3 & 0x2F;


      //shifting in the mantissa
      v_1 = v_1 << 12;
      v_2 = v_2 << 6;
      v_3 = v_3 << 0;

      //printing the final decoding
      v_1 = v_1 | v_2 | v_3;
      mips.print_x(v_1);
      mips.print_ci('\n');
      count = count + 1;
    }




    //four bytes 
    else if (b == 4) 
    {
      v_1 = v_1 & 0x07; // Keep 3 bits for four-byte character

      //reading for v_2
      mips.read_x();
      v_2 = mips.retval();
      if(isContinuation(v_2) == 1) break;
      v_2 = v_2 &  0x2F;

      //reading for v_3
      mips.read_x();
      v_3 = mips.retval();
      if(isContinuation(v_3) == 1) break;
      v_3 = v_3 & 0x2F;

      //reading for v_4
      mips.read_x();
      v_4 = mips.retval();
      if(isContinuation(v_3) == -1) break;
      v_4 = v_4 & 0x2F;

      //shifting in the mantissa
      v_1 = v_1 << 18;
      v_2 = v_2 << 12;
      v_3 = v_3 << 6;
      v_4 = v_4 << 0;

      //printing the final decoding
      v_1 = v_1 | v_2 | v_3 | v_4;
      mips.print_x(v_1);
      mips.print_ci('\n');
      count = count + 1;
    }
  }
  return count;
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
    return retval * -1;
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
