program Pas2unix;
var
  fi,fo : text;
  s,s1 : string;
  i : word;
Procedure BuscarPalabras;
  var
    p,q : byte;
  begin
    readln(fi,s);

    p:=pos('word',s);
    if p<>0 then begin
      delete(s,p,length('word'));
      insert('integer',s,p);
      writeln(' Encontrado WORD sustituido por INTEGER');
    end;

    p:=pos('assign',s);
    if p<>0 then begin
      p:=pos(',',s);
      q:=pos(')',s);
      s1:=copy(s,p,q-p);
      s:='';
      writeln(' Encontrado ASSIGN ...');
    end;

    p:=pos('reset',s);
    {si no encuentra reset}
    if p=0 then begin
      {busca rewrite}
      p:=pos('rewrite',s);
      {si encuentra rewrite}
      if p<>0 then begin
        p:=pos(')',s);
        insert(s1,s,p);
        writeln('                A¤adiendo en REWRITE');
      end;
    end else begin
    { si encuentra reset }
      p:=pos(')',s);
      insert(s1,s,p);
      writeln('                  A¤adiendo en RESET');
    end;

    p:=pos('longint',s);
    if p<>0 then begin
      delete(s,p,length('longint'));
      insert('integer',s,p);
      writeln(' Encontrado LONGINT sustituido por INTEGER');
    end;

    p:=pos('val',s);
    if p=0 then p:=pos('str',s);
    if p=0 then p:=pos('copy',s);
    if p=0 then p:=pos('delete',s);
    if p=0 then p:=pos('uses',s);
    if p<>0 then begin
      writeln(' Posible instruccion incorrecta: VAL,STR,COPY,DELETE,USES');
      Writeln(s);
      readln;
    end;

    writeln(fo,s);
  end;

begin
  writeln('Conversor de Pascal 6.x a Pascal Unix by PSL!');
  if paramcount<>2 then begin
     writeln('Sintaxis: PAS2UNIX <FichIn> <FichOut>');
  end else begin
    assign(fi,paramstr(1));
    assign(fo,paramstr(2));
    reset(fi);
    rewrite(fo);
    while not EOF(fi) do begin
      buscarpalabras;
    end;
    close(fi);
    close(fo);
  end;
end.