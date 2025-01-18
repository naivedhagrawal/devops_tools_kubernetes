# Use the official Jenkins inbound agent image as the base
FROM jenkins/inbound-agent:latest

# Update the system and install essential tools
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    curl \
    git \
    wget \
    zip \
    unzip \
    tar \
    openssh-client \
    python3 \
    python3-pip \
    ruby \
    ruby-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------- Install Docker CLI -----------
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.5.tgz | tar xz --strip-components=1 -C /usr/local/bin

# ----------- Install Latest Maven -----------
RUN curl -fsSL https://downloads.apache.org/maven/maven-3/latest/binaries/apache-maven-3.9.5-bin.tar.gz | tar -xz -C /opt/ \
    && ln -s /opt/apache-maven-3.9.5/bin/mvn /usr/bin/mvn

# ----------- Install Latest Gradle -----------
ENV GRADLE_VERSION=8.4
RUN curl -fsSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip \
    && unzip gradle.zip -d /opt/ \
    && rm gradle.zip \
    && ln -s /opt/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle

# ----------- Install Latest Node.js and npm -----------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# ----------- Install Latest Docker Compose -----------
RUN curl -fsSL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# ----------- Install Latest Go (Golang) -----------
ENV GO_VERSION=1.21.1
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xzf - \
    && ln -s /usr/local/go/bin/* /usr/bin/

# ----------- Install Latest .NET SDK -----------
ENV DOTNET_SDK_VERSION=7.0
RUN wget https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel ${DOTNET_SDK_VERSION} --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet-install.sh

# ----------- Install Python Packages -----------
RUN pip3 install --no-cache-dir --upgrade pip setuptools

# ----------- Install Ruby Bundler -----------
RUN gem install bundler

# Switch back to Jenkins user
USER jenkins

# Default environment variables
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent

# Expose Jenkins agent's default port
EXPOSE 50000

# Work directory
WORKDIR $JENKINS_AGENT_WORKDIR