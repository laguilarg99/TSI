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
                        (or(not(= ?Recurso Gas))(EstaEdificio Extractor ?Local))
                        (not(Asignar ?Unidad))
                    )
    :effect (and 
                (increase (UnidadesPorRecurso ?Recurso) 1)
                (ExtrayendoRecurso ?Recurso)
                (Asignar ?Unidad)
            )
)


(:action Construir
    :parameters (?Unidad1 - Unidades  ?Edificio - Edificios ?Tipo - TipoEdificio ?local1 - Localizaciones)
    :precondition   
                    (and
                        (Estipo ?Edificio ?Tipo)
                        (forall (?Recurso1 - Recursos)(or 
                            (not (NecesitaRecurso ?Tipo ?Recurso1))
                            (< (Coste ?Tipo ?Recurso1) (Deposito ?Recurso1))))
                        (EstaUnidad ?Unidad1 ?local1)
                        (not(Construido ?Edificio))
                        (not(Asignar ?Unidad1))
                        
                    )
                    
    :effect (and 
                (Construyendo ?Edificio ?Unidad1 ?local1)
                (EstaEdificio ?Tipo ?local1)
                (Construido ?Edificio)
                (forall (?Recurso1 - Recursos)
                    (and
                        (decrease (Deposito ?Recurso1) (Coste ?Tipo ?Recurso1))
                    )
                )
                (when(and
                (= ?Tipo Deposito))
                    (and
                        (increase (NumeroDeposito Deposito) 1)
                    )
                )
            )

)

(:action Reclutar
    :parameters (?Unidad - Unidades ?Tipo - TipoUnidades ?local - Localizaciones)
    :precondition (and
                        (EstipoU ?Unidad ?Tipo)
                       
                       (forall (?Recurso1 - Recursos)(or 
                            (not (NecesitaRecursoU ?Tipo ?Recurso1))
                            (< (CosteU ?Tipo ?Recurso1) (Deposito ?Recurso1))))
                        (not(Reclutado ?Unidad))
                        (or
                            (and
                                (EstipoU ?Unidad VCE)
                                (EstaEdificio CentroDeMando ?local)
                            )
                            (and
                                (EstipoU ?Unidad Marine)
                                (EstaEdificio Barracones ?local)
                            )
                            (and
                                (EstipoU ?Unidad Segador)
                                (EstaEdificio Barracones ?local)
                                (Investigado ImpulsoSegador)
                            )
                        )
                        
                    )
    :effect (and 
        (Reclutado ?Unidad)
        (EstaUnidad ?Unidad ?local)
        (forall (?Recurso1 - Recursos)
            (and
                (decrease (Deposito ?Recurso1) (CosteU ?Tipo ?Recurso1))
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
                            (< (CosteI ?Invest ?Recurso1) (Deposito ?Recurso1))))
                    )
    :effect (and 
                (Investigado ImpulsoSegador)
                (forall (?Recurso1 - Recursos)
                    (and
                        (decrease (Deposito ?Recurso1) (CosteI ?Invest ?Recurso1))
                    )
                )
            )
)


(:action Recolectar
    :parameters (?Recurso - Recursos)
    :precondition (and
                    (> (UnidadesPorRecurso ?Recurso) 0)
                    (ExtrayendoRecurso ?Recurso)
                    (<= (Deposito ?Recurso) (- (* (NumeroDeposito Deposito) 100) (* 25 (UnidadesPorRecurso ?Recurso))))
                  )
    :effect (and    
        (increase (Deposito ?Recurso) (* 25 (UnidadesPorRecurso ?Recurso)) )
    )
)

(:action DesAsignar
    :parameters (?Unidad - Unidades ?Recurso - Recursos)
    :precondition (and
                    (Asignar ?Unidad)
                    (ExtrayendoRecurso ?Recurso)
                )
    :effect (and 
                (decrease (UnidadesPorRecurso ?Recurso) 1)
                (not(Asignar ?Unidad))
                (not(ExtrayendoRecurso ?Recurso))
            )
)


)