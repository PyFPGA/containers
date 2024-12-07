#!/bin/bash

set -e

DOCKER="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga/synthesis"

mkdir -p results

$DOCKER ghdl --version
$DOCKER yosys -m ghdl -V
$DOCKER yosys -m slang -V
$DOCKER synlig -V

$DOCKER ghdl synth --workdir=results hdl/counter.vhdl -e counter > results/ghdl.vhdl
$DOCKER ghdl synth --workdir=results --out=verilog hdl/counter.vhdl -e counter > results/ghdl.v

$DOCKER yosys -Q -p '
plugin -i ghdl
ghdl hdl/counter.vhdl -e counter
write_verilog -noattr results/yosys-ghdl.v
'

$DOCKER yosys -Q -p '
read_verilog -sv hdl/counter.sv
hierarchy -top counter
write_verilog -noattr results/yosys.v
'

$DOCKER yosys -Q -p '
plugin -i slang
read_slang hdl/counter.sv -top counter
write_verilog -noattr results/yosys-slang.v
'

$DOCKER synlig -Q -p '
read_systemverilog hdl/counter.sv
hierarchy -top counter
write_verilog -noattr results/synlig.v
'

rm -fr slpp_all
