# ========================================================================
# conftest.py
# ========================================================================

import os
import pytest

#-------------------------------------------------------------------------
# pytest_addoption
#-------------------------------------------------------------------------

def pytest_addoption(parser):

  parser.addoption( "--waves", action="store_true",
                    help="Dump waveform(s) for the tests run" )

@pytest.fixture
def waves(request):
  return request.config.getoption("--waves")

# ------------------------------------------------------------------------
# Set up the build path
# ------------------------------------------------------------------------

curr_dir_path = os.getcwd()

file_path = os.path.realpath(__file__)
dir_path  = os.path.dirname(file_path)

build_dir_path = os.path.join(dir_path, "build")
test_dir_path  = os.path.join(dir_path, "build")

@pytest.fixture
def top_dir():
  """Return the top-level directory to include from."""
  return dir_path

@pytest.fixture
def build_dir():
  """Return the directory to build cocotb tests in."""
  return build_dir_path

@pytest.fixture
def test_dir():
  """Return the directory to test cocotb tests in."""
  return test_dir_path

# ------------------------------------------------------------------------
# Change to root directory to get includes correct
# ------------------------------------------------------------------------

def pytest_configure(config):
  os.chdir(config.rootdir)
