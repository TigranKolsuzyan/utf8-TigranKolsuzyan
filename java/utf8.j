public static int bytes_to_read(int v)
{
        | Condition               | b = bytes |
        |-------------------------|----------:|
        | 0x0000 <= v <=     0x7F |     1     |
        | 0x0080 <= v <=    0x7FF |     2     |
        | 0x0800 <= v <=   0xFFFF |     3     |
        | 0x1000 <= v <= 0x10FFFF |     4     |
        | otherwise               |    -1     |  

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

   }
}  
