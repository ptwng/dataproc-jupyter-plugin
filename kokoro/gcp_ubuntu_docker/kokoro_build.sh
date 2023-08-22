#!/bin/bash

# Fail on any error.
set -e

# Display commands being run.
# WARNING: please only enable 'set -x' if necessary for debugging, and be very
#  careful if you handle credentials (e.g. from Keystore) with 'set -x':
#  statements like "export VAR=$(cat /tmp/keystore/credentials)" will result in
#  the credentials being printed in build logs.
#  Additionally, recursive invocation with credentials as command-line
#  parameters, will print the full command, with credentials, in the build logs.
# set -x

# Code under repo is checked out to ${KOKORO_ARTIFACTS_DIR}/github.
# The final directory name in this path is determined by the scm name specified
# in the job configuration.

export PATH="$HOME/.local/bin:$PATH"

sudo apt-get update
sudo apt-get --assume-yes install python3 python3-pip nodejs

pip install jupyterlab

cd "${KOKORO_ARTIFACTS_DIR}/github/dataproc-jupyter-plugin"
# jlpm build
# python3 -m build
pip3 install -e ".[test]"
# Link your development version of the extension with JupyterLab
jupyter labextension develop . --overwrite
# Server extension must be manually installed in develop mode
jupyter server extension enable dataproc_jupyter_plugin
# Rebuild extension Typescript source after making changes
jlpm build

jupyter lab