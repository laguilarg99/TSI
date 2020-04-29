%Incluir la libreria pertinente
include "globals.mzn";

%Definición de variables 

%Rango de Items
set of int: objetos = 1..12; %objetos: mapa, compas, agua, sandwich, azuca, lata, platano, manzana, queso, cerveza, protector_solar, camara

%Preferencia sobre cada objeto
array[objetos] of int: Preferencia = [150,35,200,160,60,45,60,40,30,10,70,30];

%Peso de cada objeto
array[objetos] of int: Peso = [9,13,153,50,15,68,27,39,23,52,11,32];

int: peso_max = 275;

%Conjunto de variables de decision
var set of objetos: mochila;

%restricción
constraint sum([bool2int(i in mochila)*Peso[i]| i in objetos]) <= peso_max;

%Resolver maximizando los objetos
solve maximize sum([bool2int(i in mochila)*Preferencia[i] | i in objetos]);

%Resultado
output[show(mochila)];