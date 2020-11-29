FROM debian:stable-slim
MAINTAINER Brian Bassett <bbassett1276@gmail.com>

# Install required tools
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
    && rm -rf /var/lib/apt/lists/*
