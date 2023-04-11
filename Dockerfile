FROM python:3.11-slim-bullseye

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev binutils libproj-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip
COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN mkdir -p /home/app

RUN groupadd -r app && useradd -r app -g app

ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/staticfiles
WORKDIR $APP_HOME

COPY . $APP_HOME

RUN chown -R app:app $APP_HOME

COPY ./docker/start_client_app.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

USER app

EXPOSE 8000

CMD ["start.sh"]
