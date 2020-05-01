%Incluir la libreria pertinente
include "globals.mzn";

% %Definición de variables
enum Tareas = {A,B,C,D,E,F,G,H,I};
array[Tareas] of int: Duracion = [7,3,1,8,2,1,1,3,2];
array[Tareas] of int: Workers = [1,1,1,1,1,1,1,1,1];
int: available_time = 40;
int: available_workers = 9;

array[Tareas] of var 0..available_time: start;
var 0..available_time: end;


%Condiciones a cumplir

%Tareas Precedentes

constraint start[B] >= Duracion[A]; %A tiene que estar hecho
constraint start[C] >= Duracion[B] + start[B]; %B tiene que estar hecho
constraint start[D] >= Duracion[A]; %A tiene que estar hecho
constraint start[E] >= max(Duracion[C] + start[C], Duracion[D] + start[D]); % C,D tiene que estar hecho
constraint start[F] >= max(Duracion[C] + start[C], Duracion[D] + start[D]); % C,D tiene que estar hecho
constraint start[G] >= max(Duracion[C] + start[C], Duracion[D] + start[D]); % C,D tiene que estar hecho
constraint start[H] >= Duracion[A] + start[A]; %A tiene que estar hecho
constraint start[I] >= max(Duracion[F] + start[F], Duracion[H] + start[H]); % F,H tiene que estar hecho

%Minimizar
constraint cumulative(start , Duracion , Workers, available_workers);
constraint forall(i in Tareas)(start[i] + Duracion[i] <= end);
 
%Resolucion
solve minimize end;
output[show(i) ++": " ++ show(start[i]) ++ "\n" | i in Tareas]++["Tiempo total:" ++ show(end)];

















