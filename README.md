# GitOps Docker image build system (DIBS)
The purpose of this build system is to simplify the process of building a docker image and make it easier for everyone to contribute

## Project structure
```
.github/
  workflows/
    <my-engine>.yaml   # This will be your workflow file
<my-engine>/
  Dockerfile-<version>_<variant> # This Docker build file will be used by workflow, the configuration is based on workflow input
```

## How to build
- Create action secret `DOCKER_USERNAME`, `DOCKER_PASSWORD` and fill out the value according to your Docker Hub account
- Open GitHub Actions
- Choose some `Publish` workflow
- Fill out the publish configuration that usually contains `image name`, `image version`, `image variant`, for example:
```env
Image name    : my-engine
Image version : latest
Image variant : alpine
```
- Run workflow
- Built image will be automatically available in your Docker Hub repository
```env
Built image on Docker Hub : <DOCKER_USERNAME>/my-engine:latest-alpine
```
