%Incluir la libreria pertinente
include "globals.mzn";

% %Definición de variables
enum Tareas = {A,B,C,D,E,F,G,H,I};
array[Tareas] of int: Duracion1 = [4,3,3,2,4,3,1,1,2];
array[Tareas] of int: Duracion2 = [7,5,1,5,2,2,2,3,3];
array[Tareas] of int: Duracion3 = [10,7,4,8,6,1,3,5,4];
array[Tareas] of int: Workers = [1,1,1,1,1,1,1,1,1];
int: available_time = 40;
int: available_workers = 3;

array[Tareas] of var 0..available_time: start;
var 0..available_time: end;


%Condiciones a cumplir

%Tareas Precedentes
% constraint all_different(start);

constraint start[B] >= min(min(Duracion1[A] + start[A], Duracion2[A] + start[A]), Duracion3[A] + start[A]); %A tiene que estar hecho
constraint start[C] >=min(min(Duracion1[B] + start[B], Duracion2[B] + start[B]), Duracion3[B] + start[B]); %B tiene que estar hecho
constraint start[D] >= min(min(Duracion1[A] + start[A], Duracion2[A] + start[A]), Duracion3[A] + start[A]);   %A tiene que estar hecho
constraint start[E] >= min(min( max(Duracion1[C] + start[C],Duracion1[D] + start[D]),max(Duracion2[C] + start[C],Duracion2[D] + start[D])), max(Duracion3[C] + start[C],Duracion3[D] + start[D])); % C,D tiene que estar hecho
constraint start[F] >= min(min( max(Duracion1[C] + start[C],Duracion1[D] + start[D]),max(Duracion2[C] + start[C],Duracion2[D] + start[D])), max(Duracion3[C] + start[C],Duracion3[D] + start[D])); % C,D tiene que estar hecho
constraint start[G] >= min(min( max(Duracion1[C] + start[C],Duracion1[D] + start[D]),max(Duracion2[C] + start[C],Duracion2[D] + start[D])), max(Duracion3[C] + start[C],Duracion3[D] + start[D])); % C,D tiene que estar hecho
constraint start[H] >= min(min(Duracion1[A] + start[A], Duracion2[A] + start[A]), Duracion3[A] + start[A]); %A tiene que estar hecho
constraint start[I] >= min(min( max(Duracion1[F] + start[F],Duracion1[H] + start[H]),max(Duracion2[F] + start[F],Duracion2[H] + start[H])), max(Duracion3[F] + start[F],Duracion3[H] + start[H])); % F,H tiene que estar hecho

%Minimizar
constraint cumulative(start , Duracion1, Workers, available_workers) \/ cumulative(start , Duracion2, Workers, available_workers) \/ cumulative(start , Duracion3, Workers, available_workers) ;
constraint forall(i in Tareas)(start[i] + Duracion1[i] <= end \/ start[i] + Duracion2[i] <= end \/ start[i] + Duracion3[i] <= end);
 
%Resolucion
solve minimize end;
output[show(i) ++": " ++ show(start[i]) ++ "\n" | i in Tareas]++["Tiempo total:" ++ show(end)];

















