clear all;
Entradas=input('Entradas anteriores ');
Peso=linspace(0,0,Entradas);
Samples=input('Samples. Mayor que Entradas ,(Samples>100 & rem(Samples,4)=0). ');
Intervalo=input('Dame la longitud del intervalo');
SpeedLearning=input('SpeedLearning');
ECMPerm=input('Error permitido ');
IteraMax=input('Maximo numero de iteraciones ');
Intro=linspace(0,0,Entradas);
Peso= Intro;

for i=1:Entradas
Peso(i)=0; %inicializo los pesos.
end;


x=linspace(0,2*pi*Intervalo,Samples);

% cuanto mas bajo sea num entradas peor entrena,evidente joder
% un valor optimo de speedlearning es 0.12
% entradas=5

hold on;
for a=1:Samples
    SenalEntrada(a)=cos(x(a))*(x(a));
end;

SalidaDeseada=SenalEntrada;
  
%i indexa las entradas y j indexa los samples.
for j=2:Samples
for i=-Entradas:-1

if (i+j>0)&(i+j<=Samples) Intro(i+Entradas+1)=SenalEntrada(i+j); end;%if
end;%for
%tenemos en Intro las entradas actuales a la neurona.
%aqui se hara el procesado de la señal.


ECM=1000;

contador=0;
%entreno con el mismo patron hasta que la salida es la deseada.
%si quieres que te entrene una sola vez se le pasa a IteraMax el valor 1
while (ECM>ECMPerm)&(contador<IteraMax) 
contador=contador+1;
net(j-1)=0;
for a=1:Entradas %calculo el net
net(j-1)=net(j-1)+Peso(a)*Intro(a);
end;%for net



%modifico pesos
errorcillo(j-1)=(SalidaDeseada(j)-net(j-1));
for a=1:Entradas
Peso(a)=Peso(a)+SpeedLearning*errorcillo(j-1)*Intro(a);
end;%for modificar
ECM=(errorcillo(j-1))^2;

end;%While

end;%for
hold on;
plot(SalidaDeseada,'y--');

plot(net,'r--');
inputt=input(' ');
close all;
hold off;
plot(errorcillo);