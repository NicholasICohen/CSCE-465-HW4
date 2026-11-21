FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends socat curl bash ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY mock_skill.sh /app/mock_skill.sh

RUN chmod +x /app/mock_skill.sh

CMD ["sleep", "infinity"]
