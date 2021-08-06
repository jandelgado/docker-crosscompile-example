# Cross compile for the Raspberry using docker/qemu

[![run tests](https://github.com/jandelgado/docker-crosscompile-example/actions/workflows/build.yml/badge.svg)](https://github.com/jandelgado/docker-crosscompile-example/actions/workflows/build.yml)

By using docker and qemu it is easy to use all libraries as-is, without the
need to recompile all dependencies. Just use the package manager of the base
image (here: arm64v8/debian:buster-slim).

Before using the example Makefile, you must run once on your system:

```console
$ docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Following an example session, compiling on x86_64. Depending on your setup, you
may need to `sudo` the docker invocations.

```console
$ uname -a      # we are on x86_64 
Linux 5.13.4.x86_64 #1 SMP Tue Jul 20 20:27:29 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
$ make image.arm64v8        # create the docker image once
$ ls workdir/
hello.c  Makefile
$ make make-arm64v8         # build inside the docker image, mount workdir
docker run --rm -ti \
	       --user 1000:1000 \
		   -w /workdir \
		   -v /home/jandelgado/src/raspi-docker-crosscompile/workdir:/workdir:z \
		   --entrypoint "/usr/bin/make"\
		   jandelgado/raspi-docker-crosscompile-linux-arm64v8 \
		   
cc   -c hello.c
cc  -o hello hello.o
# voila, we got an aarch64 executable
$ file workdir/hello
workdir/hello: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV),
dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux
3.7.0, BuildID[sha1]=0805cc7c1b3179f1f878a08693a28272b0ee4fdf, not stripped
```

The resulting aarch64 binary can be run in the conainter:
```console
$ make shell-arm64v8
docker run --rm -ti \
	       --user 1000:1000 \
		   -w /workdir \
		   -v /home/jandelgado/src/raspi-docker-crosscompile/workdir:/workdir:z \
		   --entrypoint "/bin/bash"\
		   jandelgado/raspi-docker-crosscompile-linux-arm64v8 \
		   
builder@6631607d4375:/workdir$ ./hello 
hello, arm64v8 world!
```

## Author

(C) Copyright Jan Delgado, Licencse: MIT

