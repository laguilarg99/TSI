;Header and description

(define (domain Terran)

;remove requirements that are not needed
(:requirements :strips :fluents  :typing :conditional-effects :negative-preconditions  :equality :disjunctive-preconditions :universal-preconditions)

(:types Investigacion Unidades Edificios Localizaciones Recursos TipoUnidades TipoEdificio;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
)

; un-comment following line if constants are needed
(:constants
    Marine Segador VCE - TipoUnidades;
    CentroDeMando Barracones Extractor BahiaDeIngenieria - TipoEdificio
    Minerales Gas - Recursos
    ImpulsoSegador - Investigacion
)

(:predicates 
    (EstaEdificio ?Ed - TipoEdificio ?Local - Localizaciones)
    (EstaRecurso ?Recurso - Recursos ?local - Localizaciones)
    (Estipo ?ED - Edificios ?Tipo - TipoEdificio)
    (EstipoU ?Unidad - Unidades ?Tipo - TipoUnidades)
    (Construido ?Edificio - Edificios)
    (Conectado ?local1 - Localizaciones ?local2 - Localizaciones)
    (EstaUnidad ?Unidad - Unidades ?local - Localizaciones)
    (NecesitaRecurso ?Edificio - TipoEdificio ?Recursos - Recursos)
    (NecesitaRecursoU ?Unidad - TipoUnidades ?Recursos - Recursos)
    (NecesitaRecursoI ?Invest - Investigacion ?Recurso - Recursos)
    (Reclutado ?Unidad - Unidades)
    (ExtrayendoRecurso ?Recurso - Recursos)
    (Construyendo ?Edificio - Edificios ?Unidad - Unidades ?local - Localizaciones)
    (Asignar ?Unidad - Unidades)
    (Investigado ?Invest - Investigacion)
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
                        (EstipoU ?Unidad VCE)
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
    :parameters (?Unidad - Unidades ?Unidad1 - Unidades  ?Edificio - Edificios ?Tipo - TipoEdificio ?local1 - Localizaciones)
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

(:action Reclutar
    :parameters (?Unidad - Unidades ?Unidad1 - Unidades ?Tipo - TipoUnidades ?local - Localizaciones ?local1 - Localizaciones)
    :precondition (and
                        (EstipoU ?Unidad ?Tipo)
                        (forall (?Recurso1 - Recursos)(or 
                            (not (NecesitaRecursoU ?Tipo ?Recurso1))
                            (ExtrayendoRecurso ?Recurso1)))
                        (EstaUnidad ?Unidad1 ?local1)
                        (not(Reclutado ?Unidad))
                    )
    :effect (and 
        
        (when(and
                (EstipoU ?Unidad Marine)
                (EstaEdificio Barracones ?Local)
                )
                    (and
                        (Reclutado ?Unidad)
                        (EstaUnidad ?Unidad ?local)
                    )
        )
        (when(and
                (EstipoU ?Unidad Segador)
                (Investigado ImpulsoSegador)
                (EstaEdificio Barracones ?Local)
                )
                    (and
                        (Reclutado ?Unidad)
                        (EstaUnidad ?Unidad ?local)
                    )
        )

        (when(and
                (EstipoU ?Unidad VCE)
                (EstaEdificio CentroDeMando ?Local)
                )
                    (and
                        (Reclutado ?Unidad)
                        (EstaUnidad ?Unidad ?local)
                    )
        )
    )
)

(:action Investigar
    :parameters (?Invest - Investigacion ?local - Localizaciones)
    :precondition (and
                        (EstaEdificio BahiaDeIngenieria ?Local)
                        (forall (?Recurso1 - Recursos)(or 
                            (not (NecesitaRecursoI ?Invest ?Recurso1))
                            (ExtrayendoRecurso ?Recurso1)))
                    )
    :effect (and 
        
                (Investigado ImpulsoSegador)
            )
)

)