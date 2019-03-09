## If compiling on mac, comment out LIBS and CFLAGS below, and use the MacOS ones below
LIBS=-lpcre -lcrypto -lm -lpthread
CFLAGS=-ggdb -O3 -Wall -static

## If compiling on a mac make sure you install and use homebrew and run the following command `brew install pcre pcre++`
## Uncomment lines below and run `make all` 
# LIBS= -lpcre -lcrypto -lm -lpthread
# INCPATHS=-I$(shell brew --prefix)/include -I$(shell brew --prefix openssl)/include
# LIBPATHS=-L$(shell brew --prefix)/lib -L$(shell brew --prefix openssl)/lib
# CFLAGS=-ggdb -O3 -Wall -Qunused-arguments $(INCPATHS) $(LIBPATHS)
OBJS=verusvanitygen.o oclverusvanitygen.o oclengine.o veruskeyconv.o pattern.o util.o
PROGS=verusvanitygen veruskeyconv oclverusvanitygen

PLATFORM=$(shell uname -s)
ifeq ($(PLATFORM),Darwin)
	OPENCL_LIBS=-framework OpenCL
	LIBS+=-L/usr/local/opt/openssl/lib
	CFLAGS+=-I/usr/local/opt/openssl/include
else ifeq ($(PLATFORM),NetBSD)
	LIBS+=`pcre-config --libs`
	CFLAGS+=`pcre-config --cflags`
else
	OPENCL_LIBS=-lOpenCL
endif


most: verusvanitygen 

all: $(PROGS)

verusvanitygen: verusvanitygen.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

oclverusvanitygen: oclverusvanitygen.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS)

veruskeyconv: veruskeyconv.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

clean:
	rm -f $(OBJS) $(PROGS) $(TESTS)
