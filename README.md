# AMG2023

# General description:

AMG2023 is a parallel algebraic multigrid solver for linear systems arising from
problems on unstructured grids.  The driver provided here builds linear 
systems for various 3-dimensional problems. It requires an installation of 
hypre-2.27.0 or higher.

AMG2023 is written in C.  It is a SPMD code which uses MPI and OpenMP threading within MPI tasks. 
Parallelism is achieved by data decomposition, which is here achieved by simply subdividing 
the grid into logical P x Q x R (in 3D) chunks of equal size.
It can also be used on NVIDIA, AMD, and Intel GPUs via CUDA, HIP, and SYCL.

For more information, see the 'amg-doc' file in the distribution.


# Building the Code

AMG2023 uses a simple Makefile system for building the code.  All compiler and
link options are set by modifying it appropriately.  

To build the code, first install hypre, which can be cloned from
https://github.com/hypre-space/hypre .

Then modify the 'Makefile' file appropriately.

Then type 

  make

Other available targets are

  make clean        (deletes .o files)

  make veryclean    (deletes .o files, libraries, and executables)

Further information is available in the 'amg-doc' file.
