# pull official base image
FROM python:3.10-alpine

WORKDIR /app

# prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE=1
# prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1

# install dependencies
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .
