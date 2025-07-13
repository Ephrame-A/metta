;to remove the last element
(= (pop $arr)
    (if (< (size-atom $arr) 2)
        ()
        (let* (
                (($head $tail) (decons-atom $arr))
                ($recurse (pop $tail))
                ($rest (union-atom ($head) $recurse))
            ) $rest
        )
    )
)