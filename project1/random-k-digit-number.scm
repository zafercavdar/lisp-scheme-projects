#lang racket

;;;
(define (exptmod x n m)
  (define result 1)
  (define (helper product now n m result)
    (if (= n 0)
        result
        (if (< (* now 2) n)
            (helper (modulo (* product product) m) (* now 2) n m result)
            (helper x 1 (- n now) m (modulo (* result product) m)))))
  
  (helper x 1 n m result))

(display "exptmod -5 3 100: ")
(exptmod -5 3 100)
;;;

(define (helper number count max)
  (define x (random 10))
  (if (< count max)
      (helper (+ x (* number 10)) (+ count 1) max)
      number)
  )

(define (random-k-digit-number k)
  (helper 0 0 k)
  )

(define x (random-k-digit-number 2))
x
;;;;

(define (helper2 count n) (if (< n 10)
                              count
                              (helper2 (+ 1 count) (/ n 10))
                              ))
(define (count-digits n) (helper2 1 n))
(count-digits x)
;;;

(define (big-random n)
  (define digit (count-digits n))
  (define rand (random-k-digit-number digit))
  (if (< rand n) rand (big-random n))
  )

(big-random 100)
(big-random 10000)
(big-random (expt 10 40))
;;;

(define prime-test-iterations 20)

(define (prime?-helper count a n)
  (if (>= count prime-test-iterations) #t
      (if (= (exptmod a n n) a) (prime?-helper (+ 1 count) (big-random n) n) #f)
      )
  )

(define (prime? n)
  (if (< n 2) #f
      (prime?-helper 1 (big-random n) n)
      ))

(prime? 961748941)
(prime? 2)
(prime? 4)
(prime? 1)
(prime? 0)
(prime? 200)
(prime? 199)
;;;

(define (random-prime n)
  (define candidate-random (big-random n))
  (if (prime? candidate-random)
      candidate-random
      (random-prime n)))

(random-prime 3)
(random-prime 3)
(random-prime 100)
(random-prime 100)
(random-prime 100000)

;;;

(define (ax+by=1 a b)
  (define q (quotient a b))
  (define r (remainder a b))

  (define (helper xx yy q)
    (list yy (- xx (* q yy)))) 
  
  (if (= r 1)
      (list 1 (- q))
      (let (( res (ax+by=1 b r)))
      (helper (list-ref res 0) (list-ref res 1) q))))


(ax+by=1 17 13)
(ax+by=1 7 3)
(ax+by=1 10 27)

;;;

(define (inverse-mod e n)
  (define (helper e n)
  (list-ref (ax+by=1 e n) 0))
  
  (if (= (gcd e n) 1)
      (modulo (list-ref (ax+by=1 e n) 0) n)
      (display "gcd is not 1 \n")
      ))

(inverse-mod 5 11)
(inverse-mod 9 11)
(inverse-mod 7 11)
(inverse-mod 5 12)
(inverse-mod 8 12)

(define (*mod a b c)
  (modulo (* a b) c))

(define imodprime (random-prime 101))
(display "random prime: ")
(display imodprime)
(display "\nInverse of prime: ")
(define inversemod (inverse-mod imodprime 101))
(display inversemod)
(display "\ncheck with *mod: ")
(*mod imodprime inversemod 101)

;;;

(define p 0)
(define q 0)
(define n 0)
(define e 0)
(define d 0)

(define (rsa-key)
  (define (get-modulus)
    (set! p (random-prime 5000000))
    (set! q (random-prime 5000000))
    (set! n (* p q))
    n)    

  (define (get-exponent)
   (set! e (big-random n))
   
    (if (= (gcd e (* (- p 1) (- q 1))) 1)
        e
        (get-exponent)))
    
  (define (get-exponent-d)
    (set! d (inverse-mod e (* (- p 1) (- q 1))))
    d)

  (lambda (ret)
      (cond ((eq? ret 'get-modulus) (get-modulus))
            ((eq? ret 'get-exponent) (get-exponent))
            ((eq? ret 'get-exponent-d) (get-exponent-d))
            (else (error "Unknown request" ret)))))

(define mypairs (rsa-key))
(mypairs 'get-modulus)
(mypairs 'get-exponent)
(mypairs 'get-exponent-d)  

(define (rsa key message)
  (exptmod message key n))

(define crypted (rsa e 1578072040808))
(display crypted)
(display "\n")
(define decrypted (rsa d crypted))
(display decrypted)

;;;

(define (make-key e n) (cons e n))
(define (get-modulus a) (cdr a))
(define (get-exponent a) (car a))

    
    
  

