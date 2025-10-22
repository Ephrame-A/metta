

(= (subset_finder ()) (()))
(= (subset_finder $list)
    (let* (
            (($head $tail) (decons-atom $list))
            ($res (subset_finder $tail))
            ($with (foldl-atom $res () $acc $x (cons-atom (adder $x $head) $acc)))
        )
        (union-atom $res $with)
    )
)

(= (adder $subset $curr)
    (cons-atom $curr $subset)
)


!(subset_finder (A B C D E F G H 1 2 J K))


