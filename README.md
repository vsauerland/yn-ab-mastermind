# YN-AB-Mastermind
Codebreaker strategies for YN-AB-Mastermind (Matlab/Octave).

This folder contains Matlab/Octave implementations of a simple
binary search based codebreaker strategy for a variant of
the popular board game mastermind.

The Game Variant
================

In the classic mastermind game, one player (called codemaker)
chooses a secret code of length 4
by selecting one out of 6 colors for each position.
A second player (codebreaker) is supposed to be crack the code
by subsequently making corresponding code guesses,
which in turn are answered by codemaker with the number
of coincidences between the secret code and the code guess
plus the number of colors that appear in both,
secret code and code guess, but at different positions.

In the YN-AB variant of the game
* the code length is generalized to an arbitrary n and the number of colors to an arbitrary k&ge;n,
* codemaker's answers only indicate whether or not a guess coincides with the secret code at all (each answer is either yes or no),
* all colors of the secret code and each code guess must be distinct.

The Codebreaker Strategy and its Implementation
===============================================

The strategy identifies the secret code positions one-by-one,
each using a binary search procedure which asks appropriate guesses,
keeping record about the identified positions.
The number of necessary queries for k=O(n) colors is of the order O(n log n),
which is asymptotically tight, since the worst case lower bound is
&Omega;(k log n).

There are two versions implemented, depending on the number of colors:
* yn_ab_nn_mastermind.m deals with the case k=n
* yn_ab_nk_mastermind.m deals with the case k>n

Auxiliary functions are:
* info.m, telling whether two codes coincide or not
* info.m, telling whether two codes coincide in any not yet identified position
