; Import flight data from data.metta into &db space
!(import! &db data)

; Create a new space &db2 for normalized data
!(bind! &db2 (new-space))

; Helper for foldl-atom: accumulates city names, durations, costs, distances into separate lists
(= (foldlhelper $x $acc)
    (let*
        (
            (($a $b $dur $cost $dist) $x)
            (($c $d $first $second $third) $acc)
        )
        ((cons-atom $a $c) (cons-atom $b $d) (cons-atom $dur $first) (cons-atom $cost $second) (cons-atom $dist $third))
    )
)

; Builder: Normalizes a single flight's metrics (duration, cost, distance) and computes overall score
(= (builder ($cityA $cityB $dur $cost $dist) $alldur $allcosts $alldist)
    (let*
        (
            ($maxdur (max-atom $alldur))
            ($mindur (min-atom $alldur))    
            ($newdur (/ (- $dur $mindur) (- $maxdur $mindur)))

            ($maxcost (max-atom $allcosts))
            ($mincost (min-atom $allcosts))
            ($newcost (/ (- $cost $mincost) (- $maxcost $mincost)))
            
            ($maxdist (max-atom $alldist))
            ($mindist (min-atom $alldist))
            ($newdist (/ (- $dist $mindist) (- $maxdist $mindist)))  

            ($overall (+ (+ $newdist $newdur) $newcost))      

            ; (() (println! (flight-route $cityA $cityB (Duration $newdur Cost $newcost Distance $newdist Overall $overall))))
        )
        (flight-route $cityA $cityB (Duration $dur Cost $cost Distance $dist Overall $overall))
    )
)

; Data preprocessor: Extracts all flights, groups metrics, and adds normalized flights to &db2
(= (dataPreProcessor)
    (let*
        (
            ($expr (collapse (match &db (flight-route $x $y (Duration $z Cost $w Distance $u)) ($x $y $z $w $u))))
            (($allcityA $allcityB $alldur $allcosts $alldist) (foldl-atom $expr (() () () () ()) $acc $x (foldlhelper $x $acc)))
        )
        (add-reduct &db2 (let $each (superpose $expr) (builder $each $alldur $allcosts $alldist)))
    )
)

; Run data preprocessing to populate &db2 with normalized data
; !(dataPreProcessor)


; Helper for membership check: checks if element is in list using superpose
(= (isMemberHelper $list $ele) 
    (collapse (let $child (superpose $list) (if (== $child $ele) True (empty))))
)

; Membership check: returns True if element is in list, False otherwise
(= (isMember $list $ele)
    (if (== (isMemberHelper $list $ele) (True)) True False)
)

; Recursive path finder: finds all paths from $first to $last, avoiding cycles, using metric $type in space $space
; Returns paths in format like (CityA -- weight --> CityB ...)
(= (pathFind $first $last $visited $type $space)
    (if (isMember $visited $first) 
        (empty)
        (if (== $first $last) 
            ($first)
            (let $newVisited (cons-atom $first $visited)
                (match $space 
                    (flight-route $first $sec $remaining)
                    (let ($ans $x) 
                        ((pathFind $sec $last $newVisited $type $space) (index-atom $remaining (+ (* $type 2) 1)))
                        (union-atom ($first -- $x -->) $ans)
                    )
                )
            )
        )
    )
)

; Simplified path finder: calls the recursive version with appropriate space (&db or &db2 for overall)
(= (pathFind $first $second $type)
    (if (== $type 3)
        (collapse (pathFind $first $second () $type &db2))
        (let $answer (collapse (pathFind $first $second () $type &db)) $answer)
    )
)




; Helper: sums up numeric values in a path (e.g., total cost or duration)
(= (helper $path) 
    (let $y (collapse (let $each (superpose $path) (if (== (get-type $each) Number) $each (empty)))) (foldl-atom $y 0 $acc $x (+ $acc $x)))
)

; Recursive helper for shortest path: iterates through all paths to find the one with minimum total value
(= (shortestPathFinderHelper $allpaths $shPath $minimum $index) 
    (if (<= (size-atom $allpaths) $index)
        $shPath
        (let*
            (
                ($path (index-atom $allpaths $index))
                ($current (helper $path))
                ($newMin (min-atom ($minimum $current)))
                ($newShPath (if (< $current $minimum) $path $shPath))
            )
            (shortestPathFinderHelper $allpaths $newShPath $newMin (+ $index 1))
        )
    )
)

; Shortest path finder with space: finds the path with minimum metric value between cities
(= (shortestPathFinder $first $second $type $space)
    (let $allpaths (pathFind $first $second $type $space)
        (if (== $allpaths ())
            (There is no path between $first and $second)
            (let $shPath (index-atom $allpaths 0) (shortestPathFinderHelper $allpaths $shPath (py-atom "float('inf')") 0))
        )
    )
)

; Simplified shortest path finder: uses default space
(= (shortestPathFinder $first $second $type)
    (let $allpaths (pathFind $first $second $type)
        (if (== $allpaths ())
            (There is no path between $first and $second)
            (let $shPath (index-atom $allpaths 0) (shortestPathFinderHelper $allpaths $shPath (py-atom "float('inf')") 0))
        )
    )
)

; Example execution: find shortest path from Addis to Jimma by overall score
!(pathFind Addis Gonder 1)