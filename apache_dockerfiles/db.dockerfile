FROM mysql

# Install System Dependencies
#RUN microdnf install iputils

# Copy Encryption & Create DB Files 
COPY encrypt_db_cred.sh /etc/
COPY create_db.sh /etc/

# Set the permession of the Script 
RUN chmod +x /etc/create_db.sh
RUN chmod +x /etc/encrypt_db_cred.sh

# Expose Port Settings
EXPOSE 3306 33060

# Set the initial & continues Scripts
ENTRYPOINT [ "/etc/create_db.sh" ]

CMD ["mysqld"]
