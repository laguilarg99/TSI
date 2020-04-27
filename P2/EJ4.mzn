%Incluir la libreria pertinente
include "globals.mzn";

%Definición de variables 

%Cada grupo con sus asignaturas
set of int: Grupo = 1..4;
set of int: Asignatura = 1..3; % 1 -> IA | 2 -> TSI | 3 -> FBD
set of int: Hora = 9..12; %Horario docente
array[Asignatura, Grupo] of var Hora: AsigGrupo;

%Cada profesor tendrá su propia clase  Prof 1 -> Clase 1

%Creamos un array de asignaturas para la salida
array[Asignatura] of string: Asignaturas = ["IA","TSI", "FBD"];

%Condiciones a cumplir

%Horas no disponibles por los profesores 2 y 4
constraint forall(i in 1..2, j in 3..4)(AsigGrupo[3,i] != 10 /\ AsigGrupo[1,j] != 9);

%Horas distintas para que las asignaturas no coincidan
constraint all_different([AsigGrupo[i,1]|i in Asignatura]);
constraint all_different([AsigGrupo[i,2]|i in Asignatura]);
constraint all_different([AsigGrupo[i,3]|i in Asignatura]);

%Horas distintas para que los profesores no coincidan 
constraint all_different([AsigGrupo[i,j]| i in 1..2, j in 1..2]);
constraint all_different([AsigGrupo[i,j]| i in 2..3, j in 3..4]);


%Resolución 
solve satisfy;

output["Grupo   1       2       3       4\n\(Asignaturas[1])  "] ++ [show(AsigGrupo[i,j]) ++ "-" ++ show(AsigGrupo[i,j]+1) ++if j == 4 /\ i+1 <= 3 then "\n\(Asignaturas[i+1]) " else "   " endif | i in Asignatura, j in Grupo]++ ["\n"]++ ["Profesor 1: "]++[show(AsigGrupo[i,j]) ++ "-" ++ show(AsigGrupo[i,j]+1)  ++ if i!=0 then " " else "" endif| i in 1..2, j in 1..2]++ ["\n"]++ ["Profesor 2: "]++[show(AsigGrupo[i,j]) ++ "-" ++ show(AsigGrupo[i,j]+1)  ++ if i!=0 then " " else "" endif| i in 3..3, j in 1..2]++ ["\n"]++ ["Profesor 3: "]++[show(AsigGrupo[i,j]) ++ "-" ++ show(AsigGrupo[i,j]+1)  ++ if i!=0 then " " else "" endif| i in 2..3, j in 3..4]++ ["\n"]++ ["Profesor 4: "]++[show(AsigGrupo[i,j]) ++ "-" ++ show(AsigGrupo[i,j]+1)  ++ if i!=0 then " " else "" endif| i in 1..1, j in 3..4];


