cmake_minimum_required (VERSION 3.9)
project (nix-fetchgit)
set (nix-fetchgit_VERSION_MAJOR 0)
set (nix-fetchgit_VERSION_MINOR 1)
set (nix-fetchgit_VERSION_PATCH 0)

find_package(PkgConfig)

pkg_check_modules(NIX REQUIRED nix-expr>=2.1 nix-main>=2.1 nix-store>=2.1)

if(APPLE)
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -flat_namespace -undefined suppress")
endif()

add_compile_definitions(SYSTEM="foobar")

add_library(nix-fetchgit MODULE fetchGit.cc)
target_include_directories(nix-fetchgit PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(nix-fetchgit PUBLIC ${NIX_INCLUDE_DIRS})
target_compile_options(nix-fetchgit PUBLIC ${NIX_CFLAGS_OTHER})

install(TARGETS nix-fetchgit DESTINATION lib/nix/plugins)
