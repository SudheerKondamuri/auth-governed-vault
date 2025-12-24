FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache git curl bash

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH="${PATH}:/root/.foundry/bin"
RUN foundryup

WORKDIR /app

# Copy project files
COPY . .

# Install OpenZeppelin and build
RUN forge install OpenZeppelin/openzeppelin-contracts --no-commit
RUN forge build

# Set permissions for entrypoint
RUN chmod +x ./docker/entrypoint.sh

EXPOSE 8545

ENTRYPOINT ["./docker/entrypoint.sh"]