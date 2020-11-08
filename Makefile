PS_PATH = ../FDPS-5.0c/src/ 
INC = -I$(PS_PATH)

####################
###   Compiler   ###
####################
#CC = g++ -std=c++11  #変更箇所
CC = clang++ -std=c++11

#CC = mpic++ -std=c++11    #変更後：コメントアウトした
#CC = time CC

CFLAGS = -O2
CFLAGS += -Wall
CFLAGS += -ffast-math
CFLAGS += -funroll-loops

########################
###   MPI & OpenMP   ###
########################
#CFLAGS += -DPARTICLE_SIMULATOR_THREAD_PARALLEL -fopenmp   # #変更後：コメントアウトした
#CFLAGS += -DPARTICLE_SIMULATOR_MPI_PARALLEL        #変更後：コメントアウトした

################
###   SIMD   ###
################
CFLAGS_M += -march=core-avx2
CFLAGS_G += -march=core-avx2
#CFLAGS_G += -mtune=skylake-avx512
#CFLAGS_G += -march=skylake-avx512
#CFLAGS_G += -mavx2
#CFLAGS_G += -mavx512f -mavx512dq

#########################
###   Other Options   ###
#########################
CFLAGS += -DUSE_INDIVIDUAL_CUTOFF
CFLAGS += -DUSE_QUAD
CFLAGS += -DCALC_EP_64bit
CFLAGS += -DCALC_SP_64bit
CFLAGS += -DUSE_ALLGATHER_EXLET
#CFLAGS += -DUSE_RE_SEARCH_NEIGHBOR
#CFLAGS += -DISOTROPIC
#CFLAGS += -DGAS_DRAG

CFLAGS += -DCOLLISION
#CFLAGS += -DKOMINAMI
#CFLAGS += -DCHAMBERS
CFLAGS += -DOUTPUT_DETAIL
#CFLAGS += -DCALC_WTIME
#CFLAGS += -DTEST_PTCL
CFLAGS += -DMONAR
CFLAGS += -g


SRC = main_p3t.cpp
PROGRAM = gplum.out
HEADER = mathfunc.h kepler.h energy.h particle.h disk.h gravity.h gravity_kernel.hpp collisionA.h collisionB.h hermite.h hard.h read.h time.h func.h

$(PROGRAM): main_p3t.o gravity_kernel.o
	$(CC) -MMD $(INC) $(CFLAGS) $(CFLAGS_M) -o $@ main_p3t.o gravity_kernel.o

main_p3t.o: main_p3t.cpp $(HEADER)
	$(CC) -MMD $(INC) $(CFLAGS) $(CFLAGS_M) -c $<

gravity_kernel.o: gravity_kernel.cpp phantomquad_for_p3t_x86.hpp particle.h 
	$(CC) -MMD $(INC) $(CFLAGS) $(CFLAGS_G) -c $<


all: clean $(PROGRAM)

clean:
	rm -f *.out *.o *.d *~

