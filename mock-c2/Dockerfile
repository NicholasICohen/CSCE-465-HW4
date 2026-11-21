FROM python:3.12.16-slim-trixie

WORKDIR /app

RUN mkdir -p /data

EXPOSE 8080

COPY c2.py /app/c2.py

CMD ["python","c2.py"]
