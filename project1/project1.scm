;;; zcavdar14@ku.edu.tr     Wed Oct 19 12:48:37 2016
;;;   		      	 
;;; Comp200 Project 1   		      	 
;;;   		      	 
#lang sicp   		      	 
(#%require (only racket/base random))
(define your-answer-here -1)   		      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;::;;;:
;;; Problem 1: Modular Arithmetic
   		      	 
;(modulo 13 8) ; ->  5   		      	 
;(remainder 13 8) ; ->  5   		      	 
;(modulo -13 8) ; ->  3   		      	 
;(remainder -13 8) ; ->  -5   		      	 
;(modulo -13 -8) ; ->  -5   		      	 
;(remainder -13 -8) ; ->  -5
;(modulo -9 12) ; -> 3
;(remainder -9 12) ; -> -9
   		      	 
;;; What is the difference between remainder and modulo? Which one is
;;; the best choice for implementng modular arithmetic as described in
;;; project pdf?  Include your test results and your answers to these
;;; questions in a comment in your solution.

; The difference between remainder and modulo is:
; while modulo always gives a result between (0,n) or (n,0 if n < 0), remainder's result has same sign as divident has and
; 0< abs(result) < n (n = divider)
; For this project, the best choice for implementing modular arithemic is of course using modulo.
; Test results:
; (modulo -13 8) --> -13 = (8 * -2) + 3 then result = 3
; (remainder -13 8) --> (-13) = (8 * -1) + (-5), then result = -5
   		      	 
;;; +mod takes two numbers and modulo n
;;; it adds up to numbers and return the value of this number in modulo n
   		      	 
(define +mod   		      	 
  (lambda (a b n)
    (modulo (+ a b) n)
))   		      	 
   		      	 
;;; -mod takes two numbers and modulo n
;;; it substract first number from the second one and return the value of this number in modulo n  		      	 
   		      	 
(define -mod   		      	 
  (lambda (a b n)   		      	 
    (modulo (- a b) n)
))   		      	 
   		      	 
;;; +mod takes two numbers and modulo n
;;; it multiplies first 2 numbers and return the value of this number in modulo n  		      	 
   		      	 
(define *mod   		      	 
  (lambda (a b n)
    (modulo (* a b) n)
))   		      	 
   		      	 		      	 
; After the definition of each procedure, please cut and paste some
; test cases you have run, making sure the lines are commented out
; with semi-colons:   		      	 
   		      	 
; Test cases   		      	 
   		      	 
;(+mod 7 5 8) ; -> 4   		      	 
;(+mod 10 10 3) ; -> 2   		      	 
;(-mod 5 12 2) ; -> 1   		      	 
;(*mod 6 6 9) ; -> 0   		      	 
;(+mod 99 99 100) ; -> 98   		      	 
;(*mod 50 -3 100) ; -> 50
;(-mod 6 10 4) ; 0
;(+mod 10 2323 20) ;13
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;::;;:;
;;; Problem 2: Raising a Number to a Power
   		      	 
;; What is the order of growth in time of slow-exptmod?
;; Time complexity is O(b), so it is linear in time.
;;
   		      	 
;; What is its order of growth in space?
;; It also uses O(b) space, space complexity and growth is linear.   		      	 
   		      	 
;; Does slow-exptmod use an iterative algorithm or a recursive algorithm?
;; It uses a recursive algorithm, because it calls itself with multiplying with constant a.
;; When b = 0, the mod operator calculates a mod n & continues the calculations backward. (multiply with a and take modulo n) -> b times
   		      	 
;;; Description for exptmod
;;; exptmod calculates modulo n of x to the n in an iterative way by using repeated squaring.
;;; x is an any integer, n is 0 or positive integer, m is any integer.

(define (exptmod x n m)
  (define result 1)
  (define (helper product now n m result)
    (if (= n 0)
        result
        (if (< (* now 2) n)
            (helper (*mod product product m) (* now 2) n m result)
            (helper x 1 (- n now) m (*mod result product m)))))
  
  (helper x 1 n m result))  		      	 
   		      	 
; Test cases:   		      	 
;(display "exptmod tests\n")	      	 
;(exptmod 2 0 10) ; -> 1   		      	 
;(exptmod 2 3 10) ; -> 8   		      	 
;(exptmod 3 4 10) ; -> 1   		      	 
;(exptmod 2 15 100) ; -> 68   		      	 
;(exptmod -5 3 100) ; -> 75
;(exptmod 2 10 10) ; -> 4
;(exptmod -4 4 50) ; -> 6
   		      	 
;; What is the order of growth in time of exptmod?
;; It is logarithmic. O(log b) since it doubles the exponent while approaching to b. 		      	 
   		      	 
;; What is its order of growth in space?
;; It is constant O(1) since it calculates before new procedure call.	      	 
   		      	 
;; Does exptmod use an iterative algorithm or a recursive algorithm?
;; It uses an iterative algorithm, because there is no pending operations.	      	 
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;::;;::
;;; Problem 3: Large Random Number
   		      	 
;;; Examples of random   		      	 
;; The results of random will be different for each run so you might not get the
;; below results.   		      	 
;; (random 10) ; ->1   		      	 
;; (random 10) ; ->6   		      	 
;; (random 10) ; ->6   		      	 
;; (random 10) ; ->0   		      	 
;; (random 10) ; ->7
;; (random 100) ; 80
;; (random 100) ; 11
;; (random 100) ; 18
   		      	 
;;; Description for random-k-digit-number:
;;; it takes n as input parameter and returns a random number such that
;;; it's maximum number of digits is n.
;;; how does it works? choose a random number between [0,9] and add it to the
;;; 10 times of previous solution. Iterate n times.
   		      	 
(define (random-k-digit-number n)		      	 
    (define (helper number count max)
      (define x (random 10))
      (if (< count max)
          (helper (+ x (* number 10)) (+ count 1) max)
          number))
  (helper 0 0 n)
)   		      	 
   		      	 
; Test cases:   		      	 
   		      	 
;(random-k-digit-number 1) ; ->  ?  (1 digit)
;(random-k-digit-number 3) ; ->  ?  (1-3 digits)
;(random-k-digit-number 3) ; ->  ?  (is it different?)
;(random-k-digit-number 50) ; ->  ?  (1-50 digits)
;(random-k-digit-number 10) ; -> 9011946792
;(random-k-digit-number 20) ; -> 94922815849261226814
;(random-k-digit-number 30) ; -> 860611578664085839882162810600
;(random-k-digit-number 40) ; -> 3030177928248807095494990574867074989363
   		      	 
;;; count-digits takes a number and returns its number of digits in an iterative way.
   		      	 
(define count-digits   		      	 
  (lambda (n)
    (define (helper2 count n)
      (if (< n 10)
          count
          (helper2 (+ 1 count) (/ n 10))))
    (helper2 1 n)
))   		      	 
   		      	 
; Test cases:   		      	 
   		      	 
;(count-digits 3) ; -> 1   		      	 
;(count-digits 2007) ; -> 4   		      	 
;(count-digits 123456789) ; -> 9
;(count-digits 1234567890) ; -> 10
;(count-digits 123456789000) ; -> 12


   		      	 
;;; big-random takes n as input and calls k = (count-digits n).
;;; it calls random-k-digit-number k and checks if the number is smaller than n or not.
;;; if it's not smaller, calls itself again until finding a random number whose digit number is max k and smaller than n.
   		      	 
(define big-random   		      	 
  (lambda (n)   		      	 
    (define rand (random-k-digit-number (count-digits n)))
    (if (< rand n) rand (big-random n))
))   		      	 
   		      	 
; Test cases:   		      	 
;(big-random 100) ; ->  ?  (1-2 digit number)
;(big-random 100) ; ->  ?  (is it different?)
;(big-random 1) ; ->  0   		      	 
;(big-random 1) ; ->  0 (should be always 0)
;(big-random (expt 10 40)) ; ->  ?  (roughly 40-digit number) 7912012230312108824099915065031647224857
;(big-random 10000) ; 5652
;(big-random 100000) ; 74890
   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;::;:;;
;;; Problem 4: Prime Numbers   		      	 
   		      	 
;;; What is the order of growth in time of slow-prime? ?
;;; It is O(n) = linear since it calls itself with increment 1 in the worst case.  		      	 
   		      	 
;;; What is its order of growth in space?
;;; It is O(1) = constant independent of the input.	      	 
   		      	 
;;; Does slow-prime? use an iterative algorithm or a recursive algorithm?
;;; It is an iterative algorithm with no pending operations.(like for loop, increment k by 1 and test until deciding.) 		      	 
   		      	 
;;; We only have to check factors less than or equal to (sqrt n). How would this
;;; affect the order of growth in time?
;;; Then, range of iteration decreases significantly from n to sqrt(n). So order of growth
;;; becomes logarithmic rather than linear. O(sqrt(n)) = O(log n)
   		      	 
;;; We only have to check odd factors (and 2, as a special case). How would this
;;; affect the order of growth in time?
;;; Then, range of iteration decreases from n to n/2. But order of time growth is not affected
;;; since O(n/2) = O(cn) = O(n), still linear.
   		      	 
;;; Test Fermat's Little Theorem
;; (exptmod 10 11 11) ;-> 10   		      	 
;; (exptmod 4 7 7)    ;-> 4
;; (exptmod 11 47 47) ; -> 11
   		      	 
;;; prime? takes a positive integer and returns if it is prime or not
;;; with a probabilistic approach using Fermat's Little Theorem.
   		      	 
(define prime-test-iterations 20)

(define (prime?-helper count a n)
  (if (>= count prime-test-iterations) #t
      (if (= (exptmod a n n) a) (prime?-helper (+ 1 count) (big-random n) n) #f)
      )
  )
   		      	 
(define prime?   		      	 
  (lambda (p)   		      	 
    (if (< p 2) #f
      (prime?-helper 1 (big-random p) p)
      )
    ))    		      	 
   		      	 
; Test cases:   		      	 
;; (prime? 2) ; -> #t   		      	 
;; (prime? 4) ; -> #f   		      	 
;; (prime? 1) ; -> #f   		      	 
;; (prime? 0) ; -> #f   		      	 
;; (prime? 200) ; ->  #f	      	 
;; (prime? 199) ; ->  #t
;; (prime? 961748941) #t
   		      	 
;;; What is the order of growth in time of your implementation of prime?
;;; It is O(c * log n) = O(log n) (c = iteration constant, log n for each exptmod
;;; Logarithmic
   		      	 
;;; What is its order of growth in space? (take exptmod into account)
;;; exptmod has order of constant growth in space and prime? also has O(c) constant growth.	      	 
   		      	 
;;; Does prime? use an iterative algoritm or a recursive algorithm?
;;; It uses iterative algorithm, there is no pending operation.
;;; (like for loop, 20 times steps are repeated without recursive calls.   		      	 
   		      	 
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;::;:;:
;;; Problem 5: Random Primes   		      	 
   		      	 
;;; random-prime takes n as input returns a random prime smaller than n.
;;; it calls big-random n and prime? n procedures until finding a prime number.
   		      	 
(define random-prime   		      	 
  (lambda (n)
    (define candidate-random (big-random n))
    (if (prime? candidate-random)
      candidate-random
      (random-prime n))
))   		      	 
   		      	 
; Test cases:   		      	 
;(random-prime 3) ; -> 2   		      	 
;(random-prime 3) ; -> 2 (must be always 2)
;(random-prime 100) ; ->  5,19,3, 67  		      	 
;(random-prime 100) ; ->  17,47,67, 23	      	 
;(random-prime 100000) ; ->  5420,433, 64951, 97303
;(random-prime 100000000);

;; Failure cases:
;;; 1) If n is smaller than 3. (Program may stuck)
;;; 2) prime? procedure may give wrong results with a very low probability. (Encyrpted and decrypted message may not be same.)
;;;

;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;::;::;
;;; Problem 6: Multiplicative Inverses
   		      	 
;;; ax+by=1 takes a b as an input and returns a list of 2 numbers that satisfy
;;; this equation. it only succeeds iff gcd(a,b) = 1
   		      	 
(define ax+by=1   		      	 
  (lambda (a b)
    (define q (quotient a b))
  (define r (remainder a b))

  (define (helper xx yy q)
    (list yy (- xx (* q yy)))) 
  
  (if (= r 1)
      (list 1 (- q))
      (let (( res (ax+by=1 b r)))
      (helper (list-ref res 0) (list-ref res 1) q)))
))   		      	 
   		      	 
; Test cases   		      	 
;(ax+by=1 17 13) ; -> (-3 4) 17*-3 + 13*4 = 1
;(ax+by=1 7 3) ; -> (1 -2) 7*1 + 3*-2 =1
;(ax+by=1 10 27) ; -> (-8 3) 10*-8 + 3*27 =1
;(ax+by=1 5 8) ; -> (-3 2) (5*-3) + (8 * 2) = 1

;;; inverse-mod takes e and n (both positive integers) and calculates d such that
;;; e*d = 1 (mod n). it calls ax+by=1 to solve ed + (-k)n = 1 where e and n are knowns.
   		      	 
(define inverse-mod   		      	 
  (lambda (e n)
    (define (helper e n)
    (list-ref (ax+by=1 e n) 0))
  
    (if (= (gcd e n) 1)
      (modulo (list-ref (ax+by=1 e n) 0) n)
      (display "gcd is not 1 \n")
      )
))   		      	 
   		      	 
; Test cases:   		      	 
;(inverse-mod 5 11) ; ->9 5*9 = 45 = 1 (mod 11)
;(inverse-mod 9 11) ; -> 5   		      	 
;(inverse-mod 7 11) ; -> 8 7*8 = 56 = 1 (mod 11)
;(inverse-mod 8 12) ; -> error no inverse exists
;(inverse-mod (random-prime 101) 101)
; test for (inverse-mod (random-prime 101) 101)
;(define imodprime (random-prime 101))
;(display "random prime: ")
;(display imodprime)
;(display "\nInverse of prime: ")
;(define inversemod (inverse-mod imodprime 101))
;(display inversemod)
;(display "\ncheck with *mod: ")
;(*mod imodprime inversemod 101)
   		      	 
   		      	  
;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;::;:::
;;; Problem 7: RSA   		      	 
   		      	
(define (calc-exponent n p q)
   (define e (big-random n))
   
    (if (= (gcd e (* (- p 1) (- q 1))) 1)
        e
        (calc-exponent n p q)))

(define (calc-d-exponent e p q)
    (inverse-mod e (* (- p 1) (- q 1)))
  )

;;; Description of random-keypair

;;; make-key calls cons and returns exp and mod as a pair

(define (make-key exp mod)
  (cons exp mod))

;;; get-exponent returns the first component of the key pair = exponent

(define (get-exponent key)   		      	 
  (car key))

;;; get-modulus returns the second component of the key pair = modulus

(define (get-modulus key)   		      	 
  (cdr key))

;;; generates p q and n such that n > m
;;; using the p and q, it finds an appropriate encryption key = e
;;; decryption key is calculated by finding inverse-mod of e in modulus (p-1)*(q-1)
;;; random-keypair returns the list: ((e,n) (d,n))

(define (random-keypair m)
  (define p 0)
  (define q 0)
  (define e 0)
  (define n 0)
  (define d 0)
    (set! p (random-prime m))
    (set! q (random-prime m))
    (set! n (* p q))

  (define (get-pair n p q)
    (set! e (calc-exponent n p q))
    (set! d (calc-d-exponent e p q))
    ;(display "e: \n")
    ;(display e)
    ;(display "\n")
    ;(display "d: \n")
    ;(display d)
    ;(display "\n")
    
    (list (make-key e n) (make-key d n)))
  
    (if (< n m) (random-keypair m)
        (get-pair n p q)))
   		      	 
;;; Description of rsa
;;; rsa takes key (e,n) pair and message
;;; returns (m^e) mod n

(define rsa   		      	 
  (lambda (key message)
    (exptmod message (get-exponent key) (get-modulus key))
))   		      	 
   		      	 
; Test cases:
;(define keys (random-keypair 10000000000000000000000000))
;(define encrp (rsa (car keys) 1020304050607080))
;(display "encrpt:")
;encrp
;(display "decrpt: ")
;(define decrp (rsa (cadr keys) encrp))
;decrp

;(define keys2 (random-keypair 100000))
;(define encrp2 (rsa (car keys2) 1020304050607080))
;(display "encrpt:")
;encrp2
;(display "decrpt: ")
;(define decrp2 (rsa (cadr keys2) encrp2))
;decrp2 		      	 
   		      	 
;;; What happend when you try to encrypt and decrypt a message integer
;;; which is too large for the key - i.e., larger than the modulus n?
;;; Because we work with modulus n, encrypted and decrypted messages cannot be larger
;;; than n. In this condition, RSA will encrypt and decrpyt not the message but
;;; (message mod n) and won't give the actual result.
   		      	 
;;; Description of encrypt:   		      	 
   		      	 
(define encrypt   		      	 
  (lambda (public-key string)
    (define message (string->integer string))
    (rsa public-key message)
))   		      	 
   		      	 
;;; Description of encrypt:   		      	 
   		      	 
(define decrypt   		      	 
  (lambda (private-key encrypted-message)
    (define message (rsa private-key encrypted-message))
    (integer->string message)
    )) 		      	 


;; Test cases:
;(define key (random-keypair 1000000000000000000000000000))
;(define e1 (encrypt (car key) "hello Comp200!"))
;(decrypt (cadr key) e1) ; -> "hello Comp200!"
   		      	 
;(define e2 (encrypt (car key) ""))
;(decrypt (cadr key) e2) ; -> ""

;(define e3 (encrypt (car key) "This is fun!"))
;(decrypt (cadr key) e3) ; -> "This is fun!"

;(define e4 (encrypt (car key) "I am Zafer "))
;(decrypt (cadr key) e4) ;



;;;;;;;::::;:;::;;;::::;;;;::::;::;::;;:;;::;;;;::::;;:;;::;;;:;::;:;;;::;::;;::;;;;;:::;;;
;; Helper functions: you do not need to edit the functions given below.
   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   		      	 
;; Problem 2: Raising a Number to a Power
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   		      	 
(define slow-exptmod   		      	 
  (lambda (a b n)   		      	 
    (if (= b 0)   		      	 
	1   		      	 
	(*mod a (slow-exptmod a (- b 1) n) n))))
   		      	 
   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   		      	 
;; Problem 4: Prime Numbers   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   		      	 
(define test-factors   		      	 
  (lambda (n k)   		      	 
    (cond ((>= k n) #t)   		      	 
	  ((= (remainder n k) 0) #f)
	  (else (test-factors n (+ k 1))))))
   		      	 
(define slow-prime?   		      	 
  (lambda (n)   		      	 
    (if (< n 2)   		      	 
	#f   		      	 
	(test-factors n 2))))   		      	 
   		      	 
   		      	 
   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   		      	 
;; Problem 7: RSA   		      	 
;;   		      	 
;; Converting message strings to and from
;; integers.   		      	 
;;   		      	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   		      	 
   		      	 
(define (join-numbers list radix)
  ; Takes a list of numbers (i_0 i_1 i_2 ... i_k)
  ; and returns the number   		      	 
  ;    n = i_0 + i_1*radix + i_2*radix2 + ... i_k*radix^k + radix^(k+1)
  ; The last term creates a leading 1, which allows us to distinguish
  ; between lists with trailing zeros.
  (if (null? list)   		      	 
      1   		      	 
      (+ (car list) (* radix (join-numbers (cdr list) radix)))))
   		      	 
; test cases   		      	 
;(join-numbers '(3 20 39 48) 100) ;-> 148392003
;(join-numbers '(5 2 3 5 1 9) 10) ;-> 1915325
;(join-numbers '() 10) ;-> 1   		      	 
   		      	 
   		      	 
(define (split-number n radix)   		      	 
  ; Inverse of join-numbers.  Takes a number n generated by
  ; join-numbers and converts it to a list (i_0 i_1 i_2 ... i_k) such
  ; that   		      	 
  ;    n = i_0 + i_1*radix + i_2*radix2 + ... i_k*radix^k + radix^(k+1)
  (if (<= n 1)   		      	 
      '()   		      	 
      (cons (remainder n radix)
	    (split-number (quotient n radix) radix))))
   		      	 
; test cases   		      	 
;(split-number (join-numbers '(3 20 39 48) 100) 100) ;-> (3 20 39 48)
;(split-number (join-numbers '(5 2 3 5 1 9) 10) 10)  ;-> (5 2 3 5 1 9)
;(split-number (join-numbers '() 10) 10) ; -> ()
   		      	 
   		      	 
(define chars->bytes   		      	 
  ; Takes a list of 16-bit Unicode characters (or 8-bit ASCII
  ; characters) and returns a list of bytes (numbers in the range
  ; [0,255]).  Characters whose code value is greater than 255 are
  ; encoded as a three-byte sequence, 255 <low byte> <high byte>.
  (lambda (chars)   		      	 
    (if (null? chars)   		      	 
	'()   		      	 
	(let ((c (char->integer (car chars))))
	  (if (< c 255)   		      	 
	      (cons c (chars->bytes (cdr chars)))
	      (let ((lowbyte (remainder c 256))
		    (highbyte  (quotient c 256)))
		(cons 255 (cons lowbyte (cons highbyte (chars->bytes (cdr chars)))))))))))
   		      	 
; test cases   		      	 
;(chars->bytes (string->list "hello")) ; -> (104 101 108 108 111)
;(chars->bytes (string->list "\u0000\u0000\u0000")) ; -> (0 0 0)
;(chars->bytes (string->list "\u3293\u5953\uabab")) ; -> (255 147 50 255 83 89 255 171 171)
   		      	 
   		      	 
(define bytes->chars   		      	 
  ; Inverse of chars->bytes.  Takes a list of integers that encodes a
  ; sequence of characters, and returns the corresponding list of
  ; characters.  Integers less than 255 are converted directly to the
  ; corresponding ASCII character, and sequences of 255 <low-byte>
  ; <high-byte> are converted to a 16-bit Unicode character.
  (lambda (bytes)   		      	 
    (if (null? bytes)   		      	 
	'()   		      	 
	(let ((b (car bytes)))   		      	 
	  (if (< b 255)   		      	 
	      (cons (integer->char b)
		    (bytes->chars (cdr bytes)))
	      (let ((lowbyte (cadr bytes))
		    (highbyte (caddr bytes)))
		(cons (integer->char (+ lowbyte (* highbyte 256)))
		      (bytes->chars (cdddr bytes)))))))))
   		      	 
; test cases   		      	 
;(bytes->chars '(104 101 108 108 111)) ; -> (#\h #\e #\l #\l #\o)
;(bytes->chars '(255 147 50 255 83 89 255 171 171)) ; -> (#\u3293 #\u5953 #\uabab)
   		      	 
   		      	 
   		      	 
(define (string->integer string)
  ; returns an integer representation of an arbitrary string.
  (join-numbers (chars->bytes (string->list string)) 256))
   		      	 
; test cases   		      	 
;(string->integer "hello, world")
;(string->integer "")   		      	 
;(string->integer "April is the cruelest month")
;(string->integer "\u0000\u0000\u0000")
   		      	 
   		      	 
(define (integer->string integer)
  ; inverse of string->integer.  Returns the string corresponding to
  ; an integer produced by string->integer.
  (list->string (bytes->chars (split-number integer 256))))
   		      	 
; test cases   		      	 
;(integer->string (string->integer "hello, world"))
;(integer->string (string->integer ""))
;(integer->string (string->integer "April is the cruelest month"))
;(integer->string (string->integer "\u0000\u0000\u0000"))
;(integer->string (string->integer "\u3293\u5953\uabab"))

