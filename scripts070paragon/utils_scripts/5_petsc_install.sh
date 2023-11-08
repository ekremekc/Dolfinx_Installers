#Set environmental variables
export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils
export PATH=$UTILS_DIR/cmake/bin:$PATH
export PETSC_SLEPC_OPTFLAGS="-O2"
export PETSC_SLEPC_MAKE_NP=14
export PETSC_SLEPC_DEBUGGING="no"
export PETSC_VERSION=3.20.0

export PETSC_DIR=$UTILS_DIR/petsc

# Add path of mpirun to be targeted by petsc installation 
export OMPI=$UTILS_DIR/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH

# Install PETSC
mkdir -p ${PETSC_DIR} && cd ${PETSC_DIR}
git clone -b v${PETSC_VERSION}  https://gitlab.com/petsc/petsc.git ${PETSC_DIR}
export PETSC_ARCH=linux-gnu-complex-32

# Complex, 32-bit int
python3 ./configure \
PETSC_ARCH=linux-gnu-complex-32 \
--COPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--CXXOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--FOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--with-make-np="${PETSC_SLEPC_MAKE_NP}" \
--with-64-bit-indices=no \
--with-debugging=${PETSC_SLEPC_DEBUGGING} \
--with-fortran-bindings=no \
--with-shared-libraries \
--download-metis \
--download-mumps \
--download-ptscotch \
--download-scalapack \
--download-suitesparse \
--with-scalar-type=complex 

make PETSC_DIR=$PETSC_DIR PETSC_ARCH=linux-gnu-complex-32 ${MAKEFLAGS} all

cd src/binding/petsc4py 
PETSC_ARCH=linux-gnu-complex-32 pip3 install --no-cache-dir . 


