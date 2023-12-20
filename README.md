# fpse2023
Function Programming in Software Engineering Course Project Fall 2023

OCaml Functional Ray Tracer

Please find our project proposal at ./fpse_project_proposal.pdf

## Project Repo Structure
example_input/ contains the input json files that describes a 3D scene.
output/ contains the output from our tests and demonstration.
lib/ contains our library for ray tracing.
bin/ contains our main ray tracer program.

## Usage

To build the program:
```
dune cl
dune build
```

Our tests will output generated images to output/
Images generated by tests are named "test_*.ppm"
To test the binary (test output images will be placed at output/ folder):
```
dune test
```

### Notes about running tests
Please note that that "dune test" requires a built binary by first running dune clean and dune build.


### Notes about Parallelism
The program will print the time ray tracing takes.

Please note that to accurately compare the time to ray trace with and without parallelism,
bisect_ppx may need to be removed from lib/dune, as it was found to interfere with the multi-threading process
while occupying unusually high CPU resources.
To remove bisect_ppx in lib/dune, please replace the line
``` 
(preprocess
(pps ppx_jane bisect_ppx))
``` 
with 
``` 
(preprocess
 (pps ppx_jane))
```

## Example Usage:
Display Help:
```
./_build/default/bin/main.exe  --help
```

Run without multi-threading:
```
./_build/default/bin/main.exe  --out output/demo_output.ppm --height 1000 --width 1000 --in example_input/reflection_and_refraction.json --domains 1
```

Run with multi-threading (2 threads):
```
./_build/default/bin/main.exe  --out output/demo_output.ppm --height 1000 --width 1000 --in example_input/reflection_and_refraction.json --domains 2
```