# Compiler image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.16.2 AS compiler

WORKDIR /root

RUN apk --no-cache add \
    gcc \
    g++ \
    build-base \
    cmake \
    gmp-dev \
    git

COPY . .
RUN /bin/sh ./make_devel.sh

# Runtime image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.16.2 AS runtime

WORKDIR /root

RUN apk --no-cache add \
    gmp-dev \
    libsodium-dev

COPY --from=compiler /root/build /usr/lib/chik-plotter
RUN ln -s /usr/lib/chik-plotter/chik_plot /usr/bin/chik_plot

ENTRYPOINT ["/usr/bin/chik_plot"]
