
;binary tree implemetation
; general structure: 
;                  (value left-node right-node)  


;-------------1. insert -------------
(= (insert () $item) ($item () ()))
(= (insert ($val $left $right) $item)
        (if (> $item $val)
            ($val $left (insert $right $item))
            ($val (insert $left $item) $right)
        )
)

; !(insert (4 (3 () ()) (7 (5 () ()) ())) 6) ;[(4 (3 () ()) (7 (5 () (6 () ())) ()))]

;-------------- 2. find -------------
; Returns the node if its value is found in the tree
(= (find () $item) ())
(= (find ($val $left $right) $item)
    (if (== $val $item)
        ($val $left $right)
        (if (> $item $val) 
            (find $right $item) 
            (find $left $item)
        )
    )
)
; !(find (4 (3 (2 () ()) ()) (7 (5 () ()) ())) 3)

; ----------------- 3.delete -----------------
; deletes specific node from tree by usin given value
(= (delete ($val $left $right) $item)
    (if (> $item $val)
        ($val $left (delete $right $item))
        (if (< $item $val) 
            ( $val (delete $left $item) $right) 
            (if (== $right ()) ; if it has only left child return the child
                $left 
                (if (== $left ())
                    $right
                    ((min-find $right) $left (remove-last $right))
                )
            ))
    )
)
;helper function to find the min when the node has both childs
(= (min-find ($val $left $right))
    (if (== $left ())
        ()
        ($val (min-find $left) $right)
    )
)

(= (remove-last ($val $left $right))
    (if (== $left ())
        ()
        ($val (remove-last $left) $right)
    )
)

; !(delete (4 (3 (2 () ()) ()) (7 (5 () ()) ())) 5)

;---------------- 4. count_nodes ---------------
(= (count ()) 0)
(= (count ($val $left $right))
    (+ 1 (+ (count $left) (count $right)))
)

; !(count (4 (3 (2 () ()) ()) (7 (5 () ()) ())))
