FROM ubuntu:26.04 AS source

ADD --checksum=sha256:34d4c8ab4da48ac22320d4b64c287445bd94c913129492d1dbebb36665b1495a https://github.com/janhq/jan/releases/download/v0.8.4/Jan_0.8.4_amd64.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/jan"

COPY --from=source /stage/ /opt/jan/
COPY jan /usr/bin/jan
COPY jan.desktop /usr/share/applications/jan.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/jan.png

RUN chmod 0755 /usr/bin/jan && cpak-clean-junk
