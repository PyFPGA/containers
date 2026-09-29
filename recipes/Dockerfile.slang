# https://github.com/MikePopoloski/slang

FROM ubuntu:latest AS builder

WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    git
RUN apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    python3

RUN git clone --depth 1 https://github.com/MikePopoloski/slang.git
RUN cd slang && cmake -B build && cmake --build build -j$(nproc) \
 && cmake --install build --strip

#------------------------------------------------------------------------------

FROM ubuntu:latest AS runtime

COPY --from=builder /usr/local /usr/local
