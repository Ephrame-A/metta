
;To remove an element at specific index
(= (remove $arr $index)
    (if (> $index (size-atom $arr))
        ()
        (if (== (- $index 1) 0)
            (cdr-atom $arr)
            (let* (
                (($head $tail) (decons-atom $arr))
                ($recurse (remove $tail (- $index 1)))
                ($rest (union-atom ($head) $recurse))
                ) $rest
            )    
        )
    )
)

(= (backtrack $curr $remain $result) 
    (if (== $remain ())
        (cons-atom $curr $result) ;append possible permutation to result
        (select $curr $remain 0 $result)
    )
)

(= (select $elem $remain $i $res) (
    if (== $i (size-atom $remain))
        () 
        (let* (
            ($chosen (index-atom $remain $i))
            ($y (union-atom $elem ($chosen)))
            ($new_remain (remove $remain (+ $i 1)));remove the ith element for the next recursion
            ($back (backtrack $y $new_remain $res))
            ($new_elem (remove $y (size-atom $y))) ;Remove the element to try other possibilities
            ($ans (select $new_elem $remain (+ $i 1) $res))
        ) 
        (union-atom $back $ans))
))

;main function
(= (permutate $exp) (
    backtrack () $exp ()
))

!(permutate (A B C));[((A B C) (A C B) (B A C) (B C A) (C A B) (C B A))]