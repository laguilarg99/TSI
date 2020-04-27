%Incluir la libreria pertinente
include "globals.mzn";

%Definición de variables 
set of int: Profesor = 1..6;
set of int: Horas = 9..14;
array[Profesor] of var Horas: Asignacion;

%Desarrollo de la asignacion
constraint alldifferent(Asignacion);
constraint Asignacion[1] >= 11 /\ Asignacion[1] < 15;
constraint Asignacion[2] >= 11 /\ Asignacion[2] < 13;
constraint Asignacion[3] >= 10 /\ Asignacion[3] < 14;
constraint Asignacion[4] >= 10 /\ Asignacion[4] < 13;
constraint Asignacion[5] >= 11 /\ Asignacion[5] < 13;
constraint Asignacion[6] >= 9  /\ Asignacion[6] < 15;

%Resolución 
solve satisfy;
output["Profesor \(i) = \(Asignacion[i])-\(Asignacion[i] + 1) \n" | i in Profesor];
