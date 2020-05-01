%Incluir la libreria pertinente
include "globals.mzn";

%Definición de variables 

%Asignaturas
enum Asignaturas = {A1, A2, A3, A4, A5, A6, A7, A8, A9, Recreo};

%Horario
set of int:Franjas = 1..6;
array[Franjas] of var Asignaturas: Lunes;
array[Franjas] of var Asignaturas: Martes;
array[Franjas] of var Asignaturas: Miercoles;
array[Franjas] of var Asignaturas: Jueves;
array[Franjas] of var Asignaturas: Viernes;

%Condiciones
%Recreo
constraint
    Lunes[4] == Recreo /\
    Martes[4] == Recreo /\
    Miercoles[4] == Recreo /\
    Jueves[4] == Recreo /\
    Viernes[4] == Recreo;
    
%A1
var int: CountLA1 = sum([1|i in Franjas where Lunes[i] == A1]);
var int: CountMA1 = sum([1|i in Franjas where Martes[i] == A1]);
var int: CountXA1 = sum([1|i in Franjas where Miercoles[i] == A1]);
var int: CountJA1 = sum([1|i in Franjas where Jueves[i] == A1]);
var int: CountVA1 = sum([1|i in Franjas where Viernes[i] == A1]);
var int: SA1 = CountLA1 + CountMA1 + CountXA1 + CountJA1 + CountVA1;
%Horas Totales
constraint SA1 == 4;
%Horas Por Dia
constraint CountLA1 == 2 \/ CountMA1 == 2 \/ CountXA1 == 2 \/ CountJA1 == 2 \/ CountVA1 == 2;

%A2
var int: CountLA2 = sum([1|i in Franjas where Lunes[i] == A2]);
var int: CountMA2 = sum([1|i in Franjas where Martes[i] == A2]);
var int: CountXA2 = sum([1|i in Franjas where Miercoles[i] == A2]);
var int: CountJA2 = sum([1|i in Franjas where Jueves[i] == A2]);
var int: CountVA2 = sum([1|i in Franjas where Viernes[i] == A2]);
var int: SA2 = CountLA2 + CountMA2 + CountXA2 + CountJA2 + CountVA2;
%Horas Totales
constraint SA2 == 2;
%Horas Por Dia
constraint CountLA2 == 1 \/ CountMA2 == 1 \/ CountXA2 == 1 \/ CountJA2 == 1 \/ CountVA2 == 1;

%A3
var int: CountLA3 = sum([1|i in Franjas where Lunes[i] == A3]);
var int: CountMA3 = sum([1|i in Franjas where Martes[i] == A3]);
var int: CountXA3 = sum([1|i in Franjas where Miercoles[i] == A3]);
var int: CountJA3 = sum([1|i in Franjas where Jueves[i] == A3]);
var int: CountVA3 = sum([1|i in Franjas where Viernes[i] == A3]);
var int: SA3 = CountLA3 + CountMA3 + CountXA3 + CountJA3 + CountVA3;
%Horas Totales
constraint SA3 == 4;
%Horas Por Dia
constraint CountLA3 == 2 \/ CountMA3 == 2 \/ CountXA3 == 2 \/ CountJA3 == 2 \/ CountVA3 == 2;

%A4
var int: CountLA4 = sum([1|i in Franjas where Lunes[i] == A4]);
var int: CountMA4 = sum([1|i in Franjas where Martes[i] == A4]);
var int: CountXA4 = sum([1|i in Franjas where Miercoles[i] == A4]);
var int: CountJA4 = sum([1|i in Franjas where Jueves[i] == A4]);
var int: CountVA4 = sum([1|i in Franjas where Viernes[i] == A4]);
var int: SA4 = CountLA4 + CountMA4 + CountXA4 + CountJA4 + CountVA4;
%Horas Totales
constraint SA4 == 4;
%Horas Por Dia
constraint CountLA4 == 2 \/ CountMA4 == 2 \/ CountXA4 == 2 \/ CountJA4 == 2 \/ CountVA4 == 2;

%A5
var int: CountLA5 = sum([1|i in Franjas where Lunes[i] == A5]);
var int: CountMA5 = sum([1|i in Franjas where Martes[i] == A5]);
var int: CountXA5 = sum([1|i in Franjas where Miercoles[i] == A5]);
var int: CountJA5 = sum([1|i in Franjas where Jueves[i] == A5]);
var int: CountVA5 = sum([1|i in Franjas where Viernes[i] == A5]);
var int: SA5 = CountLA5 + CountMA5 + CountXA5 + CountJA5 + CountVA5;
%Horas Totales
constraint SA5 == 4;
%Horas Por Dia
constraint CountLA5 == 2 \/ CountMA5 == 2 \/ CountXA5 == 2 \/ CountJA5 == 2 \/ CountVA5 == 2;

%A6
var int: CountLA6 = sum([1|i in Franjas where Lunes[i] == A6]);
var int: CountMA6 = sum([1|i in Franjas where Martes[i] == A6]);
var int: CountXA6 = sum([1|i in Franjas where Miercoles[i] == A6]);
var int: CountJA6 = sum([1|i in Franjas where Jueves[i] == A6]);
var int: CountVA6 = sum([1|i in Franjas where Viernes[i] == A6]);
var int: SA6 = CountLA6 + CountMA6 + CountXA6 + CountJA6 + CountVA6;
%Horas Totales
constraint SA6 == 2;
%Horas Por Dia
constraint CountLA6 == 1 \/ CountMA6 == 1 \/ CountXA6 == 1 \/ CountJA6 == 1 \/ CountVA6 == 1;

%A7
var int: CountLA7 = sum([1|i in Franjas where Lunes[i] == A7]);
var int: CountMA7 = sum([1|i in Franjas where Martes[i] == A7]);
var int: CountXA7 = sum([1|i in Franjas where Miercoles[i] == A7]);
var int: CountJA7 = sum([1|i in Franjas where Jueves[i] == A7]);
var int: CountVA7 = sum([1|i in Franjas where Viernes[i] == A7]);
var int: SA7 = CountLA7 + CountMA7 + CountXA7 + CountJA7 + CountVA7;
%Horas Totales
constraint SA7 == 2;
%Horas Por Dia
constraint CountLA7 == 1 \/ CountMA7 == 1 \/ CountXA7 == 1 \/ CountJA7 == 1 \/ CountVA7 == 1;

%A8
var int: CountLA8 = sum([1|i in Franjas where Lunes[i] == A8]);
var int: CountMA8 = sum([1|i in Franjas where Martes[i] == A8]);
var int: CountXA8 = sum([1|i in Franjas where Miercoles[i] == A8]);
var int: CountJA8 = sum([1|i in Franjas where Jueves[i] == A8]);
var int: CountVA8 = sum([1|i in Franjas where Viernes[i] == A8]);
var int: SA8 = CountLA8 + CountMA8 + CountXA8 + CountJA8 + CountVA8;
%Horas Totales
constraint SA8 == 2;
%Horas Por Dia
constraint CountLA8 == 2 \/ CountMA8 == 2 \/ CountXA8 == 2 \/ CountJA8 == 2 \/ CountVA8 == 2;

%A9
var int: CountLA9 = sum([1|i in Franjas where Lunes[i] == A9]);
var int: CountMA9 = sum([1|i in Franjas where Martes[i] == A9]);
var int: CountXA9 = sum([1|i in Franjas where Miercoles[i] == A9]);
var int: CountJA9 = sum([1|i in Franjas where Jueves[i] == A9]);
var int: CountVA9 = sum([1|i in Franjas where Viernes[i] == A9]);
var int: SA9 = CountLA9 + CountMA9 + CountXA9 + CountJA9 + CountVA9;
%Horas Totales
constraint SA9 == 1;
%Horas Por Dia
constraint CountLA9 == 1 \/ CountMA9 == 1 \/ CountXA9 == 1 \/ CountJA9 == 1 \/ CountVA9 == 1;

%A1/A3 No coinciden
constraint forall(i in Franjas)(forall(j in Franjas)(if Lunes[i] == A3 then Lunes[j] != A1 /\ CountLA3 == 2 else if Lunes[i] == A1 then Lunes[j] != A3 /\ CountLA1 == 2 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Martes[i] == A3 then Martes[j] != A1 /\ CountMA3 == 2 else if Martes[i] == A1 then Martes[j] != A3 /\ CountMA1 == 2endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Miercoles[i] == A3 then Miercoles[j] != A1 /\ CountXA3 == 2 else if Miercoles[i] == A1 then Miercoles[j] != A3 /\ CountXA1 == 2 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Jueves[i] == A3 then Jueves[j] != A1 /\ CountJA3 == 2 else if Jueves[i] == A1 then Jueves[j] != A3 /\ CountJA1 == 2 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Viernes[i] == A3 then Viernes[j] != A1 /\ CountVA3 == 2 else if Viernes[i] == A1 then Viernes[j] != A3 /\ CountVA1 == 2 endif endif));

%A4/A5 No coinciden
constraint forall(i in Franjas)(forall(j in Franjas)(if Lunes[i] == A5 then Lunes[j] != A4 /\ CountLA5 == 2 else if Lunes[i] == A4 then Lunes[j] != A5 /\ CountLA4 == 2 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Martes[i] == A5 then Martes[j] != A4 /\ CountMA5 == 2 else if Martes[i] == A4 then Martes[j] != A5 /\ CountMA4 == 2 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Miercoles[i] == A5 then Miercoles[j] != A4 /\ CountXA5 == 2 else if Miercoles[i] == A4 then Miercoles[j] != A5 /\ CountXA4 == 2 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Jueves[i] == A5 then Jueves[j] != A4 /\ CountJA5 == 2 else if Jueves[i] == A4 then Jueves[j] != A5 /\ CountJA4 == 2 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Viernes[i] == A5 then Viernes[j] != A4 /\ CountVA5 == 2 else if Viernes[i] == A4 then Viernes[j] != A5 /\ CountVA4 == 2 endif endif));

%A6/A9 No coinciden
constraint forall(i in Franjas)(forall(j in Franjas)(if Lunes[i] == A9 then Lunes[j] != A6 /\ CountLA9 == 1 else if Lunes[i] == A6 then Lunes[j] != A9 /\ CountLA6 == 1 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Martes[i] == A9 then Martes[j] != A6 /\ CountMA9 == 1 else if Martes[i] == A6 then Martes[j] != A9 /\ CountMA6 == 1 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Miercoles[i] == A9 then Miercoles[j] != A6 /\ CountXA9 == 1 else if Miercoles[i] == A6 then Miercoles[j] != A9 /\ CountXA6 == 1 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Jueves[i] == A9 then Jueves[j] != A6 /\ CountJA9 == 1 else if Jueves[i] == A6 then Jueves[j] != A9 /\ CountJA6 == 1 endif endif));
constraint forall(i in Franjas)(forall(j in Franjas)(if Viernes[i] == A9 then Viernes[j] != A6 /\ CountVA9 == 1 else if Viernes[i] == A6 then Viernes[j] != A9 /\ CountVA6 == 1 endif endif));

%El resto de asignaturas pueden coincidir

%Resolución 
solve satisfy;
output["Lunes   Martes   Miercoles   Jueves   Viernes\n"] ++ [if i != 4 then show(Lunes[i]) ++ "      " ++ show(Martes[i])++ "       " ++show(Miercoles[i])++ "          " ++ show(Jueves[i])++ "       " ++ show(Viernes[i]) ++ "\n" else show(Lunes[i]) ++ "  " ++ show(Martes[i])++ "   " ++show(Miercoles[i])++ "      " ++ show(Jueves[i])++ "   " ++ show(Viernes[i]) ++ "\n" endif |i in Franjas ] 
