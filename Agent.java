package TSI;

import java.util.ArrayList;
import java.util.PriorityQueue;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.pathfinder.Node;


public class Agent extends AbstractPlayer{

    //escala
    Vector2d fescala;

    //posición del portal
    Vector2d portal;

    //posición de resources
    Vector2d gema;

    //posición de NPC
    Vector2d Scorpion;

    //Camino actual
    ArrayList<Node> path = new ArrayList<>();

    //Número de gemas
    int NumGems;

    /**
     * Inicializa todas las variables del agente
     * @param stateObs Estado actual de la observación.
     * @param elapsedTimer Cronómetro de cuando la acción es devuelta.
     */
    public Agent(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){

        //Calculamos el factor de escala entre mundos (pixeles -> grid)
        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length ,
                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

        //Se crea una lista de observaciones de portales, ordenada por cercania al avatar
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());

        //inicializamos el número de gemas
        NumGems = 0;

        //Seleccionamos el portal mas próximo
        portal = posiciones[0].get(0).position;
        portal.x = Math.floor(portal.x / fescala.x);
        portal.y = Math.floor(portal.y / fescala.y);

        ArrayList<Node> Path = new ArrayList<>();
    }


    /**
     * Comprueba si una posicion es un obstaculo
     * @param position La posición a comprobar
     * @param stateObs El estado actual
     * @return devuelve si la posición es un obstáculo
     */
    boolean isObstacle(Node position, StateObservation stateObs){
        int x = (int)position.position.x;
        int y = (int)position.position.y;

        for(core.game.Observation obs : stateObs.getObservationGrid()[x][y])
            if(obs.itype == 0) return true;


        return false;
    }


    /**
     * Devuelve una lista de nodos alcanzables desde el nodo actual.
     *
     * @param stateObs Estado actual del juego
     * @return Un Arraylist de nodos
     */
    ArrayList<Node> recheable(Node pos, StateObservation stateObs){
        ArrayList<Node> vecinos = new ArrayList<>();
        Vector2d avatar =  new Vector2d(pos.position.x,pos.position.y);

        int x = (int) avatar.x;
        int y = (int) avatar.y;

        int [] x_axis = new int [] {0,0,-1,1};
        int [] y_axis = new int [] {-1,1,0,0};

        for(int i = 0; i < x_axis.length; i++){
            Vector2d vecinoPos = new Vector2d(x + x_axis[i], y + y_axis[i]);
            Node aux = new Node(vecinoPos);
            if(!isObstacle(aux,stateObs)) vecinos.add(new Node(vecinoPos));
        }

        return vecinos;
    }



    /**
     * Devuelve el camino a seguir.
     *
     * @param node nodo final que corresponde con el objetivo calculado por el A*
     * @return Arraylist de Node que será el camino a seguir
     */
    ArrayList<Node> calculatePath(Node node){
        ArrayList<Node> path = new ArrayList<>();

        while(node != null){
            if(node.parent != null){
                node.setMoveDir(node.parent);
                path.add(0,node);
            }
            node = node.parent;
        }

        return path;
    }

    /** Algoritmo A*
     *
     * @param stateObs Estado actual
     * @param startPos Posicion de comienzo
     * @param objetivo Posicion del portal
     * @return La lista de acciones para alacanzar un objetivo
     */

    ArrayList<Node> pathfinding_A(StateObservation stateObs, Node startPos, Node objetivo){

        Node node;
        Node obj = objetivo;

        PriorityQueue<Node> Abiertos = new PriorityQueue<>();
        PriorityQueue<Node> Cerrados = new PriorityQueue<>();


        Abiertos.add(startPos);

        while (!Abiertos.isEmpty()){

            node = Abiertos.poll();
            Cerrados.add(node);

            if(node.position.x == obj.position.x && node.position.y == obj.position.y) return calculatePath(node);

            ArrayList<Node> vecinos = recheable(node, stateObs);


            for(Node vecino:vecinos) {

                if(!Abiertos.contains(vecino) && !Cerrados.contains(vecino)){
                    vecino.totalCost = vecino.totalCost + node.totalCost;
                    vecino.parent = node;
                    Abiertos.add(vecino);
                }

            }

        }

        return null;
    }


    /**
     * Devuelve la acción a realizar para moverse de un punto a otro
     * @param from punto desde el que se mueve
     * @param to punto hacia el que va
     * @return devuelve la acción a realizar
     */

    Types.ACTIONS getAction(Vector2d from, Vector2d to){
        if(to.x != from.x)
            if(to.x > from.x) return ACTIONS.ACTION_RIGHT;
            else return ACTIONS.ACTION_LEFT;
        else if(to.y > from.y) return ACTIONS.ACTION_DOWN;
        else return ACTIONS.ACTION_UP;

    }

    /**
     * Comportamiento reactivo del agente
     * @param avatar la posición actual del agente
     * @param StateObs estado actual
     * @return devuelve la posición a la que se debe mover el agente para evitar a los escorpiones
     */
    Vector2d Reactivo(Vector2d avatar, StateObservation StateObs){

        Vector2d siguientePos = new Vector2d(0, 0);

        Node sol = new Node(siguientePos);
        Node aux = new Node(avatar);

        double dis = 0;

        ArrayList<Node> vecinos = recheable(aux, StateObs);
        for(Node vecino : vecinos){
            double distancia = Math.abs(Scorpion.x - vecino.position.x) + Math.abs(Scorpion.y - vecino.position.y);
            if(distancia > dis){
                dis = distancia;
                sol = vecino;
            }
        }

        siguientePos = new Vector2d(sol.position.x, sol.position.y);
        return siguientePos;

    }


    /**
     * Devuelve la mejor acción para acercarse al portal sin morir
     * @param stateObs Estado actual
     * @param elapsedTimer Temporizador para controlar la ejecución.
     * @return Devuelve la mejor acción para acercarse al portal sin morir dependiendo del
     */
    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {

        //Tratar el caso en el que solo haya portales
        //Posicion del avatar
        Vector2d avatar =  new Vector2d(stateObs.getAvatarPosition().x / fescala.x,
                stateObs.getAvatarPosition().y / fescala.y);

        //Siguiente posicion
        Vector2d siguientePos  = new Vector2d(0,0);

        Node nuevaPos = new Node(avatar);

        //Accion a llevar a cabo
        ACTIONS action;

        double dis = 0;

        if(stateObs.getNPCPositions(stateObs.getAvatarPosition()) != null) {
            //Se crea una lista de observaciones de NPC, ordenada por cercania al avatar
            ArrayList<Observation>[] Npc = stateObs.getNPCPositions(stateObs.getAvatarPosition());

            //Seleccionamos el npc más cercano
            Scorpion = Npc[0].get(0).position;
            Scorpion.x = Math.floor(Scorpion.x / fescala.x);
            Scorpion.y = Math.floor(Scorpion.y / fescala.y);

            dis = Math.abs(Scorpion.x - avatar.x) + Math.abs(Scorpion.y - avatar.y);

        }


        if(dis != 0 && dis < 4.5){

            try{

                siguientePos = Reactivo(avatar,stateObs);
                if(siguientePos.x != 0 || siguientePos.y != 0)
                    action = getAction(avatar,siguientePos);
                else
                    action = ACTIONS.ACTION_NIL;

            }catch (IndexOutOfBoundsException|NullPointerException e){
                action = ACTIONS.ACTION_NIL;
            }
        }else {

            if (avatar.equals(gema)) {
                NumGems++;
            }

            if (stateObs.getResourcesPositions(stateObs.getAvatarPosition()) != null && NumGems < 10) {

                //Se crea una lista de observaciones de gemas, ordenada por cercania al avatar
                ArrayList<Observation>[] gemas = stateObs.getResourcesPositions(stateObs.getAvatarPosition());

                //Seleccionamos la gema mas cercana
                gema = gemas[0].get(0).position;
                gema.x = Math.floor(gema.x / fescala.x);
                gema.y = Math.floor(gema.y / fescala.y);
                Node obj = new Node(gema);
                path = pathfinding_A(stateObs, nuevaPos, obj);

            } else {
                Node obj = new Node(portal);
                path = pathfinding_A(stateObs, nuevaPos, obj);
            }


            try {
                siguientePos = path.get(0).position;
                action = getAction(avatar, siguientePos);
            } catch (IndexOutOfBoundsException | NullPointerException e) {
                action = ACTIONS.ACTION_NIL;
            }

        }

        System.out.println(elapsedTimer);
        return action;


    }


}