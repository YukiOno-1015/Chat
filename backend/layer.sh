#!/bin/bash

WORK_DIR=${PWD}
echo "Working Directory: ${WORK_DIR}"

LAYER_DIR=${WORK_DIR}/src/layer
echo "Layer Directory: ${LAYER_DIR}"

PYTHON_DIR=${LAYER_DIR}/python
echo "Python Directory: ${PYTHON_DIR}"

LAYER_FILE=${LAYER_DIR}/common.py
echo "Layer File: ${LAYER_FILE}"

if [ -d "${PYTHON_DIR}" ]; then
  rm -frv "${PYTHON_DIR}"
fi
mkdir -p "${PYTHON_DIR}"

cp -frv "${LAYER_FILE}" "${PYTHON_DIR}"

cd "${PYTHON_DIR}" || exit
pip install -r "${WORK_DIR}/requirements.txt" -t "${PYTHON_DIR}"

cd "${WORK_DIR}" || exit