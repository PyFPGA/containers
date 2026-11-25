"""Smoke test: build and simulate counter.sv with the cocotb runner."""

from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge
from cocotb_tools.runner import get_runner

HDL = Path(__file__).resolve().parent.parent / "hdl"


@cocotb.test()
async def counter_counts(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    dut.rst.value = 1
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    start = int(dut.count.value)
    await ClockCycles(dut.clk, 5)
    assert int(dut.count.value) == (start + 5) % 16


def test_counter(simulator="verilator"):
    runner = get_runner(simulator)
    build_dir = Path("/tmp") / f"cocotb_{simulator}"
    runner.build(sources=[HDL / "counter.sv"], hdl_toplevel="counter",
                 build_dir=build_dir, timescale=("1ns", "1ps"), always=True)
    runner.test(hdl_toplevel="counter", test_module="test_counter",
                test_dir=Path(__file__).parent, build_dir=build_dir,
                results_xml=build_dir / "results.xml")


if __name__ == "__main__":
    import sys
    test_counter(*sys.argv[1:])
