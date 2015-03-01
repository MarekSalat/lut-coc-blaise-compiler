.text
   .global main
main:
   pushq %rbp
   movq  %rsp, %rbp
   /** START **/



   /* ASS */
   movq $2, %rax
   movq %rax, factor(%rip)

   /* ASS */
   movq $42, %rax
   movq %rax, flag_magic(%rip)

   /* ASS */
   movq $1000000, %rax
   movq %rax, cols(%rip)

   /* ASS */
   movq $100, %rax
   movq %rax, rows(%rip)

   /* ASS */
   movq $0, %rax
   movq %rax, i_col(%rip)

   /* LABEL */
__L_0:

   /* LEQ */
   movq i_row(%rip), %rax
   movq rows(%rip), %rbx
   cmpq %rbx, %rax
   setl %al
   movzbq %al, %rax
   movq %rax, __V_0(%rip)

   /* JMP0 */
   movq __V_0(%rip), %rax
   cmpq $0, %rax
   jz __L_1

   /* ADD */
   movq i_row(%rip), %rax
   movq $1, %rbx
   addq %rbx, %rax
   movq %rax, __V_1(%rip)

   /* ASS */
   movq __V_1(%rip), %rax
   movq %rax, i_row(%rip)

   /* ASS */
   movq $0, %rax
   movq %rax, i_col(%rip)

   /* LABEL */
__L_2:

   /* LEQ */
   movq i_col(%rip), %rax
   movq cols(%rip), %rbx
   cmpq %rbx, %rax
   setl %al
   movzbq %al, %rax
   movq %rax, __V_0(%rip)

   /* JMP0 */
   movq __V_0(%rip), %rax
   cmpq $0, %rax
   jz __L_3

   /* ADD */
   movq i_col(%rip), %rax
   movq $1, %rbx
   addq %rbx, %rax
   movq %rax, __V_1(%rip)

   /* ASS */
   movq __V_1(%rip), %rax
   movq %rax, i_col(%rip)

   /* EQL */
   movq i_col(%rip), %rax
   movq $0, %rbx
   cmpq %rbx, %rax
   sete %al
   movzbq %al, %rax
   movq %rax, __V_0(%rip)

   /* JMP0 */
   movq __V_0(%rip), %rax
   cmpq $0, %rax
   jz __L_4

   /* ADD */
   movq factor(%rip), %rax
   movq $1, %rbx
   addq %rbx, %rax
   movq %rax, __V_1(%rip)

   /* ASS */
   movq __V_1(%rip), %rax
   movq %rax, factor(%rip)

   /* LABEL */
__L_4:

   /* MUL */
   movq $3, %rax
   movq rows(%rip), %rbx
   imulq %rbx, %rax
   movq %rax, __V_0(%rip)

   /* MUL */
   movq __V_0(%rip), %rax
   movq i_row(%rip), %rbx
   imulq %rbx, %rax
   movq %rax, __V_1(%rip)

   /* DIV */
   movq __V_1(%rip), %rax
   movq factor(%rip), %rbx
   movq $0, %rdx
   idivq %rbx
   movq %rax, __V_2(%rip)

   /* MUL */
   movq $3, %rax
   movq i_col(%rip), %rbx
   imulq %rbx, %rax
   movq %rax, __V_3(%rip)

   /* ADD */
   movq __V_2(%rip), %rax
   movq __V_3(%rip), %rbx
   addq %rbx, %rax
   movq %rax, __V_4(%rip)

   /* ASS */
   movq __V_4(%rip), %rax
   movq %rax, index(%rip)

   /* DIV */
   movq i_row(%rip), %rax
   movq $13, %rbx
   movq $0, %rdx
   idivq %rbx
   movq %rax, __V_0(%rip)

   /* MUL */
   movq factor(%rip), %rax
   movq $17, %rbx
   imulq %rbx, %rax
   movq %rax, __V_1(%rip)

   /* ADD */
   movq __V_0(%rip), %rax
   movq __V_1(%rip), %rbx
   addq %rbx, %rax
   movq %rax, __V_2(%rip)

   /* SUB */
   movq index(%rip), %rax
   movq __V_2(%rip), %rbx
   subq %rbx, %rax
   movq %rax, __V_3(%rip)

   /* ASS */
   movq __V_3(%rip), %rax
   movq %rax, index(%rip)

   /* DIV */
   movq flag_magic(%rip), %rax
   movq $42, %rbx
   movq $0, %rdx
   idivq %rbx
   movq %rax, __V_0(%rip)

   /* NEQ */
   movq __V_0(%rip), %rax
   movq $1, %rbx
   cmpq %rbx, %rax
   setne %al
   movzbq %al, %rax
   movq %rax, __V_1(%rip)

   /* JMP0 */
   movq __V_1(%rip), %rax
   cmpq $0, %rax
   jz __L_6

   /* ASS */
   movq $42, %rax
   movq %rax, flag_magic(%rip)

   /* LABEL */
__L_6:

   /* ASS */
   movq $0, %rax
   movq %rax, index(%rip)

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

   __V_0 : .quad 0
   __V_1 : .quad 0
   __V_2 : .quad 0
   __V_3 : .quad 0
   __V_4 : .quad 0
   cols : .quad 0
   factor : .quad 0
   flag_magic : .quad 0
   i_col : .quad 0
   i_row : .quad 0
   index : .quad 0
   rows : .quad 0
   write : .quad 0
   writeln : .quad 0
