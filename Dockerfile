FROM rust:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Clarinet
RUN cargo install clarinet

# Set the working directory
WORKDIR /app

# Copy the project files into the Docker container
COPY . .

# Set the entrypoint to Clarinet
ENTRYPOINT ["clarinet"]
