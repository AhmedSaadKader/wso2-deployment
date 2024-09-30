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
RUN wget -q https://github.com/wso2/product-apim/releases/download/v4.4.0-m2/wso2am-4.4.0-m2.zip \
    && unzip -q wso2am-4.4.0-m2.zip -d /opt \
    && rm wso2am-4.4.0-m2.zip

# Set the working directory
WORKDIR /opt/wso2am-4.4.0-m2

# Copy any custom configurations
COPY configs/ /opt/wso2am-4.4.0-m2/repository/conf/

# Update configuration to use 0.0.0.0 and PORT environment variable
RUN sed -i 's#<HostName>localhost</HostName>#<HostName>0.0.0.0</HostName>#g' /opt/wso2am-4.4.0-m2/repository/conf/carbon.xml && \
    sed -i 's#<MgtHostName>localhost</MgtHostName>#<MgtHostName>0.0.0.0</MgtHostName>#g' /opt/wso2am-4.4.0-m2/repository/conf/carbon.xml && \
    sed -i 's#<parameter name="port">9443</parameter>#<parameter name="port">${PORT}</parameter>#g' /opt/wso2am-4.4.0-m2/repository/conf/axis2/axis2.xml

# Expose ports
EXPOSE 9443 8243 8280

# Start WSO2 API Manager
CMD ["sh", "-c", "/opt/wso2am-4.4.0-m2/bin/api-manager.sh"]