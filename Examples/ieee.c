/* From Lecture 4 comp 2280, 2/3/2022*/
/* For view the encoding of a float, and the float encoded by some 32-bit value*/


#include<stdio.h>

int main() {

  union {
    float f;
    int u; /*assume 32 bit float,ints*/
  } f2u;


  f2u.f = -65.2; /*specify floating number*/

  printf("%x\n",f2u.u); /*print the encoding*/

  f2u.u = 0xc2328000; /*specify encoding*/

  printf("%f\n",f2u.f); /*print the floating number encoded*/

  return 0;

}
