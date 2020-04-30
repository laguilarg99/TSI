%Incluir la libreria pertinente
include "globals.mzn";

%Definición de variables

enum Procedencia = {Vasco, Catalan, Gallego, Navarro, Andaluz};
enum Profesion = {pintor,escultor, diplomatico, violinista, medico};
enum Animal = {perro, caracol, caballo, zorro, cebra};
enum Bebida = {te, cafe, leche, zumo, agua};
enum Color = {rojo,verde, blanca, azul, amarillo};
array[1..5] of var Procedencia: PROCEDENCIA;
array[1..5] of var Profesion: PROFESION;
array[1..5] of var Animal: ANIMAL;
array[1..5] of var Bebida: BEBIDA;
array[1..5] of var Color: COLOR;

%Condiciones
constraint all_different(PROCEDENCIA);
constraint all_different(PROFESION);
constraint all_different(ANIMAL);
constraint all_different(BEBIDA);
constraint all_different(COLOR);

constraint PROCEDENCIA[1] = Andaluz; % El andaluz vive en la primera casa de la izquierda.
constraint BEBIDA[3] = leche; % En la casa central se bebe leche.
constraint exists(n in 1..5)(PROCEDENCIA[n]=Vasco /\ COLOR[n]=rojo); % El vasco vive en la casa roja. 
constraint exists(n in 1..5)(PROCEDENCIA[n]=Catalan /\ ANIMAL[n]=perro); % El catalán tiene un perro.
constraint exists(n in 1..5)(PROCEDENCIA[n]=Catalan /\ PROFESION[n]=pintor);% El gallego es un pintor.
constraint exists(n in 1..5)(PROCEDENCIA[n]=Navarro /\ BEBIDA[n]=te);% El navarro bebe te.
constraint exists(n in 1..5)(COLOR[n]=verde /\ BEBIDA[n] = cafe); % El de la casa verde bebe café.
constraint exists(n in 1..4)(COLOR[n]=blanca /\ COLOR[n + 1] = verde);% La casa verde está al lado de la blanca y a su derecha.
constraint exists(n in 1..5)(PROFESION[n]=escultor /\ ANIMAL[n]=caracol); % El escultor cria caracoles.
constraint exists(n in 1..5)(PROFESION[n]=diplomatico /\ COLOR[n] = amarillo); % El diplomático vive en la casa amarilla.
constraint exists(n in 1..4)(PROCEDENCIA[n]= Andaluz /\ COLOR[n+1]=azul);% La casa del andaluz está al lado de la azul.
constraint exists(n in 1..5)(PROFESION[n]=violinista /\ BEBIDA[n] = zumo); % El violinista bebe zumo.
constraint exists(n in 1..4)((PROFESION[n]=medico /\ ANIMAL[n + 1] = zorro) \/ (PROFESION[n + 1]=medico /\ ANIMAL[n] = zorro)); % El zorro está en una casa al lado de la del médico.
constraint exists(n in 1..4)((PROFESION[n]=diplomatico /\ ANIMAL[n + 1] = caballo) \/ (PROFESION[n + 1]=medico /\ ANIMAL[n] = caballo)); % El caballo está en una casa al lado de la del diplomático

var 1..5: n1;
constraint ANIMAL[n1] = cebra; %Alguien tiene la cebra

var 1..5: n2;
constraint BEBIDA[n2] = agua; %Alguien bebe agua

%Resolución 
solve satisfy;
output["El " ++ show(PROCEDENCIA[n1]) ++ " tiene la cebra y vive en la casa nº\(n1)\n" ++ "El " ++ show(PROCEDENCIA[n2]) ++ " bebe agua y vive en la casa nº\(n2)\n"++"\n"++show(PROCEDENCIA)++"\n"++show(PROFESION)++"\n"++show(ANIMAL)++"\n"++show(BEBIDA)++"\n"++show(COLOR)++"\n"];