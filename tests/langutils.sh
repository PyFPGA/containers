#!/bin/bash

set -e

DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/langutils"

mkdir -p results

$DOCKER vhd2vl --version
$DOCKER slang --version
$DOCKER surelog --version
$DOCKER sv2v --version
$DOCKER verible-verilog-syntax --version

$DOCKER vhd2vl --quiet hdl/counter.vhdl results/vhd2vl.v
$DOCKER slang hdl/counter.sv --lint-only
$DOCKER surelog -parse hdl/counter.sv
$DOCKER sv2v hdl/counter.sv --write=results/sv2v.v
$DOCKER verible-verilog-lint hdl/counter.sv

rm -fr slpp_all
