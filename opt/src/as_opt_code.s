.text
   .global main
main:
   pushq %rbp
   movq  %rsp, %rbp
   /** START **/

   /* ASS */
   movq $2, %r13

   /* ASS */
   movq $1000000, %r8

   /* ASS */
   movq $100, %r9

   /* ASS */
   movq $0, %r11

   /* LABEL */
__L_0:

   /* LEQ */
   cmpq %r9, %r11
   setl %al
   movzbq %al, %rax

   /* JMP0 */
   cmpq $0, %rax
   jz __L_1

   /* ADD */
   addq $1, %r11

   /* ASS */
   movq $0, %r10

   /* ADD */
   addq $1, %r13

   /* MUL */
   movq $3, %rax
   movq %r9, %rbx
   imulq %rbx, %rax

   /* MUL */
   movq %r11, %rbx
   imulq %rbx, %rax

   /* DIV */
   movq %r13, %rbx
   movq $0, %rdx
   idivq %rbx
   movq %rax, %r14

   /* DIV */
   movq %r11, %rax
   movq $13, %rbx
   movq $0, %rdx
   idivq %rbx

   /* SUB */
   subq %r14, %rax
   movq %rax, %r14

   /* MUL */
   movq %r13, %rax
   movq $17, %rbx
   imulq %rbx, %rax

   /* SUB */
   subq %r14, %rax
   movq %rax, %r14

   /* ASS */
   movq $0, %r15

   /* LABEL */
__L_2:

   /* LEQ */
   cmpq %r8, %r10
   setl %al
   movzbq %al, %rax

   /* JMP0 */
   cmpq $0, %rax
   jz __L_3

   /* ADD */
   addq $1, %r10

   /* ADD */
   addq $3, %r15

   /* ADD */
   movq %r15, %rax
   addq %r14, %rax
   movq %rax, %r12

   /* GOTO */
   jmp __L_2

   /* LABEL */
__L_3:

   /* GOTO */
   jmp __L_0

   /* LABEL */
__L_1:


   /** END **/
   leave
   ret
.data
   paramwrlstr : .string "%s\n"
   paramwrlint : .string "%d\n"
   paramwristr : .string "%s"
   paramwriint : .string "%d"

   write : .quad 0
   writeln : .quad 0
   