
; subset_finder: returns all subsets (the power set) of a given list
; Base case: the only subset of an empty list is the empty set
(= (subset_finder ()) (()))
; Recursive case: for each subset of the tail, create a new subset by adding the head
; $res: all subsets of the tail
; $with: all subsets of the tail with $head prepended
(= (subset_finder $list)
    (let* (
            (($head $tail) (decons-atom $list))
            ($res (subset_finder $tail))
            ; $with is built by folding over $res, prepending $head to each subset
            ($with (foldl-atom $res () $acc $x (cons-atom (adder $x $head) $acc)))
        )
        (union-atom $res $with)
    )
)

; adder: prepends $curr to a given subset
(= (adder $subset $curr)
    (cons-atom $curr $subset)
)


; Example usage: find all subsets of (A B C D E)
!(subset_finder (A B C D E))


