(= (push $arr $elem)
    (if (== (size-atom $arr) 0)
        ($elem)
        (if (== (size-atom $arr) 1)
            (let $x (car-atom $arr) (cons-atom $x ($elem)))
            (let* (
                    (($head $tail) (decons-atom $arr))
                    ($rest (push $tail $elem))
                    ($res (cons-atom $head $rest))
                  ) $res
            )
        )
    )
)

!(push (4 B 7 9) 3);[(4 B 7 9 3)]

;or using union-atom 
(= (append $list $elem)(
    let $ans (union-atom $list ($elem)) $ans
))

!(append (4 B 7 9) 3);[(4 B 7 9 3)]