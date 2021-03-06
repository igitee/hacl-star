module Hacl.Impl.Ed25519.PointAdd

module ST = FStar.HyperStack.ST

open FStar.HyperStack.All

open FStar.Buffer
open Hacl.Bignum25519
open Hacl.Impl.Ed25519.ExtPoint


#reset-options "--max_fuel 0 --z3rlimit 100"

val point_add:
  out:point ->
  p:point{disjoint p out} ->
  q:point{disjoint q out} ->
  Stack unit
    (requires (fun h -> live h out /\ live h p /\ live h q /\
      (
        let x1 = as_seq h (getx p) in
        let y1 = as_seq h (gety p) in
        let z1 = as_seq h (getz p) in
        let t1 = as_seq h (gett p) in
        let x2 = as_seq h (getx q) in
        let y2 = as_seq h (gety q) in
        let z2 = as_seq h (getz q) in
        let t2 = as_seq h (gett q) in
        red_513 x1 /\ red_513 y1 /\ red_513 z1 /\ red_513 t1 /\
        red_513 x2 /\ red_513 y2 /\ red_513 z2 /\ red_513 t2)
      ))
    (ensures (fun h0 _ h1 -> live h1 out /\ live h0 p /\ live h0 q /\ modifies_1 out h0 h1 /\
      (
        let x1 = as_seq h0 (getx p) in
        let y1 = as_seq h0 (gety p) in
        let z1 = as_seq h0 (getz p) in
        let t1 = as_seq h0 (gett p) in
        let x2 = as_seq h0 (getx q) in
        let y2 = as_seq h0 (gety q) in
        let z2 = as_seq h0 (getz q) in
        let t2 = as_seq h0 (gett q) in
        let x3 = as_seq h1 (getx out) in
        let y3 = as_seq h1 (gety out) in
        let z3 = as_seq h1 (getz out) in
        let t3 = as_seq h1 (gett out) in
        (seval x3, seval y3, seval z3, seval t3) ==
          Spec.Ed25519.point_add (seval x1, seval y1, seval z1, seval t1)
                                 (seval x2, seval y2, seval z2, seval t2)
        /\ red_513 x3 /\ red_513 y3 /\ red_513 z3 /\ red_513 t3)
  ))
