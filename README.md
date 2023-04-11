# Django Example
This is my template Django application for standing up new projects, with configuration for enforcing strict typing,
code formatting with pre-commit hooks, as well as configurations for GitHub Action and Docker.

## Quick start
_These are designed for Mac/Linux, if you are using Windows you can run Makefile commands from a
Bash-like shell such as GitBash_

```shell
make conda-setup  # if Conda available on Path (Recommended)
make system-setup # Or, Use the Python on your Path to set up

make dot-env      # create .env from template
make migrate      # run Django migrations
make run          # run Django application server
```

```shell
make check        # Run Linter, formatter, and type checker
make fmt          # Format code
```

## How this repository was made from scratch

### Preparation
You can install the desired version of Python directly on your machine,
Or if you are like me who is constantly installing and destroying Python and joggling few different versions,
create a desired version of Python using Anaconda:
```
conda create -n py311-django-example python=3.11
```
With this conda environment activated, create the venv that we would use for this project:
```
conda activate py311-django-example
python -m venv environment
```
Now, we can discard the Conda environment that was created previously,
activate the Python venv we just created and
confirm you have the correct Python version that you wish to use for this project:
```
conda deactivate
conda env remove -n py311-django-example
source environment/bin/activate
python --version
```

### Add basic project requirements
I like to keep the python requirements necessary for running the production server separated from those for development
and testing. Create [requirements.txt](requirements.txt) and [requirements_dev.txt](requirements_dev.txt).

Install dependencies:
```commandline
pip install --upgrade pip
pip install -r requirements.txt
pip install -r requirements_dev.txt
```

## Start Django project
```commandline
django-admin startproject django_example
```
Django-admin creates the project in yet another folder, if you have a monolith repository this is ok;
but I usually like to keep the Django project in root of repository:
```commandline
mkdir temp
mv django_example/* temp/
rm -rf django_example
mv temp/* .
rm -rf temp
```
You can now try launching the out-of-box Django development server:
```commandline
python manage.py runserver
```
### Define environment variables
create [.env](.env) and [.env.template](.env.template) files with environment variables.
For now, they can have content, but we will check the .env.template into git, while ignore .env from the repository.

### Configure Django settings
Configure [django_example/settings.py](django_example/settings.py):

- SECRET_KEY
- DEBUG
- CORS_ALLOWED_ORIGINS
- INSTALLED_APPS
- DATABASES

The Postgres database settings are commented out for now to make running this project easier.

Now if you run django development server again, you will notice that it is not loading environment variables that we
defined in the .env file. This is okay as we do not want the application to load environment variable from file in most
deployment environments. To allow environment variables to be used from the .env file in your development environment,
we need to set up IDEs to run and debug the Django application.

## IDE set up

### PyCharm Debugger
Install EnvFile plugin: Pycharm > Settings > Plugins > Search for "EnvFile" > Install plugin

If Pycharm has not detected the Python virtual environment inside the project, set up Python interpreter:
Pycharm > Settings > Project > Python Interpreter > Add interpreter > Virtual Environment > Existing >
Interpreter: /{path_to_project}/environment/bin/python

In Pycharm's Run/Debug Configuration dialog, click + on the toolbar, select Python:
- Script path: "/path_to_project/manage.py"
- Parameters: "runserver"
- Python interpreter: select the Python interpreter from the project Python environment (from previous step)
- In the EnvFile tab, check "Enable EnvFile"; click on the "+" and add .env file from project root

### Pycharm Python Console

Pycharm console is useful for debugging Django management commands.

Pycharm > Settings > Build, Execution, Deployment > Console > Python Console:

- Environment variables: `DJANGO_USE_DOT_ENV=true;DJANGO_SETTINGS_MODULE=django_example.settings`
- Starting script:
  ```
  import sys; print('Python %s on %s' % (sys.version, sys.platform))
  import django; print('Django %s' % django.get_version())
  sys.path.extend([WORKING_DIR_AND_PYTHON_PATHS])
  if 'setup' in dir(django): django.setup()
  ```

Note that the environment variable `DJANGO_USE_DOT_ENV` is set to `True` which allows Django to load environment
variables from the .env file.

### VS Code Debugger
Add run configuration: Run > Add Configuration.. > Python > Django.

This should result in the following file being created in .vscode/launch.json:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Django",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/manage.py",
      "args": ["runserver"],
      "django": true,
      "justMyCode": true
    }
  ]
}
```

## Linters & formatters
Most of these are already installed as part of the [requirements_dev.txt](requirements_dev.txt),
and they can be configured in [pyproject.toml](pyproject.toml).

## Type checker
Mypy can be configured in [mypy.ini](mypy.ini). You will likely need to add more rules to this file as you import
libraries that do not have typing stubs into the project, in the format of:
```
[mypy-imported_package_name.*]
ignore_missing_imports = True
```
Remember to update the `django_setting_module` configuration in this file when copying to another project.

You may also ignore type error inline:
```python
blahh # type: ignore[no-any-unimported]
```

## Add pre-commit hooks
A collection of pre-commit hooks are provided and configured in this repository, including running the linters,
formatters, and type checker.
Remember to update the `django-settings-module` argument in [.pre-commit-config.yaml](.pre-commit-config.yaml).
Run `pre-commit install`.

## Add docker
[Dockerfile](Dockerfile) and [docker-compose.yaml](docker-compose.yml) are included to provide
Django application server and postgres database server in docker containers.
Remember to update the wsgi server location in docker/start_client_app.sh if you are copying these to another project.

## Add GitHub Actions


## Add Makefile
The included [Makerfile](Makefile) provides the following functionalities:

### `make conda-setup`
Set up application dependencies using Conda with specified Python version.

### `make system-setup`
Set up application dependencies using Python available on Path.

### `make dot-env`
Create `.env` file from template.

### `make run`
Run Django application server with venv activated.

### `make check`
This runs Black, Pylint, and Mypy using pre-commit hooks to check code quality.

### `make fmt`
This uses Black, Pylint, Isort to automatically reformat code.

### `make migrations [args]`
This is equivalent to `python manage.py makemigrations` with venv activated. You can also provide additional arguments by passing them as
string to `args`, ie: `make migrations args="my_app_name --name my_custom_migration --empty"`.

### `make migrate [args]`
This is equivalent to `python manage.py migrate` with venv activated.

### `make build-docker`
Builds docker images.

### `make run-docker`
Runs both Django application server and Postgres data server in Docker containers.

### `make run-docker-db`
Runs the Postgres data server in Docker container.

### `make stop-docker`
Stops Docker containers.
