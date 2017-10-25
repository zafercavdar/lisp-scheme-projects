#lang racket

(define epsilon 0.001)
(define (close-enough? a b)
  (if (< (abs(- a b)) epsilon) #t #f)
  )

(define (fixed-point f x)
  (if (close-enough? x (f x))
      x
      (fixed-point f (f x))))

(define (average a b)
  (/ (+ a b) 2))

(define (cbrt x)
  (fixed-point
   (lambda (g) (average g (/ x (* g g)))) 1))

(define (csqrt x)
(fixed-point
   (lambda (g) (average g (/ x g))) 1))

(cbrt 27)