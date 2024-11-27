# BLIMP
BRG’s Luculently Interfaced Modular Processor

<p align="center">
  <img src="docs/_static/img/blimp_no_border.png" alt="A tech-inspired blimp" width="50%"/>
</p>

## Documentation

The main documentation for Blimp can be found on the [GitHub Pages](https://cornell-brg.github.io/blimp/)

## Testing

Blimp uses Verilator to simulate and run tests. Users should first create a build directory and generate a build system with CMake:

```bash
mkdir build
cd build
cmake ..
```

From there, users can run any individual test by specifying its name as a target:

```bash
make ALU_test
```

Known tests can be listed with the `list` target. Additionally, the `check` target can be used to run all tests with `ctest`.

Running tests as shown above can often be slow; users may additionally want to specify a level of parallelism (ex. `make -j ALU_test`) or specify a different
backend when generating the build system (ex. `cmake .. -GNinja`)
