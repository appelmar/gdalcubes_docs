FROM ubuntu:bionic
MAINTAINER Marius Appel <marius.appel@uni-muenster.de>
RUN apt-get update && apt-get install -y mkdocs python-pip
RUN pip install mkdocs-rtd-dropdown pymdown-extensions  mkdocs-material


WORKDIR /mkdocs
CMD mkdocs build

# docker build -t appelmar/gdalcubes_docs
# docker run -v $PWD:/mkdocs appelmar/gdalcubes_docs
