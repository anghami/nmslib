# Main purpose of this dockerfile is to allow a quick replication of development
# enviroment of nmslib that handles installation of needed dependencies
# build with: docker build -f dev.dockerfile -t nmslib .
# run with (mount your nmslib directory to sync code changes): docker run -v {nmslib_dir}:/nmslib -it nmslib bash
# after running the container you can compile and test the code from within the container, and
# with volume mounting your code will be synced to your container

FROM ubuntu:18.04

# Install needed dependencies
RUN apt-get update && apt-get install -y wget libboost-dev libboost-test-dev libboost-program-options-dev \
 libevent-dev automake libtool flex bison pkg-config g++ libssl1.0-dev cmake python3.6 \
 python3-pip python-virtualenv

# Install thrift
WORKDIR /
RUN wget https://archive.apache.org/dist/thrift/0.11.0/thrift-0.11.0.tar.gz
RUN tar -xvzf thrift-0.11.0.tar.gz
WORKDIR /thrift-0.11.0/
RUN ./configure
RUN make
RUN make install

# compile nmslib
RUN apt-get install -y cmake vim
WORKDIR /
COPY . /nmslib
WORKDIR /nmslib
WORKDIR /nmslib/similarity_search/
RUN cmake .
RUN make
WORKDIR /nmslib/query_server/cpp_client_server/
RUN make
WORKDIR /nmslib/
