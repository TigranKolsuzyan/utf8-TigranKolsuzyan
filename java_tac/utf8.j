public static int decode()
{

                                                    // - let b = bytes_to_read (v_1)
                                                    // - if b == -1, break from LOOP
                                                    // - eliminate the framing bits from v_1
                                                    // - read v_1 hexadecimal vs, let v_2, v_3, v_4 be those vs
                                                    // - validate each of the vs are continuation bytes
                                                    //   * if any are not continuation bytes then break from LOOP
                                                    // - eliminate the framing bytes from v2, etc
                                                    // - reassemble the vs v_1, ... v_4, as appropriate, into v
                                                    // - print v as a hexadecimal v
decode:                                             ;

                                                    int i;
                                                    int b;
                                                    int v_1;
                                                    int v_2;
                                                    int v_3;
                                                    int v_4;
                                                    int count;
                                                    int isCont;

                                                    count = 0;
whileLoop:                                          ;
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
oneByte:                                                ;                                                    
                                                        v_1 = v_1 & 0x7F; // Keep 7 bits for single-byte character


                                                        //printing the final decoding
                                                        count = count + 1;
                                                      }





                                                      //two byte 
                                                      else if (b == 2) 
                                                      {
twoByte:                                                ;                                                         
                                                        v_1 = v_1 & 0x1F; // Keep 5 bits for two-byte character
                                                    

                                                        //reading for v_2
                                                        mips.read_x();
                                                        v_2 = mips.retval();
                                                        isCont = isContinuation(v_2);
                                                        if(isCont == 1) break;
                                                        v_2 = v_2 & 0x3F;
                                                    
                                                        //shifting in the mantissa
                                                        v_1 = v_1 << 6;
                                                        v_2 = v_2 << 0;

                                                        //printing the final decoding
                                                        v_1 = v_1 | v_2;
                                                        count = count + 1;
                                                      } 



                                                      //three bytes
                                                      else if (b == 3) 
                                                      {
threeByte:                                              ;                                                         
                                                        v_1 = v_1 & 0x0F; // Keep 4 bits for three-byte character
                                                    

                                                        //reading for v_2
                                                        mips.read_x();
                                                        v_2 = mips.retval();
                                                        isCont = isContinuation(v_2);
                                                        if(isCont == 1) break;
                                                        v_2 = v_2 &  0x3F;

                                                        //reading for v_3
                                                        mips.read_x();
                                                        v_3 = mips.retval();
                                                        isCont = isContinuation(v_3);
                                                        if(isCont == 1) break;
                                                        v_3 = v_3 & 0x3F;


                                                        //shifting in the mantissa
                                                        v_1 = v_1 << 12;
                                                        v_2 = v_2 << 6;
                                                        v_3 = v_3 << 0;

                                                        //printing the final decoding
                                                        v_1 = v_1 | v_2 | v_3;
                                                        count = count + 1;
                                                      }




                                                      //four bytes 
                                                      else if (b == 4) 
                                                      {
fourByte:                                               ;                                                         
                                                        v_1 = v_1 & 0x07; // Keep 3 bits for four-byte character

                                                        //reading for v_2
                                                        mips.read_x();
                                                        v_2 = mips.retval();
                                                        isCont = isContinuation(v_2);
                                                        if(isCont == 1) break;
                                                        v_2 = v_2 &  0x3F;

                                                        //reading for v_3
                                                        mips.read_x();
                                                        v_3 = mips.retval();
                                                        isCont = isContinuation(v_3);
                                                        if(isCont == 1) break;
                                                        v_3 = v_3 & 0x3F;

                                                        //reading for v_4
                                                        mips.read_x();
                                                        v_4 = mips.retval();
                                                        isCont = isContinuation(v_4);
                                                        if(isCont == -1) break;
                                                        v_4 = v_4 & 0x3F;

                                                        //shifting in the mantissa
                                                        v_1 = v_1 << 18;
                                                        v_2 = v_2 << 12;
                                                        v_3 = v_3 << 6;
                                                        v_4 = v_4 << 0;

                                                        //printing the final decoding
                                                        v_1 = v_1 | v_2 | v_3 | v_4;
                                                        count = count + 1;
                                                      }

outOfIfs:                                             ;                                                      

                                                      mips.print_x(v_1);
                                                      mips.print_ci('\n');
                                                      continue;
                                                    }
outOfLoop:                                          ;                                                     
                                                    return count;
}

                                                

public static int isContinuation(int v) {
                                                    // format of v: | ff dd dddd |
                                                    //   where  'f' denotes a framing bit
                                                    //   where  'd' denotes a data bit
isCont:                                             ;
                                                    int retval;
 
                                                    retval = -1;
                                                    // eliminate the data bits from v
                                                    v = v & 0xC0;  // 0xC0 == 0b1100 0000

                                                    // ensure the frame bits are "10"
                                                    if (v == 0x80) {   // 0x80 == 0b1000 0000
ensureFrameBit:                                      ;                                                        
                                                     retval = 0;
                                                    }
                                                    retval = retval * -1;
                                                    return retval;
}







public static int bytes_to_read(int v) 
{
                                                    if (0x00 <= v)
                                                    {
oneBytes:                                               ;
                                                        if(v <= 0x7F)
                                                        {
oneBytes:                                                 ;                                                          
                                                          return 1; // Single-byte character
                                                        }                                                        
                                                      
                                                    } 

                                                    
                                                    if (0xC0 <= v) 
                                                    {
twoBytes:                                               ;
                                                        if(v <= 0xDF)
                                                        {
twoBytes:                                                 ;                                                          
                                                          return 2; // Two-byte sequence
                                                        }                                                        
                                                    } 


                                                    if (0xE0 <= v) 
                                                    {
threeBytes:                                             ;
                                                        if(v <= 0xEF)
                                                        {
threeBytes:                                               ;                                                          
                                                          return 3; // Three-byte sequence
                                                        }                                                            
                                                    }


                                                    if (0xF0 <= v) 
                                                    {
fourBytes:                                              ;
                                                        if(v <= 0xF7)
                                                        {
fourBytes:                                                ;                                                          
                                                          return 4; // Four-byte sequence
                                                        }    
                                                    } 
                                                     
invalidBytes:                                       ;                                                     
                                                    return -1; // Invalid UTF-8 start byte
}  
