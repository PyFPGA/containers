# PyFPGA containers

A collection of Docker containers featuring a curated selection of Free/Libre and Open-Source Software (FLOSS) tools for FPGA development.
They streamline the setup process, ensuring consistency and easy access across diverse environments.
Below is a list of the available containers and their included tools.

* `langutils`: utilities for processing and analyzing HDL languages
  * [vhd2vl](https://github.com/ldoolitt/vhd2vl)
  * [Slang](https://github.com/MikePopoloski/slang)
  * [sv2v](https://github.com/zachjs/sv2v)
  * [Verible](https://github.com/chipsalliance/verible)
  * [Surelog](https://github.com/chipsalliance/Surelog)
* `synthesis`: tools for logic synthesis
  * [GHDL](https://github.com/ghdl/ghdl)
  * [Yosys](https://github.com/YosysHQ/yosys)
  * [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin)
  * [yosys-slang](https://github.com/povik/yosys-slang)
  * [synlig](https://github.com/chipsalliance/synlig)
* `simulation`: tools for simulation
  * [GHDL](https://github.com/ghdl/ghdl)
  * [iVerilog](https://github.com/steveicarus/iverilog)
  * [Verilator](https://github.com/verilator/verilator)
  * [cocotb](https://github.com/cocotb/cocotb)

In the CI pipeline, the Dockerfile is used to build a Docker image, which is then pushed to the GitHub Container Registry.
From there, it can be pulled and run as a container whenever needed.

```bash
docker run --user $(id -u):$(id -g) --rm -v $PWD:$PWD -w $PWD ghcr.io/pyfpga/<image> <command>
```

Replace `<image>` with the appropriate image name and `<command>` with the command you want to execute inside the container.
