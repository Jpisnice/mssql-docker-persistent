# Use the official Microsoft SQL Server 2022 image
FROM mcr.microsoft.com/mssql/server:2022-latest

# Set environment variables
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=YourStrong@Passw0rd
ENV MSSQL_PID=Express
ENV MSSQL_TCP_PORT=1433

# Install SQL Server command-line tools
USER root
RUN apt-get update && apt-get install -y curl apt-transport-https gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add tools to the path
ENV PATH="/opt/mssql-tools/bin:${PATH}"

# Create volumes for data persistence
# The directories will be created by the volume mount.
VOLUME ["/var/opt/mssql/data", "/var/opt/mssql/log", "/var/opt/mssql/backup"]

# Expose the SQL Server port
EXPOSE 1433

# Switch to mssql user
USER mssql

# Start SQL Server
CMD ["/opt/mssql/bin/sqlservr"]