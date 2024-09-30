FROM ubuntu:20.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Download and extract WSO2 API Manager
RUN wget -q https://github.com/wso2/product-apim/releases/download/v4.2.0/wso2am-4.2.0.zip \
    && unzip -q wso2am-4.2.0.zip -d /opt \
    && rm wso2am-4.2.0.zip

# Set the working directory
WORKDIR /opt/wso2am-4.2.0

# Copy any custom configurations
COPY configs/ /opt/wso2am-4.2.0/repository/conf/

# Expose ports
EXPOSE 9443 8243 8280

# Start WSO2 API Manager
CMD ["sh", "-c", "/opt/wso2am-4.2.0/bin/api-manager.sh"]