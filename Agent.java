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

public class Agent extends AbstractPlayer{
    //Greedy Camel:
    // 1) Busca la puerta más cercana.
    // 2) Escoge la accion que minimiza la distancia del camello a la puerta.

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
    boolean isObstacle(Vector2d position, StateObservation stateObs){
        int x = (int)position.x;
        int y = (int)position.y;

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
    ArrayList<Node> recheable(StateObservation stateObs){
        ArrayList<Node> vecinos = new ArrayList<>();
        Vector2d avatar =  new Vector2d(stateObs.getAvatarPosition().x / fescala.x,
                stateObs.getAvatarPosition().y / fescala.y);

        int x = (int) avatar.x;
        int y = (int) avatar.y;

        int [] x_axis = new int [] {0,0,-1,1};
        int [] y_axis = new int [] {-1,1,0,0};

        for(int i = 0; i < x_axis.length; i++){
            Vector2d vecinoPos = new Vector2d(x + x_axis[i], y + y_axis[i]);
            if(!isObstacle(vecinoPos,stateObs)) vecinos.add(new Node(vecinoPos));
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

    double coste(Vector2d pos, StateObservation stateObs){
        double Cost;

        double xCost = Math.abs(pos.x - portal.x);
        double yCost = Math.abs(pos.y - portal.y);

        Cost = xCost + yCost;

        return Cost;

    }

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

    /** A* algorithm
     *
     * @param stateObs current state
     * @return the list of actions to reach the portal
     */

        Node pathfinding_A(StateObservation stateObs, Vector2d startPos){

        Node node = null;
        Node start =new Node(startPos);

        PriorityQueue<Node> Abiertos = new PriorityQueue<>();
        PriorityQueue<Node> Cerrados = new PriorityQueue<>();

        start.estimatedCost = coste(startPos,stateObs);
        start.totalCost = 0.0f;

        Abiertos.add(start);

        while(!Abiertos.isEmpty()){

            node = Abiertos.poll();
            Cerrados.add(node);

            int x = (int) node.position.x ;
            int y = (int) node.position.x;
            if( x == portal.x && y == portal.y) return node;

            ArrayList<Node> vecinos = recheable(stateObs);

            for(Node vecino : vecinos){
                int vecinox = (int) vecino.position.x;
                int vecinoy = (int) vecino.position.y;
                Vector2d aux = new Vector2d(vecinox,vecinoy);

                double curDistance = coste(aux, stateObs);

                if(!Abiertos.contains(vecino) && !Cerrados.contains(vecino)) {
                    vecino.totalCost = curDistance + node.totalCost;
                    vecino.estimatedCost = curDistance;
                    vecino.parent = node;

                    Abiertos.add(vecino);
                }
                else if(vecino.totalCost < node.totalCost ){
                    vecino.parent = node;

                    Abiertos.remove(vecino);
                    Cerrados.remove(vecino);
                    Abiertos.add(vecino);
                }
            }

        }

        int x = (int) node.position.x ;
        int y = (int) node.position.x;

        assert node != null;

        if( x != portal.x && y != portal.y) return null;

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

        Node path = pathfinding_A(stateObs, avatar);

        ArrayList<Node> path_calculado = calculatePath(path);

        Vector2d siguientePos = path_calculado.get(0).position;

        ACTIONS action = getAction(avatar,siguientePos);

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