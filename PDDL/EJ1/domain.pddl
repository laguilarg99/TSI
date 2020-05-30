;Header and description

(define (domain Terran)

;remove requirements that are not needed
(:requirements :strips :fluents  :typing :conditional-effects :negative-preconditions  :equality)

(:types Unidades Edificios Localizaciones Recursos;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
)

; un-comment following line if constants are needed
(:constants
    VCE - Unidades;
    CentroDeMando Barracones - Edificios
    Minerales Gas - Recursos
)

(:predicates 
    (EstaEdificio ?Ed - Edificios ?Local - Localizaciones)
    (EstaRecurso ?Recurso - Recursos ?local - Localizaciones)
    (Conectado ?local1 - Localizaciones ?local2 - Localizaciones)
    (EstaUnidad ?Unidad - Unidades ?local - Localizaciones)
    (NecesitaRecurso ?Edificio - Edificios ?Recursos - Recursos)
    (ExtrayendoRecurso ?Recurso - Recursos ?Unidad - Unidades ?local - Localizaciones)
    (Construyendo ?Edificio - Edificios ?Unidad - Unidades ?local - Localizaciones)

    ;todo: define predicates here
)


(:functions ;todo: define numeric functions here
    
)

;define actions here
(:action Navegar
    :parameters (?Unidad - Unidades ?local1 - Localizaciones ?local2 - Localizaciones)
    :precondition   (and
                        (EstaUnidad ?Unidad ?local1) 
                        (Conectado ?local1 ?local2)
                    )
    :effect (and 
                (EstaUnidad ?Unidad ?local2)
                (not(EstaUnidad ?Unidad ?local1))
            )
)

(:action Asignar
    :parameters (?Unidad - Unidades  ?local - Localizaciones ?Recurso - Recursos)
    :precondition   (and 
                        (EstaUnidad ?Unidad ?local)
                        (EstaRecurso ?Recurso ?local)
                    )
    :effect (and 
                (ExtrayendoRecurso ?Recurso ?Unidad ?local)
            )
)

(:action Construir
    :parameters (?Unidad - Unidades ?Unidad1 - Unidades ?local - Localizaciones ?Edificio - Edificios ?local1 - Localizaciones ?Recurso - Recursos)
    :precondition   (and 
                        (NecesitaRecurso ?Edificio ?Recurso)
                        (ExtrayendoRecurso ?Recurso ?Unidad ?local)
                        (EstaUnidad ?Unidad1 ?local1)
                    )
    :effect (and 
                (Construyendo ?Edificio ?Unidad1 ?local1)
            )
)




)