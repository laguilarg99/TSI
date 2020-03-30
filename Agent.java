package TSI;

import java.awt.image.DataBufferInt;
import java.util.ArrayList;
import java.util.Collections;
import java.util.PriorityQueue;
import java.util.Vector;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import core.player.Player;
import ontology.Types;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.pathfinder.Node;

import javax.swing.*;

public class Agent extends AbstractPlayer{

    //escala
    Vector2d fescala;

    //posicion del portal
    Vector2d portal;

    //posicion de resources
    Vector2d gema;

    //Camino actual
    ArrayList<Node> path = new ArrayList<>();

    //Numero de gemas
    int NumGems;

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

        NumGems = 0;
        //Seleccionamos el portal mas proximo
        portal = posiciones[0].get(0).position;
        portal.x = Math.floor(portal.x / fescala.x);
        portal.y = Math.floor(portal.y / fescala.y);

        ArrayList<Node> Path = new ArrayList<>();
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

        if(isObstacle(pos,stateObs)) Cost = xCost + yCost + 10000.0;
        else Cost = xCost + yCost;

        return Cost;

    }

    ArrayList<Node> calculatePath(Node node){
        //ArrayList<Node> aux = new ArrayList<>();
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

    /** A* algorithm
     *
     * @param stateObs current state
     * @return the list of actions to reach the portal
     */

    ArrayList<Node> pathfinding_A(StateObservation stateObs, Node startPos, Node objetivo){

        Node node = null;
        Node obj = objetivo;

        PriorityQueue<Node> Abiertos = new PriorityQueue<>();
        PriorityQueue<Node> Cerrados = new PriorityQueue<>();

        startPos.totalCost = 0.0f;
        startPos.estimatedCost = coste(startPos, obj, stateObs);

        Abiertos.add(startPos);

        while (!Abiertos.isEmpty()){

            node = Abiertos.poll();
            Cerrados.add(node);

            if(node.position.x == obj.position.x && node.position.y == obj.position.y) return calculatePath(node);


            ArrayList<Node> vecinos = recheable(node, stateObs);


            for(Node vecino:vecinos){
                double curDistance = vecino.totalCost;

                if(!Abiertos.contains(vecino) && !Cerrados.contains(vecino)){
                    vecino.totalCost = curDistance + node.totalCost;
                    vecino.estimatedCost = coste(vecino,obj,stateObs);
                    vecino.parent = node;

                    Abiertos.add(vecino);

                }
                else if(curDistance + node.totalCost < vecino.totalCost){
                    vecino.totalCost = curDistance + node.totalCost;
                    vecino.parent = node;

                    Abiertos.remove(vecino);
                    Cerrados.remove(vecino);
                    Abiertos.add(vecino);
                }
            }

        }

        assert node != null;

        if(!(obj.position.x == node.position.x && obj.position.y == node.position.y)) return null;

        return calculatePath(node);
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

        //Tratar el caso en el que solo haya portales
        //Posicion del avatar
        Vector2d avatar =  new Vector2d(stateObs.getAvatarPosition().x / fescala.x,
                stateObs.getAvatarPosition().y / fescala.y);

        Node nuevaPos = new Node(avatar);

        /*
        if(avatar.equals(gema)){
            NumGems++;
        }


        if(stateObs.getResourcesPositions(stateObs.getAvatarPosition()) != null && NumGems < 10) {

            //Se crea una lista de observaciones de gemas, ordenada por cercania al avatar
            ArrayList<Observation>[] gemas = stateObs.getResourcesPositions(stateObs.getAvatarPosition());

            //Seleccionamos la gema mas cercana
            gema = gemas[0].get(0).position;
            gema.x = Math.floor(gema.x / fescala.x);
            gema.y = Math.floor(gema.y / fescala.y);
            Node obj = new Node(gema);
            path = pathfinding_A(stateObs, nuevaPos, obj);

        }
        else{
            Node obj = new Node(portal);
            path = pathfinding_A(stateObs, nuevaPos, obj);
        }
        */
        ACTIONS action;
        
        /*
        try{
            Vector2d siguientePos = path.get(0).position;
            action = getAction(avatar,siguientePos);
        }catch (IndexOutOfBoundsException|NullPointerException e){
            action = ACTIONS.ACTION_NIL;
        }
        */

        return action;


    }


}