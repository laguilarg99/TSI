;Header and description

(define (domain Terran)

;remove requirements that are not needed
(:requirements :strips :fluents  :typing :conditional-effects :negative-preconditions  :equality :disjunctive-preconditions :universal-preconditions)

(:types Unidades Edificios Localizaciones Recursos TipoEdificio;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
)

; un-comment following line if constants are needed
(:constants
    VCE - Unidades;
    CentroDeMando Barracones Extractor - TipoEdificio
    Minerales Gas - Recursos
)

(:predicates 
    (EstaEdificio ?Ed - TipoEdificio ?Local - Localizaciones)
    (EstaRecurso ?Recurso - Recursos ?local - Localizaciones)
    (Estipo ?ED - Edificios ?Tipo - TipoEdificio)
    (Construido ?Edificio - Edificios)
    (Conectado ?local1 - Localizaciones ?local2 - Localizaciones)
    (EstaUnidad ?Unidad - Unidades ?local - Localizaciones)
    (NecesitaRecurso ?Edificio - TipoEdificio ?Recursos - Recursos)
    (ExtrayendoRecurso ?Recurso - Recursos)
    (Construyendo ?Edificio - Edificios ?Unidad - Unidades ?local - Localizaciones)
    (Asignar ?Unidad - Unidades)
    ;todo: define predicates here
)


(:functions ;todo: define numeric functions here
    
)

;define actions here
(:action Navegar
    :parameters (?Unidad - Unidades ?local1 - Localizaciones ?local2 - Localizaciones)
    :precondition   (and
                        (not(Asignar ?Unidad))
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
                (when(and(= ?Recurso Minerales))
                    (and
                        (ExtrayendoRecurso ?Recurso)
                        (Asignar ?Unidad)
                    )
                )
                (when(and
                (EstaEdificio Extractor ?Local)
                (= ?Recurso Gas))
                    (and
                        (ExtrayendoRecurso ?Recurso)
                        (Asignar ?Unidad)
                    )
                )
            )
)


(:action Construir
    :parameters (?Unidad - Unidades ?Unidad1 - Unidades ?local - Localizaciones ?Edificio - Edificios ?Tipo - TipoEdificio ?local1 - Localizaciones)
    :precondition   
                    (and
                        (Estipo ?Edificio ?Tipo)
                        (forall (?Recurso1 - Recursos)(or 
                            (not (NecesitaRecurso ?Tipo ?Recurso1))
                            (ExtrayendoRecurso ?Recurso1)))
                        (EstaUnidad ?Unidad1 ?local1)
                        (not(Construido ?Edificio))
                    )
                    
    :effect (and 
                (Construyendo ?Edificio ?Unidad1 ?local1)
                (EstaEdificio ?Tipo ?local1)
                (Construido ?Edificio)
            )

)

)