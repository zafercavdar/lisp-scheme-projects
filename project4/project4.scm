;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;::;;;:
;;;   The Object-Oriented Adventure Game
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;::;;:;
;;;   		      	 
;;; zcavdar14@ku.edu.tr     Mon Dec  5 17:13:31 2016
(#%require (only racket/base random))
(load "objsys.scm")   		      	 
(load "objtypes.scm")   		      	 
(load "setup.scm")   		      	 
(define nil '())   		      	 
(define your-answer-here #f)   		      	 
;;;;;;;;;   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;::;;::
;;; PART II. Programming Assignment
;;;   		      	 
;;; The answers to the computer exercises in Section 5 go in the
;;; appropriate sections below.
;;;
  		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;::;:;;
;;;;;;;;;;;;; Computer Exercise 0: Setting up ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   		      	 
;;;;;;;;;;;;; CODES: ;;;;;;;;;;;;;
;;

;(ask screen 'deity-mode #f)
;(setup 'zafer)
;(ask me 'say (list 'i 'am 'at (ask (ask me 'location) 'name)))
;(ask me 'say (list 'i 'am (ask me 'name)))
;(ask me 'say '("Hello World"))
;(ask me 'go (ask (car (ask (ask me 'location) 'EXITS)) 'name))
;(ask me 'take (thing-named 'diploma))
;(ask me 'toss 'diploma)
;(ask me 'die)

;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;::;:;:
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
;ready

;At bursar-office zafer says -- i am at bursar-office 
;At bursar-office zafer says -- i am zafer 
;At bursar-office zafer says -- Hello World 
;zafer moves from bursar-office to registrar-office 
;--- the-clock Tick 0 --- 
;You are in registrar-office 
;You are not holding anything. 
;You see stuff in the room: diploma 
;There are no other people around you. 
;The exits are in directions: west out #t

;At registrar-office zafer says -- I take diploma from registrar-office 
;At registrar-office zafer says --    HURRRAY!!!!!!!!!!!!! 
;At registrar-office zafer says -- I drop diploma at registrar-office 
;At registrar-office zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... 
;An earth-shattering, soul-piercing scream is heard... 
;zafer moves from registrar-office to heaven game-over-for-you-dude   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;::;::;
   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;::;:::
;;;;;; Computer Exercise 1: Understanding installation;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;:::;;;
;;   		      	 
;;;;;;;;;;;;; ANSWER: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
#|
From the project description (page 5):
"The important difference is that if we ask an object to do something, then the self value passed to the
method will be the object itself. Using delegate, on the other hand, we can explicitly control what the
self value will be that is passed to the method, and can thus have a part (inherited superclass) of the
object do something to the whole object."

In this question, Alyssa points that if ask method is used instead of delegate method, we pass the superclass object as a self to the method.
in this situation, if you move your autonomous person, its superclass's location will be changed an will have 2 different locations.
Instead, if we use delegate, it will get the method from superclass and call for subclass.
i.e:
(method (get-method message in-object))
(apply method for-object)
and movement will change the location of subclass.
|#   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:;:;:::;;:
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;;;;
;;;;;;;;;;;; Computer Exercise 2: Who just died? ;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;;;:
;;   		      	 
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 

;(run-clock 10)
;(ask (car (ask heaven 'THINGS)) 'name)		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;;:;
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; person's DIE method calls (ask death-exit 'USE self) line.
; death-exit is defined as (make-exit nil 'heaven heaven) in setup.scm
; so, person will go to the heaven.
; heaven is a place which inherits a container and a named-object.
; things in a place are stored in container and ADD-THING method adds new object to the head of the <things> list.
; we ask for 'THINGS (inherited from container) to heaven and take the car of the things list.
; (car (ask heaven 'THINGS)) returns a person.
; we ask this person his/her 'name.
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;;::
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
;--- the-clock Tick 0 --- 
;--- the-clock Tick 1 --- 
;At eng-building prof-yuret says -- Hi zafer 
;--- the-clock Tick 2 --- 
;prof-yuret moves from eng-building to soccer-field 
;--- the-clock Tick 3 --- 
;An earth-shattering, soul-piercing scream is heard... 
;At eng-building prof-yuret says -- Hi zafer 
;--- the-clock Tick 4 --- 
;An earth-shattering, soul-piercing scream is heard... 
;An earth-shattering, soul-piercing scream is heard... 
;prof-yuret moves from eng-building to sci-building 
;--- the-clock Tick 5 --- 
;At eng-building lambda-man says -- Hi zafer 
;lambda-man moves from eng-building to sci-building 
;At eng-building prof-yuret says -- Hi zafer 
;--- the-clock Tick 6 --- 
;prof-yuret moves from eng-building to parking-lot 
;--- the-clock Tick 7 --- 
;At eng-building lambda-man says -- Hi zafer 
;At eng-building prof-yuret says -- Hi lambda-man zafer 
;At eng-building prof-yuret says -- I take transcript from lambda-man 
;At eng-building lambda-man says -- I lose transcript 
;At eng-building lambda-man says -- Yaaaah! I am upset! 
;--- the-clock Tick 8 --- 
;lambda-man moves from eng-building to eng-z21 
;prof-yuret moves from eng-building to sci-building 
;--- the-clock Tick 9 --- done
;suzy   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;:;;
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;:;:
;;;;;;;; Computer exercise 3: Having a quick look ;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;::;
;;   		      	 
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 

; GO method of avatar now looks like:

;((GO)   		      	 
;	 (lambda (self direction)  ; Shadows person's GO
;	   (let ((success? (delegate person-part self 'GO direction)))
;	     (if success?   		      	 
;                 (begin (ask clock 'TICK)
;                        (ask self 'LOOK-AROUND))) ;this line is added
;	     success?)))

;(ask me 'go (ask (car (ask (ask me 'location) 'EXITS)) 'name)) ;; go to one of the available exists
;(ask me 'go (ask (car (ask (ask me 'location) 'EXITS)) 'name)) ;;go to one of the available exists		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;::;:::
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; avatar does not have GO method, it delegates input 'GO and direction to its superclass person.
; 'GO method returns true if direction is one of the exists, else returns false
; we check if it returs true, ask clock 1 tick and ask avatar (self) to 'LOOK-AROUND
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;:::;;;
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
;zafer moves from soccer-field to eng-building 
;At eng-building lambda-man says -- Hi zafer 
;--- the-clock Tick 0 --- 
;You are in eng-building 
;You are not holding anything. 
;There is no stuff in the room. 
;You see other people: lambda-man 
;The exits are in directions: south in west north #t

;zafer moves from eng-building to sci-building 
;At sci-building lambda-man says -- Hi zafer 
;lambda-man moves from sci-building to sos-building 
;--- the-clock Tick 1 --- 
;You are in sci-building 
;You are not holding anything. 
;There is no stuff in the room. 
;There are no other people around you. 
;The exits are in directions: south north #t   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;::;;:::;;:
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;;;;
;;;;;; Computer exercise 4: But I'm too young to die!! ;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;;;:
;;   		      	 
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
(define (make-person name birthplace) ; symbol, location -> person
  (let ((mobile-thing-part (make-mobile-thing name birthplace))
	(container-part    (make-container))
	(health            3)   		      	 
	(strength          1)   		      	 
   (lives             3))   		      	 
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
                           list-of-stuff))
                  'SAID-AND-HEARD))
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
				       (ask thing 'NAME)))
		  #f)   		      	 
		 ((or (is-a thing 'PERSON?)
		      (not (is-a thing 'MOBILE-THING?)))
		  (ask self 'SAY (list "I try but cannot take"
				       (ask thing 'NAME)))
		  #F)   		      	 
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
   ; original SUFFER method
	;((SUFFER)   		      	 
	; (lambda (self hits)   		      	 
	;   (ask self 'SAY (list "Ouch!" hits "hits is more than I want!"))
	;   (set! health (- health hits))
	;   (if (<= health 0) (ask self 'DIE))
	;   health))

   ; My new version:
   ((SUFFER)   		      	 
    (lambda (self hits)
      (define remaining-hit hits)
      (map (lambda (x)
             (if (is-a x 'PROTECTOR?)
                 (set! remaining-hit (ask x 'PROTECT remaining-hit))
                 ))
                            (ask self 'THINGS))

      (if (= remaining-hit 0)
          (ask self 'SAY (list "I got NO damage!"))
          (begin
            (ask self 'SAY (list "Ouchhhh!" remaining-hit "hits is more than I want!"))
            (set! health (- health remaining-hit))
            (if (<= health 0) (ask self 'DIE))
            health))))
   		      	 
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
   		      	 
	;; Here is the original DIE method
   #|   		      	 
	 ((DIE)   		      	 
	  (lambda (self)   		      	 
	    (ask self 'SAY '("SHREEEEK!  I, uh, suddenly feel very faint..."))
	    (for-each (lambda (item) (ask self 'LOSE item (ask self 'LOCATION)))
	 	     (ask self 'THINGS))
	    (ask self 'DEATH-SCREAM)
	    (ask death-exit 'USE self)
	    'GAME-OVER-FOR-YOU-DUDE))
   |#   		      	 
	;; Your version goes here:	      	 
    ((DIE)
     (lambda (self)   		      	 
	    (ask self 'SAY '("SHREEEEK!  I, uh, suddenly feel very faint..."))
	    (for-each (lambda (item) (ask self 'LOSE item (ask self 'LOCATION)))
	 	     (ask self 'THINGS))
       (set! lives (- lives 1))
       (if (eq? lives 0)
           (begin (ask self 'DEATH-SCREAM)
                  (ask death-exit 'USE self)
                  'GAME-OVER-FOR-YOU-DUDE)
           (begin (set! health 3)
                  (delegate mobile-thing-part self 'CHANGE-LOCATION birthplace)
                  (list 'I 'DIDNT 'DIE 'I 'STILL 'HAVE lives 'LIVES)))
	   ))   		      	 
   		      	 
	(else (find-method message mobile-thing-part container-part))))))

;(setup 'zafer)
;(ask me 'die)
;(ask me 'say (list 'I 'AM 'AT (ask (ask me 'location) 'name)))
;(ask me 'die)
;(ask me 'say (list 'I 'AM 'AT (ask (ask me 'location) 'name)))
;(ask me 'die)
;(ask me 'say (list 'I 'AM 'AT (ask (ask me 'location) 'name)))
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;;:;
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; lives is decremented by 1.
; then we check if lives is equal to 0, original DIE method scenario is applied.
; if lives is not equal to 0, we set health to 3 and call the 'CHANGE-LOCATION method of mobile-thing-part with argument birthplace.
   		      	 
   		      	      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;;::
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;   		      	 

;At adm-building zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... (i didnt die i still have 2 lives)
;At adm-building zafer says -- i am at adm-building said-and-heard
;At adm-building zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... (i didnt die i still have 1 lives)
;At adm-building zafer says -- i am at adm-building said-and-heard
;At adm-building zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... 
;An earth-shattering, soul-piercing scream is heard... 
;zafer moves from adm-building to heaven game-over-for-you-dude
;At heaven zafer says -- i am at heaven said-and-heard

   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;:;;
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 	      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;:;:
;;; Computer exercise 5: Perhaps to arm oneself against a sea of .... ;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;::;
;;   		      	 
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 
(define (make-weapon name location damage)
  (let ((mobile-thing-part (make-mobile-thing name location)))
    (lambda (message)
      (case message
        ((WEAPON?) (lambda (self) #T))
        ((DAMAGE) (lambda (self) damage))
        ((HIT) (lambda (self hitter target)
                   (ask self 'emit (list (ask hitter 'NAME) " is hitting to " (ask target 'NAME) " with " (ask self 'name))) 
                   (ask target 'SUFFER (random-number damage)))
                 )

        ((EMIT)   		      	 
         (lambda (self text)         ; Output some text
           (if (is-a (ask self 'LOCATION) 'PERSON?)
               
               (ask screen 'TELL-ROOM (ask (ask self 'LOCATION) 'LOCATION)
                (append (list "At" (ask (ask (ask self 'LOCATION) 'LOCATION) 'NAME) ", ")
			text))
               
               (ask screen 'TELL-ROOM (ask self 'LOCATION)
                (append (list "At" (ask (ask self 'LOCATION) 'NAME) ", ")
			text))
               )))
        
        (else (get-method message mobile-thing-part))
        ))))

(define (create-weapon name location damage)
  (create make-weapon name location damage))

                  		     
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;::;:::
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; The weapon class that I wrote has 3 methods, WEAPON? simply checks whether the object is weapon or not.
; DAMAGE method returns max-damage of the weapon.
; HIT method takes 2 arguments, hitter person and target player.
; HIT firsly emit who is hitting to whom with which weapon, then calls target's suffer method.
; Weapon class takes 3 parameters during construction. It has name, location and max damage.
; The class extends mobile-thing class.
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;:::;;;
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;

;(setup 'zafer)
;(define lightsaber (create-weapon 'lightsaber (ask me 'location) 9))
;(define TA (create-autonomous-player 'TA (ask me 'location) 1 2))

;(ask lightsaber 'HIT me TA)
;At sci-building zafer  is hitting to  ta  with  lightsaber 
;At sci-building ta says -- Ouch! 7 hits is more than I want! 
;At sci-building ta says -- SHREEEEK!  I, uh, suddenly feel very faint... 3

;(ask lightsaber 'HIT me TA)
;At sci-building zafer  is hitting to  ta  with  lightsaber 
;At sci-building ta says -- Ouch! 9 hits is more than I want! 
;At sci-building ta says -- SHREEEEK!  I, uh, suddenly feel very faint... 3


;(ask lightsaber 'HIT me TA)
;At sci-building zafer  is hitting to  ta  with  lightsaber 
;At sci-building ta says -- Ouch! 3 hits is more than I want! 
;At sci-building ta says -- SHREEEEK!  I, uh, suddenly feel very faint... 
;An earth-shattering, soul-piercing scream is heard... 
;ta moves from sci-building to heaven 0   		      	 
   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;::;:::;:::;;:
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;;;;
;;;;;;;; Computer exercise 6: Good thing I'm armed and dangerous ;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;;;:
;;   		      	 
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 
(define (make-violent-person name birthplace activity miserly freq)
  (let ((autonomous-player-part (make-autonomous-player name birthplace activity miserly)))
    (lambda (message)
      (case message
        ((VIOLENT-PERSON?) (lambda (self) #T))
        ((INSTALL) (lambda (self)
		     (ask clock 'ADD-CALLBACK
			  (make-clock-callback 'check-engage-in-violent self 'CHECK-ENGAGE-IN-VIOLENT))
		     (delegate autonomous-player-part self 'INSTALL)))

        ((CHECK-ENGAGE-IN-VIOLENT)   		      	 
         (lambda (self)
           (let ((victims (ask self 'PEOPLE-AROUND)))
             (if (not (null? victims))
                 (let ((prob (random-number freq)))
                   (if (eq? prob 1) ; violent act is required
                       (let* ((victim (pick-random victims)) ; choose random victim
                              (weapons (myfilter (lambda (x) (is-a x 'WEAPON?)) (ask self 'THINGS)))) ; choose random weapon

                         (if (null? weapons)
                             'I-DONT-HAVE-WEAPON
                             (begin 
                               ;(ask self 'TAKE weapon)
                               (ask (pick-random weapons) 'HIT self victim) ; act
                               'ENGAGED-IN-A-VIOLENT-ACT)))
                       
                       'NOT-ENGAGED-IN-A-VIOLENT-ACT) ; not engaged in a violent act
                       )
                 'NO-PEOPLE-AROUND))
             ))

        ((DIE)    	  	   	 
         (lambda (self)    	  	   	 
           (ask clock 'REMOVE-CALLBACK self 'CHECK-ENGAGE-IN-VIOLENT)
           (delegate autonomous-player-part self 'DIE)))

        (else (get-method message autonomous-player-part))))))

(define (create-violent-person name birthplace activity miserly freq)
  (create make-violent-person name birthplace activity miserly freq))


;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;;:;
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; The violent player class constructor takes 5 parameters and extends autonomous-player class.
; As a difference, violent player has a violence frequency and with some randomness,
; a violent player chooses a person in the same room and chooses a weapon from its bag and hits the other player.
; this action is added to clock as a callback and every clock tick, CHECK-ENGAGE-IN-VIOLENT method is called.
; DIE method removes the callback from clock.
; To test CHECK-ENGAGE-IN-VIOLENT method, I created a kafes(cage) place and put myself and violent player into this place.
; I added 2 weapons to this place and run the clock 5 times.
; violent player first picked the weapons from floor
; then, attacked me after 1 clock.
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;;::
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;

;(setup 'zafer)
;(define kafes (create-place 'kafes))
;(ask me 'CHANGE-LOCATION kafes)
;(define expert-bot (create-violent-person 'expert-bot kafes 1 2 2))
;(define ak47 (create-weapon 'ak47 kafes 9))
;(define m4a1 (create-weapon 'm4a1 kafes 7))
;(run-clock 5)

;At kafes expert-bot says -- I take m4a1 from kafes 
;--- the-clock Tick 0 --- 
;--- the-clock Tick 1 --- 
;At kafes ,  expert-bot  is hitting to  zafer  with  m4a1 
;At kafes zafer says -- Ouch! 5 hits is more than I want! 
;At kafes zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... 
;--- the-clock Tick 2 --- 
;--- the-clock Tick 3 --- 
   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;:;;
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;:;:
;;; Computer exercise 7: A good hacker could defuse this situation ;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;::;
;;   		      	 
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 
(define (make-bomb name location damage)
  (let* ((mobile-thing-part (make-mobile-thing name location))
         (aware-thing-part (make-aware-thing))
         (armed #f)
         (destroyed #f))
    
    (lambda (message)
      (case message
        ((BOMB?) (lambda (self) #T))
        ((ARM) (lambda (self)
                 (set! armed #t)))
        ((DISARM) (lambda (self)
                    (set! armed #f)))
        ((TRIGGER) (lambda (self)
                     (if armed (ask self 'ACTIVATE) 'BOMB-IS-NOT-ARMED-YET)))
        ((HEARD-NOISE) (lambda (self someone)
                         (ask self 'TRIGGER)))
        ((ACTIVATE)
         (lambda (self)
           (if destroyed
               'BOMB-IS-ALREADY-DESTROYED
               (let* ((victims (ask self 'people-around)))
                 (map (lambda (victim)
                        (ask victim 'SUFFER damage)) victims)
                 (ask self 'EMIT (list "Type of the bomb: " (ask self 'NAME) " -- and these people suffered " damage "damage"
                          (map (lambda (victim) (ask victim 'NAME)) victims))) 
                 (ask self 'DESTROY)))))            
         
        ((DESTROY)
         (lambda (self)
           (set! destroyed #t)
           (delegate mobile-thing-part self 'DESTROY)))

        ((IS-ARMED)
         (lambda (self)
           armed))

         ((PEOPLE-AROUND)
          (lambda (self)   		      	 
            (let* ((in-room (ask (ask self 'LOCATION) 'THINGS))
                   (people (myfilter (lambda (x) (is-a x 'PERSON?)) in-room)))
              (delq self people))))

        (else (find-method message mobile-thing-part aware-thing-part))))))

(define (create-bomb name location damage)
  (create make-bomb name location damage))

   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;::;:::
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; Bomb class constructor takes 3 parameters: name location and damage. It extends both Mobile Thing and Aware classes.
; It has BOMB?, ARM, DISARM, TRIGGER, HEARD-NOISE, ACTIVATE, DESTROY and PEOPLE-AROUND methods.
; Bomb return whether the object is bomb or not.
; ARM simply sets arm to true.
; DISARM simply sets arm to false.
; TRIGGER calls ACTIVATE if arm == true
; ACTIVATE looks for people around and suffer them with bomb damage and emits people and damage information if the bomb is not destroyed.
; DESTROY sets destroyed to true and delegates remaining work to mobile-thing-part
; PEOPLE-AROUND returns the list of people in the location.

; To test if the bomb class methods work or not, I created a bomb and put it my location.
; Then I leave the room and come back.
; When I come back to room, I make a noise and trigger method is called, the bomb was activated and I got damage.
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;:::;;;
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;

;> (setup 'zafer)
;> (define tnt (create-bomb 'tnt (ask me 'LOCATION) '15))
;> (ask tnt 'ARM)
;> (ask me 'LOOK-AROUND)

;You are in gym 
;You are not holding anything. 
;You see stuff in the room: tnt tnt basketball 
;There are no other people around you. 
;The exits are in directions: east ok
;> (ask me 'GO 'EAST)

;zafer moves from gym to library 
;--- the-clock Tick 0 --- 
;You are in library 
;You are not holding anything. 
;You see stuff in the room: engineering-book 
;There are no other people around you. 
;The exits are in directions: west east #t
;> (ask me 'GO 'WEST)

;zafer moves from library to gym 
;At gym zafer says -- Ouch! 15 hits is more than I want! 
;At gym zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... 
;At gym Type of the bomb:  tnt  -- and these people suffered  15 damage (zafer) 
;--- the-clock Tick 1 --- 
;You are in gym 
;You are not holding anything. 
;You see stuff in the room: tnt basketball 
;There are no other people around you. 
;The exits are in directions: east #t

   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;;;:::;;:
   		      	 
  		      	 
   		      	 
		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;;;;
;;;; Computer exercise 8: Well, maybe only if they have enough time ;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;;;:
;;   		      	 
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 
(define (make-time-bomb name location damage lifetime)
  (let* ((bomb-part (make-bomb name location damage))
         (left-time lifetime)
         (is-triggered #f)
         )
    
    (lambda (message)
      (case message

        ((INSTALL) (lambda (self)
                     (ask clock 'ADD-CALLBACK
                          (make-clock-callback 'TICK self 'TICK))
                     (delegate bomb-part self 'INSTALL)))

        ((TICK)
         (lambda (self)
           (if is-triggered
               (begin 
                 (set! left-time (- left-time 1))
                 (if (= left-time 0)
                     (begin 
                       (ask self 'ACTIVATE)
                       (set! is-triggered #t))
                     
                     (ask self 'emit (list left-time "seconds remained to explode!"))
                                        )))))

        ((TRIGGER) (lambda (self)
                     (if (ask self 'IS-ARMED)
                         (set! is-triggered #t))))
                    
        (else (get-method message bomb-part))))))

(define (create-bomb-with-timer name location damage lifetime)
  (create make-time-bomb name location damage lifetime))


   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;;:;
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; Time Bomb class extends Bomb class and overrides TRIGGER method. Now trigger method does not activate the bomb but sets is-triggered to true.
; We added TICK method as a callback for CLOCK and each time clock ticks, TICK method is called.
; TICK method decreases left-time by 1 if the bomb is triggered.
; If left-time is 0, it calls activate method.
; else, it emits how much time left until explode.
; Time Bomb constructor has 1 more parameter, lifetime, different than the Bomb constructor.
; To test whether the class is working or not, I created a time bomb and put it my location.
; Then I leave the room and come back.
; When I come back to room, I make a noise and trigger method is called. I run the clock 4 times.
; In the first 3 runs, time bomb said x seconds remained to explode.
; In the last run, it exploded and I got damaged.
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;;::
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;

;> (setup 'zafer)
;> (define tnt (create-bomb-with-timer 'tnt (ask me 'LOCATION) 15 4))
;> (ask tnt 'ARM)
;> (ask me 'LOOK-AROUND)   		      	 
;You are in eng-auditorium 
;You are not holding anything. 
;You see stuff in the room: tnt final-exam 
;There are no other people around you. 
;The exits are in directions: north ok

;> (ask me 'GO 'NORTH)

;zafer moves from eng-auditorium to eng-z21 
;At eng-z21 prof-yuret says -- Hi zafer 
;--- the-clock Tick 0 --- 
;You are in eng-z21 
;You are not holding anything. 
;You see stuff in the room: problem-set 
;You see other people: prof-yuret 
;The exits are in directions: up down south out #t
;> (ask me 'GO 'SOUTH)

;zafer moves from eng-z21 to eng-auditorium 
;At eng-auditorium 3 seconds remained to explode! 
;--- the-clock Tick 1 --- 
;You are in eng-auditorium 
;You are not holding anything. 
;You see stuff in the room: tnt final-exam 
;There are no other people around you. 
;The exits are in directions: north #t
;> (run-clock 1)

;At eng-auditorium 2 seconds remained to explode! 
;--- the-clock Tick 2 --- done
;> (run-clock 1)

;At eng-auditorium 1 seconds remained to explode! 
;--- the-clock Tick 3 --- done
;> (run-clock 1)

;At eng-auditorium zafer says -- Ouch! 15 hits is more than I want! 
;At eng-auditorium zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... 
;At eng-auditorium Type of the bomb:  tnt  -- and these people suffered  15 damage (zafer) 
;--- the-clock Tick 4 --- done
;>    		      	 
   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;:;;
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;:;:
;;;;;;;;; Computer Exercise 9: Even you can change the world! ;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;::;
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;::;:::
;;;;;;;;;;;;; DESCRIPTION: ;;;;;;;;;;;;;
;;   		      	 
; I added a new class named Protector and changed Person class's SUFFER method.
; All details are in the part explanation.
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;:::;;;
;;;;;;;;;;;;; CODE: ;;;;;;;;;;;;;
;;   		      	 
(define (make-protector name location durability)
  (let ((mobile-thing-part (make-mobile-thing name location)))
    
    (lambda (message)
      (case message
        
        ((PROTECTOR?) (lambda (self) #t))
        ((DURABILITY) (lambda (self) durability))

        ((INSTALL) (lambda (self)
                     (ask clock 'ADD-CALLBACK
                          (make-clock-callback 'BECOME-OLD self 'BECOME-OLD))
                     (delegate mobile-thing-part self 'INSTALL)))

        ((BECOME-OLD) ;called at every clock tick
         (lambda (self)
           (if (> durability 0)
               (set! durability (- durability 1))
               (set! durability 0)
               )
           (ask self 'EMIT (list "time passed and durability of " name " is decreased to" durability))
            ))           
        
        ((PROTECT) (lambda (self weapon) ;absorb the damage, return remaining damage
                     (let* ((damage weapon))
                       (if (> (- durability damage) -1)
                           (begin
                             (ask self 'emit (list "the protector absorbed all damage(" damage ") and remaining durability is " (- durability damage))) 
                             (set! durability (- durability damage)) 0)
                           (begin
                             (ask self 'emit (list "the protector absorbed some damage(" durability ") and it's broken."))
                             (let ((temp durability))
                               (set! durability 0)
                               (- damage temp)))))))
        ((EMIT)   		      	 
         (lambda (self text)
           (if (is-a (ask self 'LOCATION) 'PERSON?)
               
               (ask screen 'TELL-ROOM (ask (ask self 'LOCATION) 'LOCATION)
                (append (list "At" (ask (ask (ask self 'LOCATION) 'LOCATION) 'NAME) ", ")
			text))
               
               (ask screen 'TELL-ROOM (ask self 'LOCATION)
                (append (list "At" (ask (ask self 'LOCATION) 'NAME) ", ")
			text))
               )))
        
        (else (get-method message mobile-thing-part))
        ))))

(define (create-protector name location durability)
  (create make-protector name location durability))		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;;;:::;;:;:::;;:
;;;;;;;;;;;;; EXPLANATION: ;;;;;;;;;;;;;
;;   		      	 
   		      	 
; In this question, I write a class named Protector.
; Person can have protector objects by using 'TAKE method.
; CLASS HIERARCHY:
;      Protector extends Mobile Thing.
;      Protector is not a superclass of any other class but it is a subclass of mobile-thing.
; CLASS STATE INFORMATION:
;      Protector does not have variables or states. It updates its durability variable created at construction.
; CLASS METHODS:
;      Protector constructor has name location and durability parameters.
;      PROTECTOR? simply returns true.
;      DURABILITY returns how much durability is left.
;      INSTALL adds the BECOME-OLD method to the clock as a callback.
;      BECOME-OLD method is called once for each clock tick and it decreases the durability by 1.
;      PROTECT method takes the damage as a parameter and does the following:
;      if the damage is smaller than durability, it absorbs all damage and returns 0
;      if the damage is greater than durability, it absorbs durability amount of damage and returns (damage-durability)
;      EMIT method emits the message to the location. If the location is owner, then it emits the message to the location of the owner.

; DEMONSTRATION PLAN:
; For the purpose of the demonstration, Person class's suffer method should be changed. (now we have armor that protects us!)
; I also changed the Person class's SUFFER method's behavior.

; New version of SUFFER:
#|
((SUFFER)   		      	 
    (lambda (self hits)
      (define remaining-hit hits)
      (map (lambda (x)
             (if (is-a x 'PROTECTOR?)
                 (set! remaining-hit (ask x 'PROTECT remaining-hit))
                 ))
                            (ask self 'THINGS))

      (if (= remaining-hit 0)
          (ask self 'SAY (list "I got NO damage!"))
          (begin
            (ask self 'SAY (list "Ouchhhh!" remaining-hit "hits is more than I want!"))
            (set! health (- health remaining-hit))
            (if (<= health 0) (ask self 'DIE))
            health))))

|#

; Now, SUFFER method first iterates over all things and finds the armors the person has.
; Then for each armor, it calls protect method and hits are absorbed by armors.
; if the remaining hits is greater than 0, then health is decreased.
; if the remaining is 0, it says I got NO damage!
; if protector is broken, it reflects all hits to person.

; HOW TO TEST:
; Simply create a protector and take it.
; I created a weapon and attacked myself multiple times.
; (ask gun 'HIT me me)
; How the protector behaves when hit receives and clock ticks can be easily observed by checking below transcript.
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;:;::;;;;;::;;;;
;;;;;;;;;;;;; TRANSCRIPT: ;;;;;;;;;;;;;
;;   		      	 

#|
> (setup 'zafer)
ready
> (define armor (create-protector 'armor-of-god (ask me 'LOCATION) 30))
> (ask me 'TAKE armor)

At adm-building zafer says -- I take armor-of-god from adm-building 
> (define gun (create-weapon 'gun (ask me 'LOCATION) 15))
> (ask me 'TAKE gun)

At adm-building zafer says -- I take gun from adm-building 
> (ask gun 'HIT me me)

At adm-building ,  zafer  is hitting to  zafer  with  gun 
At adm-building ,  the protector absorbed all damage( 8 ) and remaining durability is  22 
At adm-building zafer says -- I got NO damage! said-and-heard
> (run-clock 1)

At adm-building ,  time passed and durability of  armor-of-god  is decreased to 21 
--- the-clock Tick 0 --- done
> (ask gun 'HIT me me)

At adm-building ,  zafer  is hitting to  zafer  with  gun 
At adm-building ,  the protector absorbed all damage( 5 ) and remaining durability is  16 
At adm-building zafer says -- I got NO damage! said-and-heard
> (run-clock 1)

At adm-building ,  time passed and durability of  armor-of-god  is decreased to 15 
--- the-clock Tick 1 --- done
> (ask gun 'HIT me me)

At adm-building ,  zafer  is hitting to  zafer  with  gun 
At adm-building ,  the protector absorbed all damage( 1 ) and remaining durability is  14 
At adm-building zafer says -- I got NO damage! said-and-heard
> (ask gun 'HIT me me)

At adm-building ,  zafer  is hitting to  zafer  with  gun 
At adm-building ,  the protector absorbed all damage( 12 ) and remaining durability is  2 
At adm-building zafer says -- I got NO damage! said-and-heard
> (ask gun 'HIT me me)

At adm-building ,  zafer  is hitting to  zafer  with  gun 
At adm-building ,  the protector absorbed some damage( 2 ) and it's broken. 
At adm-building zafer says -- Ouchhhh! 7 hits is more than I want! 
At adm-building zafer says -- SHREEEEK!  I, uh, suddenly feel very faint... 
At adm-building zafer says -- I lose gun 
At adm-building zafer says -- Yaaaah! I am upset! 
At adm-building zafer says -- I lose armor-of-god 
At adm-building zafer says -- Yaaaah! I am upset! 3
> 

|#
   		      	 
   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;:;::;;;;;::;;;:
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;:;::;;;;;::;;:;
;# DO NOT FORGET TO SUBMIT YOUR WORK BEFORE THE DEADLINE!         #
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;:;::;;;;;::;;::
;# GOOD LUCK!                                                     #
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;:;;;::;;;:;::;;;;;::;:;;
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
   		      	 
