FROM python:3.12.16-slim-trixie

EXPOSE 8000

WORKDIR /app

RUN mkdir -p /app/web

COPY benign.html adverserial.html /app/web

CMD ["python3", "-m", "http.server", "8000", "--directory", "web"]
