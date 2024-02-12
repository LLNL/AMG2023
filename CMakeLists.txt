cmake_minimum_required(VERSION 3.21)

project (amg2023 C)

# Version information
set(AMG2023_MAJOR_VERSION 1)
set(AMG2023_MINOR_VERSION 0)
set(AMG2023_PATCH_VERSION 0)
set(AMG2023_VERSION "${AMG2023_MAJOR_VERSION}.${AMG2023_MINOR_VERSION}.${AMG2023_PATCH_VERSION}")

## Fail if someone tries to config an in-source build.
if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "In-source builds are not supported. Please remove "
                       "CMakeCache.txt from the 'src' dir and configure an "
                       "out-of-source build in another directory.")
endif()

add_definitions(-DAMG_CMAKE_BUILD=1)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

option(AMG_WITH_MPI "Use MPI" TRUE) 
option(AMG_WITH_CUDA "Use CUDA" FALSE)
option(AMG_WITH_HIP "Use HIP" FALSE)
option(AMG_WITH_CALIPER "Enable Caliper" FALSE)
option(AMG_WITH_OMP "Enable OpenMP" FALSE)
option(AMG_WITH_UMPIRE "Enable Umpire support (requires Umpire support in HYPRE)" FALSE)

find_library(HYPRE_LIBRARIES
    NAMES HYPRE
    HINTS ${HYPRE_PREFIX}/lib)
find_path(HYPRE_INCLUDE_DIR
    NAMES HYPRE.h
    HINTS ${HYPRE_PREFIX}/include)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(HYPRE DEFAULT_MSG
    HYPRE_LIBRARIES
    HYPRE_INCLUDE_DIR)

if (NOT HYPRE_FOUND)
    message(FATAL_ERROR "Hypre not found")
endif()

add_definitions(-DHYPRE_TIMING)
include_directories(${HYPRE_INCLUDE_DIR})

list(APPEND AMG_DEPENDENCIES
  ${HYPRE_LIBRARIES})

if (AMG_WITH_CUDA)
  find_package(CUDAToolkit REQUIRED)
  list(APPEND AMG_DEPENDENCIES
    CUDA::cudart
    CUDA::cublas
    CUDA::cusparse
    CUDA::curand)
endif()

if (AMG_WITH_HIP)
  enable_language(CXX)
  find_package(hip REQUIRED)
  find_package(rocsparse REQUIRED)
  find_package(rocrand REQUIRED)
  list(APPEND AMG_DEPENDENCIES
    hip::device
    hip::host
    roc::rocsparse
    roc::rocrand)
endif()

if (AMG_WITH_CALIPER)
  find_package(caliper REQUIRED)
  list(APPEND AMG_DEPENDENCIES 
    caliper)
  set(USE_CALIPER TRUE)
  find_package(adiak REQUIRED)
  list(APPEND AMG_DEPENDENCIES
    adiak::adiak)
endif()

if (AMG_WITH_OMP)
  find_package(OpenMP REQUIRED)
  list(APPEND AMG_DEPENDENCIES
    OpenMP::OpenMP_C)
endif()

if (AMG_WITH_MPI)
  find_package(MPI REQUIRED)
  list(APPEND AMG_DEPENDENCIES
    MPI::MPI_C)
endif()

if (AMG_WITH_UMPIRE)
  find_package(umpire REQUIRED)
  list(APPEND AMG_DEPENDENCIES
    umpire)
endif()

configure_file(
  "${CMAKE_SOURCE_DIR}/amg-config.h.in"
  "${CMAKE_BINARY_DIR}/amg-config.h"
)

add_executable(amg amg.c)
target_link_libraries(amg PUBLIC ${AMG_DEPENDENCIES} m)
target_include_directories(amg PUBLIC ${CMAKE_BINARY_DIR})

install(TARGETS amg DESTINATION ${CMAKE_INSTALL_BINDIR})
