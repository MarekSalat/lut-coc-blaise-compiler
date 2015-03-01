program some_name ( input, output );
	{   r8	  r9    r10    r11    r12    r13     r14  r15    }
    var cols, rows, i_col, i_row, index, factor, tmp, i_colx3;
begin 
	factor := 2;

	cols := 1000000;
	rows := 100;

	i_row:=0;
	while i_row <= rows do begin
		i_row := i_row + 1;
		i_col:=0;

		factor := factor+1;	

		{tmp := 3*rows*i_row DIV factor - (i_row DIV 13 + factor * 17);}
		{unwrapped just for reducing temporary variables in assembly code}
		tmp := 3*rows;
		tmp := tmp*i_row;
		tmp := tmp DIV factor;
		tmp := tmp - i_row DIV 13;
		tmp := tmp - factor * 17;

		i_colx3 := 0;

		while i_col <= cols do begin	
			i_col := i_col + 1; 
			i_colx3 := i_colx3 + 3;

			index := tmp + i_colx3;

			(*
				writeln(index);
			*)
		end	
	end
end.