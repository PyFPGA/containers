#!/bin/bash
set -e
bash run.sh synthesis 'ghdl --version'
bash run.sh synthesis 'yosys -m ghdl -V'
