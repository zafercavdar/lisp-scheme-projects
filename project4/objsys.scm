;;; This file provides a basic object system, and
;;; a clock for objects in a simulation world.  Additional
;;; utility procedures are also provided.
   		      	 
;;------------------------------------------------------------
;; Object Interface   		      	 
   		      	 
;; ask   		      	 
;;   		      	 
;; We "ask" an object to invoke a named method on some arguments.
;;   		      	 
(define (ask object message . args)
  ;; See your Scheme manual to explain `. args' usage
  ;; which enables an arbitrary number of args to ask.
  (apply-method object object message args))
   		      	 
;; delegate   		      	 
;;   		      	 
;; One "delegates" the handling of a message to an internal object.
;;   		      	 
;; "to" is the internal object to which we are delegating.
;; "from" is the object on whose behalf we are acting.
;;   		      	 
(define (delegate to from message . args)
  (apply-method to from message args))
   		      	 
;; This is an internal helper procedure.
;;  - it gets the method out of "in-object"
;;  - it invokes the method, passing "for-object" as the
;;    "self" for the method.   		      	 
;;   		      	 
(define (apply-method in-object for-object message args)
  (let ((method (get-method message in-object)))
    (cond ((method? method)   		      	 
           (apply method for-object args))
          ((eq? in-object for-object)
	   (display method)   		      	 
           (error "No method for" message 'in
		  (safe-ask 'UNNAMED-OBJECT
			    in-object 'NAME)))
          (else (error "Can't delegate" message
                       "from" (safe-ask 'UNNAMED-OBJECT
					for-object 'NAME)
		       "to" (safe-ask 'UNNAMED-OBJECT
				      in-object 'NAME))))))
   		      	 
;;--------------------   		      	 
;; Method Interface   		      	 
;;   		      	 
;; Objects have methods to handle messages.
   		      	 
(define (get-method message object)	; single-inheritance
  (object message))   		      	 
   		      	 
(define (find-method message . objects)	; multiple-inheritance
  (define (try objects)   		      	 
    (if (null? objects)   		      	 
	(no-method)   		      	 
	(let ((method (get-method message (car objects))))
	  (if (not (eq? method (no-method)))
	      method   		      	 
	      (try (cdr objects))))))
  (try objects))   		      	 
   		      	 
(define (method? x)   		      	 
  (cond ((procedure? x) #T)   		      	 
        ((eq? x (no-method)) #F)
        (else (error "Object returned this non-message:" x))))
   		      	 
(define no-method   		      	 
  (let ((tag (list 'NO-METHOD)))
    (lambda () tag)))   		      	 
   		      	 
;; Object type information   		      	 
;;   		      	 
(define (is-a object type-pred)
  (if (not (procedure? object))
      #F   		      	 
      (let ((method (get-method type-pred object)))
	(if (method? method)   		      	 
	    (ask object type-pred)
	    #F))))   		      	 
   		      	 
;; Safe (doesn't generate errors) method of invoking methods
;; on objects.  If the object doesn't have the method,
;; simply returns the default-value.  safe-ask should only
;; be used in extraordinary circumstances (like error handling).
;;   		      	 
(define (safe-ask default-value obj msg . args)
  (let ((method (get-method msg obj)))
    (if (method? method)   		      	 
	(apply-method obj obj msg args)
	default-value)))   		      	 
   		      	 
;;------------------------------------------------------------
;; Utility procedures   		      	 
   		      	 
(define (random-number n)   		      	 
  ;; Generate a random number between 1 and n
  (+ 1 (random n)))   		      	 
   		      	 
(define (pick-random lst)   		      	 
  (if (null? lst)   		      	 
      #F   		      	 
      (list-ref lst (random (length lst)))))
   		      	 
(define (delq item lst)   		      	 
  (cond ((null? lst) '())   		      	 
        ((eq? item (car lst)) (delq item (cdr lst)))
        (else (cons (car lst) (delq item (cdr lst))))))
   		      	 
(define (myfilter predicate lst)
   (cond ((null? lst) '())   		      	 
         ((predicate (car lst))
          (cons (car lst) (myfilter predicate (cdr lst))))
         (else (myfilter predicate (cdr lst)))))
   		      	 
(define (accumulate op init lst)
  (if (null? lst)   		      	 
      init   		      	 
      (op (car lst)   		      	 
	  (accumulate op init (cdr lst)))))
   		      	 
;;------------------------------------------------------------
;; Support for Objects in a Simulation World
   		      	 
;; Some definitions:   		      	 
;;   		      	 
;;  "make" an object -- make a new instance of the object
;;   		      	 
;;  "install" an object -- ask the object to INSTALL itself.
;; When we install an object, it may initialize itself, insert
;; itself into the world, and connect up with other related
;; objects in the world.   		      	 
;;   		      	 
;;  "create" an object -- to create an object in our world
;; is to both make a new instance, and install that object
;; into the world.   		      	 
   		      	 
   		      	 
;; Here's a fancy higher order procedure that one can use
;; in the body of a new "create" procedure for future use in creating
;; an object of a particular type (that is, to both make and
;; install the object into the world).
;; weird syntax for proc that takes 1 or more args
;;   		      	 
(define (create maker . args)   		      	 
    (let ((object (apply maker args)))
      (ask object 'INSTALL)   		      	 
      object))   		      	 
   		      	 
;;--------------------   		      	 
;; Root Object   		      	 
;;   		      	 
;; Base object.  It contains no methods itself
;; and only exists to be derived from
   		      	 
(define (make-root-object)   		      	 
  (lambda (message)   		      	 
    (no-method)))   		      	 
   		      	 
;;--------------------   		      	 
;; Clock   		      	 
;;   		      	 
;; A clock is an object with a notion of time, which it
;; imparts to all objects that have asked for it.  It does
;; this by invoking a list of CALLBACKs whenever the TICK
;; method is invoked on the clock.  A CALLBACK is an action to
;; invoke on each tick of the clock, by sending a message to an object
   		      	 
   		      	 
(define (make-clock . args)   		      	 
  (let ((root-part (make-root-object))
	(name (if (not (null? args))
		  (car args)   		      	 
		  'THE-CLOCK))   		      	 
	(the-time 0)   		      	 
	(callbacks '()))   		      	 
    (lambda (message)   		      	 
      (case message   		      	 
	((CLOCK?) (lambda (self) #t))
	((NAME) (lambda (self) name))
	((THE-TIME) (lambda (self) the-time))
	((RESET) (lambda (self)
		   (set! the-time 0)
		   (set! callbacks '())))
	((TICK)   		      	 
	 (lambda (self)   		      	 
	   (for-each (lambda (x) (ask x 'activate)) callbacks)
	   (set! the-time (+ the-time 1))))
	((ADD-CALLBACK)   		      	 
	 (lambda (self cb)   		      	 
	   (cond ((not (is-a cb 'CLOCK-CALLBACK?))
		  (error "Non callback provided to ADD-CALLBACK"))
		 ((null? (myfilter (lambda (x) (ask x 'SAME-AS? cb))
				 callbacks))
		  (set! callbacks (cons cb callbacks))
		  'added)   		      	 
		 (else   		      	 
		  'already-present))))
	((REMOVE-CALLBACK)   		      	 
	 (lambda (self obj cb-name)
	   (set! callbacks (myfilter (lambda (x)
				     (not (and (eq? (ask x 'NAME)
						    cb-name)
					       (eq? (ask x 'OBJECT)
						    obj))))
				   callbacks))
	   'removed))   		      	 
	((PRINT-TICK)   		      	 
	 ;; Method suitable for a callback that prints out the tick
	 (lambda (self)   		      	 
	   (ask screen 'TELL-WORLD (list "---"
					 (ask self 'NAME)
					 "Tick"
					 (ask self 'THE-TIME)
					 "---"))))
	(else (find-method message root-part))))))
   		      	 
;; Clock callbacks   		      	 
;;   		      	 
;; A callback is an object that stores a target object,
;; message, and arguments.  When activated, it sends the target
;; object the message.  It can be thought of as a button that executes an
;; action at every tick of the clock.
   		      	 
(define (make-clock-callback name object msg . data)
  (let ((root-part (make-root-object)))
    (lambda (message)   		      	 
      (case message   		      	 
	((CLOCK-CALLBACK?) (lambda (self) #t))
	((NAME) (lambda (self) name))
	((OBJECT) (lambda (self) object))
	((MESSAGE) (lambda (self) msg))
	((ACTIVATE) (lambda (self)
		      (apply-method object object msg data)))
	((SAME-AS?) (lambda (self cb)
		      (and (is-a cb 'CLOCK-CALLBACK?)
			   (eq? (ask self 'NAME)
				(ask cb 'NAME))
			   (eq? object (ask cb 'OBJECT)))))
	(else (find-method message root-part))))))
   		      	 
;; Setup global clock object   		      	 
(define clock (make-clock))   		      	 
   		      	 
;; By default print out clock-ticks -- note how we are adding a callback
;; to a method of the clock object
   		      	 
(ask clock 'ADD-CALLBACK   		      	 
     (make-clock-callback 'tick-printer clock 'PRINT-TICK))
   		      	 
;; Get the current time   		      	 
(define (current-time)   		      	 
  (ask clock 'THE-TIME))   		      	 
   		      	 
;; Advance the clock some number of ticks
(define (run-clock n)   		      	 
  (cond ((= n 0) 'DONE)   		      	 
        (else (ask clock 'tick)
	      ;; remember that this pushes each button in callback list
              (run-clock (- n 1)))))
   		      	 
;; Using the clock:   		      	 
;;   		      	 
;; When you want the object to start being aware of the clock
;; (during initialization of autonomous-person, for example),
;; add a callback to the clock which activates a method on the
;; object:   		      	 
;; (ask clock 'ADD-CALLBACK   		      	 
;;      (make-clock-callback 'thingy self 'DO-THINGY))
;; The first argument is a name or descriptor of the callback.
;; The second argument is the object to which to send the message.
;; The third argument is the message (method-name) to send.
;; Additional arguments can be provided and they are sent to
;; the object with the message when the callback is activated.
;; In this case, the method do-thingy should be descriptive of
;; the behavior the object will exhibit when time passes.
;; When the object's lifetime expires (sometime this is taken
;; literally!), it should remove it's callback(s) from the clock.
;; This can be done with   		      	 
;; (ask clock 'REMOVE-CALLBACK   		      	 
;;      'thingy self)   		      	 
;;   		      	 
;; An example of using callback names and additional arguments:
;; (ask clock 'ADD-CALLBACK   		      	 
;;      (make-clock-callback 'whoopee me 'SAY '("Whoopee!")))
;; (ask clock 'ADD-CALLBACK   		      	 
;;      (make-clock-callback 'fun me 'SAY '("I am having fun!")))
;; This causes the avatar to say two things every time the clock
;; ticks.   		      	 
   		      	 
;;-----------   		      	 
;; screen   		      	 
   		      	 
;; This is a singleton object (only 1 object of this type in existence
;; at any time), which deals with outputting text to the user
;;   		      	 
;; If the screen is in deity-mode, the user will hear every message,
;; regardless of the location of the avatar.  If deity-mode is
;; false, only messages sent to the room which contains the avatar
;; will be heard.   		      	 
;;   		      	 
;; network-mode is something set only by the network code.
;;   		      	 
(define screen   		      	 
  (let ((deity-mode #t)   		      	 
	(network-mode #f)   		      	 
	(me #f)   		      	 
        (root-part (make-root-object)))
    (lambda (message)   		      	 
      (case message   		      	 
	((NAME) (lambda (self) 'THE-SCREEN))
	((SET-ME) (lambda (self new-me)
		    (set! me new-me)))
	((TELL-ROOM) (lambda (self room msg)
		       (if (or deity-mode
			       (eq? room (safe-ask #f me 'location)))
			   (if network-mode
			       (display-net-message msg)
			       (display-message msg)))))
	((TELL-WORLD) (lambda (self msg)
			(if network-mode
			    (display-net-message msg)
			    (display-message msg))))
	((DEITY-MODE) (lambda (self value)
			(set! deity-mode value)))
	((NETWORK-MODE) (lambda (self value)
			  (set! network-mode value)))
	((DEITY-MODE?) (lambda (self)
			 deity-mode))
	(else (find-method message root-part))))))
   		      	 
;;--------------------   		      	 
;; Utilities for our simulation world
;;   		      	 
   		      	 
(define (display-message list-of-stuff)
  (if (not (null? list-of-stuff)) (newline))
  (for-each (lambda (s) (display s) (display " "))
            list-of-stuff))   		      	 
   		      	 
(define (display-net-message list-of-stuff)
  (for-each (lambda (s) (display s server-port) (display " " server-port))
            list-of-stuff)   		      	 
  (display #\newline server-port)
  (flush-output server-port))   		      	 
   		      	 
(define (find-all location pred)
  (myfilter (lambda (x) (is-a x pred))
	  (ask location 'THINGS)))
   		      	 
; Grab any kind of thing from avatar's location,
; given its name.  The thing may be in the possession of
; the place, or in the possession of a person at the place.
;   		      	 
(define (thing-named name)   		      	 
  (let* ((place (ask me 'LOCATION))
	 (things (ask place 'THINGS))
	 (peek-stuff (ask me 'PEEK-AROUND))
	 (my-stuff (ask me 'THINGS))
	 (all-things (append things (append my-stuff peek-stuff)))
	 (things-named (myfilter (lambda (x) (eq? name (ask x 'NAME)))
				all-things)))
    (cond ((null? things-named)
	   (error "In here there is nothing named" name))
	  ((null? (cdr things-named)) 	; just one thing
	   (car things-named))   		      	 
	  (else   		      	 
	   (display-message (list "There is more than one thing named"
				  name "here. Picking one of them."))
	   (pick-random things-named)))))
   		      	 
   		      	 
   		      	 
;;--------------------   		      	 
;; show   		      	 
;;   		      	 
;; Use (show whatever) to view a reasonably intelligible
;; description of the "whatever" data or object.
;;   		      	 
;; Treat show as a gift from the (Scheme) Gods.
;; Don't try to understand this!
;;   		      	 
(define (show thing)   		      	 
  (define (global-environment? frame)
    (environment->package frame))
  (define (pp-binding name value width)
    (let ((value* (with-string-output-port
                   (lambda (port)
                     (if (pair? value)
                         (pretty-print value port #F (+ width 2))
                         (display value port))))))
      (newline)   		      	 
      (display name)   		      	 
      (display ": ")   		      	 
      (display (make-string (- width (string-length name)) #\Space))
      (if (pair? value)   		      	 
          (display (substring value* (+ width 2) (string-length value*)))
          (display value*))))   		      	 
  (define (show-frame frame)   		      	 
    (if (global-environment? frame)
        (display "\nGlobal Environment")
        (let* ((bindings (environment-bindings frame))
               (parent   (environment-parent frame))
               (names    (cons "Parent frame"
                               (map symbol->string (map car bindings))))
               (values   (cons (if (global-environment? parent)
                                   'GLOBAL-ENVIRONMENT
                                   parent)
                               (map cadr bindings)))
               (width    (reduce max 0 (map string-length names))))
          (for-each (lambda (n v) (pp-binding n v width))
            names values))))   		      	 
  (define (show-procedure proc)
    (fluid-let ((*unparser-list-depth-limit* 4)
                (*unparser-list-breadth-limit* 4))
      (newline)   		      	 
      (display "Frame:")   		      	 
      (newline)   		      	 
      (display "  ")   		      	 
      (if (global-environment? (procedure-environment proc))
          (display "Global Environment")
          (display (procedure-environment proc)))
      (newline)   		      	 
      (display "Body:")   		      	 
      (newline)   		      	 
      (pretty-print (procedure-lambda proc) (current-output-port) #T 2)))
   		      	 
  (define (print-nicely thing)   		      	 
    (newline)   		      	 
    (display thing)   		      	 
    (cond ((false? thing)   		      	 
           'UNINTERESTING)   		      	 
          ((environment? thing)
           (show-frame thing))   		      	 
          ((compound-procedure? thing)
           (show-procedure thing))
          (else 'UNINTERESTING)))
  (print-nicely   		      	 
   (or (if (exact-integer? thing)
           (object-unhash thing)
           thing)   		      	 
       thing)))   		      	 
   		      	 
