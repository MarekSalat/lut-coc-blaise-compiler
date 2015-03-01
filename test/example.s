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

   /* LABEL */
__L_6:

   /* ADD */
   movq value2(%rip), %rax
   movq $1, %rbx
   addq %rbx, %rax
   movq %rax, __V_2(%rip)

   /* ASS */
   movq __V_2(%rip), %rax
   movq %rax, value1(%rip)

   /* ASS */
   movq $10, %rax
   movq %rax, value1(%rip)

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_5, %rsi
   call printf

   /* EQL */
   movq value1(%rip), %rax
   movq $10, %rbx
   cmpq %rbx, %rax
   sete %al
   movzbq %al, %rax
   movq %rax, __V_0(%rip)

   /* CALL */
   movq __V_0(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_6, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_7, %rsi
   call printf

   /* EQL */
   movq value1(%rip), %rax
   movq $20, %rbx
   cmpq %rbx, %rax
   sete %al
   movzbq %al, %rax
   movq %rax, __V_1(%rip)

   /* CALL */
   movq __V_1(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_8, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_9, %rsi
   call printf

   /* NEQ */
   movq value1(%rip), %rax
   movq $20, %rbx
   cmpq %rbx, %rax
   setne %al
   movzbq %al, %rax
   movq %rax, __V_2(%rip)

   /* CALL */
   movq __V_2(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_a, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_b, %rsi
   call printf

   /* NEQ */
   movq value1(%rip), %rax
   movq $10, %rbx
   cmpq %rbx, %rax
   setne %al
   movzbq %al, %rax
   movq %rax, __V_3(%rip)

   /* CALL */
   movq __V_3(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_c, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_d, %rsi
   call printf

   /* GEQ */
   movq value1(%rip), %rax
   movq $5, %rbx
   cmpq %rbx, %rax
   setg %al
   movzbq %al, %rax
   movq %rax, __V_4(%rip)

   /* CALL */
   movq __V_4(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_e, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_f, %rsi
   call printf

   /* GEQ */
   movq value1(%rip), %rax
   movq $10, %rbx
   cmpq %rbx, %rax
   setg %al
   movzbq %al, %rax
   movq %rax, __V_5(%rip)

   /* CALL */
   movq __V_5(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_10, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_11, %rsi
   call printf

   /* GTR */
   movq value1(%rip), %rax
   movq $5, %rbx
   cmpq %rbx, %rax
   setge %al
   movzbq %al, %rax
   movq %rax, __V_6(%rip)

   /* CALL */
   movq __V_6(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_12, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_13, %rsi
   call printf

   /* GTR */
   movq value1(%rip), %rax
   movq $20, %rbx
   cmpq %rbx, %rax
   setge %al
   movzbq %al, %rax
   movq %rax, __V_7(%rip)

   /* CALL */
   movq __V_7(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_14, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_15, %rsi
   call printf

   /* LEQ */
   movq value1(%rip), %rax
   movq $20, %rbx
   cmpq %rbx, %rax
   setl %al
   movzbq %al, %rax
   movq %rax, __V_8(%rip)

   /* CALL */
   movq __V_8(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_16, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_17, %rsi
   call printf

   /* LEQ */
   movq value1(%rip), %rax
   movq $5, %rbx
   cmpq %rbx, %rax
   setl %al
   movzbq %al, %rax
   movq %rax, __V_9(%rip)

   /* CALL */
   movq __V_9(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_18, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_19, %rsi
   call printf

   /* LSS */
   movq value1(%rip), %rax
   movq $20, %rbx
   cmpq %rbx, %rax
   setle %al
   movzbq %al, %rax
   movq %rax, __V_a(%rip)

   /* CALL */
   movq __V_a(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_1a, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_1b, %rsi
   call printf

   /* LSS */
   movq value1(%rip), %rax
   movq $5, %rbx
   cmpq %rbx, %rax
   setle %al
   movzbq %al, %rax
   movq %rax, __V_b(%rip)

   /* CALL */
   movq __V_b(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_1c, %rsi
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_1d, %rsi
   call printf

   /* MUL */
   movq value1(%rip), %rax
   movq $6, %rbx
   imulq %rbx, %rax
   movq %rax, __V_c(%rip)

   /* USUB */
   movq __V_c(%rip), %rax
   negq %rax
   movq %rax, __V_d(%rip)

   /* CALL */
   movq __V_d(%rip), %rsi
   movq $paramwriint, %rdi
   movq $0, %rax
   call printf

   /* CALL */
   movq $paramwristr, %rdi
   movq $__S_1e, %rsi
   call printf


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
   __V_5 : .quad 0
   __V_6 : .quad 0
   __V_7 : .quad 0
   __V_8 : .quad 0
   __V_9 : .quad 0
   __V_a : .quad 0
   __V_b : .quad 0
   __V_c : .quad 0
   __V_d : .quad 0
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
   __S_5: .string "value1 =  10 = "
   __S_6: .string "\n"
   __S_7: .string "value1 =  20 = "
   __S_8: .string "\n"
   __S_9: .string "value1 <> 20 = "
   __S_a: .string "\n"
   __S_b: .string "value1 <> 10 = "
   __S_c: .string "\n"
   __S_d: .string "value1 >= 5  = "
   __S_e: .string "\n"
   __S_f: .string "value1 >= 10 = "
   __S_10: .string "\n"
   __S_11: .string "value1 >  5  = "
   __S_12: .string "\n"
   __S_13: .string "value1 >  20 = "
   __S_14: .string "\n"
   __S_15: .string "value1 <= 20 = "
   __S_16: .string "\n"
   __S_17: .string "value1 <= 5  = "
   __S_18: .string "\n"
   __S_19: .string "value1 <  20 = "
   __S_1a: .string "\n"
   __S_1b: .string "value1 <  5  = "
   __S_1c: .string "\n"
   __S_1d: .string "-value1 * 6 = "
   __S_1e: .string "\n"
