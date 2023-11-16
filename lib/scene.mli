open Ray
open Vector
open Camera
open Light
open Shape
open Color
module Scene : sig
  type intersect_record_t = {intersection_time: float; position: Vector3f.t; normal: Vector3f.t; }
  type global_data_t = {camera:Camera.t; lights:(module L) list; shapes:(module S) list}
  type t
  val get_color : Ray.t -> int -> int -> Vector3f.t
  val ray_trace : t -> Color.t list list
end