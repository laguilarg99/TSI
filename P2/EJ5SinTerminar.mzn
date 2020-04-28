%Incluir la libreria pertinente
include "globals.mzn";

%Definición de variables 

%Asignaturas
set of int:Asignaturas = 1..9;
array[Asignaturas] of int: Horas = [4,2,4,4,4,2,2,2,1];
array[1..5] of int: Bloque2 =[1,3,4,5,8];

%A2, A7, A8 Prof 4 Se pueden repetir

%Horario
set of int:AsigRecreo = 0..9;
set of int:Franjas = 1..6;
set of int:Dias = 1..5;
array[Franjas, Dias] of var AsigRecreo: Horario;


%Condiciones a cumplir

%Recreo -> 0 lo representa
constraint forall(S in Dias)(Horario[4,S] == 0);

%Se cumplen las horas minimas a la semana
constraint 



%Resolución 
solve satisfy;
output[show(Horario[i,j]) ++if j == 5 then "\n" else "   " endif | i in Franjas, j in Dias]


