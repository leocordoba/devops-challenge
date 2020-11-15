FROM python:3.7-slim-buster

COPY ./app/requirements.txt .

RUN apt-get update -y && \
    apt-get install -y nginx

RUN pip install -r requirements.txt

COPY default /etc/nginx/sites-available

COPY ./app /app

WORKDIR /app

ENTRYPOINT [ "./deploy.sh" ]
