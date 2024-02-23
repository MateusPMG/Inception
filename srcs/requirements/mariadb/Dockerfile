# Use Debian Bullseye as the base image
FROM debian:bullseye

# Update the package repository
RUN apt-get update

# Install MariaDB server and clean up the package manager cache
RUN apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copy the custom script for MariaDB configuration
COPY ./tools/create_mariadb.sh /home

# Make the script executable
RUN chmod +x /home/create_mariadb.sh

# Expose port 3306 for MariaDB
EXPOSE 3306

# Set the entry point for the container
ENTRYPOINT ["/home/create_mariadb.sh"]

# Set the default command to start MariaDB in a safe mode with network access
CMD ["mysqld_safe", "--bind-address=0.0.0.0"]