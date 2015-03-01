   NOPE   
   NOPE              2
    ASS         factor              2
   NOPE             42
    ASS     flag_magic             42
   NOPE        1000000
    ASS           cols        1000000
   NOPE            100
    ASS           rows            100
   NOPE              0
    ASS          i_col              0
  LABEL          __L_0
    LEQ          __V_0          i_row           rows
   JMP0          __V_0          __L_1
    ADD          __V_1          i_row              1
    ASS          i_row          __V_1
   NOPE              0
    ASS          i_col              0
  LABEL          __L_2
    LEQ          __V_0          i_col           cols
   JMP0          __V_0          __L_3
    ADD          __V_1          i_col              1
    ASS          i_col          __V_1
    EQL          __V_0          i_col              0
   JMP0          __V_0          __L_4
    ADD          __V_1         factor              1
    ASS         factor          __V_1
  LABEL          __L_4
    MUL          __V_0              3           rows
    MUL          __V_1          __V_0          i_row
    DIV          __V_2          __V_1         factor
    MUL          __V_3              3          i_col
    ADD          __V_4          __V_2          __V_3
    ASS          index          __V_4
    DIV          __V_0          i_row             13
    MUL          __V_1         factor             17
    ADD          __V_2          __V_0          __V_1
    SUB          __V_3          index          __V_2
    ASS          index          __V_3
    DIV          __V_0     flag_magic             42
    NEQ          __V_1          __V_0              1
   JMP0          __V_1          __L_6
   NOPE             42
    ASS     flag_magic             42
  LABEL          __L_6
   NOPE              0
    ASS          index              0
   GOTO          __L_2
  LABEL          __L_3
   GOTO          __L_0
  LABEL          __L_1
