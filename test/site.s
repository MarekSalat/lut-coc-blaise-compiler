.text
   .global main
main:
   pushq %rbp
   movq  %rsp, %rbp
   /** START **/



   /* ASS */
   movq $10, %rax
   movq %rax, value1(%rip)

   /* MUL */
   movq $3, %rax
   movq value1(%rip), %rbx
   imulq %rbx, %rax
   movq %rax, __V_0(%rip)

   /* DIV */
   movq __V_0(%rip), %rax
   movq $2, %rbx
   movq $0, %rdx
   idivq %rbx
   movq %rax, __V_1(%rip)

   /* SUB */
   movq __V_1(%rip), %rax
   movq $4, %rbx
   subq %rbx, %rax
   movq %rax, __V_2(%rip)

   /* ASS */
   movq __V_2(%rip), %rax
   movq %rax, value2(%rip)

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_0, %rsi
   call printf

   /* CALL */
   movq value1(%rip), %rsi
   movq $paramwrlint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_1, %rsi
   call printf

   /* CALL */
   movq value2(%rip), %rsi
   movq $paramwrlint, %rdi
   movq $0, %rax
   call printf

   /* NEQ */
   movq value1(%rip), %rax
   movq value2(%rip), %rbx
   cmpq %rbx, %rax
   setne %al
   movzbq %al, %rax
   movq %rax, __V_0(%rip)

   /* JMP0 */
   movq __V_0(%rip), %rax
   cmpq $0, %rax
   jz __L_0

   /* CALL */
   movq $paramwrlstr, %rdi
   movq $__S_2, %rsi
   call printf

   /* ASS */
   movq value2(%rip), %rax
   movq %rax, value1(%rip)

   /* LABEL */
__L_0:

   /* LABEL */
__L_2:

   /* GTR */
   movq value1(%rip), %rax
   movq $1, %rbx
   cmpq %rbx, %rax
   setge %al
   movzbq %al, %rax
   movq %rax, __V_1(%rip)

   /* JMP0 */
   movq __V_1(%rip), %rax
   cmpq $0, %rax
   jz __L_3

   /* SUB */
   movq value1(%rip), %rax
   movq $1, %rbx
   subq %rbx, %rax
   movq %rax, __V_2(%rip)

   /* ASS */
   movq __V_2(%rip), %rax
   movq %rax, value1(%rip)

   /* CALL */
   movq value1(%rip), %rsi
   movq $paramwrlint, %rdi
   movq $0, %rax
   call printf

   /* GOTO */
   jmp __L_2

   /* LABEL */
__L_3:

   /* LABEL */
__L_4:

   /* SUB */
   movq value2(%rip), %rax
   movq $1, %rbx
   subq %rbx, %rax
   movq %rax, __V_0(%rip)

   /* ASS */
   movq __V_0(%rip), %rax
   movq %rax, value2(%rip)

   /* CALL */
   movq value2(%rip), %rsi
   movq $paramwrlint, %rdi
   movq $0, %rax
   call printf

   /* EQL */
   movq value1(%rip), %rax
   movq value2(%rip), %rbx
   cmpq %rbx, %rax
   sete %al
   movzbq %al, %rax
   movq %rax, __V_0(%rip)

   /* JMP0 */
   movq __V_0(%rip), %rax
   cmpq $0, %rax
   jz __L_4

   /* EQL */
   movq value1(%rip), %rax
   movq value2(%rip), %rbx
   cmpq %rbx, %rax
   sete %al
   movzbq %al, %rax
   movq %rax, __V_1(%rip)

   /* JMP0 */
   movq __V_1(%rip), %rax
   cmpq $0, %rax
   jz __L_5

   /* CALL */
   movq $paramwrlstr, %rdi
   movq $__S_3, %rsi
   call printf

   /* GOTO */
   jmp __L_6

   /* LABEL */
__L_5:

   /* CALL */
   movq $paramwrlstr, %rdi
   movq $__S_4, %rsi
   call printf

   /* ADD */
   movq value2(%rip), %rax
   movq $1, %rbx
   addq %rbx, %rax
   movq %rax, __V_2(%rip)

   /* ASS */
   movq __V_2(%rip), %rax
   movq %rax, value1(%rip)

   /* LABEL */
__L_6:


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
   value1 : .quad 0
   value2 : .quad 0
   value3 : .quad 0
   write : .quad 0
   writeln : .quad 0
   __S_0: .string "Value1 is: "
   __S_1: .string "Value2 is: "
   __S_2: .string "Initial values were not the same."
   __S_3: .string "Values are the same."
   __S_4: .string "Values are not the same."
