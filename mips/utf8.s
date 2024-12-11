                    .text
                    .globl decode
                    .globl isContinuation
                    .globl bytes_to_read
                    # insert .globl for any other methods
                    # that you want to test

                    .text
                    .include "include/stack.s"
                    .include "include/syscalls.s"
                    .include "include/subroutine.s"
                    .include "include/io.s"

                                                    #public static int decode()
                                                    #{                                                   

                                                    #// - let b = bytes_to_read (v_1)
                                                    #// - if b == -1, break from LOOP
                                                    #// - eliminate the framing bits from v_1
                                                    #// - read v_1 hexadecimal vs, let v_2, v_3, v_4 be those vs
                                                    #// - validate each of the vs are continuation bytes
                                                    #//   * if any are not continuation bytes then break from LOOP
                                                    #// - eliminate the framing bytes from v2, etc
                                                    #// - reassemble the vs v_1, ... v_4, as appropriate, into v
                                                    #// - print v as a hexadecimal v
decode:             nop                             #;
                    # $t0 = int i;
                    # $t1 = int b;
                    # $t2 = int v_1;
                    # $t3 = int v_2;
                    # $t4 = int v_3;
                    # $t5 = int v_4;
                    # $t6 = int count;
                    # $t7 = int iscont;

                    
                    li $t6, 0                       #count = 0;
whileLoop:          nop                             #;
                                                    #while(true)
                                                    #{
                                                    
                                                    #  //figuring out how many bytes
                    read_x()                        #  mips.read_x();
                    move $t2, $v0  
                    beq $t2, -1, outOfLoop          #  v_1 = mips.retval();
                    call bytes_to_read $t2          #  b = bytes_to_read(v_1);
                    move $t1, $v0                   #
                                                    #  //if its done
                    
                    beq $t1, -1, outOfLoop          #  if(b == -1) break;


                                                    #  //one byte
                    beq $t1, 1, oneByte             #  if (b == 1)

                    beq $t1, 2, twoByte

                    beq $t1, 3, threeByte

                    beq $t1, 4, fourByte

                    j outOfIfs
                                                    #  {
oneByte:            nop                             #    ;                                                    
                    andi $t2, $t2, 0x7F             #    v_1 = v_1 & 0x7F; // Keep 7 bits for single-byte character
                    addi $t6, $t6, 1
                    j finishedDecoding
                                                    #    //printing the final decoding
                                                    #    count = count + 1;
                                                    #  }





                                                    #  //two byte 
                                                    #  else if (b == 2) 
                                                    #  {
twoByte:            nop                             #    ;                                                         
                    andi $t2, $t2, 0x1F             #    v_1 = v_1 & 0x1F; // Keep 5 bits for two-byte character
                                                    

                                                    #    //reading for v_2
                    read_x()                        #    mips.read_x();
                    move $t3, $v0                   #    v_2 = mips.retval();
                    call isContinuation $t3         #    if(isContinuation(v_2) == 1) break;
                    move $t7, $v0                   #    v_2 = v_2 & 0x3F;
                    beq $t7, 1, outOfLoop           
                    andi $t3, $t3, 0x3F             #    //shifting in the mantissa
                    sll $t2, $t2, 6                 #    v_1 = v_1 << 6;
                    sll $t3, $t3, 0                 #    v_2 = v_2 << 0;

                                                    #    //printing the final decoding
                    or $t2, $t2, $t3                #    v_1 = v_1 | v_2;
                    addi $t6, $t6, 1                #    count = count + 1;
                    j finishedDecoding              #  } 



                                                    #  //three bytes
                                                    #  else if (b == 3) 
                                                    #  {
threeByte:          nop                             #    ;                                                         
                    andi $t2, $t2, 0x0F             #    v_1 = v_1 & 0x0F; // Keep 4 bits for three-byte character
                                                    #

                                                    #    //reading for v_2
                    read_x()                        #    mips.read_x();
                    move $t3, $v0                   #    v_2 = mips.retval();
                    call isContinuation $t3         #    if(isContinuation(v_2) == 1) break;
                    move $t7, $v0                   #    v_2 = v_2 & 0x3F;
                    beq $t7, 1, outOfLoop           
                    andi $t3, $t3, 0x3F
                                                    #    //reading for v_3
                    read_x()                        #    mips.read_x();
                    move $t4, $v0                   #    v_3 = mips.retval();
                    call isContinuation $t4         #    if(isContinuation(v_3) == 1) break;
                    move $t7, $v0                   #    v_3 = v_3 & 0x3F;
                    beq $t7, 1, outOfLoop
                    andi $t4, $t4, 0x3F
                                                    #    //shifting in the mantissa
                    sll $t2, $t2, 12                #    v_1 = v_1 << 12;
                    sll $t3, $t3, 6                 #    v_2 = v_2 << 6;
                    sll $t4, $t4, 0                 #    v_3 = v_3 << 0;

                                                    #    //printing the final decoding
                    or $t2, $t2, $t3                #    v_1 = v_1 | v_2 | v_3;
                    or $t2, $t2, $t4                #    count = count + 1;
                    addi $t6, $t6, 1                #  }
                    j finishedDecoding



                                                    #  //four bytes 
                                                    #  else if (b == 4) 
                                                    #  {
fourByte:           nop                             #    ;                                                         
                    andi $t2, $t2, 0x07             #    v_1 = v_1 & 0x07; // Keep 3 bits for four-byte character

                                                    #    //reading for v_2
                    read_x()                        #    mips.read_x();
                    move $t3, $v0                   #    v_2 = mips.retval();
                    call isContinuation $t3         #    if(isContinuation(v_2) == 1) break;
                    move $t7, $v0                   #    v_2 = v_2 & 0x3F;
                    beq $t7, 1, outOfLoop
                    andi $t3, $t3, 0x3F             #    //reading for v_3


                    read_x()                        #    mips.read_x();
                    move $t4, $v0                   #    v_3 = mips.retval();
                    call isContinuation $t4         #    if(isContinuation(v_3) == 1) break;
                    move $t7, $v0                   #    v_3 = v_3 & 0x3F;
                    beq $t7, 1, outOfLoop
                    andi $t4, $t4, 0x3F             #    //reading for v_4


                    read_x()                        #    mips.read_x();
                    move $t5, $v0                   #    v_4 = mips.retval();
                    call isContinuation $t5         #    if(isContinuation(v_3) == -1) break;
                    move $t7, $v0                   #    v_4 = v_4 & 0x3F;
                    beq $t7, 1, outOfLoop
                    andi $t5, $t5, 0x3F             #    //shifting in the mantissa


                    sll $t2, $t2, 18                #    v_1 = v_1 << 18;
                    sll $t3, $t3, 12                #    v_2 = v_2 << 12;
                    sll $t4, $t4, 6                 #    v_3 = v_3 << 6;
                    sll $t5, $t5, 0                 #    v_4 = v_4 << 0;

                                                    #    //printing the final decoding
                    or $t2, $t2, $t3             
                    or $t2, $t2, $t4
                    or $t2, $t2, $t5                #    v_1 = v_1 | v_2 | v_3 | v_4;
                    addi $t6, $t6, 1                #    count = count + 1;
                    j finishedDecoding              #  }

finishedDecoding:                                   #  ;                                                      

                print_x($t2)                        #  mips.print_x(v_1);
                print_ci('\n')                      #  mips.print_ci('\n');


outOfIfs:                                           #  ;                                                         
                j whileLoop                         #  continue;
                                                    #}



outOfLoop:                                          #;                                                     
                move $v0, $t6                       #return count;
                jr $ra                              #}

                                                

                                                    #public static int isContinuation(int v) {
                                                    #// format of v: | ff dd dddd |
                                                    #//   where  'f' denotes a framing bit
                                                    #//   where  'd' denotes a data bit
isContinuation: nop                                 #;
                # a0 = v                            #int retval;
                # v0 = retval                       

                                                    #retval = -1;
                                                    #// eliminate the data bits from v
                andi $a0, $a0, 0xC0                 #v = v & 0xC0;  // 0xC0 == 0b1100 0000
                beq $a0, 0x80, valid
                                                    #// ensure the frame bits are "10"
                                                    #if (v == 0x80) {   // 0x80 == 0b1000 0000
invalid:        nop                                 # ;                                                        
                li $v0, 1                           # retval = 0;
                jr $ra                              #}

valid:          nop                                       
                li $v0, 0                           #retval = retval * -1;
                jr $ra                              #return retval;
                                                    #}






bytes_to_read:  nop
                #a0 = v                             #public static int bytes_to_read(int v) 
                                                    #{
                li $v0, 1                           #if (0x00 <= v)
                ble $a0, 0x7F, return               #{
                                                    #    ;
                li $v0, 2                           
                bge $a0, 0xC0, checkTwo
                j invalidByte                       #    if(v <= 0x7F)
                                                    #    {
checkTwo:       nop                                 #      ;                                                          
                ble $a0, 0xDF, return               #      return 1; // Single-byte character
                                                    #    }                                                        
                li $v0, 3                             
                bge $a0, 0xE0, checkThree           #} 
                j invalidByte
                                                    #
                                                    #if (0xC0 <= v) 
                                                    #{
checkThree:     nop                                 #    ;
    
                ble $a0, 0xEF, return


                li $v0, 4
                bge $a0, 0xF0, checkFour
                j invalidByte                       #    if(v <= 0xDF)
                                                    #    {
checkFour:      nop                                 #      ;                                                          
                ble $a0, 0xF7, return               #      return 2; // Two-byte sequence
                                                    #    }                                                        
                                                    #} 


                                                    #if (0xE0 <= v) 
                                                    #{
invalidByte:    nop                                 #    ;
                li $v0, -1                          #    if(v <= 0xEF)
                jr $ra                              #    {
return:         nop                                 #      ;                                                          
                jr $ra                              #      return 3; // Three-byte sequence
                                                    #    }                                                            
                                                    #}


                                                    #if (0xF0 <= v) 
                                                    #{
                                                    #    ;
                                                    #    if(v <= 0xF7)
                                                    #    {
                                                    #      ;                                                          
                                                    #      return 4; // Four-byte sequence
                                                    #    }    
                                                    #} 
                                                     
                                                    #;                                                     
                                                    #return -1; // Invalid UTF-8 start byte
                                                    #}  
                    