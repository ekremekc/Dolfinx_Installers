# This script is prepared to install gcc 12.2 from source.
# Dolfinx uses cpp 20 so this compiler is necessary to build latest versions of dolfinx.

mkdir $HOME/gcc
cd $HOME/gcc
wget -nc --quiet https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-12.2.0/gcc-12.2.0.tar.gz
tar -xf gcc-12.2.0.tar.gz

export srcdir=$HOME/gcc/gcc-12.2.0

export objdir=$HOME/gcc-12
mkdir $objdir
cd $objdir
$srcdir/configure --prefix=$objdir --disable-nls --enable-languages=c,c++,fortran --without-headers --disable-multilib
make -j 16
make install # This code will executed tomorrow

echo "Installation of gcc is complete"
echo "Now, we will link the libraries.."

# Add the 4 lines below to the .bashrc file.
export PATH=/home/ee331/gcc-12/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-12/lib64:$LD_LIBRARY_PATH
export CC=/home/ee331/gcc-12/bin/gcc
export CXX=/home/ee331/gcc-12/bin/g++

echo "The gcc installed in system now has a version of;"
gcc -v

