#!/bin/bash

set -e

DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/langutils"
echo "* vhd2vl"
$DOCKER ldd /usr/local/bin/vhd2vl
echo "* sv2v"
$DOCKER ldd /usr/local/bin/sv2v
echo "* slang"
$DOCKER ldd /usr/local/bin/slang
echo "* surelog"
$DOCKER ldd /usr/local/bin/surelog
echo "* verible"
$DOCKER ldd /usr/local/bin/verible-verilog-syntax
echo "* svlint"
$DOCKER ldd /usr/local/bin/svlint

DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/synthesis"
echo "* ghdl"
$DOCKER ldd /usr/local/bin/ghdl
echo "* yosys"
$DOCKER ldd /usr/local/bin/yosys
echo "* synlig"
$DOCKER ldd /usr/local/bin/synlig

DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/simulation"
echo "* ghdl"
$DOCKER ldd /usr/local/bin/ghdl
echo "* iverilog"
$DOCKER ldd /usr/local/bin/iverilog
echo "* verilator"
$DOCKER ldd /usr/local/bin/verilator_bin

echo "Test passed"
