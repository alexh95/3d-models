# OpenSCAD 2021.01, the version the .scad files are written for, to check
# that they still open in it. Build and use from the u3421we-riser folder:
#
#   docker build -t local/openscad-2021 tools/openscad-2021
#   docker run --rm -v "$PWD":/work local/openscad-2021 \
#       xvfb-run -a openscad -o /work/check-2021.png --imgsize=1200,800 riser.scad
FROM ubuntu:24.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openscad xvfb xauth \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /work
