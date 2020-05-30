;Header and description

(define (domain Terran)

;remove requirements that are not needed
(:requirements :strips :fluents  :typing :conditional-effects :negative-preconditions  :equality :disjunctive-preconditions :universal-preconditions)

(:types Investigacion Unidades Edificios Localizaciones Recursos TipoUnidades TipoEdificio;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
)

; un-comment following line if constants are needed
(:constants
    Marine Segador VCE - TipoUnidades;
    CentroDeMando Barracones Extractor BahiaDeIngenieria Deposito - TipoEdificio
    Minerales Gas - Recursos
    ImpulsoSegador - Investigacion
)

(:predicates 
    (EstaEdificio ?Ed - TipoEdificio ?Local - Localizaciones)
    (EstaRecurso ?Recurso - Recursos ?local - Localizaciones)
    (Estipo ?ED - Edificios ?Tipo - TipoEdificio)
    (ExtrayendoRecurso ?Recursos - Recursos ?Unidad - Unidades)
    (EstipoU ?Unidad - Unidades ?Tipo - TipoUnidades)
    (Construido ?Edificio - Edificios)
    (Construyendo ?Edificio - Edificios ?local - Localizaciones)
    (Conectado ?local1 - Localizaciones ?local2 - Localizaciones)
    (EstaUnidad ?Unidad - Unidades ?local - Localizaciones)
    (Reclutado ?Unidad - Unidades)
    (Asignar ?Unidad - Unidades)
    (Investigado ?Invest - Investigacion)
    ;todo: define predicates here
)


(:functions ;todo: define numeric functions here
    (Coste ?Edificio - TipoEdificio ?Recurso - Recursos)
    (CosteU ?Unidad - TipoUnidades ?Recurso - Recursos)
    (CosteI ?Invest - Investigacion ?Recurso - Recursos)
    (UnidadesPorRecurso ?Recurso - Recursos)
    (Deposito ?Recurso - Recursos)
    (NumeroDeposito ?Edificio - TipoEdificio)
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
                        (not(Asignar ?Unidad))
                        (or 
                            (not(= ?Recurso Gas))
                            (and
                                (EstaEdificio Extractor ?local)
                            )
                        )
                    )
    :effect (and 
                (Asignar ?Unidad)
                (ExtrayendoRecurso ?Recurso ?Unidad)
                (increase (UnidadesPorRecurso ?Recurso) 1)
            )
)


(:action Construir
    :parameters (?Unidad1 - Unidades  ?Edificio - Edificios ?Tipo - TipoEdificio ?local1 - Localizaciones)
    :precondition   
                    (and
                        (forall (?Recurso1 - Recursos)
                            (and
                                (>= (Deposito ?Recurso1) (Coste ?Tipo ?Recurso1))           
                            )
                        )
                        (EstaUnidad ?Unidad1 ?local1)
                        (Estipo ?Edificio ?Tipo)
                        (not(Construido ?Edificio))
                        (not(Asignar ?Unidad1))
                    )
                    
    :effect (and 
                (when(= ?Tipo Deposito)
                        (increase (NumeroDeposito Deposito) 1)
                )
                (EstaEdificio ?Tipo ?local1)
                (Construido ?Edificio)
                (Construyendo ?Edificio ?local1)
                (forall (?Recurso1 - Recursos)
                    (and
                            (decrease (Deposito ?Recurso1) (Coste ?Tipo ?Recurso1))
                    )
                )
            )

)

(:action Reclutar
    :parameters (?Unidad - Unidades ?Tipo - TipoUnidades ?local - Localizaciones)
    :precondition (and
                        (EstipoU ?Unidad ?Tipo)
                        (forall (?Recurso1 - Recursos)
                            (and
                                (<= (CosteU ?Tipo ?Recurso1) (Deposito ?Recurso1))
                            )
                        )

                        (not(Reclutado ?Unidad))
                        
                        (or(not
                            (or
                                (not(EstipoU ?Unidad VCE))
                                (and
                                    (EstaEdificio CentroDeMando ?local)
                                )
                            ))
                            
                            (or
                                (or
                                    (not(EstipoU ?Unidad Segador))
                                    (not(EstipoU ?Unidad Marine))     
                                )
                                (EstaEdificio Barracones ?local)
                            )
                        )
                    )
    :effect (and 
        (Reclutado ?Unidad)
        (EstaUnidad ?Unidad ?local)
        (forall (?Recurso1 - Recursos)
            (and
                (decrease (Deposito ?Recurso1) (CosteU ?Tipo ?Recurso1) )
            )
        )
    )
)

(:action Investigar
    :parameters (?Invest - Investigacion ?local - Localizaciones)
    :precondition (and
                        (EstaEdificio BahiaDeIngenieria ?Local)
                        (forall (?Recurso1 - Recursos)
                            (and
                                (<= (CosteI ?Invest ?Recurso1) (Deposito ?Recurso1))
                            )
                        )
                    )
    :effect (and 
        
                (Investigado ImpulsoSegador)
                (forall (?Recurso1 - Recursos)
                    (and
                        (decrease (Deposito ?Recurso1) (CosteI ?Invest ?Recurso1) )
                    )
                )
            )
)

(:action Recolectar
    :parameters (?Recurso - Recursos ?Unidad - Unidades)
    :precondition (and
                    (> (UnidadesPorRecurso ?Recurso) 0)
                  )
    :effect (and 
        
        (when(and
                (> (Deposito ?Recurso) (- (* 100 (NumeroDeposito Deposito)) (* 20 (UnidadesPorRecurso ?Recurso))) )
                )
                    (and
                        (assign (Deposito ?Recurso) (* 100 (NumeroDeposito Deposito)) )
                    )
        )
        (when(and
                (< (Deposito ?Recurso) (- (* 100 (NumeroDeposito Deposito)) (* 20 (UnidadesPorRecurso ?Recurso))) )
                )
                    (and
                        (increase (Deposito ?Recurso) (* 20 (UnidadesPorRecurso ?Recurso)) )
                    )
        )
    
    )
)

(:action DesAsignar
    :parameters (?Unidad - Unidades ?Recurso - Recursos)
    :precondition (and
                    (Asignar ?Unidad)
                    (ExtrayendoRecurso ?Recurso ?Unidad)
                )
    :effect (and 
                (decrease (UnidadesPorRecurso ?Recurso) 1)
                (not(Asignar ?Unidad))
                (not(ExtrayendoRecurso ?Recurso ?Unidad))
            )
)

)