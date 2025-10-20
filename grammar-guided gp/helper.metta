;============= helper functions ==================

(= (arithmetic $opr)
    (if (== $opr add) 
        +
        (if (== $opr sub) 
            -
            (if (== $opr mul)
                *
                (if (== $opr div)
                 /
                 $opr)))
    )
)

(= (is-member $item $list)(
    if (== $list ())
        False
    (let ($head $tail) 
        (decons-atom $list)
        (if (== $head $item) 
            True 
            (is-member $item $tail)
        ) 
    )   
))

(= (slicefirst $list $end)
    (if (== $end 0)
        ()
        (let* (
                (($head $tail) (decons-atom $list))
                ($res (slicefirst $tail (- $end 1)))
                ) (cons-atom $head $res)
        )
    )
)
(= (slicelast $list $start)
    (if (== $start 0)
        $list
        (let $x (cdr-atom $list) (slicelast $x (- $start 1)))
    )
)

;replace an element at specific index
(= (replace $list $index $elem)
    (if (== $index 0)
        (let $ans (cdr-atom $list) (union-atom ($elem) $ans))
        (let* (
            (($head $tail) (decons-atom $list))
            ($res (replace $tail (- $index 1) $elem))
            ) (cons-atom $head $res)
        )
    )
)

(= (sort-pop $population)
    (if (== $population ())
        (() ())
        (let* (
                (((($score) ($gene)) $tail) (decons-atom $population))
                ()
              )
        )
    )
)


;inner loop
(= (helper $arr)(
    if (== (size-atom $arr) 1)
        $arr
            (
                    let* ((((($score1) $gene1) $tail1)(decons-atom $arr))
                        (((($score2) $gene2) $tail2) (decons-atom $tail1))
                        (($first $second) (if (> $score1 $score2) 
                                              ((($score1) $gene1) (($score2) $gene2)) 
                                              ((($score2) $gene2) (($score1) $gene1))))
                        ($ans (helper (cons-atom $first $tail2)))
                    ) (cons-atom $second $ans)
                
            )
        )
)
;outer loop
(= (recurse $current_arr $size)
    (if (== $size 1)
        $current_arr
            (let $sorted (helper $current_arr)(
                recurse $sorted (- $size 1)
            ))
    )
)
;main sorting function
(= (sort $list)(
    let $size (size-atom $list) (recurse $list $size)
))

 ! (sort (
            ((1 0) (A B C D))
            ((2 4) (E F G H))
            ((3 10) (Q))
            ))


;============ substitute function =============
;substitute variables and operators by correct value

(= (substitute $exp $target $value)
    (if (== $exp ()) 
        ()
        (let* (
                (($head $tail) (decons-atom $exp))
                ($temp (if (== $head $target) $value (arithmetic $head)))
                ; (() (println! $head))
                ($res (substitute $tail $target $value))
             ) (union-atom ($temp) $res)
        )
        )
    
)


(= (new $list $store)
    (let $type (== (get-metatype $list) Expression)
        (if (or  (not $type) (== $list ())) (union-atom $store ($list))
    (let* (
        (($head $tail) (decons-atom $list))
        ($tail2 (if (or (== (get-metatype $tail) Expression) (< (size-atom $tail) 2)) (car-atom $tail) $tail))
        ($newstore (union-atom $store ($head)))
        ) (new $tail2 $newstore)
    )))
) 

;============== random list of numbers generator=============

(= (rand $limit)
    (if (== $limit 0)
        (0)
        (let* (
        ($elem (random-int &rng 0 2))
        ($list (rand (- $limit 1)))
        ) (union-atom $list ($elem) )
        )
    )
)

;========= selects individuals from population by using index list ===========
(= (choose $popn () $limit) ())
(= (choose $popn $list $limit)
    (if (== $limit 0) 
        ()
        (let* (
                (($head $tail) (decons-atom $list))
                ($ind (index-atom $popn $head))
                ($res (choose $popn $tail (- $limit 1)))
                ) (union-atom ($ind) $res)
                ) 
    )   
)