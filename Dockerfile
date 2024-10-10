FROM alpine:latest
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add eww py3-pip fontconfig ttf-dejavu mesa-dri-gallium lxterminal neovim jq
ADD ./requirements.txt /tmp/requirements.txt
RUN pip3 install --break-system-packages -r /tmp/requirements.txt 
#
# # Run a basic command to confirm installation
# CMD ["eww", "--version"]
# # FROM alpine:latest
# # RUN apk update && apk add curl cargo gtk+3.0 gtk-layer-shell pango gdk-pixbuf cairo glib dbus-glib gcc git
# # RUN apk add --no-cache \
# #         gtk+3.0-dev \
# #         pkgconfig \
# #         build-base \
# #         cairo-dev \
# #         pango-dev \
# #         gdk-pixbuf-dev \
# #         glib-dev
# # RUN apk add libdbusmenu-gtk3 libdbusmenu-gtk3-dev
# # RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | sh -s -- -y
# # RUN git clone https://github.com/elkowar/eww /tmp/eww
# # WORKDIR /tmp/eww
# # RUN cargo build --release --no-default-features --features x11
# #


# Use the latest Alpine image as base
# FROM alpine:latest
#
# # Add the edge/testing repository and install eww package
# RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
#     apk update && \
#     apk add eww
#
# # Run a basic command to confirm installation
# CMD ["eww", "--version"]
# # FROM alpine:latest
# # RUN apk update && apk add curl cargo gtk+3.0 gtk-layer-shell pango gdk-pixbuf cairo glib dbus-glib gcc git
# # RUN apk add --no-cache \
# #         gtk+3.0-dev \
# #         pkgconfig \
# #         build-base \
# #         cairo-dev \
# #         pango-dev \
# #         gdk-pixbuf-dev \
# #         glib-dev
# # RUN apk add libdbusmenu-gtk3 libdbusmenu-gtk3-dev
# # RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | sh -s -- -y
# # RUN git clone https://github.com/elkowar/eww /tmp/eww
# # WORKDIR /tmp/eww
# # RUN cargo build --release --no-default-features --features x11
# #
