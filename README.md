[![C Skeleton Project-CI](https://github.com/salvadorz/c_proj_starter/actions/workflows/cmake.yml/badge.svg?branch=develop)](https://github.com/salvadorz/c_proj_starter/actions/workflows/cmake.yml)

# C project starter (template)

## Prerequisites
The current project is using **`CMake`** as a _build system_ which enables the capability to use [Windows, Linux/Unix, MacOS].

The only prerequisites is to have a 

1) C/C+ compiler (`gcc`,`llvm`,etc)
2) `CMake`
3) `clang-format` (optional)
4) `clang-tidy`   (optional)
5) `gcov` and `lcov`

```bash
sudo apt install build-essential cmake git clang
```

## Project Structure

```sh
.
├── cmake         # Build CMake module configurations (clang-tidy, clang-format, code-coverage).
├── include       # The include directory, with public headers.
├── scripts       # Scripts used by the CI/CD.
├── src           # Source directory.
│   ├── app       # Final Applications.
│   └── lib       # Library sources.
└── tests         # Test code for the apps/libs.

```


## Project Deployment
Once the project is builded the final structure has
```sh
./artifacts/
           ├── bin         # All the app binaries
           ├── include     # The public headers files
           ├── lib         # all static and dynamic libraries
           └── tests       # test binaries

```


