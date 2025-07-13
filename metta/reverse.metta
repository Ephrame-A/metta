;list reverse function

(= (reverse $list)
        (if (== (size-atom $list) 1)
             $list
            (let* ((($head $tail) (decons-atom $list))
                    ($res (reverse $tail))
                    ($rest (union-atom $res ($head)))
                    $rest
                  )
            )
     )
)
!(reverse 1)