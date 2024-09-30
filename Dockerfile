FROM wso2/wso2am:4.2.0

   # Copy any custom configurations
   COPY configs/ /home/wso2carbon/wso2am-4.2.0/repository/conf/

   # Expose ports
   EXPOSE 9443 8243 8280

   # Start WSO2 API Manager
   CMD ["sh", "-c", "/home/wso2carbon/wso2am-4.2.0/bin/api-manager.sh"]