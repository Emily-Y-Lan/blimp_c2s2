# ========================================================================
# tests.cmake
# ========================================================================
# Identify all of Blimp's sub-tests

set(BLIMP_VERSIONS
  BlimpV1
  BlimpV2
)

set(BlimpV1_TESTS
  BlimpV1_test/BlimpV1_add_test.v
  BlimpV1_test/BlimpV1_addi_test.v
  BlimpV1_test/BlimpV1_mul_test.v
)

set(BlimpV2_TESTS
  BlimpV2_test/BlimpV2_add_test.v
  BlimpV2_test/BlimpV2_addi_test.v
  BlimpV2_test/BlimpV2_mul_test.v
)