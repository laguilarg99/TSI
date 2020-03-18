package TSI;

import java.awt.image.DataBufferInt;
import java.util.ArrayList;
import java.util.Collections;
import java.util.PriorityQueue;
import java.util.Vector;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.pathfinder.Node;

import javax.swing.*;

public class Agent extends AbstractPlayer{


    Vector2d fescala;
    Vector2d portal;

    /**
     * initialize all variables for the agent
     * @param stateObs Observation of the current state.
     * @param elapsedTimer Timer when the action returned is due.
     */
    public Agent(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
        //Calculamos el factor de escala entre mundos (pixeles -> grid)
        fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length ,
                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);

        //Se crea una lista de observaciones de portales, ordenada por cercania al avatar
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());

        //Seleccionamos el portal mas proximo
        portal = posiciones[0].get(0).position;
        portal.x = Math.floor(portal.x / fescala.x);
        portal.y = Math.floor(portal.y / fescala.y);
    }


    /**
     * checks if there is an obstacle
     * @param position the position to check
     * @param stateObs the current state observation
     * @return whether 'position' there isn't an obstacle
     */
    boolean isObstacle(Node position, StateObservation stateObs){
        int x = (int)position.position.x;
        int y = (int)position.position.y;

        for(core.game.Observation obs : stateObs.getObservationGrid()[x][y])
            if(obs.itype == 0) return true;


        return false;
    }

    /**
     * get (reachable) neighbors from a node
     *
     * @param stateObs the current state of the game
     * @return An ArrayList of recheable neighbors
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
            vecinos.add(new Node(vecinoPos));
        }

        return vecinos;
    }

    /**
     * get the final estimated cost
     *
     * @param pos postion to calculate the cost
     * @param stateObs current state
     * @return total estimated cost
     */

    double coste(Node pos, Node obj, StateObservation stateObs){
        double Cost;

        double xCost = Math.abs(pos.position.x - obj.position.x);
        double yCost = Math.abs(pos.position.y - obj.position.y);

        if(isObstacle(pos,stateObs)) Cost = xCost + yCost + 100.0;
        else Cost = xCost + yCost;

        return Cost;

    }

    ArrayList<Node> calculatePath(Node node){
        ArrayList<Node> aux = new ArrayList<>();
        ArrayList<Node> path = new ArrayList<>();

        while(node != null){
            if(node.parent != null){
                aux.add(node);
            }
            node = node.parent;
        }

        int tam = aux.size()-1;

        for(int i = tam; i >= 0; i--) {
            path.add(aux.get(i));
        }

        return path;
    }

    /** A* algorithm
     *
     * @param stateObs current state
     * @return the list of actions to reach the portal
     */

    Node pathfinding_A(StateObservation stateObs, Node startPos){

        Node node = null;
        Node obj = new Node(portal);

        PriorityQueue<Node> Abiertos = new PriorityQueue<>();
        PriorityQueue<Node> Cerrados = new PriorityQueue<>();

        startPos.totalCost = 0.0f;
        startPos.estimatedCost = coste(startPos, obj, stateObs);

        Abiertos.add(startPos);

        while (!Abiertos.isEmpty()){

            node = Abiertos.poll();
            Cerrados.add(node);

            if(node.position.x == portal.x && node.position.y == portal.y) return node;


            ArrayList<Node> vecinos = recheable(node, stateObs);


            for(Node vecino:vecinos){
                vecino.estimatedCost = coste(vecino, obj, stateObs);

                if(!Abiertos.contains(vecino) && !Cerrados.contains(vecino)){
                    Abiertos.add(vecino);
                    vecino.parent = node;
                }
                else if(vecino.estimatedCost < node.estimatedCost){
                    Abiertos.remove(node);
                }
            }

        }

        return node;
    }


    Types.ACTIONS getAction(Vector2d from, Vector2d to){
        if(to.x != from.x)
            if(to.x > from.x) return ACTIONS.ACTION_RIGHT;
            else return ACTIONS.ACTION_LEFT;
        else if(to.y > from.y) return ACTIONS.ACTION_DOWN;
        else return ACTIONS.ACTION_UP;

    }

    /**
     * return the best action to arrive faster to the closest portal
     * @param stateObs Observation of the current state.
     * @param elapsedTimer Timer when the action returned is due.
     * @return best	ACTION to arrive faster to the closest portal
     */
    @Override
    public ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        //Posicion del avatar
        Vector2d avatar =  new Vector2d(stateObs.getAvatarPosition().x / fescala.x,
                stateObs.getAvatarPosition().y / fescala.y);

        Node inicio = new Node(avatar);

        Node path_calculado =  pathfinding_A(stateObs, inicio);

        ArrayList<Node> path = calculatePath(path_calculado);

        Vector2d siguientePos = new Vector2d(path.get(0).position.x, path.get(0).position.y);

        ACTIONS action = getAction(avatar, siguientePos);

        return action;





        //Probamos las cuatro acciones y calculamos la distancia del nuevo estado al portal.
//        Vector2d newPos_up = avatar, newPos_down = avatar, newPos_left = avatar, newPos_right = avatar;
//        if (avatar.y - 1 >= 0) {
//            newPos_up = new Vector2d(avatar.x, avatar.y-1);
//        }
//        if (avatar.y + 1 <= stateObs.getObservationGrid()[0].length-1) {
//            newPos_down = new Vector2d(avatar.x, avatar.y+1);
//        }
//        if (avatar.x - 1 >= 0) {
//            newPos_left = new Vector2d(avatar.x - 1, avatar.y);
//        }
//        if (avatar.x + 1 <= stateObs.getObservationGrid().length - 1) {
//            newPos_right = new Vector2d(avatar.x + 1, avatar.y);
//        }
//
//
//        //Manhattan distance
          //ArrayList<Integer> distances = new ArrayList<Integer>();
//        distances.add((int) (Math.abs(newPos_up.x - portal.x) + Math.abs(newPos_up.y - portal.y)));
//        distances.add((int) (Math.abs(newPos_down.x - portal.x) + Math.abs(newPos_down.y-portal.y)));
//        distances.add((int) (Math.abs(newPos_left.x - portal.x) + Math.abs(newPos_left.y-portal.y)));
//        distances.add((int) (Math.abs(newPos_right.x - portal.x) + Math.abs(newPos_right.y-portal.y)));

//        ArrayList<Vector2d> recheable = recheable(stateObs);
//
//        for(Vector2d v : recheable) {
//            distances.add((int) coste(v, stateObs));
//        }
//
//
//        // Nos quedamos con el menor y tomamos esa accion.
//        //int minIndex = distances.indexOf(Collections.min(distances));
//
//        switch (minIndex) {
//            case 0:
//                return Types.ACTIONS.ACTION_UP;
//            case 1:
//                return Types.ACTIONS.ACTION_DOWN;
//            case 2:
//                return Types.ACTIONS.ACTION_LEFT;
//            case 3:
//                return Types.ACTIONS.ACTION_RIGHT;
//            default:
//                return Types.ACTIONS.ACTION_NIL;
//        }

    }


}