close;
disp ('[1] Representar el error en funcion del numero de ciclos.');
disp ('[2] Representar salida deseada frente a salida obtenida.');
opcion = input ('Opcion : ');
  if opcion == 1
     fileid1 = fopen ('ts1-emc');
     error = fscanf (fileid1,'%e');
     x=linspace (1,length(error),length(error));
     plot (x,error);
     grid;
     title ('Variacion del error con el numero de ciclos');
     xlabel ('Ciclos');
     ylabel ('Error');
  end;
  if opcion == 2
     fileid1 = fopen ('ts1-out');
     fileid2 = fopen ('ts1-in');
     dataout = fscanf (fileid1,'%e');
     datain  = fscanf (fileid2,'%e');
     salidadeseada = datain.*4;
     plot (datain,dataout,'g:',datain,salidadeseada,'r-',datain,datain,'c-.');
     grid;
     title ('Salida deseada frente a salida obtenida');
     xlabel ('Entrada');
     ylabel ('Salida');
  end;
  if opcion == 3
     pesos1 = linspace(-4,4,20);
     for i=1:20
        for j=1:20
            %calculamos el error
            error(i,j)=0.1*(4-(1*pesos1(i)))^2+(8 -(2*pesos1(i)))^2+(12-(3*pesos1(i)))^2+(16-(4*pesos1(i)))^2+(20-(5*pesos1(i)))^2+(24-(6*pesos1(i)))^2+(28-(7*pesos1(i)))^2+(32-(8*pesos1(i)))^2+(36-(9*pesos1(i)))^2+(40-(10*pesos1(i)))^2;
        end;
     end;
     plot(pesos1,error);
     title('Caso1: Superficie 3D del error');
  end;
