#=========================================================================
# cocotb.py
#=========================================================================
# Utilities for using cocotb

import cocotb
from cocotb.runner import get_runner
import inspect
import os
import pytest

def _get_tests(module):
  """Get all of the tests from within a module.

  Args:
      module (ModuleType): The module to get the tests from

  Returns:
      list[str]: The names of all test functions in the module
  """
  return [
    func.__name__ for func in vars(module).values() 
    if isinstance(func, cocotb.regression.Test)
  ]

def _param_name(params):
  """Return the name to be used when testing the given parameter.

  Args:
      param (dict[str, object] | None): The current parameter

  Returns:
      str: The name to use for the pytest test
  """
  if params is None:
    return "noparams"
  else:
    return "__".join([
      f"{str(param)}_{str(name)}" for param, name in params.items()
    ])

def gen_tests(
    hdl_toplevel,
    sources,
    params_to_try
  ):
  """Generate tests for a specific Verilog module.
  
  This should be called from within the testing module, and
  will generate tests within that module.

  Args:
      hdl_toplevel (str): The name of the top-level module
      sources (list[str]): The sources to explicitly include. This is usually
        only one, as the rest are included from the root
      parameters (list[dict[str, object]], optional): A list of parameter
        mappings to parametrize over. Defaults to [None].
  """
  parent_frame = inspect.currentframe().f_back
  parent_module = inspect.getmodule(parent_frame)

  tests = _get_tests(parent_module)

  # Define the test
  @pytest.mark.parametrize("params", params_to_try, ids = _param_name)
  @pytest.mark.parametrize("test", tests)
  def test_func(test, params, top_dir, build_dir, test_dir, waves, request):
    """Run a given test on the Verilog module.

    Args:
        test (_type_): The test to run
        params (_type_): The parameters to use
        top_dir (_type_): The top-level directory
        build_dir (_type_): The build directory
        test_dir (_type_): The test directory
        waves (_type_): Whether to include waves or not
        request (_type_): The pytest request for testing
    """
    build_dir = os.path.join(build_dir, "build_" + _param_name(params))
    test_dir = os.path.join(test_dir, request.node.name)

    # Create, build, and run a runner
    runner = get_runner("verilator")
    runner.build(
        sources = sources,
        hdl_toplevel = hdl_toplevel,
        includes = [top_dir],
        build_dir = build_dir,
        parameters = params,
        waves = waves
    )
    runner.test(
        hdl_toplevel = hdl_toplevel,
        test_module = parent_module.__name__,
        build_dir = build_dir,
        test_dir = test_dir,
        testcase = test,
        extra_env = params,
        waves = waves
    )

  # Inject the test back into the module
  setattr(parent_module, f"test_{hdl_toplevel}", test_func)
