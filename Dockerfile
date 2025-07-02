# Use the official Microsoft SQL Server 2022 image
FROM mcr.microsoft.com/mssql/server:2022-latest

# Set environment variables
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=mssqlpass
ENV MSSQL_PID=Express
ENV MSSQL_TCP_PORT=1433

# Create volumes for data persistence
# The directories will be created by the volume mount.
VOLUME ["/var/opt/mssql/data", "/var/opt/mssql/log", "/var/opt/mssql/backup"]

# Expose the SQL Server port
EXPOSE 1433

# Switch to mssql user
USER mssql

# Start SQL Server
CMD ["/opt/mssql/bin/sqlservr"]