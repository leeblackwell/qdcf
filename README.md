# qdcf

Quick and dirty container framework.

## Background

Building containers can be quite repetitive; build, test, tweak, rinse & repeat.  QDCF is a distilled version of what I've used elsewhere in order to make the process of container dev/build a little easier.

## How To

Carve out a directory per container, in this instance we'll use ubuntu-focal:

```
ubuntu-focal/
ubuntu-focal/Dockerfile
ubuntu-focal/static
ubuntu-focal/static/init.sh
ubuntu-focal/cf-configure_envcheck.00
ubuntu-focal/cf-configure_common.01
```

Place files/scripts/whatever thats intended to be inside your container in the `static` directory, and tweak the Dockerfile `COPY` line accordingly (filenames or wildcard, your call):

> COPY cf-configure* static/init.sh init-functions.sh /root/

Create `cf-configure*` files (typically bash scripts) as necessary to perform whatever tasks are required for preparing your container.  They'll be executed (inside the container context) at build time in numerical order; example:

| File | Purpose |
| -- | -- |
| cf-configure_envcheck.00 | Validate that mandatory env vars are set |
| cf-configure_common.01 | Common tasks |
| cf-configure_aptinsall.02 | Install things with apt |
| cf-configure_configurethis.03 | Configure a widget |

(NB: set executable permissions on the files before you run the build)

Then perform the build:

```
[theluckylee@vs85483 qdcf]$ ./build.sh --img ubuntu-focal --build
Sending build context to Docker daemon  10.24kB
Step 1/5 : FROM ubuntu:focal
focal: Pulling from library/ubuntu
c549ccf8d472: Pull complete 
Digest: sha256:aba80b77e27148d99c034a987e7da3a287ed455390352663418c0f2ed40417fe
Status: Downloaded newer image for ubuntu:focal
 ---> 9873176a8ff5
Step 2/5 : MAINTAINER someone@somewhere.com
 ---> Running in f4b745f15961
Removing intermediate container f4b745f15961
 ---> 300989c8f965
Step 3/5 : COPY cf-configure* static/init.sh init-functions.sh /root/
 ---> 9d3bf8e23b26
Step 4/5 : RUN /root/cf-configure.sh
 ---> Running in 09a220944455
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
/root/cf-configure.sh 2021-06-27 09:11:58 Enter: /root/cf-configure_envcheck.00
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
/root/cf-configure.sh 2021-06-27 09:11:58 Exit : /root/cf-configure_envcheck.00 with result 0
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
/root/cf-configure.sh 2021-06-27 09:11:58 Enter: /root/cf-configure_common.01
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
/root/cf-configure.sh 2021-06-27 09:11:58 Exit : /root/cf-configure_common.01 with result 0
/root/cf-configure.sh 2021-06-27 09:11:58 ********************************************************************************
Removing intermediate container 09a220944455
 ---> 2f3b9190abe9
Step 5/5 : CMD ["/root/init.sh"]
 ---> Running in 42f453a37bae
Removing intermediate container 42f453a37bae
 ---> 04896d0507e4
Successfully built 04896d0507e4
Successfully tagged ubuntu-focal:theluckylee
docker build returned 0
[theluckylee@vs85483 qdcf]$ 
```

## TODO

  * Notes on --push, --reghost, --regport and private registries
  * Notes on build-all.sh (or, make it smarter/auto)