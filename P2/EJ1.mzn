% Importa la librería oportuna para la función alldifferent
include "globals.mzn";

%Dominio de cada una de las variables
var 0..9: A; var 0..9: D; var 0..9: E; var 0..9: F; var 0..9: I;
var 0..9: K; var 0..9: N; var 0..9: R; var 0..9: S; var 0..9: T;

%Suma
constraint 10000*T + 1000*E + 100*S + 10*T + 1*E
          +10000*F + 1000*E + 100*S + 10*T + 1*E
          +10000*D + 1000*E + 100*I + 10*N + 1*E
= 100000*K+10000*R + 1000*A + 100*F + 10*T + 1*E;

%Cada uno de los valores debe ser diferente
constraint alldifferent([A,D,E,F,I,K,N,R,S,T]);

% Resuelva
solve satisfy;

%Impresión de la solucion
output["    ",show(T),show(E),show(S),show(T),show(E),"          ","T","E","S","T","E","\n",
      "+   ",show(F),show(E),show(S),show(T),show(E),"       +  ","F","E","S","T","E","\n",
      "+   ",show(D),show(E),show(I),show(N),show(E),"       +  ","D","E","I","N","E","\n",
      "  =========      =========\n",
      "   ",show(K),show(R),show(A),show(F),show(T),show(E),"         ","K","R","A","F","T","E","\n"];

