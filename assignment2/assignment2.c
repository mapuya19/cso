
#include <stdio.h>
#include <stdlib.h>

#include "sum_squares.h"


// The print_hex function prints a 32-bit word out in hexadecimal, using only
// printf's "%c" or "%d" format specifiers.
// It works by selecting (using masking and shifting) each 4-bit group of bits
// in the word and then printing the value of that 4-bit group as a hex
// digit (between 0 and F, inclusive).

// complete this constant definition for the mask

#define FOUR_BIT_BASK  // FILL IN HERE

// It takes as a parameter a pointer p of type void *, so that p can be
// a pointer to anything (i.e. you can pass in the address of anything).

void print_hex(void *p)
{
    // copy the value that p points to into an unsigned integer variable.
    unsigned int x = *((unsigned int *) p);

    // In a loop, select four bits at a time using a mask.  Then, print
    // the value of that four-bit group using a single hex digit.

    // IMPORTANT: Do NOT use a bunch of "if" statements to map the
    // bits to a hex digit. Either use the value of the bits to
    // index into a an array of characters or the following method:
    //   - if the value of the bits is between 0 and 9, just print the value
    //   - otherwise (i.e. the valus is greater than 9, print the value as
    //   an ASCII character (you'll need to add something to the value).

}   // end of print_hex


// This function performs division on signed 32-bit integers,
// by using shifting and subtraction (not the "/" operator).
// It performs division on the positive (unsigned) versions of the
// numbers, and then adjusts the sign of the result as necessary.

int divide(int x, int y) {

    // leave these lines unchanged. Notice the use of the "exit" operator,
    // which causes the entire program to exit. To use "exit", you
    // need "#include <stdlib.h>", as seen above.

    if (y == 0) {
        printf("Error: Divisor is by 0\n");
        exit(1);       // this causes the program to terminate
    }

    // Declare two unsigned long (64-bit) variables, x1 and y1, which will be
    // used to hold the (positive) values of x and y during the computation.
    // Before writing x into x1 and y into y1, if x or y are negative,
    // you will need to negate them before writing them into x1 and y1.
    // If you negated exactly one of x or y, you will need to
    // negate the result after performing the unsigned division.

    // FILL IN CODE HERE

    // Shift the 32-bit value (which was either y or -y) that you wrote into y1
    // to the leftmost 32 bits of y1.

    // FILL IN CODE HERE

    // Declare an unsigned 32-bit integer to be used as the quotient

    // FILL IN CODE HERE


    // In a loop that terminates when the original 32-bit value in y1
    // has been shifted back to it's original position:
    //    - shift y1 to the right by 1 bit.
    //    - shift the quotient left by 1 bit.
    //    - if y1 is less than or equal to x1, write a 1
    //      into the rightmost bit of the quotient
    //      and subtract y1 from x1.

    // FILL IN CODE HERE

    // write the quotient into a signed integer
    // variable, adjust the sign if necessary, and
    // return the value of the signed variable.

    // FILL IN CODE HERE

}  // end of the divide function




// Define as macros the expressions for extracting the
// sign, exponent, and fraction fields of a 32-bit
// floating point number.

// select bit 31, shifted all the way to the right.

#define SIGN(x) (/* FILL THIS IN */)

// select bits 23 through 30, shifted right by 23 bits

#define EXP(x) (/* FILL THIS IN */)

// select bits 0 through 22 (the rightmost 23 bits)

#define FRAC(x) (/* FILL THIS IN */)


// This function performs a floating point addition without
// using the built-in floating point addition -- instead, it only
// uses integer addition and subtraction. It does so
// by extracting on the sign, exponent, and fraction of the
// operands and performing operations using those to
// compute the sign, exponent, and operand of the result.

float float_add(float f, float g)
{

    // We need to treat the values stored in f and g
    // as 32-bit unsigned numbers. See the hint sheet
    // for ways to do that.  We then need to extract the
    // sign, exponent, and fraction fields from f
    // and g, using the SIGN, EXP, and FRAC macros
    // above.

    unsigned int sign_f = /* FILL THIS IN */;
    unsigned int sign_g = /* FILL THIS IN */;


    unsigned int exp_f =  /* FILL THIS IN */;
    unsigned int exp_g =  /* FILL THIS IN */;

    unsigned int frac_f = /* FILL THIS IN */;
    unsigned int frac_g =  /* FILL THIS IN */;

    // Handle the special case where f is zero (i.e.
    // both the exp_f and frac_f are zero),
    // in which case the value of g should be returned immediately.

    // FILL THIS IN

    // Do the same for g (i.e. check if g is zero).

    // FILL THIS IN

    // In order to perform the multiplication, the implicit
    // leading 1 in the mantissa for f and g must be made
    // explicit. That is, the mantissa for f should contain
    // a 1 in the bit 23 position, followed by the bits of frac_f.
    // The same is true for the mantissa of g.

    unsigned int mantissa_f = /* FILL THIS IN */;
    unsigned int mantissa_g = /* FILL THIS IN */;

    // Before performing any addition, the two numbers must have the
    // same exponent. Take the mantissa of the number with the smaller
    // exponent, and shift that mantissa right by the difference in the
    // exponents, and set the smaller exponent to the larger exponent.
    // For example, if f has a smaller exponent than g, shift mantissa_f
    // the right by (exp_g - exp_f) bits and set exp_f to exp_g.

    // FILL THIS IN

    // Now it's time to compute the exponent, sign, and
    // mantissa of the result.

    // The exponent of the result (before normalization) is
    // now the same as exponent_f (which is the same as
    // exponent_g).

    // This will hold the sign of the result.

    unsigned int sign_res;

    // This will hold the mantissa of the result.

    unsigned int mantissa_res;

    // This holds the exponent of the result.

    unsigned int exp_res = /* FILL THIS IN */;

    // If  sign_f and sign_g are the same, i.e. they are both
    // 0 (positive) or 1 (negative), then:
    //    -- the sign of the result is the same sign_f and sign_g
    //    -- the mantissa of the result is just the sum of mantissa_f and
    //       mantissa_g.
    //    -- since the sum of the two mantissas may cause a carry into
    //       bit 24 of the result, the result may need to be renormalized.
    //       That is, if bit 24 of the result mantissa is 1, then the
    //       result mantissa should be shifted to the right by 1 and the
    //       exponent of the result should be incremented by 1.

    if (sign_f == sign_g) {

        /* FILL THIS IN */

    }
    else {

        // Otherwise, namely if sign_f and sign_g are different (i.e. one
        // number was positive and one negative), then:
        //    -- the sign of the result is the sign of the number with the larger
        //       mantissa (since the numbers have the same exponent at this point).
        //    -- the mantissa of the result should be the result of subtracting
        //       the smaller mantissa from the larger mantissa.
        //
        //       For example, if mantissa_f > mantissa_g, then the sign of the result is
        //       set to sign_f and the mantissa of the result is set to
        //       (mantissa_f - mantissa_g).
        //
        //    -- If the resulting mantissa is 0, then the entire result is 0 and
        //       the function should just return 0.0.
        //    -- Otherwise, the resulting mantissa may be small enough that it has to be
        //       renormalized to have a 1 in the bit 23 position. Do this in
        //       a loop, shifting the result mantissa to the left by 1 bit and subtracting
        //       1 from the result exponent, until the mantissa has a 1 in the
        //       bit 23 position.

        // FILL THIS IN

    }

    // Now construct the result from OR'ing (using bitwise-or, | ) together the
    // following components of the result:
    //  -- the sign bit of the result, shifting into the sign position
    //  -- the lowest 8 bits of the exponent, shifted into exponent position
    //  -- the lowest 23 bits of the mantissa (i.e. removing the 1 in bit 23 position,
    //     since it is implicit)

    unsigned int result  = /* FILL THIS IN */;

    // Return the computed result (which is an unsigned int) as a floating point number.
    // Be sure that the compiler does not perform a conversion (see the hint sheet).

    return /* FILL THIS IN */;
}




// No code in this function should be changed. Just uncomment the appropriate
// code as you complete each of the functions above and the assembly
// function sum_squares in sum_squares.c.

int main()
{

    int x;
    printf("Enter a number to print in hex > ");
    scanf("%d", &x);
    print_hex(&x);
    printf("\n");
    printf("Checking, answer should be: %x\n", x);

    /*

    int a, b;

    printf("Enter a divisor and a dividend > ");
    scanf("%d %d", &a, &b);

    int c = divide(a,b);

    printf("%d/%d = %d\n", a, b, c);
    printf("Checking, answer should be: %d\n", a/b);

    float f, g;

    printf("Enter two floating point numbers (to add) > ");
    scanf("%f", &f);
    scanf("%f", &g);

    printf("Computed %f + %f = %f\n", f, g, float_add(f,g));
    printf("Checking, answer should be %f\n", f+g);

    int n;
    printf("Enter n > ");

    scanf("%d", &n);
    printf("The sum of the squares from 1 to %d is %d\n", n, sum_squares(n));

    int sum = 0;
    for(int i = 1; i <= n; i++)
      sum += i*i;
    printf("Checking: %d\n", sum);

    */

}

