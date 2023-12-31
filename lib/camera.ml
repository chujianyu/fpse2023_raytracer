open Vector
open Core

type t = {height_angle : float; pos : Vector3f.t; up : Vector3f.t; forward : Vector3f.t} [@@deriving sexp, fields ~getters]

let create ~height_angle ~pos ~up ~forward = {height_angle; pos; up; forward}

let get_right camera = Vector3f.cross camera.forward camera.up

let get_random_offset (random:bool) =
  let my_state = Random.State.make_self_init () in
  match random with 
  |true -> (Random.State.float my_state 1.0,Random.State.float my_state 1.0)
  |false ->  (0.0,0.0)

let get_ray {height_angle; pos; up; forward} ~(i:int) ~(j:int) ~(width:int) ~(height:int) ~(random:bool) = 
  let i, j, width, height = 
    float_of_int i, float_of_int j, float_of_int width, float_of_int height 
  in
  let right = Vector3f.cross forward up in
  let ar = height /. width in
  let width_angle = Float.atan @@ (Float.tan height_angle) /. ar in
  let open Vector3f in
  let right_component = right *: 2. *: Float.tan (width_angle /. 2.) in
  let up_component = up *: 2. *: Float.tan (height_angle /. 2.) in
  let bottom_left_pos = forward -: (right_component/:2.) -: (up_component/:2.) in
  let random_offset = get_random_offset(random) in 
  let pixel_pos = 
    bottom_left_pos +: right_component *: ((Core.Float.clamp_exn (fst(random_offset) +. 0.0) ~min:0.01 ~max:0.999)  
    +.  j) /: width +: up_component *: ((Core.Float.clamp_exn (snd(random_offset) +. 0.0) ~min:0.01 ~max:0.999) +.  i) /: height 
  in
  Ray.create ~orig:pos ~dir:pixel_pos

