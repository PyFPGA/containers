#!/bin/bash

set -e

DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/simulation"

$DOCKER ghdl --version
$DOCKER iverilog -V | grep Icarus
$DOCKER verilator --version
$DOCKER cocotb-config --version
$DOCKER python3 -B cocotb/test_counter.py verilator
$DOCKER python3 -B cocotb/test_counter.py icarus
$DOCKER python3 -B -c "import cocotbext.axi, pytest, wavedrom"
