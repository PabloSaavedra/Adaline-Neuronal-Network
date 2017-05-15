program sistemasconexionistas;
const
  maxdatos    = 10;
  maxpatrones = 10;
type

  tdatos = array [1..maxdatos] of real;        { tipo para entradas y pesos en la neurona }
  tpatrentr = array [1..maxpatrones] of tdatos;{ tipo para guardar los patrones de entrada }
  tsalidad = array [1..maxpatrones] of real;   { tipo para guardar las salidas deseadas }

  ppe = ^tpe;  { Puntero PE }
  tpe = record  { tipo pe = elemento de procesado }
        entr      : tdatos;    {array de entradas}
        peso      : tdatos;    {array de pesos}
        vactiv    : real;      {se¤al de activacion}
        salida    : real;      {salida}
        tendencon : boolean;   {indica si la tendencia esta activa}
        tendencia : real;      {valor de la tendencia}
        entrenada : boolean;   {la neurona esta entrenada}
        enlace    : ppe;       {enlace con el siguiente PE}
  end;{tpe}

  preal = ^treal;           { Dato para crear una lista de reales }
  treal = record            { en la que se guardaran los valores  }
          dato: real;       { sucesivos de la variacion de pesos  }
          enlace : preal;   { en funcion del tiempo.              }
  end;

  tfichtxt = text;

var
  velaprend        : real;      { velocidad de aprendizaje }
  maxerror         : real;      { error maximo permitido }
  neurona          : tpe;       { una neurona }
  patrentr         : tpatrentr; { array de patrones de entrada }
  salidad          : tsalidad;  { array de salidas deseadas }
  patronactivo     : boolean;   { dice si hay un patron de entrenamiento cargado }
  NumDatos         : integer;   { numero de datos(entradas neurona,datos por patron }
  NumPatrones      : integer;   { numero de patrones de entrenamiento }

  fichpesos        : tfichtxt;  { fichero de pesos }
  ficherror        : tfichtxt;  { fichero de errores }
  nfichpesos       : string;    { nombre fichero de pesos }
  nficherror       : string;    { nombre fichero de errores }

  grabaerror       : boolean;   { dice si se graban los EMC }
  grabapesos       : boolean;   { dice si se graban los pesos sucesivos }
  tecla            : char;      { tecla para el menu de opciones }
  fin              : boolean;   { fin de programa }

{***************************************************************************}
procedure inicvar;
  begin
    velaprend:=0.025;
    maxerror:=0.0001;
    NumDatos    :=0;
    NumPatrones :=0;
    grabaerror:=false;
    grabapesos:=false;
  end;
{***************************************************************************}
procedure calcsalida(var neurona : tpe);
{ calcula la salida de la neurona }
  procedure calcvactiv(var neurona : tpe);
  { calcula el valor de activacion }
    function neto (neurona : tpe): real;
    { calcula el valor neto }
      var i     : integer;
          valor : real;
      begin
        valor:=0;
        for i:=1 to numdatos do begin
          valor:=valor+(neurona.entr[i]*neurona.peso[i]);
        end;
        if neurona.tendencon then valor:=valor+neurona.tendencia;
        neto:=valor;
      end;
    begin
      neurona.vactiv:=neto(neurona);
    end;
  begin
    calcvactiv(neurona);
    neurona.salida:=neurona.vactiv;
  end;
{***************************************************************************}
procedure inicneurona( var neurona : tpe );
  var i : integer;
  begin
    for i:=1 to numdatos do begin
      neurona.peso[i]:=random(3);
      neurona.entr[i]:=0;
    end;
    neurona.tendencia:=random(3);
    neurona.vactiv:=0;
    neurona.salida:=0;
    neurona.entrenada:=false;
  end;
{***************************************************************************}
procedure introentrenamiento;
  var
      tecla : char;
  {-------------------------------------}
  procedure introducirpatrones;
    var i,j : integer;
    begin
      write('introduzca numero de patrones: ');readln(numpatrones);
      write('introduzca numero entradas : ');readln(numdatos);
      for i:=1 to numpatrones do begin
        for j:=1 to numdatos do begin
          write('introduzca patron ',i:2,', dato ',j:2,' : ');
          readln(patrentr[i,j]);
        end;
        write('introduzca salida deseada : ');
        readln(salidad[i]);
      end;
      patronactivo:=true;
    end;
  {-------------------------------------}
  procedure leerpatronesfich;
    var  i,j : integer;
    begin
      write('introduzca nombre del fichero: ');
      readln(nfichpesos);
      assign(fichpesos,nfichpesos);
      reset(fichpesos);
      readln(fichpesos,numpatrones);
      readln(fichpesos,numdatos);
      for i:=1 to numpatrones do begin
        for j:=1 to numdatos do begin
          readln(fichpesos,patrentr[i,j]);
        end;
        readln(fichpesos,salidad[i]);
      end;
      close(fichpesos);
      patronactivo:=true;
    end;
  {-------------------------------------}
  procedure leerpesosfich;
    var i : integer;
    begin
      write('introduzca nombre del fichero: ');
      readln(nfichpesos);
      assign(fichpesos,nfichpesos);
      reset(fichpesos);
      readln(fichpesos,numdatos);
      for i:=1 to numdatos do begin
        read(fichpesos,neurona.peso[i]);
      end;
      close(fichpesos);
      patronactivo:=true;
      neurona.entrenada:=true;
      writeln('entrenamiento no realizado.');
      writeln('pesos asignados a la neurona');
    end;
  {-------------------------------------}
  procedure grabarpatrfich;
    var  i,j : integer;
    begin
      write('introduzca nombre del fichero: ');
      readln(nfichpesos);
      assign(fichpesos,nfichpesos);
      rewrite(fichpesos);
      writeln(fichpesos,numpatrones);
      writeln(fichpesos,numdatos);
      for i:=1 to numpatrones do begin
        for j:=1 to numdatos do begin
          writeln(fichpesos,patrentr[i,j]);
        end;
        writeln(fichpesos,salidad[i]);
      end;
      close(fichpesos);
    end;
  {-------------------------------------}
  begin
    writeln('** CAMBIAR PATRON DE ENTRENAMIENTO **');
    writeln('         [1] introducir patrones manualmente.');
    writeln('         [2] leer patrones de fichero.');
    writeln('         [3] leer pesos ya calculados y no hacer entrenamiento');
    writeln('         [4] grabar patron de entrenamiento a fichero');
    writeln('         [0] volver al menu principal.');
    write('  opcion:');readln(tecla);
    case tecla of
       '1':introducirpatrones;
       '2':leerpatronesfich;
       '3':leerpesosfich;
       '4':grabarpatrfich;
    end;
  end;

{***************************************************************************}
procedure entrenarneurona;
  var
    finentrenamiento : boolean;   { el entrenamiento ha acabado }
    interacciones    : integer;   { numero de interacciones en entrenamiento }
    emc              : real;      { error medio cuadratico }
    errores          : tsalidad;  { array de errores }
    error_actual     : real;      { error al aplicar el patron actual }
    opcion           : char;
    cpatron          : integer;   { contador de patrones de entrada }
    i,j,k,l          : integer;
    nombrfich        : array [1..MaxDatos] of string;
    listareal        : preal;     { lista donde guardaremos los pesos en el tiempo }
    valor            : real;      { valor que tomamos de la lista }
  {-------------------------------------}
    procedure calcemc;
      var i : integer;
       begin
         for i:=1 to numpatrones do begin
           emc:=emc+errores[i];
         end;
         emc:=emc/numpatrones;
       end;
  {-------------------------------------}
    procedure ponerpatron ( var neurona : tpe ;patron : tdatos ;salidad : real );
                                          { patron que le llega, salida deseada}
      var i : integer;
      begin
        for i:=1 to numdatos do begin
          neurona.entr[i]:=patron[i];
        end;
        {calculamos la salida}
        calcsalida(neurona);
        error_actual:=salidad-neurona.salida;
        errores[cpatron]:=sqr(error_actual);
      end;
  {-------------------------------------}
    procedure cambiarpesos(var neurona : tpe);
      var i : integer;
      begin
        for i:=1 to numdatos do begin
          neurona.peso[i]:=neurona.peso[i]+2*velaprend*error_actual*neurona.entr[i];
        end;
        if neurona.tendencon then
           neurona.tendencia:=neurona.tendencia+2*velaprend*error_actual;
      end;
  {-------------------------------------}
    procedure iniclista(var lista : preal);
      begin
        lista:=nil;
      end;
  {-------------------------------------}
    procedure meterenlista(var lista : preal;dato : real);
      var buscafin : preal;
          nuevo : preal;
      begin
        new(nuevo);
        nuevo^.dato:=dato;
        nuevo^.enlace:=nil;
        if lista=NIL then
           lista:=nuevo
        else begin
           buscafin:=lista;
           while buscafin^.enlace<>nil do begin
             buscafin:=buscafin^.enlace;
           end;
           buscafin^.enlace:=nuevo;
        end;
      end;
  {-------------------------------------}
    function cogerdatolista(lista : preal;pos : integer):real;
      var i : integer;
      begin
        if lista<>NIL then begin
           for i:=2 to pos do
             lista:=lista^.enlace;
           cogerdatolista:=lista^.dato;
        end;
      end;
  {------ e n t r e n a m i e n t o ----}
  begin
    if not patronactivo then begin
      writeln('no hay ningun patron de entrenamiento cargado.');
    end else begin
      if grabaerror then begin
         write('introduzca nombre del fichero de EMC : ');
         readln(nficherror);
         assign(ficherror,nficherror);
         rewrite(ficherror);
      end;
      inicneurona(neurona);
      if grabapesos then begin
         for i:=1 to NumDatos do begin
           write('introduzca nombre del fichero de pesos Entrada ',i,' : ');
           readln(nombrfich[i]);
         end;
         iniclista(listareal);
         for i:=1 to NumDatos do
           meterenlista(listareal,neurona.peso[i]);
      end;
      write('  quiere tendencia (s/n) ? ');
      readln(opcion);
      if opcion='s' then neurona.tendencon:=true else neurona.tendencon:=false;
      interacciones:=0;
      emc:=0;
      finentrenamiento:=false;
      writeln('entrenando neurona.');
      while not finentrenamiento do begin
        cpatron:=1;
        while cpatron<=numpatrones do begin
          ponerpatron(neurona,patrentr[cpatron],salidad[cpatron]);
          cambiarpesos(neurona);
          cpatron:=cpatron+1;
        end;
        interacciones:=interacciones+1;
        calcemc;
        writeln('en la interaccion ',interacciones,' el emc ha sido ',emc);
        if grabaerror=true then write(ficherror,emc);
        if grabapesos then begin
           for i:=1 to NumDatos do
             meterenlista(listareal,neurona.peso[i]);
        end;
        if emc<maxerror then finentrenamiento:=true;
        emc:=0;
      end;
      neurona.entrenada:=true;
      writeln('neurona entrenada.');
      writeln('los pesos son : w1=',neurona.peso[1],';  w2=',neurona.peso[2]);
      tecla:='a';
      if grabapesos then begin
         k:=3;
         for i:=1 to numdatos do begin
           l:=k;
           assign(fichpesos,nombrfich[i]);
           rewrite(fichpesos);
           for j:=1 to interacciones do begin
             valor:=cogerdatolista(listareal,l);
             write(fichpesos,valor);
             l:=l+numdatos;
           end;
           close(fichpesos);
           k:=k+1;
         end;
      end;
      if grabaerror then close(ficherror);
    end;
  end;
{***************************************************************************}
procedure probarneurona;
  var i : integer;
  begin
    if neurona.entrenada then begin
      for i:=1 to numdatos do begin
        write('introduzca el dato ',i,': ');
        readln(neurona.entr[i]);
      end;
      calcsalida(neurona);
      writeln ('salida =',neurona.salida);
    end else begin
      writeln('la neurona no ha sido entrenada');
    end;
  end;
{***************************************************************************}
procedure guardarpesos;
  var i : integer;
  begin
    write('introduzca nombre del fichero: ');
    readln(nfichpesos);
    assign(fichpesos,nfichpesos);
    rewrite(fichpesos);
    writeln(fichpesos,numdatos);
    for i:=1 to numdatos do begin
      write(fichpesos,neurona.peso[i]);
    end;
    close(fichpesos);
  end;
{***************************************************************************}
procedure verpatrentr;
  var i,j : integer;
  begin
    for i:=1 to numpatrones do begin
      write('patron ',i:2,': ');
      for j:=1 to numdatos do begin
        write(patrentr[i,j]:5:3,',');
      end;
      writeln(' -> salida deseada: ',salidad[i]:5:3);
    end;
  end;
{***************************************************************************}
procedure introvelaprend;
  begin
    write('introduzca nueva velocidad de aprendizaje: ');
    readln(velaprend);
  end;
{***************************************************************************}
procedure intromaxerror;
  begin
    write('introduzca nuevo error maximo: ');
    readln(maxerror);
  end;
{********************** p r i n c i p a l **********************************}
begin
  fin:=false;
  patronactivo:=false;
  inicvar;
  while not fin do begin
    writeln;
    writeln('**** Practica de Sistemas Conexionistas por Pablo Saavedra Lopez ****');
    writeln('Menu Principal : ');
    writeln('         [1] entrenar neurona');
    writeln('         [2] probar la neurona');
    writeln('         [3] guardar pesos neurona en fichero');
    writeln('         [4] elegir patrones entrenamiento');
    writeln('         [5] ver patron de entrenamiento actual');
    writeln('         [6] cambiar velocidad de aprendizaje ',velaprend:7:5);
    writeln('         [7] cambiar error maximo permitido ',maxerror:7:5);
    writeln('         [8] grabar EMC sucesivo a fichero = ',grabaerror);
    writeln('         [9] grabar pesos sucesivos a fichero = ',grabapesos);
    writeln('         [0] salir.');
    write('  opcion:');readln(tecla);
    case tecla of
       '1':entrenarneurona;
       '2':probarneurona;
       '3':guardarpesos;
       '4':introentrenamiento;
       '5':verpatrentr;
       '6':introvelaprend;
       '7':intromaxerror;
       '8':grabaerror:=not(grabaerror);
       '9':grabapesos:=not(grabapesos);
       '0':fin:=true;
    end;
  end;
end.
