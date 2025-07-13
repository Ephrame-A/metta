;inner loop
(= (helper $arr)(
    if (== (size-atom $arr) 1)
        $arr
            (
                    let* ((($head1 $tail1)(decons-atom $arr))
                        (($head2 $tail2) (decons-atom $tail1))
                        (($first $second) (if (> $head1 $head2) ($head1 $head2) ($head2 $head1)))
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
(= (bubble $list)(
    let $size (size-atom $list) (recurse $list $size)
))

 !(bubble (7 3 4 9 1));[(1 3 4 7 9)]


