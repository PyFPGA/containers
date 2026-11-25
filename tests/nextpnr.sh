#!/bin/bash

set -e

RUN="docker run --rm -v $HOME:$HOME -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga"

mkdir -p results

$RUN/synthesis yosys -Q -q -p '
read_verilog -sv hdl/counter.sv
synth_ice40 -top counter -json results/ice40.json
design -reset
read_verilog -sv hdl/counter.sv
synth_ecp5 -top counter -json results/ecp5.json
design -reset
read_verilog -sv hdl/counter.sv
synth_gowin -top counter -json results/gowin.json
'

echo "* nextpnr-icestorm"
$RUN/nextpnr-icestorm nextpnr-ice40 -q --hx1k --package tq144 --pcf hdl/constraints/icestick.pcf \
  --json results/ice40.json --asc results/ice40.asc
$RUN/nextpnr-icestorm icepack results/ice40.asc results/ice40.bin
test -s results/ice40.bin

echo "* nextpnr-trellis"
$RUN/nextpnr-trellis nextpnr-ecp5 -q --25k --package CSFBGA285 \
  --lpf hdl/constraints/orangecrab.lpf --json results/ecp5.json --textcfg results/ecp5.config
$RUN/nextpnr-trellis ecppack results/ecp5.config results/ecp5.bit
test -s results/ecp5.bit

echo "* nextpnr-apicula"
$RUN/nextpnr-apicula nextpnr-himbaechel -q --device GW1NR-LV9QN88PC6/I5 \
  --vopt family=GW1N-9C --vopt cst=hdl/constraints/tangnano9k.cst \
  --json results/gowin.json --write results/gowin_pnr.json
$RUN/nextpnr-apicula gowin_pack -d GW1N-9C -o results/gowin.fs results/gowin_pnr.json
test -s results/gowin.fs

echo "Test passed"
