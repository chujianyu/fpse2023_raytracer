open Core
open OUnit2
open Fpse2023_raytracer_lib

(*ref:https://bheisler.github.io/post/writing-raytracer-in-rust-part-2/*)
(*ref:Ray Tracer Challenge : A Test-driven Guide to Your First 3d Renderer*)
[@@@warning "-32"]
let test_from_list _ = 
  let expected_1 = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:5. ~y:6. ~z:7. in 
  let result_1 = Fpse2023_raytracer_lib.Vector.Vector3f.from_list [5.;6.;7.] in 
  assert_equal result_1 @@ expected_1
  (*assert_raises Failure "malformed list; cannot convert to Vector3f" (fun() -> Vector.Vector3f.from_list [1.;2.])*)



let test_empty_vector _ = 
  let expected = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:0. ~y:0. ~z:0. in
  let result = Fpse2023_raytracer_lib.Vector.Vector3f.empty() in 
  assert_equal result @@ expected 

let test_to_tuple _ = 
  let expected = (1.,2.,3.) in 
  let result = Fpse2023_raytracer_lib.Vector.Vector3f.to_tuple (Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:1. ~y:2. ~z:3.) in 
  assert_equal result @@ expected

let test_divide_vector _ = 
  let open Fpse2023_raytracer_lib.Vector.Vector3f in 
  let expected = create ~x:1. ~y:1. ~z:1. in 
  let result = (/:) (create ~x:5. ~y:5. ~z:5.) 5. in 
  assert_equal result @@ expected

let test_cross _ =
  let open Vector.Vector3f in 
  let v1 = create ~x:1. ~y:2. ~z:3. in 
  let v2 = create ~x:4. ~y:5. ~z:6. in 
  let expected = create ~x:(-3.) ~y:6. ~z:(-3.) in 
  assert_equal expected @@ cross v1 v2

let test_to_tuple_col _ = 
  let expected = (1.0, 1.0, 1.0) in 
  let result = Color.to_tuple {Fpse2023_raytracer_lib.Color.r = 1.; g = 1.; b = 1.} in 
  assert_equal result @@ expected

let test_to_vector_col _ = 
  let expected = Vector.Vector3f.create ~x:1. ~y:1. ~z:1. in 
  let result = Color.to_vector {Fpse2023_raytracer_lib.Color.r = 1.; g = 1.; b = 1.} in 
  assert_equal result @@ expected

let test_from_vector_col _ = 
  let expected = {Fpse2023_raytracer_lib.Color.r = 2.; g = 2.; b = 2.} in 
  let result =Color.from_vector (Vector.Vector3f.create ~x:2. ~y:2. ~z:2.) in 
  assert_equal result @@ expected

let color_1 = Color.make ~r:6. ~g:6. ~b:6. 
let color_2 = Color.make ~r:1. ~g:2. ~b:3.

let test_add_col _ = 
  let expected = Color.make ~r:7. ~g:8. ~b:9. in 
  let result = Color.add color_1 color_2 in 
  assert_equal result @@ expected

let test_sub_col _ = 
  let expected = Color.make ~r:5. ~g:4. ~b:3. in 
  let result = Color.sub color_1 color_2 in 
  assert_equal result @@ expected

let test_mul_col _ = 
  let expected = Color.make ~r:6. ~g:12. ~b:18. in 
  let result = Color.mul color_1 color_2 in 
  assert_equal result @@ expected

let test_div_col _ = 
  let expected = Color.make ~r:6. ~g:3. ~b:2. in 
  let result = Color.div color_1 color_2 in 
  assert_equal result @@ expected

let test_scale_col _ = 
  let expected = Color.make ~r:12. ~g:12. ~b:12. in 
  let result = Color.scale color_1 2.0 in 
  assert_equal result @@ expected

let test_greater_col _ =
  let result = Color.greater color_1 color_2 in
  assert_bool "greater than" result;
  let result = not @@ Color.greater color_2 color_1 in
  assert_bool "less than"  result



let add_vector _ = 
  let one = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:0. ~y:1. ~z:0. in 
  let two = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:1. ~y:0. ~z:1. in 
  let expected = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:1. ~y:1. ~z:1. in
  let result = Vector.Vector3f.add one two in 
  assert_equal result @@  expected



let reflect_vector _ = 
  let one = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:1. ~y:0. ~z:0. in 
  let two = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:0. ~y:1. ~z:0. in 
  let expected = Fpse2023_raytracer_lib.Vector.Vector3f.create ~x:(-1.0) ~y:0. ~z:0. in
  let result = Vector.Vector3f.reflect one two in 
  assert_equal result @@  expected


let sphere_intersect_test _ = 
  let open Sphere in
  let open Vector in
  let open Shape in
  let current_sphere_material_params:Material.t = 
  {ambient=Color.make~r:0.~g:0.~b:0.;
  specular=Color.make~r:0.~g:0.~b:0.;
  diffuse=Color.make~r:0.~g:0.~b:0.;
  emissive=Color.make~r:0.~g:0.~b:0.;
  transparent=Color.make~r:0.~g:0.~b:0.;
  shininess=0.0;
  ir=1.05;
  } in
  let current_sphere_params:Sphere_params.t = {center=(Vector3f.create ~x:3.~y:0.~z:0.);radius=1.;material=current_sphere_material_params} in
  let ray_one = Ray.create ~orig:(Vector3f.create ~x:0.~y:0.~z:0.) ~dir:(Vector3f.create ~x:1.~y:0.~z:0.) in 
  let sphere_one = Sphere.make_sphere current_sphere_params in 
  let module Unpacked_sphere = (val sphere_one : Shape.S) in
  let expected_pos = Vector3f.create ~x:2. ~y:0. ~z:0. in
  let result = Unpacked_sphere.intersect ~ray:ray_one in 
  match result with 
  |None -> assert false
  |Some actual_intersect_data -> (
    let () = Core.Printf.printf "%s" (Core.Sexp.to_string(Vector.Vector3f.sexp_of_t actual_intersect_data.position)) in
    assert_equal 0 @@  (Vector3f.compare expected_pos actual_intersect_data.position )
  );;

  let quick_test_ray_triangle_intersection _ =
    let open Vector in
    let open Shape in
    let open Triangle in
    let v0 = Vertex.{pos=(Vector3f.create ~x:(-2.)~y:0.~z:2.); normal=(Vector3f.create ~x:0.~y:1.~z:0.)} in
    let v1 = Vertex.{pos=(Vector3f.create ~x:(2.)~y:0.~z:2.); normal=(Vector3f.create ~x:0.~y:1.~z:0.)} in
    let v2 = Vertex.{pos=(Vector3f.create ~x:(2.)~y:0.~z:(-2.)); normal=(Vector3f.create ~x:0.~y:1.~z:0.)} in
    let material: Material.t = {ambient=Color.make~r:0.~g:0.~b:0.;
    specular=Color.make~r:0.~g:0.~b:0.;
    diffuse=Color.make~r:0.~g:0.~b:0.;
    emissive=Color.make~r:0.~g:0.~b:0.;
    transparent=Color.make~r:0.~g:0.~b:0.;
    shininess=0.0;
    ir=1.05;
    } 
   in
    let triangle_params = Triangle_params.{v0; v1; v2; material} in
    let triangle = Triangle.make_triangle triangle_params in
    let module Unpacked_triangle = (val triangle : Shape.S) in
     (* custom generator to use appropriate range *)
  let vector3f_gen =
    let gen_float = Float.gen_incl (-10.0) 10.0 in
    Quickcheck.Generator.map3 gen_float gen_float gen_float ~f:(fun x y z -> Vector3f.create ~x ~y ~z)
  in
  let ray_gen = 
    Quickcheck.Generator.map2 vector3f_gen vector3f_gen ~f:(fun orig dir -> Ray.create ~orig ~dir)
  in
    let invariant ray =
      OUnit2.assert_bool "Ray must intersect the triangle within range" @@
      match Unpacked_triangle.intersect ~ray with
      | None -> true
      | Some intersect ->
          let pos = intersect.position in
          let (x,y,z) = Vector3f.to_tuple pos in
          let open Float in
          x >= -2.1 && x <= 2.1 && y >= -0.1 && y<= 0.1 && z >= -2.1 && z <= 2.1
    in
    Quickcheck.test ~sexp_of:[%sexp_of: Ray.t] ray_gen ~f:invariant;;

  let is_file_present filename =
    Sys_unix.file_exists filename
    |> function
    | `Yes -> true
    | _ -> false;;

  Sys_unix.chdir "../../..";;
  let multiple_sphere_with_sky_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path);
    let input_path = "example_input/multiple_sphere_with_sky.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_multiple_sphere_with_sky.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ())

  let multi_thread_multiple_sphere_with_sky_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path);
    let input_path = "example_input/multiple_sphere_with_sky.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_multiple_sphere_with_sky_multi_thread.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001";
    "--domains"; "2"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ())


  let reflection_and_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/reflection_and_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_reflection_and_refraction.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ())

  let multi_thread_reflection_and_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/reflection_and_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_reflection_and_refraction_multi_thread.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001";
    "--domains"; "2"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ())

  let transparent_no_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/transparent_no_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_transparent_no_refraction.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ()) 

  let multi_thread_transparent_no_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/transparent_no_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_transparent_no_refraction_multi_thread.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001";
    "--domains"; "2"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ()) 

  let no_reflection_no_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/no_reflection_no_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_no_reflection_no_refraction.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ()) 

  let multi_thread_no_reflection_no_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/no_reflection_no_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_no_reflection_no_refraction_multi_thread.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001";
    "--domains"; "2"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ()) 

  let reflection_no_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/reflection_no_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_reflection_no_refraction.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ()) 

  let multi_thread_reflection_no_refraction_test (ctxt : test_ctxt) =
    let binary_path = "./_build/default/bin/main.exe" in
    OUnit2.assert_bool ("Run dune build first; Binary not found: " ^ binary_path) (is_file_present binary_path) ;
    let input_path = "example_input/reflection_no_refraction.json" in
    OUnit2.assert_bool ("Input file not found: " ^ input_path) (is_file_present input_path);
    let () = Core.Printf.printf "dir: %s \n"(Sys_unix.getcwd ()) in
    (*assert true*)
    assert_command 
    ~ctxt:ctxt
    binary_path
    ["--in"; input_path; 
    "--out"; "output/test_reflection_no_refraction_multi_thread.ppm"; 
    "--height"; "500"; 
    "--width"; "500"; 
    "--rLimit"; "5"; 
    "--cutOff"; "0.0001";
    "--domains"; "2"]
    ~foutput:(fun seq -> try 
    Seq.iter (fun ch -> let() = Core.Printf.printf "%c" ch in ignore ch) seq
    with End_of_file ->
    ()) 
  
let vector_tests =
  "vector_tests"
  >: test_list
  [
    "add_vector">:: add_vector;
    "reflect_vector">:: reflect_vector;
    "test_empty_vector" >:: test_empty_vector;
    "test_from_list" >:: test_from_list;
    "test_to_tuple" >:: test_to_tuple;
    "test_divide_vector" >:: test_divide_vector;
    "test_cross" >:: test_cross;
  ]

let color_tests = 
  "color_tests"
  >: test_list
  [
    "test_to_tuple" >:: test_to_tuple_col;
    "test_to_vector" >:: test_to_vector_col;
    "test_from_vector" >:: test_from_vector_col;
    "test_add" >:: test_add_col;
    "test_sub" >:: test_sub_col;
    "test_mul" >:: test_mul_col;
    "test_div" >:: test_div_col;
    "test_scale" >:: test_scale_col;
    "test_greater" >:: test_greater_col;
  ]

let shape_tests =
  "shape_tests"
  >: test_list
  [
    "sphere_intersect_test">:: sphere_intersect_test;
  ]
let full_image_tests =
  "full_image_tests"
  >: test_list
  [
    "sphere_intersect_test">:: sphere_intersect_test;
    "quick_test_ray_triangle_intersection">:: quick_test_ray_triangle_intersection;
  ]

(* output images placed in output/ folder for inspection *)
let end_to_end_tests =
  "end_to_end_tests"
  >::: [
    "multiple_sphere_with_sky_test" >:: multiple_sphere_with_sky_test;
    "multi_thread_multiple_sphere_with_sky_test" >:: multi_thread_multiple_sphere_with_sky_test;
    "reflection_and_reflection_test" >:: reflection_and_refraction_test;
    "multi_thread_reflection_and_refraction_test" >:: multi_thread_reflection_and_refraction_test;
    "transparent_no_refraction_test" >:: transparent_no_refraction_test;
    "multi_thread_transparent_no_refraction_test" >:: multi_thread_transparent_no_refraction_test;
    "no_reflection_no_refraction_test" >:: no_reflection_no_refraction_test;
    "multi_thread_no_reflection_no_refraction_test" >:: multi_thread_no_reflection_no_refraction_test;
    "reflection_no_refraction_test" >:: reflection_no_refraction_test;
    "multi_thread_reflection_no_refraction_test" >:: multi_thread_reflection_no_refraction_test;
  ]

let series =
  "raytracer tests"
  >::: [
    vector_tests;
    shape_tests;
    color_tests;
    full_image_tests; 
    end_to_end_tests; 
  ]
      
  let () = run_test_tt_main series

  