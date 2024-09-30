FROM archlinux:latest as base-dev

ARG USER=pawel
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID -o $USER && \
    useradd -m -u $UID -g $GID -o -s /bin/bash $USER

RUN pacman-key --init && \
    pacman-key --populate

RUN pacman -Suy --noconfirm && pacman --noconfirm -S \
    base-devel \
    fzf \
    git \
    make \
    man-db \
    nodejs \
    npm \
    openssh \
    python \
    ranger \
    ripgrep \
    sudo \
    tldr \
    tmux \
    unzip \
    vim \
    wget \
    python-black \
    python-pip
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USER

######### ESP ##############

FROM base-dev as esp32
ARG USER=pawel

RUN sudo pacman -Suy --needed --noconfirm && sudo pacman --noconfirm -S \
    gperf \
    cmake \
    ninja \
    ccache \
    dfu-util

ARG IDF_CLONE_URL=https://github.com/espressif/esp-idf.git
ARG IDF_CLONE_BRANCH_OR_TAG=master
ARG IDF_CHECKOUT_REF=
ARG IDF_CLONE_SHALLOW=
ARG IDF_CLONE_SHALLOW_DEPTH=1
ARG IDF_INSTALL_TARGETS=all

ENV IDF_TOOLS_PATH=/opt/esp
ENV IDF_PATH=/opt/esp/idf

RUN sudo mkdir -p $IDF_TOOLS_PATH && \
    sudo chown -R $USER $IDF_TOOLS_PATH

RUN echo IDF_CHECKOUT_REF=$IDF_CHECKOUT_REF IDF_CLONE_BRANCH_OR_TAG=$IDF_CLONE_BRANCH_OR_TAG && \
    git clone --recursive \
      ${IDF_CLONE_SHALLOW:+--depth=${IDF_CLONE_SHALLOW_DEPTH} --shallow-submodules} \
      ${IDF_CLONE_BRANCH_OR_TAG:+-b $IDF_CLONE_BRANCH_OR_TAG} \
      $IDF_CLONE_URL $IDF_PATH && \
    if [ -n "$IDF_CHECKOUT_REF" ]; then \
      cd $IDF_PATH && \
      if [ -n "$IDF_CLONE_SHALLOW" ]; then \
        git fetch origin --depth=${IDF_CLONE_SHALLOW_DEPTH} --recurse-submodules ${IDF_CHECKOUT_REF}; \
      fi && \
      git checkout $IDF_CHECKOUT_REF && \
      git submodule update --init --recursive; \
    fi

# Install all the required tools
RUN : \
  && $IDF_PATH/install.sh all \
  && rm -rf $IDF_TOOLS_PATH/dist \
  && :

USER $USER
# Access to /dev/ttyXXX - ESP board device
RUN sudo usermod -aG uucp $USER
ENV IDF_PYTHON_CHECK_CONSTRAINTS=no
ENV IDF_CCACHE_ENABLE=1
COPY esp32-entrypoint.sh /opt/esp/entrypoint.sh
ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]
CMD [ "/bin/bash" ]

######### ESPHome ##############

FROM esp32 as esphome
ARG USER=pawel

ENV ESPHOME_PATH=/opt/esp/esphome

RUN git clone https://github.com/esphome/esphome.git $ESPHOME_PATH
RUN : \
  $ESPHOME_PATH/script/setup \
  && :

######### Lab ##############

FROM base-dev as lab

RUN sudo pacman -Suy --needed --noconfirm && sudo pacman --noconfirm -S \
    go \
    hugo \
    libwebp

######### Google Cloud CLI + Terraform ##############

FROM base-dev as gcloud
ARG CLOUD_SDK_VERSION=460.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ARG GCLOUD_CLI_FILENAME=google-cloud-cli-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

ARG TERRAFORM_VERSION=1.7.0

ENV PATH /opt/terraform:/opt/google-cloud-sdk/bin:$PATH

RUN cd /tmp && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_CLI_FILENAME} && \
    tar xzf ${GCLOUD_CLI_FILENAME} && \
    rm ${GCLOUD_CLI_FILENAME} && \
    sudo mv google-cloud-sdk /opt/ && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

RUN cd /tmp && \
    curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mkdir terraform && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d terraform && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    sudo mv terraform /opt/ && \
    terraform --version


######### FLUTTER ##############
# Inspired by https://github.com/matsp/docker-flutter

FROM base-dev as flutter
ARG USER=pawel
ENV WORKSPACE="/workspace"
ENV JAVA_VERSION="17"
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip"
ENV ANDROID_VERSION="34"
ENV ANDROID_BUILD_TOOLS_VERSION="34.0.0"
ENV ANDROID_ARCHITECTURE="x86_64"
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV ANDROID_PREFS_ROOT="$WORKSPACE"
ENV FLUTTER_VERSION="3.19.1"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz"
ENV FLUTTER_HOME="/opt/flutter"

ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$FLUTTER_HOME/bin:$PATH"

RUN sudo pacman -Suy --noconfirm &&  sudo pacman --noconfirm -S \
    jdk$JAVA_VERSION-openjdk \
    ruby

USER $USER
WORKDIR $WORKSPACE

# android sdk
RUN sudo chown -R $USER $WORKSPACE && \
    sudo mkdir -p $ANDROID_SDK_ROOT && sudo chown -R $USER $ANDROID_SDK_ROOT && \
    mkdir -p $ANDROID_PREFS_ROOT/.android && \
    touch $ANDROID_PREFS_ROOT/.android/repositories.cfg && \
    curl -o /tmp/android_tools.zip $ANDROID_TOOLS_URL && \
    unzip -qq -d "$ANDROID_SDK_ROOT" /tmp/android_tools.zip && \
    rm /tmp/android_tools.zip && \
    mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools && \
    yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" && \
    yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" && \
    yes "y" | sdkmanager "platform-tools" && \
    yes "y" | sdkmanager "cmdline-tools;latest"

# flutter
RUN curl -o /tmp/flutter.tar.xz $FLUTTER_URL && \
    sudo mkdir -p $FLUTTER_HOME && sudo chown -R $USER $FLUTTER_HOME && \
    tar xf /tmp/flutter.tar.xz --strip-components 1 -C $FLUTTER_HOME && \
    rm /tmp/flutter.tar.xz && \
    flutter config --no-analytics && \
    flutter precache && \
    yes "y" | flutter doctor --android-licenses && \
    flutter doctor

# fastlane
RUN sudo gem install --no-user-install -NV \
    fastlane \
    fastlane-plugin-firebase_app_distribution

######### cpp ##############

FROM base-dev as cpp

RUN sudo pacman -Suy --needed --noconfirm && sudo pacman --noconfirm -S \
    gcc \
    clang \
    gdb
