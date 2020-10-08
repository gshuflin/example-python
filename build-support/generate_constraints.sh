#!/usr/bin/env bash
# Copyright 2020 Pants project contributors (see CONTRIBUTORS.md).
# Licensed under the Apache License, Version 2.0 (see LICENSE).

# See https://www.pantsbuild.org/v2.0/docs/python-third-party-dependencies.

set -euo pipefail

PYTHON_BIN=python3
VIRTUALENV=build-support/.venv
PIP="${VIRTUALENV}/bin/pip"
CONSTRAINTS_FILE=constraints.txt

"${PYTHON_BIN}" -m venv "${VIRTUALENV}"
"${PIP}" install pip --upgrade
"${PIP}" install -r <(./pants dependencies --type=3rdparty ::)
echo "# Generated by build-support/generate_constraints.sh on $(date)" > "${CONSTRAINTS_FILE}"
"${PIP}" freeze --all >> "${CONSTRAINTS_FILE}"

# This example repo includes some Python 2-only code for demonstration. Because we generated
# the constraints using Python 3.7, we must manually ensure things still work with Python 2.7. So,
# we warn to the user that they should check the diff. You can delete this if you don't use Python 2.
echo "Check the diff for ${CONSTRAINTS_FILE} and restore any entries that were specific to" \
  "Python 2, i.e. entries ending in \`python_version == '2.7'\`. Those are needed for Python 2 to" \
  "work properly, and this script will overwrite it." 1>&2
