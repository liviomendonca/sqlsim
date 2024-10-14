FROM postgres:16

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    postgresql-16-postgis-3 \
    postgresql-16-postgis-3-scripts

# Set the working directory
WORKDIR /breastcancer

# Copy the data file into the container
COPY wdbc.data /breastcancer/wdbc.data

# Set the correct permissions on the file
RUN chmod 644 /breastcancer/wdbc.data
