
; --------------1. foldl -----------
; params list, binary function, initial value
(= (foldl $list $fun $init)(
    if (== $list ())
        $init
            (let* (
            (($head $tail) (decons-atom $list)) 
            ($rest ($fun $head $init))
            ($res (foldl $tail $fun $rest))
                ) $res
            )
))


; !(foldl (1 2 3 4) adder 1)



;-------------- 2. max value finder -------------

(= (max $list)
    (if (< (size-atom $list) 3)
        (let ($head $tail) (decons-atom $list) (if (> $head (car-atom $tail)) $head (car-atom $tail)))
        (let* (
                (($head1 $tail1) (decons-atom $list))
                (($head2 $tail2) (decons-atom $tail1))               
                ($temp-max (if (> $head1 $head2) $head1 $head2))
                ($result (cons-atom $temp-max $tail2))        
                ($res (max $result))
            ) $res
        )
    )
)
; !(max (3 5 7 1 3 11 0));11


;------------3. min-value finder-------------------
(= (min $list)
    (if (< (size-atom $list) 3)
        (let ($head $tail) (decons-atom $list) (if (< $head (car-atom $tail)) $head (car-atom $tail)))
        (let* (
                (($head1 $tail1) (decons-atom $list))
                (($head2 $tail2) (decons-atom $tail1))               
                ($tempmin (if (< $head2 $head1) $head2 $head1))
                ($result (cons-atom $tempmin $tail2))        
                ($res (min $result))
            ) $res
        )
    )
)
; !(min (1 5 7 3 11 0));[0]




;--------------- 4. filter --------------------
; params: list, function which takes 1 parameter and return boolean
;(: filter (-> Expression (-> Atom Bool) Expression) )
(= (filter $list $cond)
    (if (== $list ()) ()
        (let* (
            (($head $tail) (decons-atom $list))
            ($res (filter $tail $cond))
            ($result ($cond $head))
            ) (if $result (union-atom ($head) $res ) $res)
        )
    )   
)
; (= (dummy $x) 
;     (> $x 3))

; !(filter (1 4 6 7) dummy)



;----------------- 5. remove ----------------
;params: list, element to be removed
(= (remove $arr $elem)
    (if (< (size-atom $arr) 2)
        (if (== (car-atom $arr) $elem) (()) $arr)
        (if (==  $elem (car-atom $arr))
            (remove (cdr-atom $arr) $elem)
                (let* (
                    (($head $tail) (decons-atom $arr))
                    ($recurse (remove $tail $elem))
                    ($rest (union-atom ($head) $recurse))
                    ) $rest
                ) 
            )   
        )
)

; !(remove (B 1 2 B 4 5 B 7) B);[(1 2 4 5 7)]


;-----------------6. map-----------------------
; (: map(-> Expression (-> Number Number) Number))

(= (map $list $function)
    (if (== $list ())
        ()
            (let* (
            (($head $tail) (decons-atom $list))
            ($res (map $tail $function))
            ; (() (println! $res))
            ($rest ($function $head))
            )
            (cons-atom $rest $res)
            )
    )
)
(= (inc $x) (* $x $x))

; !(map (1 2 4 5) inc)

;--------------7. is memeber------------

(= (is-member $list $item)(
    if (== $list ())
        False
    (let ($head $tail) 
        (decons-atom $list)
        (if (== $head $item) 
            True 
            (is-member $tail $item)
        ) 
    )   
))
; !(is-member (1 2 4 5) 1)


;-----------8. foldr-----------

 (= (foldr () $_ $init) $init) ;; base case just returning 0

;; we will add current number with the number that its next number returns to it
( = (foldr  ($head $tail) $function $init) (
     $function $head (foldr $tail $function $init)
))


;(= (adder $x $i) (* $i $x))
; !(foldr (2 (3 (4 (5 ())))) adder 1)

