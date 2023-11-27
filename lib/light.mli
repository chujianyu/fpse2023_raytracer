[@@@warning "-69-27-33"]

open Ray
open Vector
open Color
open Shape

(* Parameters for a Point Light source *)
module Point_light_param : sig
  type t = {pos:Vector3f.t; diffuse:Color.t; const_atten:float; linear_atten:float; quad_atten:float}
   [@@deriving sexp]
end

(* Shared module type for all types of light sources. Designed to support use of first-class modules *)
module type L = sig
  type t [@@deriving sexp]
  val item : t
  val get_diffuse : Ray.t -> Vector3f.t -> Vector3f.t -> Material.t -> Color.t
end