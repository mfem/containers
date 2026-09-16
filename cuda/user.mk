VERBOSE = NO

CXX = clang++
MPICXX = OMPI_CXX=$(CXX) mpicxx

# clang's list of known CUDA releases lags the installed toolkit, so it warns
# on every translation unit about a version difference that is benign.
BASE_FLAGS  = -std=c++17 -Wno-unknown-cuda-version
OPTIM_FLAGS = -O3 $(BASE_FLAGS)

STATIC = NO
SHARED = YES

CUDA_CXX = $(MPICXX)
CUDA_ARCH = CUDA_ARCH_SM_PLACEHOLDER

MFEM_USE_MPI           = YES
MFEM_USE_METIS         = $(MFEM_USE_MPI)
MFEM_USE_METIS_5       = YES
MFEM_DEBUG             = NO
MFEM_USE_LIBUNWIND     = NO
MFEM_USE_MEMALLOC      = YES
MFEM_TIMER_TYPE        = $(if $(NOTMAC),2,4)
MFEM_USE_ENZYME        = YES
MFEM_USE_CUDA		   = YES

HYPRE_DIR = /usr/local
HYPRE_OPT = -I$(HYPRE_DIR)/include
HYPRE_LIB = -L$(HYPRE_DIR)/lib -lHYPRE

METIS_DIR =
METIS_OPT =
METIS_LIB = -L/usr/lib/x86_64-linux-gnu -lmetis -lparmetis

ENZYME_DIR = /usr/local
