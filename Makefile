# Copyright (c) Lawrence Livermore National Security, LLC and other
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

########################################################################
# Compiler and external dependences
########################################################################
#CC        = mpixlc
CC        = mpicc
#CC        = mpiicc
#CC        = cc

#CXX       = mpixlC
CXX       = mpic++
#CXX       = mpiicc
#CXX       = CC

LINK_CC   = ${CXX}
LINK_CXX  = ${CXX}

AR	= ar -rcu
RANLIB  = ranlib

LDFLAGS =
#LIBS    = -lm ${HYPRE_CUDA_LIBS} ${HYPRE_HIP_LIBS}

INCLUDES = ${HYPRE_CUDA_INCLUDE} ${HYPRE_HIP_INCLUDE} ${MPIINCLUDE} ${HYPRE_UMPIRE_INCLUDE}

##################################################################
## Set path to hypre installation
##################################################################
HYPRE_DIR = /usr/WS1/li50/hypre/releases/src/hypre

##################################################################
##  MPI options - this is needed for Crusher, Tioga, RZVernal,
##    when using AMD GPUs, might not be needed for other computers
##################################################################
#MPIPATH = /opt/cray/pe/mpich/8.1.21/ofi/crayclang/10.0
#MPIINCLUDE =  -I${MPIPATH}/include
#MPILIBDIRS = -L${MPIPATH}/lib
#MPILIBS    =  ${MPILIBDIRS} -lmpi  # -lmpi needed for AMD GPUs
#MPIFLAGS   =

########################################################################
# CUDA options - set correct paths depending on cuda package
########################################################################
HYPRE_CUDA_PATH    = /usr/tce/packages/cuda/cuda-10.1.243
HYPRE_CUDA_INCLUDE = -I${HYPRE_CUDA_PATH}/include
HYPRE_CUDA_LIBS    = -L${HYPRE_CUDA_PATH}/lib64 -lcudart -lcusparse -lcublas -lcurand

########################################################################
# HIP options set correct path depending on rocm version
########################################################################
HYPRE_HIP_PATH    = #/opt/rocm-5.4.1
HYPRE_HIP_INCLUDE = #-I${HYPRE_HIP_PATH}/include
HYPRE_HIP_LIBS    = #-L${HYPRE_HIP_PATH}/lib -lamdhip64 -lrocsparse -lrocrand

##################################################################
##  UMPIRE options
##################################################################
HYPRE_UMPIRE_LIB_DIR      = -L/usr/workspace/hypre/ext-libs/Umpire/2022.03.1-nvcc10.1.243-sm_70-xl2021.09.22/lib
HYPRE_UMPIRE_INCLUDE      = -I/usr/workspace/hypre/ext-libs/Umpire/2022.03.1-nvcc10.1.243-sm_70-xl2021.09.22/include
HYPRE_UMPIRE_LIB          = -lumpire

########################################################################
# Compiling and linking options
########################################################################

CINCLUDES = -I. -I$(HYPRE_DIR)/include $(INCLUDES)
CDEFS = -DHYPRE_TIMING

########################################################################
# MPI only
########################################################################
COPTS = -O2 -DHAVE_CONFIG_H
LINKOPTS =

########################################################################
# MPI  and OpenMP threading
########################################################################
#COPTS = -O2 -DHAVE_CONFIG_H -fopenmp
#LINKOPTS = -fopenmp
#COPTS = -O2 -DHAVE_CONFIG_H -qsmp=omp
#LINKOPTS = -qsmp=omp
#COPTS = -O2 -DHAVE_CONFIG_H -qopenmp
#LINKOPTS = -qopenmp

CFLAGS = $(COPTS) $(CINCLUDES) $(CDEFS)
CXXOPTS = $(COPTS) -Wno-deprecated
CXXINCLUDES = $(CINCLUDES) -I..
CXXDEFS = $(CDEFS)
CXXFLAGS  = $(COPTS) $(CINCLUDES) $(CDEFS)

LIBS = -L$(HYPRE_DIR)/lib -lHYPRE $(XLINK) ${MPILIBS} -lm $(HYPRE_CUDA_LIBS) $(HYPRE_HIP_LIBS) ${HYPRE_UMPIRE_LIB_DIR} ${HYPRE_UMPIRE_LIB}
#LIBS = -L$(HYPRE_DIR)/lib -lHYPRE $(XLINK) ${MPILIBS} $(HYPRE_HIP_LIBS)
#LFLAGS = $(LINKOPTS) $(LIBS) -lstdc++

XLINK = -Wl,-rpath,${HYPRE_DIR}/lib

LFLAGS = $(LINKOPTS) $(LIBS) $(XLINK)

########################################################################
# Rules for compiling the source files
########################################################################
.SUFFIXES: .c .f .cuf .cxx

.c.o:
	$(CC) $(CFLAGS) -c $<
.cuf.o:
	$(CUF) $(FFLAGS) $(CUFFLAGS) -c $<
.cxx.o:
	$(CXX) $(CXXFLAGS) -c $<

########################################################################
# List of all programs to be compiled
########################################################################
ALLPROGS = amg

all: $(ALLPROGS)

default: all

gpu: all

########################################################################
# AMG driver
########################################################################
amg: amg.o
	$(LINK_CC) -o $@ $^ $(LFLAGS)

########################################################################
clean:
	rm -f $(ALLPROGS:=.o)
distclean: clean
	rm -f $(ALLPROGS) $(ALLPROGS:=*~)
