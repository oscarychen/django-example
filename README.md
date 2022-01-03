# Django Docker Example

This is a template Django application running inside Docker with configurtations for both development and deployment.

## Development

```commandline
docker-compose build
docker-compose up
```

## Deployment

```commandline
docker-compose -f docker-compose.prod.yml up -d --build
docker-compose -f docker-compose.prod.yml exec web python manage.py collectstatic --no-input --clear
docker-compose -f docker-compose.prod.yml up
```
