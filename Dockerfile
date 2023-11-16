#FROM alpine:3.18.4
FROM ubuntu:22.04
LABEL authors="caldremch"
#RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
#RUN sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && apt-get update
RUN apt-get install --no-install-recommends -y openjdk-17-jdk curl unzip

#RUN apk update && apk add openjdk17 && apk add --no-cache libc6-compat
#ADD commandlinetools-linux-latest.zip /
ENV ANDROID_HOME="/android-sdk" \
	ANDROID_SDK_HOME="/android-sdk" \
	ANDROID_SDK_ROOT="/android-sdk"

WORKDIR /

ENV ANDROID_SDK_MANAGER=${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager
ENV ANDROID_SDK_HOME="$ANDROID_HOME"
ENV ANDROID_NDK_HOME="$ANDROID_NDK"


RUN curl -o commandlinetools-linux-latest.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip


RUN mkdir --parents "$ANDROID_HOME" && \
	unzip -q commandlinetools-linux-latest.zip -d "$ANDROID_HOME" && \
	cd "$ANDROID_HOME" && \
	mv cmdline-tools latest && \
	mkdir cmdline-tools && \
	mv latest cmdline-tools

RUN rm -f /commandlinetools-linux-latest.zip

#ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
ENV ANDROID_SDK_HOME="$ANDROID_HOME"
ENV ANDROID_NDK_HOME="$ANDROID_NDK"

ENV AAPT_HOME="${ANDROID_HOME}/build-tools/33.0.2"

ENV PATH="$AAPT_HOME:$JAVA_HOME/bin:$PATH:$ANDROID_SDK_HOME/emulator:$ANDROID_SDK_HOME/cmdline-tools/latest/bin:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$ANDROID_NDK"

RUN mkdir --parents "$ANDROID_HOME/.android/"
RUN echo '### User Sources for Android SDK Manager' > "$ANDROID_HOME/.android/repositories.cfg"
RUN yes | $ANDROID_SDK_MANAGER "build-tools;33.0.2"
#ENTRYPOINT ["top", "-b"]