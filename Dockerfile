FROM heifeng/anisette-v3-server-builder:latest AS builder

FROM debian:stable-slim
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy build artefacts to run
#WORKDIR /opt/
#COPY --from=builder /opt/anisette-v3-server /opt/anisette-v3-server

# Setup rootless user which works with the volume mount
RUN useradd -ms /bin/bash Alcoholic \
 && mkdir /home/Alcoholic/.config/anisette-v3/lib/ -p \
 && mkdir /opt/anisette-v3/provisioning -p \
 && chown -R Alcoholic /home/Alcoholic/ \
 && chmod -R +wx /home/Alcoholic/ \
 && chown -R Alcoholic /opt/ \
 && chmod -R +wx /opt/

COPY ./lib/ /home/Alcoholic/.config/anisette-v3/lib/

WORKDIR /opt/
COPY --from=builder /opt/anisette-v3-server /opt/anisette-v3-server

# Run the artefact
USER Alcoholic
EXPOSE 6969
ENTRYPOINT [ "/opt/anisette-v3-server" ]
