#!/bin/bash

set -e

DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/langutils"

mkdir -p results

$DOCKER vhd2vl --version
$DOCKER vhd2vl --quiet hdl/counter.vhdl results/vhd2vl.v
test -f results/vhd2vl.v

$DOCKER sv2v --version
$DOCKER sv2v hdl/counter.sv --write=results/sv2v.v
test -f results/sv2v.v

$DOCKER slang --version
$DOCKER slang hdl/counter.sv --lint-only

$DOCKER surelog --version
$DOCKER surelog -parse hdl/counter.sv

$DOCKER verible-verilog-syntax --version
$DOCKER verible-verilog-lint hdl/counter.sv

$DOCKER svlint --version
$DOCKER svlint hdl/counter.sv

rm -fr slpp_all

echo "Test passed"
