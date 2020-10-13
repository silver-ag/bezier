#lang racket

(require racket/draw)

(define (get-bezier-point bezier position)
  ;; lines is a list of points (ie. pairs of coords)
  ;; if there's only two, return the point between them proportional to position
  ;; if there's more than two, take the points along the lines between them them proportional to position
  ;; then call recursively with that list of lines
  (if (= (length bezier) 2)
      (get-point bezier position)
      (get-bezier-point (let [[lines (seperate-lines bezier)]]
                          (reverse
                           (foldl
                            (λ (l new)
                              (cons (get-point l position) new))
                            '() lines))) position)))

(define (seperate-lines points)
  (reverse
   (foldl (λ (p lst) (cons (list (second (first lst)) p) lst))
          (list (list (first points) (second points)))
          (drop points 2))))

(define (get-point line position)
  ;; get the point along line proportional to position (0-1)
  (let ((delta (cons (- (car (second line))
                        (car (first line)))
                     (- (cdr (second line))
                        (cdr (first line))))))
    (cons (+ (* position (car delta))
             (car (first line)))
          (+ (* position (cdr delta))
             (cdr (first line))))))

(define (bezier-points bezier [precision 25])
  (map (curry get-bezier-point bezier) (build-list precision (λ (n) (/ n (- precision 1))))))

(define (draw-bezier bezier dc [precision 25])
  ;; takes a bezier (list of points, ie. pairs of coords) and a drawing context
  ;; uses the dc to draw the bezier at the specified precision on the dcs target
  ;; this mutates the target, but returns the new target anyway
  (define scale-factor (let-values [[(width height) (send dc get-size)]]
                         (max width height)))
  (map (λ (l) (send dc draw-line
                    (* scale-factor (car (first l))) (* scale-factor (cdr (first l)))
                    (* scale-factor (car (second l))) (* scale-factor (cdr (second l)))))
       (seperate-lines (bezier-points bezier precision)))
  dc)

(provide bezier-points draw-bezier get-bezier-point)