#!/bin/bash

set -e

POC=$1

# [[ -z "$POC" ]] && echo "POC is unset"
# [[ -n "$POC" ]] && echo "POC is set"

[[ -z "$POC" ]] && DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/langutils"

mkdir -p results

[[ -n "$POC" ]] && DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/vhd2vl"
$DOCKER vhd2vl --version
$DOCKER vhd2vl --quiet hdl/counter.vhdl results/vhd2vl.v
test -f results/vhd2vl.v

[[ -n "$POC" ]] && DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/sv2v"
$DOCKER sv2v --version
$DOCKER sv2v hdl/counter.sv --write=results/sv2v.v
test -f results/sv2v.v

[[ -n "$POC" ]] && DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/slang"
$DOCKER slang --version
$DOCKER slang hdl/counter.sv --lint-only

[[ -n "$POC" ]] && DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/surelog"
$DOCKER surelog --version
$DOCKER surelog -parse hdl/counter.sv
rm -fr slpp_all

[[ -n "$POC" ]] && DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/verible"
$DOCKER verible-verilog-syntax --version
$DOCKER verible-verilog-lint hdl/counter.sv

[[ -n "$POC" ]] && DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/svlint"
$DOCKER svlint --version
$DOCKER svlint hdl/counter.sv

echo "Test passed"
