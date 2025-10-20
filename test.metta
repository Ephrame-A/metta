
! (import! &self main)
! (import! &self helper)
! (bind! test-pairs ((0 1) (2 4) (3 1)))
! (bind! exp-limit 4)
! (bind! child-size 4)
! (bind! mutation-prob 0.2)

! (bind! population (genotype-generate 10))
! (population)
; ! (phenotype (0 1 0 0 0 1 1 0 0) start)
; ! (evaluation (2 (add x)) test-pairs)
; ; ! (mutate population mutation-prob () exp-limit)
; ! (minor (((0.0) (0 1 0 0 0 1 1 0 0)) ((0.0) (0 1 0 0 0 1 1 0 0))) ())

; ! (let* (
;         (($p1 $p2) (genotype-generate 2)) 
;         (($c1 $c2) (cross $p1 $p2))
;         (() (println! (parents $p1 $p2)))
;         (() (println! (children $c1 $c2)))
;         ) (mutate ($c1 $c2) mutation-prob () exp-limit)
;         )

; ! (main (((0.0) (0 1 0 0 0 1 1 0 0)) ((0.0) (0 1 0 0 0 1 1 0 0))) 4)
