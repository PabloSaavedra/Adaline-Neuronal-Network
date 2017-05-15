program may2min;
var
  fi,fo : text;
  s : string;
  i : word;
begin
  writeln('Conversor de mayusculas a minusculas by PSL!');
  if paramcount<>2 then begin
    writeln('Sintaxis: MM <fichEntr> <fichSalid>');
  end else begin
    assign(fi,paramstr(1));
    assign(fo,paramstr(2));
    reset(fi);
    rewrite(fo);
    while not EOF(fi) do begin
      readln(fi,s);
      for i:=1 to Length(s) do begin
        s[i]:=upcase(s[i]);
        if s[i] in ['A'..'Z'] then
           s[i]:=chr(ord(s[i])+32);
      end;
      writeln(fo,s);
    end;
    close(fi);
    close(fo);
  end;
end.