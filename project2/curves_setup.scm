;; setup graphics interfaces for curves project
;; note that this probably only runs on MIT Scheme
   		      	 
(define g1 false)   		      	 
(define g2 false)   		      	 
(define g3 false)   		      	 
   		      	 
;; need to load the following   		      	 
;; curves_utils.scm   		      	 
;; curves.scm   		      	 
;; drawing.scm   		      	 
;;   		      	 
;; then need to evaluated (setup-windows)
   		      	 
(define (setup-windows)   		      	 
  (define (make-window)   		      	 
    (make-graphics-device (car (enumerate-graphics-types))))
  (if (and g1 (graphics-device? g1))
      (graphics-close g1))   		      	 
  (begin (set! g1 (make-window))
	 (graphics-set-coordinate-limits g1 0.0 0.0 1.0 1.0)
	 (graphics-operation g1 'set-window-name "Graphics: g1"))
  (if (and g2 (graphics-device? g2))
      (graphics-close g2))   		      	 
  (begin (set! g2 (make-window))
	 (graphics-set-coordinate-limits g2 0.0 0.0 1.0 1.0)
	 (graphics-operation g2 'set-window-name "Graphics: g2"))
  (if (and g3 (graphics-device? g3))
      (graphics-close g3))   		      	 
  (begin (set! g3 (make-window))
	 (graphics-set-coordinate-limits g3 0.0 0.0 1.0 1.0)
	 (graphics-operation g3 'set-window-name "Graphics: g3"))
  )   		      	 
   		      	 
