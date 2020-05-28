(define (problem Ejercicio1) (:domain Terran)
(:objects 
    VCE1 VCE2 - Unidades
    loc1_1 loc1_2 loc1_3 loc1_4 loc1_5 - Localizaciones
    loc2_1 loc2_2 loc2_3 loc2_4 loc2_5 - Localizaciones
    loc3_1 loc3_2 loc3_3 loc3_4 loc3_5 - Localizaciones
    loc4_1 loc4_2 loc4_3 loc4_4 loc4_5 - Localizaciones
    loc5_1 loc5_2 loc5_3 loc5_4 loc5_5 - Localizaciones
    Barracones1 - Edificios
    
)

(:init
    (conectado loc1_1 loc2_1)
    (conectado loc1_1 loc1_2)
    (conectado loc1_2 loc2_2)
    (conectado loc1_2 loc1_3)
    (conectado loc1_2 loc1_1)
    (conectado loc1_3 loc2_3)
    (conectado loc1_3 loc1_4)
    (conectado loc1_3 loc1_2)
    (conectado loc1_4 loc2_4)
    (conectado loc1_4 loc1_5)
    (conectado loc1_4 loc1_3)
    (conectado loc1_5 loc2_5)
    (conectado loc1_5 loc1_4)
    (conectado loc2_1 loc1_1)
    (conectado loc2_1 loc3_1)
    (conectado loc2_1 loc2_2)
    (conectado loc2_2 loc1_2)
    (conectado loc2_2 loc3_2)
    (conectado loc2_2 loc2_3)
    (conectado loc2_2 loc2_1)
    (conectado loc2_3 loc1_3)
    (conectado loc2_3 loc3_3)
    (conectado loc2_3 loc2_4)
    (conectado loc2_3 loc2_2)
    (conectado loc2_4 loc1_4)
    (conectado loc2_4 loc3_4)
    (conectado loc2_4 loc2_5)
    (conectado loc2_4 loc2_3)
    (conectado loc2_5 loc1_5)
    (conectado loc2_5 loc3_5)
    (conectado loc2_5 loc2_4)
    (conectado loc3_1 loc2_1)
    (conectado loc3_1 loc4_1)
    (conectado loc3_1 loc3_2)
    (conectado loc3_2 loc2_2)
    (conectado loc3_2 loc4_2)
    (conectado loc3_2 loc3_3)
    (conectado loc3_2 loc3_1)
    (conectado loc3_3 loc2_3)
    (conectado loc3_3 loc4_3)
    (conectado loc3_3 loc3_4)
    (conectado loc3_3 loc3_2)
    (conectado loc3_4 loc2_4)
    (conectado loc3_4 loc4_4)
    (conectado loc3_4 loc3_5)
    (conectado loc3_4 loc3_3)
    (conectado loc3_5 loc2_5)
    (conectado loc3_5 loc4_5)
    (conectado loc3_5 loc3_4)
    (conectado loc4_1 loc3_1)
    (conectado loc4_1 loc5_1)
    (conectado loc4_1 loc4_2)
    (conectado loc4_2 loc3_2)
    (conectado loc4_2 loc5_2)
    (conectado loc4_2 loc4_3)
    (conectado loc4_2 loc4_1)
    (conectado loc4_3 loc3_3)
    (conectado loc4_3 loc5_3)
    (conectado loc4_3 loc4_4)
    (conectado loc4_3 loc4_2)
    (conectado loc4_4 loc3_4)
    (conectado loc4_4 loc5_4)
    (conectado loc4_4 loc4_5)
    (conectado loc4_4 loc4_3)
    (conectado loc4_5 loc3_5)
    (conectado loc4_5 loc5_5)
    (conectado loc4_5 loc4_4)
    (conectado loc5_1 loc4_1)
    (conectado loc5_1 loc5_2)
    (conectado loc5_2 loc4_2)
    (conectado loc5_2 loc5_3)
    (conectado loc5_2 loc5_1)
    (conectado loc5_3 loc4_3)
    (conectado loc5_3 loc5_4)
    (conectado loc5_3 loc5_2)
    (conectado loc5_4 loc4_4)
    (conectado loc5_4 loc5_5)
    (conectado loc5_4 loc5_3)
    (conectado loc5_5 loc4_5)
    (conectado loc5_5 loc5_4)
    (EstaEdificio CentroDeMando loc2_2)
    (EstaRecurso Minerales loc1_2)
    (EstaRecurso Minerales loc3_1)
    (EstaRecurso Minerales loc5_3)
    (EstaRecurso Gas loc4_3)
    (EstaRecurso Gas loc5_5)
    (EstaUnidad VCE loc1_5)
    (EstaUnidad VCE1 loc5_1)
    (EstaUnidad VCE2 loc5_1)
    (NecesitaRecurso Barracones1 Minerales)
    ;todo: put the initial state's facts and numeric values here
)

(:goal (and
    (Construyendo Barracones1 VCE1 loc3_3)
    ;todo: put the goal condition here
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
