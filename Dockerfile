FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    gcc \
    make \
    golang-go \
    libssl-dev \
    jq \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ticarpi/jwt_tool /app/jwt_tool && \
    cd /app/jwt_tool && \
    pip3 install -r requirements.txt

RUN go install github.com/hahwul/jwt-hack@latest
ENV PATH="/root/go/bin:${PATH}"

RUN git clone https://github.com/brendan-rius/c-jwt-cracker /app/c-jwt-cracker && \
    cd /app/c-jwt-cracker && \
    make

COPY secrets.txt /app/secrets.txt
COPY verify.sh /app/verify.sh
RUN chmod +x /app/verify.sh

ENTRYPOINT ["/app/verify.sh"]
