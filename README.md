# PyFPGA containers

A collection of Docker containers featuring a curated selection of Free/Libre and Open-Source Software (FLOSS) tools for FPGA development.
They streamline the setup process, ensuring consistency and easy access across diverse environments.
Below is a list of the available containers and their included tools.

* `langutils`: utilities for processing and analyzing HDL languages
  * [vhd2vl](https://github.com/ldoolitt/vhd2vl)
  * [Slang](https://github.com/MikePopoloski/slang)
  * [sv2v](https://github.com/zachjs/sv2v)
  * [svlint](https://github.com/dalance/svlint)
  * [Verible](https://github.com/chipsalliance/verible)
  * [Surelog](https://github.com/chipsalliance/Surelog)
* `synthesis`: tools for logic synthesis
  * [GHDL](https://github.com/ghdl/ghdl)
  * [Yosys](https://github.com/YosysHQ/yosys) (now including [sv-elab](https://github.com/povik/sv-elab))
  * [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin)
  * [synlig](https://github.com/chipsalliance/synlig)
* `simulation`: tools for simulation
  * [GHDL](https://github.com/ghdl/ghdl)
  * [iVerilog](https://github.com/steveicarus/iverilog)
  * [Verilator](https://github.com/verilator/verilator)
  * [cocotb](https://github.com/cocotb/cocotb)
* [nextpnr](https://github.com/YosysHQ/nextpnr) based containers: place and route + bitstream manipulation
  * `nextpnr-apicula`: for gowin FPGAs ([apicula](https://github.com/yosyshq/apicula))
  * `nextpnr-icestorm`: for Lattice iCe40 FPGAs ([icestrom](https://github.com/YosysHQ/icestorm))
  * `nextpnr-trellis`: for Lattice ecp5 FPGAs ([trellis](https://github.com/YosysHQ/prjtrellis))

In the CI pipeline, the Dockerfile is used to build a Docker image, which is then pushed to the GitHub Container Registry.
From there, it can be pulled and run as a container whenever needed.

```bash
docker run --user $(id -u):$(id -g) --rm -v $PWD:$PWD -w $PWD ghcr.io/pyfpga/<image> <command>
```

Replace `<image>` with the appropriate image name and `<command>` with the command you want to execute inside the container.

Notes:
* Only `$PWD` is mounted: files outside the current directory (e.g. `../rtl/top.v`) are not visible inside the container. Run from a common parent directory or mount it instead (`-v $HOME:$HOME`).
* `--user $(id -u):$(id -g)` makes generated files belong to you instead of root.
* Each container is independent: a full flow chains several of them (e.g. `yosys` from `synthesis`, then `nextpnr-*` for place and route).

## Executables

| Image | Executables (in `/usr/local/bin` unless stated) |
|---|---|
| `langutils` | `vhd2vl`, `sv2v`, `slang`, `slang-tidy`, `surelog`, `svlint`, `verible-verilog-*` (`syntax`, `lint`, `format`, `ls`, `preprocessor`, ...) |
| `synthesis` | `ghdl`, `yosys` (with `plugin -i ghdl` and `read_slang`), `synlig` |
| `simulation` | `ghdl`, `iverilog`, `vvp`, `verilator`, `verilator_coverage`, `python3` with `cocotb`, `cocotbext-axi`, `pytest`, `wavedrom` |
| `nextpnr-icestorm` | `nextpnr-ice40`, `icepack`, `iceunpack`, `icetime`, `icepll`, `icebram`, `icemulti`, `iceprog`, `icebox_*` |
| `nextpnr-trellis` | `nextpnr-ecp5`, `ecppack`, `ecpunpack`, `ecppll`, `ecpbram`, `ecpmulti` |
| `nextpnr-apicula` | `nextpnr-himbaechel` (gowin uarch), `gowin_pack`, `gowin_unpack`, `gowin_pll` (apycula, Python) |

## Examples

Define a helper (adjust the mount if your sources are outside `$PWD`):

```bash
RUN="docker run --rm -v $PWD:$PWD -w $PWD --user $(id -u):$(id -g) ghcr.io/pyfpga"
```

Language utilities:

```bash
$RUN/langutils sv2v top.sv --write=top.v            # SystemVerilog to Verilog
$RUN/langutils vhd2vl top.vhdl top.v                # VHDL to Verilog
$RUN/langutils slang top.sv --lint-only             # SystemVerilog lint
$RUN/langutils verible-verilog-lint top.sv
```

Synthesis:

```bash
$RUN/synthesis yosys -p 'read_verilog -sv top.sv; synth -top top'
$RUN/synthesis yosys -p 'read_slang top.sv -top top; synth -top top'
$RUN/synthesis yosys -p 'plugin -i ghdl; ghdl top.vhdl -e top; synth -top top'
$RUN/synthesis ghdl synth --out=verilog top.vhdl -e top > top.v
```

Simulation:

```bash
$RUN/simulation iverilog -g2012 -o sim tb.sv top.sv && $RUN/simulation vvp sim
$RUN/simulation verilator --binary --top-module tb tb.sv top.sv
$RUN/simulation python3 test_top.py    # cocotb (cocotb_tools.runner), see tests/cocotb
```

Full flows, synthesis + place and route + bitstream:

```bash
# Lattice iCE40 (iCEstick)
$RUN/synthesis yosys -p 'read_verilog -sv top.sv; synth_ice40 -top top -json top.json'
$RUN/nextpnr-icestorm nextpnr-ice40 --hx1k --package tq144 --pcf top.pcf --json top.json --asc top.asc
$RUN/nextpnr-icestorm icepack top.asc top.bin

# Lattice ECP5 (OrangeCrab)
$RUN/synthesis yosys -p 'read_verilog -sv top.sv; synth_ecp5 -top top -json top.json'
$RUN/nextpnr-trellis nextpnr-ecp5 --25k --package CSFBGA285 --lpf top.lpf --json top.json --textcfg top.config
$RUN/nextpnr-trellis ecppack top.config top.bit

# Gowin (Tang Nano 9K)
$RUN/synthesis yosys -p 'read_verilog -sv top.sv; synth_gowin -top top -json top.json'
$RUN/nextpnr-apicula nextpnr-himbaechel --device GW1NR-LV9QN88PC6/I5 --vopt family=GW1N-9C \
  --vopt cst=top.cst --json top.json --write top_pnr.json
$RUN/nextpnr-apicula gowin_pack -d GW1N-9C -o top.fs top_pnr.json
```

Working examples of every tool (with HDL sources and constraint files) are in [tests](tests).
