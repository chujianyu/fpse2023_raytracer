open Vector

(* Module that represents a camera in the scene *)

type t = {height_angle : float; pos : Vector3f.t; up : Vector3f.t; forward : Vector3f.t}  [@@deriving sexp, fields ~getters]

val create : height_angle:float -> pos:Vector3f.t -> up:Vector3f.t -> forward:Vector3f.t -> t
(* Given indices i and j, and the width and height of the image, return the ray that passes through that pixel 
  where (i,j) means the pixel at the i-th row, j-th column *)
val get_ray : t -> i:int -> j:int -> width:int -> height:int -> random:bool-> Ray.t
val get_right : t -> Vector3f.t
