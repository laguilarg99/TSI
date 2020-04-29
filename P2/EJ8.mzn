%Incluir la libreria pertinente
include "globals.mzn";

% %Definición de variables
enum Tareas = {A,B,C,D,E,F,G,H,I};
array[Tareas] of int: Duracion = [7,3,1,8,2,1,1,3,2];
array[Tareas] of int: Workers = [2,3,2,2,1,2,1,1,2];
int: available_time = 1000000000;
int: available_workers = 3;

array[Tareas] of var 0..available_time: start;
var 0..available_time: end;

%Condiciones a cumplir

%Tareas Precedentes
% constraint all_different(start);

constraint start[B] == Duracion[A] + start[A]; %A tiene que estar hecho
constraint start[C] == Duracion[B] + start[B]; %B tiene que estar hecho
constraint start[D] == Duracion[A] + start[A] ; %A tiene que estar hecho
constraint start[E] == Duracion[C] + start[C] + Duracion[D] + start[D]; % C,D tiene que estar hecho
constraint start[F] == Duracion[C] + start[C] + Duracion[D] + start[D]; % C,D tiene que estar hecho
constraint start[G] == Duracion[C] + start[C] + Duracion[D] + start[D]; % C,D tiene que estar hecho
constraint start[H] == Duracion[A] + start[A]; %A tiene que estar hecho
constraint start[I] == Duracion[F] + start[F] + Duracion[H] + start[H]; % F,H tiene que estar hecho

%Minimizar
constraint cumulative(start , Duracion , Workers, available_workers);
constraint forall(i in Tareas)(start[i] + Duracion[i] <= end);
 
%Resolucion
solve minimize end;
output[show(i) ++": " ++ show(start[i]) ++ "\n" | i in Tareas]++["Tiempo total:" ++ show(end)];
%++ ": " ++ show([start[i]|i in Tareas]) ++ "\n"];

















