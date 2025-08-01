
! (bind! Terminal (x 1 2 3 add sub mul div))
! (bind! test-pairs ((0 1) (2 4) (3 1)))
! (bind! &grammar (new-space))
! (bind! population-size 50)
! (bind! grammar_limit 10)
! (bind! tournament 5)

;========== defining grammar space ===============
! (add-reduct &grammar 
                (superpose 
                (   (start exp 0)
                    (exp term 0)
                    (exp (exp opr exp) 1)
                    (opr add 0)
                    (opr sub 1)
                    (opr mul 2)
                    (opr div 3)
                    (term var 0)
                    (term digit 1)
                    (var x 0)
                    (digit 1 0)
                    (digit 2 1)
                    (digit 3 2)
                ))

    )

;=============== defining limit space===========
! (bind! &limit (new-space))
! (add-reduct &limit (superpose 
                (
                (start 1)
                (exp 2)
                (term 2)
                  (opr 4) 
                  (var 1)  
                  (digit 3)
                )
                ))

;=============== random population genotype generator ================
(= (genotype-generate $pop_size)
    (if (< $pop_size 1)
        ()
        (let* (
            ($list (rand grammar_limit))
            ($population (genotype-generate (- $pop_size 1)))
             ) (cons-atom  ((0.0) $list) $population)
        )
    )
)


;================= phenotype mapper===================
; maps phenotype and genotype
(= (phenotype $genotype $start)
    (if  (== $genotype ())
        (invalid) 
        (if (is-member $start Terminal) 
            $start
            (let* (
                    (($hd $ta) (decons-atom $genotype)) ;(0 1 0 0 0 1 1 0 0)
                    ($num (collapse (match &limit ($start $lim) $lim)))
                    
                )
            
                (if (== (get-metatype $start) Expression) 

                    (let* ( 
                            (($h $t) (decons-atom $start))
                            ($val (collapse (match &limit ($h $lim) $lim)))
                          )

                           (if (> (car-atom $val) $hd)
                               (let $result (match &grammar ($h $wanted $hd) $wanted)
                                    (let $loop 
                                            (phenotype $ta $result)
                                            (if (== $t ()) 
                                                $loop
                                                (let $f (phenotype $ta $t) (union-atom ($loop) ($f))))))
                               (invalid)
                            ))
                    (if (> (car-atom $num) $hd)
                        (let $nxt 
                            (match &grammar ($start $expr $hd) $expr)
                            (phenotype $ta $nxt))
                        (invalid))
                )   )
        ))
)
; ============= Calculate score ==============
(= (evaluation $exp $test)
    (if (== $test ()) 
        0
        (let* (
             ((($val $y) $tail) (decons-atom $test))
             ($expr (new $exp ()))
            ($sub (substitute $expr x $val))
            ($evaluated (py-atom $sub))
            ($score (abs-math (- $y $evaluated)))
        ) (+ $score (evaluation $exp $tail)))
    )
)

; !(phenotype (0 1 1 0 0 0 1 1 1) 22 start)


;================ cross over =======================
;crossing over parents gene to get new offsprings
(= (cross $pop1 $pop2)
    (let* ( ((($score1) $gene1) $pop1)
            ((($score2) $gene2) $pop2)
            ($rand1 (random-int &rng 0 grammar_limit))
            ($elem1 (slicefirst $gene1 $rand1))
            ($elem2 (slicelast $gene2 $rand1))
            ($elem3 (slicefirst $gene2 $rand1))
            ($elem4 (slicelast $gene1 $rand1))
            ($child1 (union-atom $elem1 $elem2))
            ($child2 (union-atom $elem3 $elem4))
        ) (((0.0) $child1) ((0.0) $child2))
    )
)



;=========== mutation ===================
; mutate random gene if it satisfies probability of mutation

(= (mutate $pop $probability $mutated $exp-limit)
    (if (== $pop ()) 
        $mutated
    (let* ( (((($score) $gene) $tail) (decons-atom $pop))
            ($randProb (random-float &rng 0 1))
            ($randIndex (random-int &rng 0 2))
            ($randElem (random-int &rng 0 $exp-limit))
            ($result (if (< $randProb $probability) (replace $gene $randIndex $randElem) $gene))
            ($new-mutated (union-atom $mutated (($score) $result)))
          ) (mutate $tail $probability $new-mutated $exp-limit)
    )  
    )
)

;
(= (minor $pop_list $store)
    (if (== $pop_list ()) 
        $store
        (let* 
            (
                (((($score) $gene) $tail) (decons-atom $pop_list))
                (() (println! $tail))
                ($phenotype (phenotype $gene start))
                ($new-score (if (or (is-member invalid $phenotype) (is-member (invalid) $phenotype)) ;filtering
                                ()
                                (evaluation $phenotype test-pairs))
                )
                ($res (if (== $new-score ()) $store (union-atom  (($new-score) $gene) $store))) ; updating
            ) (minor $tail $res)
        )
    )
    
)


(= (main () $generation) ())
(= (main $pop_list $generation)
    (if (== $generation 0) 
        ()
        (let* (
                ($updated_pop (minor $pop_list ()))
                ($sored_pop  (sort $updated_pop))
                ($top (slicefirst $sorted_pop 5)) ;selecting top 5
                ($least (slicelast $sorted_pop 5))
                ($selected (selection $least tournament child-size))
                ($mutated (mutate $selected mutation-prob ()))
                ($res (main $mutated (- $generation 1)))
                ) (cons-atom $top $res)
        )
    )
)

(= (selection $least $tournament-size $selection-size)
    (if (< $selection-size 1) () (
    (let* ( 
            ($ch  (rand (+ 2 $tournament-size)))
            ($choices (unique-atom $ch))
            (() (println! ($ch $choices)))
            ($selected (choose $least $choices $tournament-size))
            ($sorted (sort $selected))
            (($parent1 $parent2) (slicefirst $sorted 2))
            ($children (cross $parent1 $parent2))
            ($new-size (- $selection-size 2))
            ($res (selection $least $tournament-size $new-size))
            ) (union-atom $children $res)
    ) 
    )
    )
)

(= (GBGP)
    (let $population (genotype-generate population-size) (main $population))
)

; ! (selection (((1) (1 2 3)) ((2) (3 2 1)) ((3) (3 2 1)) ((5) (3 B 1))) 3 4)
