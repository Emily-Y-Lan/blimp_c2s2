//========================================================================
// inst.cpp
//========================================================================
// Functions that operate on instruction specifications

#include <inttypes.h>

#include <algorithm>
#include <cstdio>
#include <format>
#include <iostream>
#include <stdexcept>
#include <vector>

#include "inst.h"

//------------------------------------------------------------------------
// Parse a given assembly into tokens
//------------------------------------------------------------------------

const std::vector<char> delimeters = {' ', ',', '(', ')'};

std::vector<std::string> tokenize(std::string assembly) {
  std::vector<std::string> tokens;
  std::string curr_token = "";

  for (char c : assembly) {
    if (std::find(delimeters.begin(), delimeters.end(), c) !=
        delimeters.end()) {
      if (curr_token.length() > 0) {
        tokens.push_back(curr_token);
      }
      curr_token = "";
    } else {
      curr_token += c;
    }
  }

  if (curr_token.length() > 0) tokens.push_back(curr_token);
  return tokens;
}

//------------------------------------------------------------------------
// Find the appropriate specification
//------------------------------------------------------------------------

std::string get_inst_name(std::string inst_asm) {
  return inst_asm.substr(0, inst_asm.find(" "));
}

inst_spec get_inst_spec(std::string inst_name) {
  for (const inst_spec spec : inst_specs) {
    if (get_inst_name(spec.assembly) == inst_name) {
      return spec;
    }
  }

  // Didn't find instruction spec
  std::string excp = std::format(
      "Couldn't find specification for instruction '{}'", inst_name);
  std::cout << excp << std::endl;
  throw std::invalid_argument(excp);
}

inst_spec get_inst_spec(uint32_t inst_bin) {
  for (const inst_spec spec : inst_specs) {
    if ((inst_bin & spec.mask) == spec.match) {
      return spec;
    }
  }

  // Didn't find instruction spec (don't print, in case running test in
  // background)
  std::string excp = std::format(
      "Couldn't find specification for instruction '0x{:X}'", inst_bin);
  std::cout << excp << std::endl;
  throw std::invalid_argument(excp);
}

//------------------------------------------------------------------------
// Get a specification's name
//------------------------------------------------------------------------

std::string inst_spec_name(inst_spec spec){
  std::string assembly = spec.assembly;
  return assembly.substr(0, assembly.find(" "));
}