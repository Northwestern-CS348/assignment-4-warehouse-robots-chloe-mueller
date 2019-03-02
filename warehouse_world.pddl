(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?l - location ?l2 - location ?r - robot)
      :precondition (and (free ?r) (connected ?l ?l2) (at ?r ?l) (no-robot ?l2))
      :effect (and (not (at ?r ?l)) (at ?r ?l2) (no-robot ?l) (not (no-robot ?l2)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?l - location ?l2 - location ?r - robot ?p - pallette)
      :precondition (and (free ?r) (connected ?l ?l2) (at ?r ?l) (at ?p ?l) (no-robot ?l2) (no-pallette ?l2))
      :effect (and (not (at ?r ?l)) (at ?r ?l2) (not (at ?p ?l)) (at ?p ?l2) (no-robot ?l) (not (no-robot ?l2)) (no-pallette ?l) (not (no-pallette ?l2)))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (ships ?s ?o) (orders ?o ?si) (started ?s) (not (complete ?s)) (packing-location ?l) (packing-at ?s ?l) (at ?p ?l) (contains ?p ?si))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   
   (:action completeShipment 
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (complete ?s) (available ?l) (not (packing-at ?s ?l)) (not (started ?s)))
   )

)
