;;; YOUR NAME:   		      	 
;;;   		      	 
;;; Comp200 Project 3   		      	 
;;;   		      	 
(define your-answer-here -1)   		      	 
(load "databases.scm")   		      	 
   		      	 
;;; problem 1 ;;;   		      	 
   		      	 
;; your code should have the following general form

;; example-table is created as empty table and few rows are added
;; rows have name and major columns.
(define example-table
  (let* ((col1 (list 'name 'symbol))
         (col2 (list 'major 'number))
         (cols (list col1 col2))
         (ex-table (make-empty-table cols)))
    
    (table-insert! (list 'ben '6) ex-table)
    (table-insert! (list 'jen '3) ex-table)
    (table-insert! (list 'amy '12) ex-table)
    (table-insert! (list 'kim '13) ex-table)
    (table-insert! (list 'alex '6) ex-table)
    ex-table)
   )   		      	 
   		      	 
;; test cases
;(table-display example-table)

;;; problem 2 ;;;

;; this method inserts all rows in the list to the table one by one
;; inputs: list of rows, table
;; output: updated table
(define (table-insert-all! lst table)
  (if (null? lst)
      table
      (table-insert-all! (cdr lst) (table-insert! (car lst) table)))
)   		      	 
;; test cases   		      	 
   		      	 
 (define books (make-empty-table
 	       (list (make-column 'title 'symbol)
 		     (make-column 'author 'symbol)
 		     (make-column 'rating 'number))))
   		      	 
   		      	 
 (table-insert-all! '((sicp abelson-sussman 8)
 		     (return-of-the-king jrr-tolkien 9)
 		     (treatment-of-subordinates darth-vader 4)
 		     (project-grading tom 2)
 		     (all-things-stata frank-gehry 5)
 		     (biting-the-hand-that-feeds-me my-cat 1))
 		   books)   		      	 
; (table-display books)   		      	 
   		      	 
;;; problem 3 ;;;   		      	 
;; Hint: Writing (filter predicate lst) might be helpful

;; this method returns a table of selected rows according to selector method
;; selector is used with filter.

(define (table-select selector table)
  (let* (
         (cols (get-table-columns table))
         (rows (get-table-data table))
         (newrows (filter selector rows))
         (newrowdatas (map (lambda (row) (row-data row)) newrows))
         (mtable (table-insert-all! newrowdatas (make-empty-table cols)))
         )
    mtable)
  )   		      	 
   		      	 
;; test cases   		      	 
   		      	 
 (display "Testing Problem 3\n")
 (table-display   		      	 
  (table-select   		      	 
   (lambda (row)   		      	 
     (> (get 'rating row) 4))
   books))   		      	 
   		      	 
;;; problem 4 ;;;   		      	 
   		      	 
;; Hint: Be careful about the comparator operator of the corresponding
;; row.  Writing a (get-column-type row column-name) might be helpful.

;; using the sort procedure with comparator, new table is created according to comparator
;; input: column & table itself
;; output: sorted table 
(define (table-order-by column table)
  (let* (
         (cmpr (make-row-comparator column table))
         (mtable (make-table (get-table-columns table) (sort cmpr (get-table-data table))))  
         )
    mtable
  
  
))   		      	 
;; test cases   		      	 
(display "Testing Problem 4\n")
 (table-display   		      	 
  (table-order-by 'rating books)
 )   		      	 
   		      	 
 (table-display   		      	 
  (table-order-by 'title books)
 )   		      	 
   		      	 
;;; problem 5 ;;;
;; this procedure deletes some of the rows that (pred row) is true (satisfied)
;; input: predicate procedure, table
;; output: new table
   		      	 
(define (table-delete! pred table)
  (let ((fresult (filter (lambda (x) (not (pred x))) (get-table-data table))))
    (change-table-data! table fresult))
  )   		      	 
   		      	 
;; test cases   		      	 
 (display "Testing Problem 5\n")
 (table-delete!   		      	 
  (lambda (row)   		      	 
   (eq? (get 'author row) 'my-cat))
 books)   		      	 
   		      	 
 (table-display books)   		      	 
   		      	 
;;; problem 6 ;;;
;; this procedure updates the rows if (pred row) is true
;; new value is calculated according to proc
;; input: predicate procedure, column, procedure to apply for value, table
;; output: updated table

#|
(define (table-update! pred column proc table)
  (define (mapper row)
    (if (pred row)
        (let* ((newrow  (row-col-replace row column (proc row))))
            (if (row-type-check newrow)
                   newrow
                   'type-mismatch-error))       
        row))
  
  (let* (
         (rows (get-table-data table))
         (newrows (map mapper rows))
         )
    (make-table (get-table-columns table) newrows)
  ))
|#

(define (table-update! pred column proc table)
(change-table-data! table (map (lambda(x) (if (pred x) (row-col-replace x column (proc x)) x)) (get-table-data table))                
  ))

;; test cases   		      	 
   		      	 
 (display "Testing Problem 6\n")
 (table-update! (lambda (row) (or (eq? (get 'name row) 'amy) (eq? (get 'name row) 'alex)))
               'major   		      	 
               (lambda (row) '9)
               example-table)
 (table-display example-table)
   		      	 
;;; problem 7 ;;;
;; list of types that the table supports
;; each type has a name, checker and comparator procedure
   		      	 
(define *type-table*   		      	 
(list
   (list 'string string? string<?)
   (list 'number number? <)
   (list 'symbol symbol? symbol<?))
)   		      	 

;; example-table2: new table according to new *type-table*
(define example-table2   		      	 
(let* ((col1 (list 'name 'string))
         (col2 (list 'major 'number))
         (cols (list col1 col2))
         (ex-table (make-empty-table cols)))
    
    (table-insert! (list "ben" '6) ex-table)
    (table-insert! (list "jen" '3) ex-table)
    (table-insert! (list "amy" '12) ex-table)
    (table-insert! (list "kim" '13) ex-table)
    (table-insert! (list "alex" '6) ex-table)
    ex-table)   		      	 
   )   		      	 
   		      	 
;; test cases   		      	 
 (display "Testing Problem 7\n")
 (table-insert! '("jen" 3) example-table2)
 (table-insert! '("ben" 6) example-table2)
 (table-insert! '("alex" 6) example-table2)
 (table-insert! '("amy" 12) example-table2)
 (table-insert! '("kim" 13) example-table2)
   		      	 
   		      	 
 (table-display example-table2)
 (display "\nordered example-table2\n")
 (table-display   		      	 
  (table-order-by 'name example-table2)
 )   		      	 
   		      	 
;;; problem 8 ;;;   		      	 
   		      	 
;; Hint: Writing these two procedures might be helpful (contains? lst
;; x) returns true if x in the lst and (get-pos lst x) returns the
;; position of x if it is in the list.
;; Ex: (get-pos '(1 2 3 4) 2) => 2
;;     (get-pos '(1 2 3 4) 5) => 0

;; returns if input lst contains x element
;; input: list, element x
;; output: boolean result
(define (contains? lst x)
  (if (null? lst)
      #f
      (or (eq? x (car lst)) (contains? (cdr lst) x))))

;; get-pos return the index of x in the lst
;; first index = 1
;; if not found -> index = 0

(define (get-pos lst x)
  (define (helper count lstt)
    (if (null? lstt)
        0
        (if (eq? x (car lstt))
            count
            (helper (+ count 1) (cdr lstt)))))
  (helper 1 lst))


;; enum checker returns a procedure that checks
;; given x is in the enum list
(define (make-enum-checker lst)
   (lambda (x) (contains? lst x))
  )

;; enum comparator returns a procedure that compares
;; two given inputs' positions in the list
(define (make-enum-comparator lst)
  (lambda (x y) (< (get-pos lst x) (get-pos lst y)))  		      	 
)

(define *days* '(sunday monday tuesday Wednesday thursday friday saturday))
(define day-checker (make-enum-checker *days*))
(define day-comparator (make-enum-comparator *days*))
   		      	 
;; test cases   		      	 
 (display "Testing Problem 8\n")
 (day-checker 'monday)   ;=> #t
 (day-checker 7)         ;=> #f
 (day-comparator 'monday 'tuesday)   ;=> #t (monday is "less than" tuesday)
 (day-comparator 'friday 'sunday)    ;=> #f (sunday is before friday)
   		      	 
 ;; list of types that the table supports
;; each type has a name, checker and comparator procedure	      	 
(define *type-table*
  (list
   (list 'string string? string<?)
   (list 'number number? <)
   (list 'day day-checker day-comparator)
   (list 'symbol symbol? symbol<?))
)   		      	 

;; example-table3: columns: name, date, major
 (define example-table3   		      	 
   (make-empty-table   		      	 
    (list (make-column 'name 'string)
          (make-column 'date 'day)
          (make-column 'major 'number)))
    )   		      	 
   		      	 
 (table-insert! '("jen" monday 3) example-table3)
 (table-insert! '("ben" sunday 6) example-table3)
 (table-insert! '("alex" friday 6) example-table3)
 (table-insert! '("amy" tuesday 1) example-table3)
 (table-insert! '("kim" saturday 2) example-table3)
   		      	 
(table-display example-table3)
 (display "\nordered example-table3\n")
 (table-display   		      	 
  (table-order-by 'date example-table3)
 )   		      	 
   		      	 
;;; Problem 9   		      	 
;; Hint: Similar with Problem 8

;; same enum-checker and enum-comparators are used.

;; day, gender and race are defined with enum.

(define *days* '(sunday monday tuesday Wednesday thursday friday saturday))
(define day-checker (make-enum-checker *days*))
(define day-comparator (make-enum-comparator *days*))

(define *gender* '(male female))
(define gender-checker
  (make-enum-checker *gender*)
)
(define gender-comparator
  (make-enum-comparator *gender*)
)

(define *race* '(white black red blue))
   		      	 
(define race-checker   		      	 
(make-enum-checker *race*)   		      	 
)   		      	 
(define race-comparator   		      	 
(make-enum-comparator *race*)   		      	 
)   		      	 

;; list of types that the table supports
;; each type has a name, checker and comparator procedure

(define *type-table*
   (list
    (list 'string string? string<?)
    (list 'number number? <)
    (list 'day day-checker day-comparator)
    (list 'race race-checker race-comparator)
    (list 'gender gender-checker gender-comparator)
    (list 'symbol symbol? symbol<?)
    )
)
  		      	 
;;; Problem 10   		      	 

;; person table has name, race, gender and birthyear columns
(define person-table   		      	 
(make-empty-table   		      	 
    (list (make-column 'name 'string)
          (make-column 'race 'race)
          (make-column 'gender 'gender)
          (make-column 'birthyear 'number)
          ))   		      	 
)

;;; tests   		      	 
 (display "Testing Problem 10\n")
 (table-insert! '("jen" white female 1983) person-table)
 (table-insert! '("axe" black male 1982) person-table)
 (table-display person-table)
   		      	 
   		      	 
;;; Problem 11   		      	 
 (table-delete! (lambda (x) #t) person-table)
 (display "\nDeleted Person Table\n")
 (table-display person-table)
   		      	 
(define (make-person name race gender birthyear)
  (let ((lst (list name race gender birthyear)))
    (table-insert! lst person-table))
  name)   		      	 
   		      	 
;; test cases   		      	 
   		      	 
 (display "Testing Problem 11\n")
   		      	 
 (define p1 (make-person "Alex" 'white 'male 1983))
 (define p2 (make-person "Clark" 'black 'male 1982))
 (table-display person-table)
   		      	 
;;; Problem 12

(define (person-name person) person)


;; lookup-person-row takes person name as an input and
;; finds the row that contains with name and returns
;; this row
(define (lookup-person-row person)
  (let ((filtered-rows (filter (lambda
                                   (row)
                                        (eq? (get 'name row) person))
                               (get-table-data person-table))))
    filtered-rows
    (if (null? filtered-rows)
        (make-row (get-table-columns person-table)(list (error "person not found")(error "person not found") (error "person not found") (error "person not found")))
        (car filtered-rows)))
  )

(define (person-race person)   		      	 
  (get 'race (lookup-person-row person)))
   		      	 
(define (person-gender person)   		      	 
  (get 'gender (lookup-person-row person)))
   		      	 
(define (person-birthyear person)
  (get 'birthyear (lookup-person-row person)))
   		      	 
(define (person-age person)   		      	 
; returns an approximation to the person's age in years
  (let ((*current-year* 2016))   		      	 
    (- *current-year* (person-birthyear person))))
   		      	 
;; test cases   		      	 
 (display "Testing Problem 12\n")
 (lookup-person-row p1)   		      	 
 (person-race p1)   		      	 
 (person-gender p1)   		      	 
 (person-birthyear p1)   		      	 
 (person-age p1)   		      	 
 (lookup-person-row "Muslera")
   		      	 
;;; Problem 13

;; update-person-row! takes 3 inputs
;; inputs: person to be updated, colname to be updated, newvalue to be put.

(define (update-person-row! person colname newvalue)
  (table-update! (lambda (row) (eq? (get 'name row) person)) colname (lambda (value) newvalue) person-table)
)
  
(define (set-person-name! person newname)
  (update-person-row! person 'name newname))
   		      	 
(define (set-person-race! person newrace)
  (update-person-row! person 'race newrace))
   		      	 
(define (set-person-gender! person newgender)
  (update-person-row! person 'gender newgender))
   		      	 
(define (set-person-birthyear! person newbirthyear)
  (update-person-row! person 'birthyear newbirthyear))
   		      	 
;; QUESTION What happens? Why? Comments?
;; This method simply does not work. I used table-update! procedure which the documentation is explained as it is guaranteed to modify the existing table.
;; when update-person-row! procedure is called, person-table should be updated.
   		      	 
;;; test cases   		      	 
   		      	 
;; (display "Testing Problem 13\n")
 (define alyssa (make-person "alyssa-p-hacker" 'black 'female 1978))
 (set-person-name! alyssa "alyssa-p-hacker-bitdiddle")  ; got married!
 (table-display person-table)
 (person-name alyssa)   		      	 
 (person-race alyssa)   		      	 


;;; Problem 14
;; life table has year and lots of expected life long numbers

(define life-table   		      	 
(make-empty-table   		      	 
    (list (make-column 'year 'number)
          (make-column 'all-all 'number)
          (make-column 'all-male 'number)
          (make-column 'all-female 'number)
          (make-column 'white-all 'number)
          (make-column 'white-male 'number)
          (make-column 'white-female 'number)
          (make-column 'black-all 'number)
          (make-column 'black-male 'number)
          (make-column 'black-female 'number)
          ))      		      	 
)   		      	 
   		      	 
(table-insert-all! life-expect-data life-table)		      	 
 (display "14- Selecting 1950\n")
 (table-display   		      	 
  (table-select   		      	 
  (lambda (row)   		      	 
    (= (get 'year row) 1950))
  life-table))   		      	 


;;; Problem 15
;; convert-lifetable simply takes a list as an input
;; and for each row of the list, it creates 4 seperate data
;; append them to each other, converts to table to more
;; understandle and analyzable format.
   		      	 
(define (convert-lifetable lst)
;; Converts the data to the (year race gender expected) format
  (define (helper cList)
    (if (null? cList)
        '()
        (let* (
              (row (car cList))
              (a1 (list (car row) 'white 'male (cadr (cddddr row))))
              (a2 (list (car row) 'white 'female (caddr (cddddr row))))
              (a3 (list (car row) 'black 'male (car (cddddr (cddddr row)))))
              (a4 (list (car row) 'black 'female (cadr (cddddr (cddddr row)))))
               )
          (append (list a1 a2 a3 a4) (helper (cdr cList))))))
  (helper lst)       
) 	      	 
   		      	 
;; test cases   		      	    		      	 
   		      	 
(define life-expect-data-new (convert-lifetable life-expect-data))
   		      	 
(define life-table-new   		      	 
   (make-empty-table   		      	 
   (list (make-column 'year 'number)
         (make-column 'race 'race)
         (make-column 'gender 'gender)
         (make-column 'expected 'number)
   )))   		      	 
(table-insert-all! life-expect-data-new life-table-new)
(display "15- Selecting 1950 from new data\n")
(table-display   		      	 
(table-select   		      	 
 (lambda (row)   		      	 
  (= (get 'year row) 1950))   		      	 
  life-table-new))   		      	 
   		      	      	 
;;; Problem 16

(display "\nTesting Problem 16\n")

;; problem16-table is the filtered and ordered version of the life-table-new.
;; filter predicate procedure simply checks the year (1949<x<1960) where gender is female and race is white.
;; result table is ordered.

(define problem16-table
  (let ((filtered (table-select   		      	 
 (lambda (row)   		      	 
  (and
   (and
    (and (> (get 'year row) 1949) (< (get 'year row) 1960))
    (eq? (get 'race row) 'white))
    (eq? (get 'gender row) 'female)))
  life-table-new)))
    (table-order-by 'expected filtered)))   		      	    		      	 
   		      	 
;;; QUESTION Was life expectancy for white women steadily increasing
;;; in this decade?   		      	 
; Yes, it is increasing regularly as printed in the console.
   		      	 
(table-display   		      	 
  (table-order-by 'expected problem16-table)
)   		      	 
   		      	 
;; Paste the output of Problem 16 for black female
;; between 1950 and 1959   		      	 

;Testing Problem 16
;year	race	gender	expected	
;1950	black	female	62.9	
;1951	black	female	63.4	
;1952	black	female	63.8	
;1953	black	female	64.5	
;1957	black	female	65.5	
;1958	black	female	65.8	
;1954	black	female	65.9	
;1956	black	female	66.1	
;1955	black	female	66.1	
;1959	black	female	66.5
	      	 
;;; Problem 17
   		      	 
(define p3 (make-person "GeorgeBest" 'white 'female 1987))
(define p4 (make-person "Lizarazu" 'white 'male 1940))


;; this procedure takes person as an input and returns
;; how many years he/she has to live.
;; to calculate it, it finds the gender, race, birthyear of the person and
;; searchs with this inputs in the life-table-new.
;; 2016= current year is substracted from birthyear + expected life long.
(define (expected-years person)
  (let* (
         (birthyear (person-birthyear person))
         (gender (person-gender person))
         (race (person-race person))
         (single (filter (lambda
                (row)
                (and (and (eq? (get 'year row) birthyear)
                (eq? (get 'gender row) gender))
                (eq? (get 'race row) race))
              ) (get-table-data life-table-new)))
         (remaining (- (+  (get 'expected (car single)) birthyear) 2016))
         )
    remaining
   ))
;; test cases   		      	 
(display "Testing problem 17\n")   		      	 
(expected-years p3)   		      	 
(expected-years p4)
