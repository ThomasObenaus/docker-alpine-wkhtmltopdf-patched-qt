FROM alpine:3.8 AS build

# install qt build packages #
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk update \
	&& apk add gtk+ openssl glib fontconfig bash vim \
	&& apk add --virtual .deps git patch make g++ \
		libc-dev gettext-dev zlib-dev bzip2-dev libffi-dev pcre-dev \
		glib-dev atk-dev expat-dev libpng-dev freetype-dev fontconfig-dev \
		libxau-dev libxdmcp-dev libxcb-dev xf86bigfontproto-dev libx11-dev \
		libxrender-dev pixman-dev libxext-dev cairo-dev perl-dev \
		libxfixes-dev libxdamage-dev graphite2-dev icu-dev harfbuzz-dev \
		libxft-dev pango-dev gtk+-dev libdrm-dev \
		libxxf86vm-dev libxshmfence-dev wayland-dev mesa-dev openssl-dev \
	&& git clone --recursive https://github.com/wkhtmltopdf/wkhtmltopdf.git /tmp/wkhtmltopdf \
	&& cd /tmp/wkhtmltopdf \
	&& git checkout a8ba57e \
	&& cd /tmp/wkhtmltopdf/qt \
	&& git checkout wk_4.8.7 && git reset --hard 5db36ec

# revision 6a57c14 is tag 0.12.6 (https://github.com/wkhtmltopdf/wkhtmltopdf/commit/6a57c1449797d6cb915921fb747f3ac36199241f)
# revision 5db36ec is on a fork of qt (https://github.com/wkhtmltopdf/qt/commit/5db36ec76b29712eb2c5bd0625c2c77d7468b3fc)
COPY conf/* /tmp/wkhtmltopdf/qt/

RUN	cd /tmp/wkhtmltopdf/qt && \
	patch -p1 -i qt-musl.patch && \
	patch -p1 -i qt-musl-iconv-no-bom.patch && \
	patch -p1 -i qt-recursive-global-mutex.patch && \
	patch -p1 -i qt-font-pixel-size.patch && \
	patch -p1 -i qt-gcc6.patch && \
	sed -i "s|-O2|$CXXFLAGS|" mkspecs/common/g++.conf && \
	sed -i "/^QMAKE_RPATH/s| -Wl,-rpath,||g" mkspecs/common/g++.conf && \
	sed -i "/^QMAKE_LFLAGS\s/s|+=|+= $LDFLAGS|g" mkspecs/common/g++.conf && \
	CFLAGS=-w CPPFLAGS=-w CXXFLAGS=-w LDFLAGS=-w \
	./configure -confirm-license -opensource \
		-prefix /usr \
		-datadir /usr/share/qt \
		-sysconfdir /etc \
		-plugindir /usr/lib/qt/plugins \
		-importdir /usr/lib/qt/imports \
		-fast \
		-release \
		-static \
		-largefile \
		-glib \
		-graphicssystem raster \
		-qt-zlib \
		-qt-libpng \
		-qt-libmng \
		-qt-libtiff \
		-qt-libjpeg \
		-svg \
		-script \
		-webkit \
		-gtkstyle \
		-xmlpatterns \
		-script \
		-scripttools \
		-openssl-linked \
		-nomake demos \
		-nomake docs \
		-nomake examples \
		-nomake tools \
		-nomake tests \
		-nomake translations \
		-no-qt3support \
		-no-pch \
		-no-icu \
		-no-phonon \
		-no-phonon-backend \
		-no-rpath \
		-no-separate-debug-info \
		-no-dbus \
		-no-opengl \
		-no-openvg && \
	NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
	export MAKEFLAGS=-j${NPROC} && \
	export MAKE_COMMAND="make -j${NPROC}" && \
	make --silent && \
	make install && \
	cd /tmp/wkhtmltopdf && \
	qmake && \
	make --silent && \
	make install && \
	rm -rf /tmp/*

# remove qt build packages #
RUN apk del .deps \
	&& rm -rf /var/cache/apk/*

FROM alpine:3.9

RUN apk --update --no-cache add \
    libgcc \
    libstdc++ \
    musl \
    qt5-qtbase \
    qt5-qtbase-x11 \
    qt5-qtsvg \
    qt5-qtwebkit \
    ttf-freefont \
    ttf-dejavu \
    ttf-droid \
    ttf-liberation \
    ttf-ubuntu-font-family \
    fontconfig

# Add openssl dependencies for wkhtmltopdf
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.8/main' >> /etc/apk/repositories && \
    apk add --no-cache libcrypto1.0 libssl1.0

COPY --from=build /bin/wkhtmltopdf /bin/wkhtmltopdf
