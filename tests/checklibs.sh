#!/bin/bash

FAILED=()

check() {
  local image=$1; shift
  local DOCKER="docker run --rm --user $(id -u):$(id -g) ghcr.io/pyfpga/${image}"
  for bin in "$@"; do
    echo "* ${image}: ${bin}"
    if ! out=$($DOCKER ldd "/usr/local/bin/${bin}" 2>&1); then
      echo "$out"
      FAILED+=("${image}: ${bin} (ldd failed)")
    elif grep "not found" <<< "$out"; then
      FAILED+=("${image}: ${bin} (missing libraries)")
    fi
  done
}

check langutils vhd2vl sv2v slang surelog verible-verilog-syntax svlint
check synthesis ghdl yosys synlig
check simulation ghdl iverilog verilator_bin
check nextpnr-icestorm nextpnr-ice40 icepack
check nextpnr-trellis nextpnr-ecp5 ecppack
check nextpnr-apicula nextpnr-himbaechel

if [ ${#FAILED[@]} -gt 0 ]; then
  echo "Test failed:"
  printf '  %s\n' "${FAILED[@]}"
  exit 1
fi

echo "Test passed"
