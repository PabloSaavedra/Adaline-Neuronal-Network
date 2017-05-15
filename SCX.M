caso=1;
while caso>0,
   clear all;
   disp('** En que caso estas ?');
   disp('[1] Caso 1:  2 patrones; VelApr=0.025; MaxEMC=0.0001; Tendencia OFF');
   disp('[2] Caso 2:  2 patrones; VelApr=0.025; MaxEMC=0.0001; Tendencia ON');
   disp('[3] Caso 3: 10 patrones; VelApr=0.025; MaxEMC=0.0001; Tendencia OFF');
   disp('[4] Caso 4:  2 patrones; VelApr=0.025; MaxEMC=0.0001; Tendencia OFF&ON');
   disp('[0] Salir');
   caso = input ('Caso : ');
%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if caso==1
     close;  			
     pesos1 = linspace(-2,2,20);
     pesos2 = linspace(-2,2,20);
     disp('[1] Caso 1: Representar en 3D la superficie de error');
     disp('[2] Caso 1: Representar en 2D la superficie del error');
     disp('[3] Caso 1: Representar variacion de pesos en la superficie del error');
     disp('[4] Caso 1: Representar variacion del EMC con el tiempo');
     opcion = input ('Opcion : ');
     if opcion == 1
        for i=1:20
           for j=1:20
               %calculamos el error
               error(i,j)=0.5*(4-(3*pesos1(i)+1*pesos2(j)))^2+(5-(1*pesos1(i)+4*pesos2(j)))^2;
           end;
        end;
        surf(pesos1,pesos2,error);
        view(30,30);
	title('Caso1: Superficie 3D del error');
        xlabel('Peso Entrada 1');
        ylabel('Peso Entrada 2');
        zlabel('EMC');
        grid;
     end;

     if opcion == 2
        for i=1:20
           for j=1:20
               %calculamos el error
               error(i,j)=0.5*(4-(3*pesos1(i)+1*pesos2(j)))^2+(5-(1*pesos1(i)+4*pesos2(j)))^2;
           end;
        end;
        surf(pesos1,pesos2,error);
        view(2);
        title('Caso1: Superficie 2D del error');
     end;

     if opcion == 3
        %Abrimos los ficheros necesarios...
        fileid1 = fopen ('c1-p1');
        fileid2 = fopen ('c1-p2');
        fileid3 = fopen ('c1-emc');
        file1dat = fscanf (fileid1,'%e');
        file2dat = fscanf (fileid2,'%e');
        file3dat = fscanf (fileid3,'%e');
        for i=1:20
           for j=1:20
              %calculamos el error
              error(i,j)=0.5*(4-(3*pesos1(i)+1*pesos2(j)))^2+(5-(1*pesos1(i)+4*pesos2(j)))^2;
           end;
        end;
        surf(pesos1,pesos2,error);
        view(2);
        hold on;
        plot3 (file1dat,file2dat,file3dat);
        title('Caso1: Variacion de pesos en la superficie del error');
     end;

     if opcion == 4
        fileid3 = fopen ('c1-emc');
        file3dat = fscanf (fileid3,'%e');
        x = length(file3dat);
        y = linspace(1,x,x);
        plot (y,file3dat);
        grid;
        title('Caso1: Variacion del EMC respecto al tiempo');
        xlabel('Interaciones');
        ylabel('Errores');
     end;
   end;
%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if caso==2,
      pesos1 = linspace(-2,2,20);
      pesos2 = linspace(-2,2,20);
      fileid3 = fopen ('c1t-emc');
      file3dat = fscanf (fileid3,'%e');
      x = length(file3dat);
      y = linspace(1,x,x);
      plot (y,file3dat);
      title('Caso2: Variacion del EMC respecto al tiempo tendenc.');
      xlabel('Interaciones');
      ylabel('Errores');
   end;
%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if caso==3,
      pesos1 = linspace(-2,2,20);
      pesos2 = linspace(-2,2,20);
      disp('[1] Caso 3: Representar en 3D la superficie de error');
      disp('[2] Caso 3: Representar en 2D la superficie del error');
      disp('[3] Caso 3: Representar variacion de pesos en la superficie del error');
      disp('[4] Caso 3: Representar variacion del EMC con el tiempo');
      opcion = input ('Opcion : ');
      if opcion == 1
         for i=1:20
            for j=1:20
                error(i,j)=0.1*(8-(5*pesos1(i)+3*pesos2(j)))^2+(6-(2*pesos1(i)+4*pesos2(j)))^2+(5-(3*pesos1(i)+2*pesos2(j)))^2+(7-(1*pesos1(i)+6*pesos2(j)))^2+(9-(7*pesos1(i)+2*pesos2(j)))^2+(6-(1*pesos1(i)+5*pesos2(j)))^2+(3-(1*pesos1(i)+2*pesos2(j)))^2+(6-(4*pesos1(i)+2*pesos2(j)))^2+(6-(3*pesos1(i)+3*pesos2(j)))^2+(8-(2*pesos1(i)+6*pesos2(j)))^2;
            end;
         end;
         surf(pesos1,pesos2,error);
         view(30,30);
         title('Caso3: Superficie 3D del error');
         xlabel('Peso Entrada 1');
         ylabel('Peso Entrada 2');
         zlabel('EMC');
         grid;
      end;
      if opcion == 2
         for i=1:20
            for j=1:20
                error(i,j)=0.1*(8-(5*pesos1(i)+3*pesos2(j)))^2+(6-(2*pesos1(i)+4*pesos2(j)))^2+(5-(3*pesos1(i)+2*pesos2(j)))^2+(7-(1*pesos1(i)+6*pesos2(j)))^2+(9-(7*pesos1(i)+2*pesos2(j)))^2+(6-(1*pesos1(i)+5*pesos2(j)))^2+(3-(1*pesos1(i)+2*pesos2(j)))^2+(6-(4*pesos1(i)+2*pesos2(j)))^2+(6-(3*pesos1(i)+3*pesos2(j)))^2+(8-(2*pesos1(i)+6*pesos2(j)))^2;
            end;
         end;
         surf(pesos1,pesos2,error);
         view(2);
         title('Caso3: Superficie 2D del error');
      end;
      if opcion == 3
         fileid1 = fopen ('c3-p1');
         fileid2 = fopen ('c3-p2');
         fileid3 = fopen ('c3-emc');
         file1dat = fscanf (fileid1,'%e');
         file2dat = fscanf (fileid2,'%e');
         file3dat = fscanf (fileid3,'%e');
         for i=1:20
            for j=1:20
                error(i,j)=0.1*(8-(5*pesos1(i)+3*pesos2(j)))^2+(6-(2*pesos1(i)+4*pesos2(j)))^2+(5-(3*pesos1(i)+2*pesos2(j)))^2+(7-(1*pesos1(i)+6*pesos2(j)))^2+(9-(7*pesos1(i)+2*pesos2(j)))^2+(6-(1*pesos1(i)+5*pesos2(j)))^2+(3-(1*pesos1(i)+2*pesos2(j)))^2+(6-(4*pesos1(i)+2*pesos2(j)))^2+(6-(3*pesos1(i)+3*pesos2(j)))^2+(8-(2*pesos1(i)+6*pesos2(j)))^2;
            end;
         end;
         surf(pesos1,pesos2,error);
         view(2);
         hold on;
         plot3 (file1dat,file2dat,file3dat);
        title('Caso3: Variacion de pesos en la superficie del error');
      end;
      if opcion == 4
         fileid3 = fopen ('c3-emc');
         file3dat = fscanf (fileid3,'%e');
         x = length(file3dat);
         y = linspace(1,x,x);
         plot (y,file3dat);
         grid;
         title('Caso3: Variacion del EMC respecto al tiempo');
         xlabel('Interaciones');
         ylabel('Errores');
      end;
   end;
%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if caso==4,
      pesos1 = linspace(-2,2,20);
      pesos2 = linspace(-2,2,20);
      disp('[1] Representar en 3D la superficie de error');
      disp('[2] Representar en 2D la superficie del error');
      disp('[3] Representar variacion de pesos en la superficie del error');
      disp('[4] Representar variacion del EMC con el tiempo sin tendencia');
      disp('[5] Representar variacion de pesos en la superficie del error');
      disp('[6] Representar variacion del EMC con el tiempo con tendencia');
      opcion = input ('Opcion : ');
      if opcion == 1
         for i=1:20
            for j=1:20
                error(i,j)=0.5*(8-(5*pesos1(i)+3*pesos2(j)))^2+(6-(2*pesos1(i)+4*pesos2(j)))^2;
            end;
         end;
         surf(pesos1,pesos2,error);
         view(30,30);
         title('Caso4: Superficie 3D del error');
         xlabel('Peso Entrada 1');
         ylabel('Peso Entrada 2');
         zlabel('EMC');
         grid;
      end;
      if opcion == 2
         for i=1:20
            for j=1:20
                error(i,j)=0.5*(8-(5*pesos1(i)+3*pesos2(j)))^2+(6-(2*pesos1(i)+4*pesos2(j)))^2;
            end;
         end;
         surf(pesos1,pesos2,error);
         view(2);
         title('Caso4: Superficie 2D del error');
      end;
      if opcion == 3
         fileid1 = fopen ('c4-p1');
         fileid2 = fopen ('c4-p2');
         fileid3 = fopen ('c4-emc');
         file1dat = fscanf (fileid1,'%e');
         file2dat = fscanf (fileid2,'%e');
         file3dat = fscanf (fileid3,'%e');
         for i=1:20
            for j=1:20
                error(i,j)=0.5*(8-(5*pesos1(i)+3*pesos2(j)))^2+(6-(2*pesos1(i)+4*pesos2(j)))^2;
            end;
         end;
         surf(pesos1,pesos2,error);
         view(2);
         hold on;
         plot3 (file1dat,file2dat,file3dat);
         title('Caso4: Variacion de pesos en la superficie del error');
      end;
      if opcion == 4
         fileid3 = fopen ('c4-emc');
         file3dat = fscanf (fileid3,'%e');
         x = length(file3dat);
         y = linspace(1,x,x);
         plot (y,file3dat);
         grid;
         title('Caso4: Variacion del EMC respecto al tiempo');
         xlabel('Interaciones');
         ylabel('Errores');
      end;
      if opcion == 5
         fileid1 = fopen ('c4t-p1');
         fileid2 = fopen ('c4t-p2');
         fileid3 = fopen ('c4t-emc');
         file1dat = fscanf (fileid1,'%e');
         file2dat = fscanf (fileid2,'%e');
         file3dat = fscanf (fileid3,'%e');
         for i=1:20
            for j=1:20
                error(i,j)=0.5*(8-(5*pesos1(i)+3*pesos2(j)))^2+(6-(2*pesos1(i)+4*pesos2(j)))^2;
            end;
         end;
         surf(pesos1,pesos2,error);
         view(2);
         hold on;
         plot3 (file1dat,file2dat,file3dat);
         title('Caso4: Variacion pesos en superficie de error tendenc.');
      end;
      if opcion == 6
         fileid3 = fopen ('c4t-emc');
         file3dat = fscanf (fileid3,'%e');
         x = length(file3dat);
         y = linspace(1,x,x);
         plot (y,file3dat);
         grid;
         title('Caso3: Variacion del EMC respecto al tiempo tendenc.');
         xlabel('Interaciones');
         ylabel('Errores');
      end;
   end;
end;

