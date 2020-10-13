#lang scribble/manual

@(require (for-label racket racket/draw "main.rkt"))

@title{Bezier Curve Drawing}
@defmodule[bezier]

This module provides simple utilities for drawing and finding points on Bezier curves.
It isn't particularly efficient, but it supports curves of arbitrary degree. Curves are
represented by lists of points, where each point is a pair of numbers representing coordinates.

@section{Reference}

@defproc[(bezier-points [bezier (listof? (pairof? number?))]
                        [precision integer? 25])
         (listof? (pairof? number))]{
Takes a Bezier curve, represented as always by a list of points, where each point is a pair of
coordinates. Returns a list of @racket[precision] points that lie equally spaced on the curve.}

@defproc[(get-bezier-point [bezier (listof? (pairof? number?))]
                           [location number?])
         (pairof? number?)]{
Takes a Bezier curve and a location, which is a number 0 - 1 specifying how far along the along the
curve to return the point at (so for instance, @racket[(get-bezier-point a-curve 0.75)] returns the
point three quarters of the way along @racket[a-curve]).}

@defproc[(draw-bezier [bezier (listof? (pairof? number?))]
                      [dc dc<%>?]
                      [precision integer? 25])
         bitmap%?]{
Takes a Bezier curve and a @racket[dc<%>] drawing context (it doesn't matter what kind), and draws the curve onto the context.
Expects the curve to lie entirely within the unit square, and scales it to match the largest square that
fits inside the context. This process mutates the target of the drawing context.
@racket[draw-bezier] returns the drawing context for lack of anything else particularly sensible to return.}