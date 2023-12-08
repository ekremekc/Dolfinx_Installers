export VENV_DIR=/home/ee331/Dev/Venvs/v072complex
export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils

source $VENV_DIR/bin/activate 

# sourcing correct gcc for multiphenicsx
export CC=/home/ee331/bin/gcc
export CXX=/home/ee331/bin/g++
export LD_LIBRARY_PATH=$HOME/gcc-12/lib64:$LD_LIBRARY_PATH

export OMPI=$UTILS_DIR/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH
#export OMP_NUM_THREADS=1

export KAHIP=$UTILS_DIR/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib

export ADIOS2=$UTILS_DIR/adios2
export PATH=$ADIOS2/bin:$PATH
export LD_LIBRARY_PATH=$ADIOS2/lib:$LD_LIBRARY_PATH


# Activating complex mode
export PKG_CONFIG_PATH=$VENV_DIR/installation/dolfinx-complex/lib/pkgconfig:$PKG_CONFIG_PATH
export PETSC_ARCH=linux-gnu-complex-32 
export PYTHONPATH=$VENV_DIR/lib/python3.8/dist-packages:/usr/bin/python3:$PYTHONPATH
export LD_LIBRARY_PATH=$VENV_DIR/installation/lib:$LD_LIBRARY_PATH

# For ADIOS2
export PYTHONPATH=/home/ee331/Dev/Venvs/dolfinx_utils/adios2/home/ee331/Dev/Venvs/v072complex/lib/python3.8/site-packages/adios2:PYTHONPATH
