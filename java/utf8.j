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
