program some_name ( input, output );
    var cols, rows, i_col, i_row, index, factor, flag_magic;
begin 
	factor := 2;
	flag_magic := 3*7+21;

	cols := 1000000;
	rows := 100;

	i_row:=0;
	while i_row <= rows do begin
		i_row := i_row + 1;
		i_col:=0;

		while i_col <= cols do begin	
			i_col := i_col + 1; 

			if i_col = 0 then begin
				factor := factor+1;	
			end;

			index := 3*rows*i_row DIV factor + 3*i_col;
			index := index - (i_row DIV 13 + factor * 17);

			if flag_magic DIV 42 <> 1 then begin
				flag_magic := 42;
			end;

			(*
				writeln(index);
			*)

			index := 0;
		end	
	end
end.