%Definicion de variables
set of int: NUM = 0..9;
array[NUM] of var 0..10: s;

%Desarrollo del programa
constraint forall (i in NUM) (s[i] = (sum(j in NUM)(bool2int(s[j]=i))));
constraint sum(i in NUM) (s[i]) = 10;
constraint sum(i in NUM)(s[i] * i) = 10;

%Solución
solve satisfy;

%Impresión de la solución
output[ "s = ", show(s), ";\n"];
