# THIS IS THE WINDOWS CALLING CONVENTION:
#
# Passing Parameters:
#  First four integer/pointer parameters (in order): %rcx, %rdx, %r8, %r9
#	 (or corresponding 32-bit halves)
#  Additional parameters are passed on the stack, pushed in right-to-left (reverse) order.
#  IMPORTANT: The caller must allocate 32 bytes on stack (by subtracting 32 from %rsp) right
#             before calling the function. Don’t forget to restore the %rsp (by adding 32)
#	      after the call. This means that the stack parameters are an extra 32 bytes away
#	      from %rbp (so they are at 40(%rbp), 48(%rbp), etc.

# Return Value:
#   %rax (for 64-bit result), %eax (for 32-bit result)

# Caller-Saved Registers (may be overwritten by called function):
#    %rax, %rcx, %rdx, %r8, %r9, %r10, %r11
# Callee-Saved Registers (must be preserved – or saved and restored – by called function):
#    %rbx, %rbp, %rdi, %rsi, %rsp, %r12, %r13, %r14, %r15

	.text
	.globl	yes_response


// Returns true (1 or any non-zero value) if user types "yes" or "y" (upper or lower case)
// and returns false (0) if user types "no" or "n". Keeps prompting otherwise.
	
// DON'T TOUCH THIS FUNCTION! It works fine and serves as an example for you.
// Make sure you understand what's going on.

yes_response:	

	pushq	%rbp
	movq	%rsp, %rbp

	//  char response[STRING_SIZE];  // recall that STRING_SIZE is 200
	                           // Allocate this on the stack, at least 200 bytes, but make
	//                         // it a multiple of 16, so 208 (which is 13 x 16)
	//			   // The array can still start at -200(%rbp).

	subq	$208,%rsp

	//
	//   BOOL result;        // since this is the return value, use %eax.
	                         // Nothing needs to be done with this yet, though.


	//   do {                       // Just the top of the loop, so need a label here

RESPONSE_LOOP_TOP:	
	
	//     read_line(response, STRING_SIZE);  // call read_line, passing the ADDRESS (using leaq) of the start of the 
	// array in %rcx and 200 in %rdx.  No registers need saving at this point.
	// No return value.
	
	  
        leaq	-200(%rbp),%rcx
	movq	$200,%rdx

	subq	$32,%rsp  		# mandatory
	call	read_line
	addq	$32,%rsp
	
	//     if (!strcasecmp(response,"yes") || !strcasecmp(response,"y")) {
	//       result = TRUE;
	//       break;
	//     }

	// Two calls to strcasecmp(). The || means that we do the second one only
	// if the first one returns a non-zero number. If they both return a
	// non-zero number, then we execute the else part, below. Otherwise,
	// we write 1 to result (%eax) and jump out of the loop.

        leaq	-200(%rbp),%rcx		# call strcasecmp, passing the addresses of the array and the string "yes"
	leaq	string_yes(%rip),%rdx

	subq	$32,%rsp  		# mandatory
	call	strcasecmp		# returns 0 in %eax if the strings are the same
	addq	$32,%rsp
	
	cmp	$0,%eax			# if the strings are the same, i.e. the string was "yes", 
	je	FOUND_YES		# then jump over the next comparison                     

        leaq	-200(%rbp),%rcx		# wasn't a "yes", check for "y", need to reload %rcx since it is caller-saved
	leaq	string_y(%rip),%rdx

	subq	$32,%rsp  		# mandatory
	call	strcasecmp		# returns 0 in %eax if the strings are the same
	addq	$32,%rsp


	cmp	$0,%eax	
	jne	CHECK_FOR_NO            # if didn't match "y", then check for "No"

FOUND_YES:	
	movl	$1,%eax			# otherwise, the answer was yes, so put 1 in %eax
	jmp	RESPONSE_LOOP_DONE	# and jump out of the loop


CHECK_FOR_NO:
	
	//     else if (!strcasecmp(response,"no") || !strcasecmp(response,"n")) {
	//       result = FALSE;
	//       break;
	//     }
	
        leaq	-200(%rbp),%rcx		# call strcasecmp, passing the addresses of the array and the string "no"
	leaq	string_no(%rip),%rdx

	subq	$32,%rsp  		# mandatory
	call	strcasecmp		# returns 0 in %eax if the strings are the same
	addq	$32,%rsp


	cmp	$0,%eax			# if the strings are the same, i.e. the string was "no",
	je	FOUND_NO                # then jump over the next comparison                     

        leaq	-200(%rbp),%rcx		# wasn't a "no", check for "n", need to reload %rcx since it is caller-saved
	leaq	string_n(%rip),%rdx

	subq	$32,%rsp  		# mandatory
	call	strcasecmp		# returns 0 in %eax if the strings are the same
	addq	$32,%rsp


	cmp	$0,%eax	
	jne	RE_ENTER		# if the answer didn't match "n", jump to code for asking user to re-enter input

FOUND_NO:	
	movl	$0,%eax			# otherwise, the answer was no, so put 0 in %eax

	jmp	RESPONSE_LOOP_DONE	# and jump out of the loop

RE_ENTER:

	//     printf("Please enter \"yes\" or \"no\" > ");
	//   } while (TRUE);

	leaq	string_enter(%rip),%rcx   # pass the string to printf

	subq	$32,%rsp  		# mandatory
	call	printf
	addq	$32,%rsp

	jmp	RESPONSE_LOOP_TOP	  # always jump to the top of the loop

RESPONSE_LOOP_DONE:	

	//   return result;
	# result is already in %eax, so just restore the stack (removing the array)

	addq	$208,%rsp

	popq	%rbp
	retq
// }

	
	.text

string_yes:                                 
	.asciz	"yes"
string_y:	
	.asciz	"y"
string_no:
	.asciz	"no"
string_n:
	.asciz	"n"
string_enter:
	.asciz  "Please enter \"yes\" or \"no\" > "
	


// // This procedure creates a new NODE and copies
// // the contents of string s into the 
// // question_or_animal field.  It also initializes
// // the left and right fields to NULL.
// // It should return a pointer to the new node
// 
// NODE *new_node(char *s)
// {
	.text
	.globl	new_node

new_node:

	pushq	%rbp
	movq	%rsp,%rbp

	# IMPORANT: THE ALIGNMENT RULE FOR MALLOC AND OTHER C FUNCTIONS IS THAT THE STACK HAS
	# TO BE 16-BYTE ALIGNED. SO, AFTER THE PUSH TO %RBP, THE STACK POINTER %RSP, SHOULD
	# BE INCREMENTED OR DECREMENTED IN MULTIPLES OF 16.

	# So, two 8-byte pushes is fine.

	# the string to write into the new node is pointed to by %rcx
	# NOTE: sizeof(NODE) is 216.
        # Offsets within NODE are: question_or_animal = 0, left = 200, right = 208
	# NULL is 0.

	# We'll move s to a callee-saved register, %rbx, so we don't have to repeatedly
	# push and pop it when we make calls to malloc and strcpy.
	# Similarly, we'll put p in %r12, another callee-saved register.

	# first save %rbx and %r12 on the stack.
	
	pushq %rbx;
	pushq %r12;
	
	# then move s to %rbx

	movq %rcx, %rbx;

//   NODE *p = (NODE *) malloc(sizeof(NODE));  // where sizeof(NODE) is 216
	
	movq $216, %rcx;
	subq $32, %rsp;
	call malloc;
	addq $32, %rsp;

	# put the result of malloc into p (%r12)

	mov %rax, %r12;	

//   p->left = NULL;
//   p->right = NULL;

	movq $0, 200(%r12);
	movq $0, 208(%r12);

//   strcpy(p->question_or_animal, s);	

	# call strcpy, passing the address of p->question_or_animal and the pointer s (which is in %rbx)
	
	leaq 0(%r12), %rcx;
	movq %rbx, %rdx;
	subq $32, %rsp;
	call strcpy;
	addq $32, %rsp;
	
//   return p;

	mov %r12, %rax;

	# restore the callee-saved registers %r12, %rbx

	pop %r12;
	pop %rbx;

	popq	%rbp
	retq
	


	.text
	.globl	guess_animal
	

	
// // This is the function that performs the guessing.
// // If the animal is not correctly guessed, it prompts
// // the user for the name of the animal and inserts a
// // new node for that animal into the tree.
// 
// void guess_animal()
// {

guess_animal:

	push	%rbp
	mov	%rsp,%rbp

	# IMPORANT: THE ALIGNMENT RULE FOR MALLOC AND OTHER C FUNCTIONS IS THAT THE STACK HAS
	# TO BE 16-BYTE ALIGNED. SO, AFTER THE PUSH TO %RBP, THE STACK POINTER %RSP, SHOULD
	# BE INCREMENTED OR DECREMENTED IN MULTIPLES OF 16 . 
	
	# We'll use some callee-saved registers, since we have a bunch of calls.

	//     char new_question_or_animal[200];

	# In this function, we're going to save registers at fixed offsets from %ebp (as local variables).
	# We're using two callee-saved registers (that's 16 bytes) and have a 200-byte array, for a total of
	# of 216 bytes.  The next 16-byte boundary is at 224, so we'll decrement %rsp by 224 and save/restore
	# %rbx and %r12 as offsets from %rbp (as if they were local variables)
	#  %rbx: -8(%rbp)
	#  %r12: -16(%rbp)
	#  new_question_or_animal: -216(%rbp)

	# We'll use %rbx for p and %r12 for new_n (see below).

	# make space on the stack for the array and the two callee-saved registers

	movq %rbx, -8(%rbp)
	movq %r12, -16(%r12)
	subq $224, %rsp
	
//   if (root == NULL) {
	
	cmpq $0, root(%rip)
	jne GUESS_ELSE

//     p = (NODE *) malloc(sizeof(NODE));	

	# NOTE: sizeof(NODE) is 216.
	# Also, copy the address to p in %rbx, don't leave it in %rax

	movq $216, %rcx
	subq $32, %rsp
	call malloc
	addq $32, %rsp
	leaq (%rax), %rbx

	//     p->left = NULL
	//     p->right = NULL

    # Offsets within NODE are: question_or_animal = 0, left = 200, right = 208	

	movq $0, 200(%rbx)
	movq $0, 208(%rbx)
	
//     printf("I give up! What animal is it? > ");	

	leaq string_give_up(%rip), %rcx
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp
	

//     read_line(p->question_or_animal, STRING_SIZE);	

	leaq 0(%rbx), %rcx
	movq $200, %rdx
	xorq %rax, %rax
	subq $32, %rsp
	call read_line
	addq $32, %rsp

//     root = p

	movq %rbx, root(%rip)

//   }  // end of if (root == NULL)
//   else {

	GUESS_ELSE:
	
//     p = root

	movq root(%rip), %rbx

//     while (TRUE) {

	WHILE_GUESSING:
	
//       if ((p->left == NULL) && (p->right == NULL)) { //leaf, guess the animal

        # Offsets within NODE are: question_or_animal = 0, left = 200, right = 208

	cmpq $0, 200(%rbx)
	jne NOT_LEAF
	cmpq $0, 208(%rbx)
	jne NOT_LEAF

	# - if we are here, we're at a leaf

// 	printf("I'm guessing: %s\n", p->question_or_animal);

	leaq string_guess(%rip), %rcx
	leaq 0(%rbx), %rdx
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp

// 	printf("Am I right? > ");	

	leaq string_am_i_right(%rip), %rcx
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp

// 	if (yes_response()) {

	subq $32, %rsp
	call yes_response
	addq $32, %rsp
	cmpq $0, %rax
	je WRONG_GUESS
	# call yes_reponse, then compare its result and jump as necessary.

// 	  printf("I win!\n");

	leaq string_i_win(%rip), %rcx
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp
	
// 	  break;

	jmp ALL_DONE
	# (jump out of loop, to end of function)

// 	}  // end of if (yes_response())

	
// 	else { //guess was wrong

	WRONG_GUESS:

// 	  printf("\noops.  What animal were you thinking of? > ");

	leaq string_oops(%rip), %rcx
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp
	
// 	  read_line(new_question_or_animal); 

	leaq -216(%rbp), %rcx
	movq $200, %rdx
	subq $32, %rsp
	call read_line
	addq $32, %rsp

// 	  new_n = new_node(new_question_or_animal);

	leaq -216(%rbp), %rcx
	subq $32, %rsp
	call new_node
	addq $32, %rsp
	movq %rax, %r12

// 	  printf("Enter a yes/no question to distinguish between a %s and a %s > ", 
// 		 new_question_or_animal, p->question_or_animal);

	leaq string_distinguish(%rip), %rcx
	leaq -216(%rbp), %rdx
	leaq (%rbx), %r8
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp
	
// 	  read_line(new_question_or_animal);

	leaq -216(%rbp), %rcx
	movq $200, %rdx
	subq $32, %rsp
	call read_line
	addq $32, %rsp

// 	  printf("What is the answer for a %s (yes or no)? > ",
// 		 new_n->question_or_animal);

	leaq string_yes_or_no(%rip), %rcx
	leaq (%r12), %rdx
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp

// 	  if (yes_response()) {
	
	subq $32, %rsp
	call yes_response
	addq $32, %rsp
	cmpq $0, %rax
	je NOT_YES_RESPONSE

// 	    p->left = new_n;

	movq %r12, 200(%rbx)

// 	    p->right = new_node(p->question_or_animal);
	
	leaq (%rbx), %rcx
	subq $32, %rsp
	call new_node
	addq $32, %rsp

	movq %rax, 208(%rbx)
	
	# , take the of calling new_node, and write it into p->right
	
// 	  }  // end of if (yes_response())

// 	  else {

	NOT_YES_RESPONSE:
	
// 	    p->right = new_n;
// 	    p->left = new_node(p->question_or_animal);
// 	  }  # end of else

	movq %r12, 208(%rbx);

	leaq (%rbx), %rcx
	subq $32, %rsp
	call new_node
	addq $32, %rsp
	movq %rax, 200(%rbx)


// 	  }  # end of else	

	ANOTHER_LEAF_MAYBE:
	
	// 	  strcpy(p->question_or_animal, new_question_or_animal);

	leaq 0(%rbx), %rcx
	leaq -216(%rbp), %rdx
	subq $32, %rsp
	call strcpy
	addq $32, %rsp

	// 	  break;

	jmp ALL_DONE
// 	}

//  else { //not a leaf

	NOT_LEAF:
	
	//      printf("%s (yes/no) > ", p->question_or_animal)
	
	leaq string_yes_slash_no(%rip), %rcx
	leaq (%rbx), %rdx
	xorq %rax, %rax
	subq $32, %rsp
	call printf
	addq $32, %rsp

// 	if (yes_response())
	
	subq $32, %rsp
	call yes_response
	addq $32, %rsp
	cmpq $0, %rax
	jne NOT_YES_AGAIN

// 	  p = p->left

	movq 200(%rbx), %rbx

	jmp GUESS_LOOP_BOTTOM

	# , after this we need to continue iterating
	
//	} // end of if (yes_response())

// 	else {

	NOT_YES_AGAIN:

// 	  p = p->right

	movq 208(%rbx), %rbx

//      }  // end of else

GUESS_LOOP_BOTTOM:
	# jump back to top of loop

	jmp WHILE_GUESSING

	ALL_DONE:

	# Restore the callee-saved registers and remove locals from stack (by adding to %rsp)
	
	movq -8(%rbp), %rbx
	movq -16(%rbp), %r12
	addq $224, %rsp
	
	popq	%rbp
	retq
	

	.text

	string_give_up: 
		.asciz	"I give up! What animal is it? > "

	string_guess:
		.asciz "I'm guessing: %s\n"

	string_am_i_right:
		.asciz "Am I right? > "

	string_yes_slash_no:
		.asciz "%s (yes/no) > "

	string_i_win:
		.asciz "I win!\n"

	string_distinguish:
		.asciz "Enter a yes/no question to distinguish between a %s and a %s > "

	string_yes_or_no:
		.asciz "What is the answer for a %s (yes or no)? > "
	
	string_oops:
		.asciz "\noops.  What animal were you thinking of? > "

	
	
	# The global "root" variable is here. You don't need
	# to touch it.
	
	.data
	.globl	root

root:
	.quad	0		# allocating 8 bytes and initializing to 0
	
