;;; This file defines object types for use in our simulation
;;; world.  The full world is created in setup.scm.
   		      	 
;;--------------------   		      	 
;; named-object   		      	 
;;   		      	 
;; Named objects are the basic underlying object type in our
;; system. For example, persons, places, and things will all
;; be kinds of (inherit from) named objects.
;;   		      	 
;; Behavior (messages) supported by all named objects:
;;  - Answers #T to the question NAMED-OBJECT?
;;  - Has a NAME that it can return
;;  - Handles an INSTALL message
;;  - Handles a  DESTROY message
   		      	 
(define (make-named-object name)  ; symbol -> named-object
  (let ((root-part (make-root-object)))
    (lambda (message)   		      	 
      (case message   		      	 
	((NAMED-OBJECT?) (lambda (self) #T))
	((NAME) (lambda (self) name))
	((INSTALL) (lambda (self) 'INSTALLED))
	((DESTROY) (lambda (self) 'DESTROYED))
	(else (find-method message root-part))))))
   		      	 
(define (create-named-object name)
  (create make-named-object name))
   		      	 
(define (names-of objects)   		      	 
  ; Given a list of objects, returns a list of their names.
  (map (lambda (x) (ask x 'NAME)) objects))
   		      	 
   		      	 
;;--------------------   		      	 
;; container   		      	 
;;   		      	 
;; A container holds THINGS.   		      	 
;;   		      	 
;; This class is not really meant as a "stand-alone" object class;
;; rather, it is expected that other classes will inherit from the
;; container class in order to be able to contain things.
   		      	 
(define (make-container)  ; void -> container
  (let ((root-part (make-root-object))
	(things '())) ; a list of THING objects in container
    (lambda (message)   		      	 
      (case message   		      	 
	((CONTAINER?) (lambda (self) #T))
	((THINGS) (lambda (self) things))
	((HAVE-THING?)   		      	 
	 (lambda (self thing)  ; container, thing -> boolean
	   (not (eqv? #f (memq thing things)))))
	((ADD-THING)   		      	 
	 (lambda (self new-thing)
	   (if (not (ask self 'HAVE-THING? new-thing))
	       (set! things (cons new-thing things)))
	   'DONE))   		      	 
	((DEL-THING)   		      	 
	 (lambda (self thing)   		      	 
	   (set! things (delq thing things))
	   'DONE))   		      	 
	(else (find-method message root-part))))))
   		      	 
   		      	 
;;--------------------   		      	 
;; thing   		      	 
;;   		      	 
;; A thing is a named-object that has a LOCATION
;;   		      	 
;; Note that there is a non-trivial installer here.  What does it do?
   		      	 
(define (make-thing name location)  ; symbol, location -> thing
  (let ((named-object-part (make-named-object name)))
    (lambda (message)   		      	 
      (case message   		      	 
	((THING?) (lambda (self) #T))
	((LOCATION) (lambda (self) location))
	((INSTALL)   		      	 
	 (lambda (self)		; Install: synchronize thing and place
	   (ask (ask self 'LOCATION) 'ADD-THING self)
	   (delegate named-object-part self 'INSTALL)))
	((DESTROY)   		      	 
	 (lambda (self)         ; Destroy: remove from place
	   (ask (ask self 'LOCATION) 'DEL-THING self)
	   (delegate named-object-part self 'DESTROY)))
	((EMIT)   		      	 
	 (lambda (self text)         ; Output some text
	   (ask screen 'TELL-ROOM (ask self 'LOCATION)
		(append (list "At" (ask (ask self 'LOCATION) 'NAME))
			text))))
	(else (get-method message named-object-part))))))
   		      	 
(define (create-thing name location)
  (create make-thing name location))
   		      	 
;;--------------------   		      	 
;; mobile-thing   		      	 
;;   		      	 
;; A mobile thing is a thing that has a LOCATION that can change.
   		      	 
(define (make-mobile-thing name location)
  ; symbol, location -> mobile-thing
  (let ((thing-part (make-thing name location)))
    (lambda (message)   		      	 
      (case message   		      	 
	((MOBILE-THING?) (lambda (self) #T))
	((LOCATION) 	; This shadows message to thing-part!
	 (lambda (self) location))
	((CHANGE-LOCATION)   		      	 
	 (lambda (self new-location)
	   (ask location 'DEL-THING self)
	   (ask new-location 'ADD-THING self)
	   (set! location new-location)))
	((ENTER-ROOM)   		      	 
	 (lambda (self) #t))   		      	 
	((LEAVE-ROOM)   		      	 
	 (lambda (self) #t))   		      	 
	((CREATION-SITE)   		      	 
	 (lambda (self)   		      	 
	   (delegate thing-part self 'location)))
	(else (get-method message thing-part))))))
   		      	 
(define (create-mobile-thing name location)
  (create make-mobile-thing name location))
   		      	 
;;--------------------   		      	 
;; aware-thing   		      	 
;;   		      	 
;; an aware thing is aware of events happening in the world
;; but initially only knows about noises and takes no action
;; in response to hearing them.
   		      	 
(define (make-aware-thing)   		      	 
  (let ((root-part (make-root-object)))
    (lambda (msg)   		      	 
      (case msg   		      	 
	((AWARE?) (lambda (self) #t))
	((HEARD-NOISE) (lambda (self who) 'nothing))
	(else (find-method msg root-part))))))
; should be combined with other classes (doesn't install or have a name)
   		      	 
;;--------------------   		      	 
;; place   		      	 
;;   		      	 
;; A place is a container (so things may be in the place).
;;   		      	 
;; A place has EXITS, which are passages from one place
;; to another.  One can retrieve all of the exits of a
;; place, or an exit in a given direction from place.
   		      	 
(define (make-place name)  ; symbol -> place
  (let ((named-obj-part (make-named-object name))
	(container-part (make-container))
	(exits '()))	; a list of exits
    (lambda (message)   		      	 
      (case message   		      	 
	((PLACE?) (lambda (self) #T))
	((MAKE-NOISE)   		      	 
	 (lambda (self who)   		      	 
	   (let ((interested (find-all self 'AWARE?)))
	     (for-each (lambda (a) (ask a 'HEARD-NOISE who)) interested)
	     'noise-made)))   		      	 
	((EXITS) (lambda (self) exits))
	((EXIT-TOWARDS)   		      	 
	 (lambda (self direction)
	   (find-exit-in-direction exits direction)))
	((ADD-EXIT)   		      	 
	 (lambda (self exit) ; place, symbol -> exit | #f
	   (let ((direction (ask exit 'DIRECTION)))
	     (cond ((ask self 'EXIT-TOWARDS direction)
		    (error (list name "already has exit" direction)))
		   (else   		      	 
		    (set! exits (cons exit exits))
		    'DONE)))))   		      	 
	(else   		      	 
	 (find-method message container-part named-obj-part))))))
   		      	 
(define (create-place name)   		      	 
  (create make-place name))   		      	 
   		      	 
;;------------------------------------------------------------
;; exit   		      	 
;;   		      	 
;; An exit leads FROM one place TO another in some DIRECTION.
   		      	 
(define (make-exit from direction to)
  ; place, symbol, place -> exit
  (let ((named-object-part (make-named-object direction)))
    (lambda (message)   		      	 
      (case message   		      	 
	((EXIT?)	(lambda (self) #T))
	((FROM) 	(lambda (self) from))
	((TO) 		(lambda (self) to))
	((DIRECTION) 	(lambda (self) direction))
	((USE)   		      	 
	 (lambda (self whom)   		      	 
	   (ask whom 'LEAVE-ROOM)
	   (ask screen 'TELL-ROOM (ask whom 'location)
		(list (ask whom 'NAME)
		      "moves from"
		      (ask (ask whom 'LOCATION) 'NAME)
		      "to"   		      	 
		      (ask to 'NAME)))
	   (ask whom 'CHANGE-LOCATION to)
	   (ask whom 'ENTER-ROOM)))
	((INSTALL)   		      	 
	 (lambda (self)   		      	 
	   (ask (ask self 'FROM) 'ADD-EXIT self)
	   (delegate named-object-part self 'INSTALL)))
	(else (get-method message named-object-part))))))
   		      	 
(define (create-exit from direction to)
  (create make-exit from direction to))
   		      	 
(define (find-exit-in-direction exits dir)
  ; Given a list of exits, find one in the desired direction.
  (cond ((null? exits) #f)   		      	 
	((eq? dir (ask (car exits) 'DIRECTION))
	 (car exits))   		      	 
	(else (find-exit-in-direction (cdr exits) dir))))
   		      	 
(define (random-exit place)   		      	 
  (pick-random (ask place 'EXITS)))
   		      	 
;;--------------------   		      	 
;; person   		      	 
;;   		      	 
;; There are several kinds of person:
;;   There are autonomous persons, including trolls, and there
;;   is the avatar of the user.  The foundation is here.
;;   		      	 
;; A person can move around (is a mobile-thing),
;; and can hold things (is a container). A person responds to
;; a plethora of messages, including 'SAY to say something.
;;   		      	 
   		      	 
(define (make-person name birthplace) ; symbol, location -> person
  (let ((mobile-thing-part (make-mobile-thing name birthplace))
	(container-part    (make-container))
	(health            3)   		      	 
	(strength          1))   	      	 
    (lambda (message)   		      	 
      (case message   		      	 
	((PERSON?) (lambda (self) #T))
	((STRENGTH) (lambda (self) strength))
	((HEALTH) (lambda (self) health))
        ((SAY)   		      	 
         (lambda (self list-of-stuff)
           (ask screen 'TELL-ROOM (ask self 'location)
                (append (list "At" (ask (ask self 'LOCATION) 'NAME)
                                 (ask self 'NAME) "says --")
                           list-of-stuff))))
	((HAVE-FIT)   		      	 
	 (lambda (self)   		      	 
	   (ask self 'SAY '("Yaaaah! I am upset!"))
	   'I-feel-better-now))
   		      	 
	((PEOPLE-AROUND)	; other people in room...
	 (lambda (self)   		      	 
	   (let* ((in-room (ask (ask self 'LOCATION) 'THINGS))
		  (people (myfilter (lambda (x) (is-a x 'PERSON?)) in-room)))
	     (delq self people))))
   		      	 
	((STUFF-AROUND)		; stuff (non people) in room...
	 (lambda (self)   		      	 
	   (let* ((in-room (ask (ask self 'LOCATION) 'THINGS))
		  (stuff (myfilter (lambda (x) (not (is-a x 'PERSON?))) in-room)))
	     stuff)))   		      	 
   		      	 
	((PEEK-AROUND)		; other people's stuff...
	 (lambda (self)   		      	 
	   (let ((people (ask self 'PEOPLE-AROUND)))
	     (accumulate append '() (map (lambda (p) (ask p 'THINGS)) people)))))
   		      	 
	((TAKE)   		      	 
	 (lambda (self thing)   		      	 
	   (cond ((ask self 'HAVE-THING? thing)  ; already have it
		  (ask self 'SAY (list "I am already carrying"
				       (ask thing 'NAME))))
		 ((or (is-a thing 'PERSON?)
		      (not (is-a thing 'MOBILE-THING?)))
		  (ask self 'SAY (list "I try but cannot take"
				       (ask thing 'NAME))))
		 (else   		      	 
		  (let ((owner (ask thing 'LOCATION)))
		    (ask self 'SAY (list "I take" (ask thing 'NAME)
					 "from" (ask owner 'NAME)))
		    (if (is-a owner 'PERSON?)
			(ask owner 'LOSE thing self)
			(ask thing 'CHANGE-LOCATION self))
		    thing)))))   		      	 
   		      	 
	((LOSE)   		      	 
	 (lambda (self thing lose-to)
	   (ask self 'SAY (list "I lose" (ask thing 'NAME)))
	   (ask self 'HAVE-FIT)
	   (ask thing 'CHANGE-LOCATION lose-to)))
   		      	 
	((DROP)   		      	 
	 (lambda (self thing)   		      	 
	   (ask self 'SAY (list "I drop" (ask thing 'NAME)
				"at" (ask (ask self 'LOCATION) 'NAME)))
	   (ask thing 'CHANGE-LOCATION (ask self 'LOCATION))))
   		      	 
        ((GO-EXIT)   		      	 
         (lambda (self exit)   		      	 
           (ask exit 'USE self)))
   		      	 
	((GO)   		      	 
	 (lambda (self direction) ; person, symbol -> boolean
	   (let ((exit (ask (ask self 'LOCATION) 'EXIT-TOWARDS direction)))
	     (if (is-a exit 'EXIT?)
                 (ask self 'GO-EXIT exit)
		 (begin (ask screen 'TELL-ROOM (ask self 'LOCATION)
			     (list "No exit in" direction "direction"))
			#F)))))
	((SUFFER)   		      	 
	 (lambda (self hits)   		      	 
	   (ask self 'SAY (list "Ouch!" hits "hits is more than I want!"))
	   (set! health (- health hits))
	   (if (<= health 0) (ask self 'DIE))
	   health))

        
 ((DIE)   	; depends on global variable "death-exit"	      	 
	  (lambda (self)   		      	 
	    (ask self 'SAY '("SHREEEEK!  I, uh, suddenly feel very faint..."))
	    (for-each (lambda (item) (ask self 'LOSE item (ask self 'LOCATION)))
	 	     (ask self 'THINGS))
	    (ask self 'DEATH-SCREAM)
	    (ask death-exit 'USE self)
	    'GAME-OVER-FOR-YOU-DUDE))
   		      	 
	((DEATH-SCREAM)   		      	 
	 (lambda (self)   		      	 
	   (ask screen 'TELL-WORLD
		'("An earth-shattering, soul-piercing scream is heard..."))))
   		      	 
	((ENTER-ROOM)   		      	 
	 (lambda (self)   		      	 
	   (let ((others (ask self 'PEOPLE-AROUND)))
	     (if (not (null? others))
		 (ask self 'SAY (cons "Hi" (names-of others)))))
	   (ask (ask self 'location) 'make-noise self)
	   #T))   		      	 
   		      	 
	(else (find-method message mobile-thing-part container-part))))))
   		      	 
(define (create-person name birthplace)
  (create make-person name birthplace))
   		      	 
;;--------------------   		      	 
;; autonomous-player   		      	 
;;   		      	 
;; activity determines maximum movement
;; miserly determines chance of picking stuff up
   		      	 
(define (make-autonomous-player name birthplace activity miserly)
  (let ((person-part (make-person name birthplace)))
    (lambda (message)   		      	 
      (case message   		      	 
	((AUTONOMOUS-PLAYER?) (lambda (self) #T))
	((INSTALL) (lambda (self)
		     (ask clock 'ADD-CALLBACK
			  (make-clock-callback 'move-and-take-stuff self
					       'MOVE-AND-TAKE-STUFF))
		     (delegate person-part self 'INSTALL)))
	((MOVE-AND-TAKE-STUFF)   		      	 
	 (lambda (self)   		      	 
	   ;; first move   		      	 
	   (let loop ((moves (random-number activity)))
	     (if (= moves 0)   		      	 
		 'done-moving   		      	 
		 (begin   		      	 
		   (ask self 'MOVE-SOMEWHERE)
		   (loop (- moves 1)))))
	   ;; then take stuff   		      	 
	   (if (= (random miserly) 0)
		  (ask self 'TAKE-SOMETHING))
	   'done-for-this-tick))
	((DIE)   		      	 
	 (lambda (self)   		      	 
	   (ask clock 'REMOVE-CALLBACK self 'move-and-take-stuff)
	   (delegate person-part self 'DIE)))
	((MOVE-SOMEWHERE)   		      	 
	 (lambda (self)   		      	 
	   (let ((exit (random-exit (ask self 'LOCATION))))
	     (if (not (eqv? #f exit)) (ask self 'GO-EXIT exit)))))
	((TAKE-SOMETHING)   		      	 
	 (lambda (self)   		      	 
	   (let* ((stuff-in-room (ask self 'STUFF-AROUND))
		  (other-peoples-stuff (ask self 'PEEK-AROUND))
		  (pick-from (append stuff-in-room other-peoples-stuff)))
	     (if (not (null? pick-from))
		 (ask self 'TAKE (pick-random pick-from))
		 #F))))   		      	 
	(else (get-method message person-part))))))
   		      	 
(define (create-autonomous-player name birthplace activity miserly)
  (create make-autonomous-player name birthplace activity miserly))
   		      	 
;;--------------------   		      	 
;; troll   		      	 
;;   		      	 
;; An person that randomly attacks people.
;; The happier the troll is, the less likely it is to attack someone.
;;   		      	 
(define (make-troll name birthplace laziness happiness)
  ; symbol, location, integer, integer -> troll
  (let ((person-part (make-person name birthplace)))
    (lambda (message)   		      	 
      (case message   		      	 
        ((TROLL?) (lambda (self) #T))
	((INSTALL)   		      	 
	 (lambda (self)   		      	 
	   (ask clock 'ADD-CALLBACK
		(make-clock-callback 'rove-and-attack self
				     'ROVE-AND-ATTACK))
	   (delegate person-part self 'INSTALL)))
	((DIE)   		      	 
	 (lambda (self)   		      	 
	   (ask clock 'REMOVE-CALLBACK self 'rove-and-attack)
	   (delegate person-part self 'DIE)))
        ((ROVE-AND-ATTACK)   		      	 
         (lambda (self)   		      	 
           (if (= (random laziness) 0) (ask self 'MOVE-SOMEWHERE))
           (if (= (random happiness) 0) (ask self 'ATTACK-SOMEONE))
           'ok))   		      	 
	((MOVE-SOMEWHERE)   		      	 
	 (lambda (self)   		      	 
	   (let ((exit (random-exit (ask self 'LOCATION))))
	     (if (not (eqv? #f exit)) (ask self 'GO-EXIT exit)))))
        ((ATTACK-SOMEONE)   		      	 
         (lambda (self)   		      	 
           (let ((others (ask self 'PEOPLE-AROUND)))
             (if (not (null? others))
                 (let ((victim (pick-random others)))
                   (ask self 'SAY (list "Prepare to suffer,"
                                        (ask victim 'NAME) "!"))
                   (ask victim 'SUFFER (random-number 3))))
             'troll-is-tired)))
        (else (get-method message person-part))))))
   		      	 
(define (create-troll name birthplace laziness happiness)
  (create make-troll name birthplace laziness happiness))
   		      	 
;;--------------------   		      	 
;; avatar   		      	 
;;   		      	 
;; The avatar of the user is also a person.
   		      	 
(define (make-avatar name birthplace) ; symbol, location -> avatar
  (let ((person-part (make-person name birthplace)))
    (lambda (message)   		      	 
      (case message   		      	 
	((AVATAR?) (lambda (self) #T))
   		      	 
	((LOOK-AROUND)		; report on world around you
	 (lambda (self)   		      	 
	   (let* ((place (ask self 'LOCATION))
		  (exits (ask place 'EXITS))
		  (other-people (ask self 'PEOPLE-AROUND))
		  (my-stuff (ask self 'THINGS))
		  (stuff (ask self 'STUFF-AROUND)))
	     (ask screen 'TELL-WORLD (list "You are in" (ask place 'NAME)))
	     (ask screen 'TELL-WORLD
	      (if (null? my-stuff)
		  '("You are not holding anything.")
		  (append '("You are holding:") (names-of my-stuff))))
	     (ask screen 'TELL-WORLD
	      (if (null? stuff)
		  '("There is no stuff in the room.")
		  (append '("You see stuff in the room:") (names-of stuff))))
	     (ask screen 'TELL-WORLD
	      (if (null? other-people)
		  '("There are no other people around you.")
		  (append '("You see other people:") (names-of other-people))))
	     (ask screen 'TELL-WORLD
	      (if (not (null? exits))
		  (append '("The exits are in directions:") (names-of exits))
		  ;; heaven is only place with no exits
		  '("There are no exits... you are dead and gone to heaven!")))
	     'OK)))   		      	 
   		      	 
	((GO)   		      	 
	 (lambda (self direction)  ; Shadows person's GO
	   (let ((success? (delegate person-part self 'GO direction)))
	     (if success?   		      	 
                 (begin (ask clock 'TICK)
                        (ask self 'LOOK-AROUND)));;I changed this line to look around.
	     success?)))   		      	 
	((GET)   		      	 
	 (lambda (self tname)   		      	 
	   (let ((objs (myfilter (lambda (x) (eq? (ask x 'name) tname))
			       (ask (ask self 'location) 'things))))
	     (if (null? objs)   		      	 
		 (ask self 'say `(I do not see a ,tname here))
		 (ask self 'take (car objs))))))
	((TOSS)   		      	 
	 (lambda (self tname)   		      	 
	   (let ((objs (myfilter (lambda (x) (eq? (ask x 'name) tname))
			       (ask self 'things))))
	     (if (null? objs)   		      	 
		 (ask self 'say `(I do not have a ,tname))
		 (ask self 'drop (car objs))))))
	((TAKE)   		      	 
	 (lambda (self thing)   		      	 
	   (let ((thing (delegate person-part self 'TAKE thing)))
	     (if (and (not (null? thing))
		      (eq? 'diploma (ask thing 'NAME)))
		 (ask self 'SAY '("   HURRRAY!!!!!!!!!!!!!"))))))
   		      	 
	(else (get-method message person-part))))))
   		      	 
(define (create-avatar name birthplace)
  (create make-avatar name birthplace))
   		      	 
   		      	 
   		      	 
   		      	 
