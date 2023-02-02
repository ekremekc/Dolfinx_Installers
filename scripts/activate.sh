export VENV_DIR=/home/ee331/Dev/Venvs/v042c

source $VENV_DIR/bin/activate 

export OMPI=/$VENV_DIR/installation/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH

export KAHIP=$VENV_DIR/installation/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib

export HDF5=$VENV_DIR/installation/hdf5
export PATH=$HDF5/bin:$PATH
export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH

export ADIOS2=$VENV_DIR/installation/adios2
export PATH=$ADIOS2/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ADIOS2/lib

source $VENV_DIR/scripts/complex-mode.sh
