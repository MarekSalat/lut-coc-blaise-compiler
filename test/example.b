{an example of Blaise code}
program example ( input, output );
    var value1 : integer;
           value2, value3 : integer;
begin
    (* this is a 
    * multiline comment *)
        value1:=11+(-1);
        value2:=3*value1 DIV (1+1)-4;
        write('Value1 is: ');
        writeln(value1);
        write('Value2 is: ');
        writeln(value2);
    if value1<>value2 then
    begin
        writeln('Initial values were not the same.');
        value1:=value2;
    end;
    while value1>1 do
    begin
        value1:=value1-1;
        writeln(value1);
    end;
    repeat
        value2:=value2-1;
        writeln(value2);
    until value1=value2;
    if value1=value2 then
        writeln('Values are the same.');
    else
        writeln('Values are not the same.');
    value1 := value2 + 1;

    value1:= 10;

    write('value1 =  10 = ', value1 =  10, '\n');
    write('value1 =  20 = ', value1 =  20, '\n');
                                          
    write('value1 <> 20 = ', value1 <> 20, '\n');
    write('value1 <> 10 = ', value1 <> 10, '\n');
                        
    write('value1 >= 5  = ', value1 >= 5 , '\n');
    write('value1 >= 10 = ', value1 >= 10, '\n');
                        
    write('value1 >  5  = ', value1 >  5 , '\n');
    write('value1 >  20 = ', value1 >  20, '\n');
                        
    write('value1 <= 20 = ', value1 <= 20, '\n');
    write('value1 <= 5  = ', value1 <= 5 , '\n');
                        
    write('value1 <  20 = ', value1 <  20, '\n');
    write('value1 <  5  = ', value1 <  5 , '\n');

    write('-value1 * 6 = ', -vaLue1 * 6, '\n');

end. 
