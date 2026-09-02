VERBOSE = NO

CXX = clang++
MPICXX = OMPI_CXX=$(CXX) mpicxx

BASE_FLAGS  = -std=c++17
OPTIM_FLAGS = -O3 $(BASE_FLAGS)

STATIC = NO
SHARED = YES

MFEM_USE_MPI           = YES
MFEM_USE_METIS         = $(MFEM_USE_MPI)
MFEM_USE_METIS_5       = YES
MFEM_DEBUG             = NO
MFEM_USE_LIBUNWIND     = NO
MFEM_USE_MEMALLOC      = YES
MFEM_TIMER_TYPE        = $(if $(NOTMAC),2,4)
MFEM_USE_ENZYME        = YES
MFEM_USE_CUDA		   = NO
MFEM_USE_SUPERLU       = YES
MFEM_USE_PETSC         = YES

HYPRE_DIR = /usr/local
HYPRE_OPT = -I$(HYPRE_DIR)/include
HYPRE_LIB = -L$(HYPRE_DIR)/lib -lHYPRE

METIS_DIR =
METIS_OPT =
METIS_LIB = -L/usr/lib/x86_64-linux-gnu -lmetis -lparmetis

ENZYME_DIR = /usr/local

SUPERLU_DIR = /usr/local
SUPERLU_OPT =
SUPERLU_LIB = $(XLINKER)-rpath,$(SUPERLU_DIR)/lib -L$(SUPERLU_DIR)/lib\
    -lsuperlu_dist -lblas

# PETSc library configuration (version greater or equal to 3.8 or the dev branch)
PETSC_ARCH :=
PETSC_DIR  := /usr/local
PETSC_VARS := $(PETSC_DIR)/lib/petsc/conf/petscvariables
PETSC_FOUND := $(if $(wildcard $(PETSC_VARS)),YES,)
PETSC_INC_VAR = PETSC_CC_INCLUDES
PETSC_LIB_VAR = PETSC_EXTERNAL_LIB_BASIC
ifeq ($(PETSC_FOUND),YES)
   PETSC_OPT := $(shell sed -n "s/$(PETSC_INC_VAR) = *//p" $(PETSC_VARS))
   PETSC_DEP := $(shell sed -n "s/$(PETSC_LIB_VAR) = *//p" $(PETSC_VARS))
   PETSC_LIB = $(XLINKER)-rpath,$(abspath $(PETSC_DIR))/lib\
      -L$(abspath $(PETSC_DIR))/lib -lpetsc\
      $(subst $(CXX_XLINKER),$(XLINKER),$(PETSC_DEP))
endif
