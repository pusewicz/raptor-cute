set(CF_FRAMEWORK_BUILD_SAMPLES OFF)
set(CF_FRAMEWORK_BUILD_TESTS OFF)
set(CF_FRAMEWORK_STATIC OFF) # TODO: Set to ON for Release build
set(CF_RUNTIME_SHADER_COMPILATION OFF)
set(CF_CUTE_SHADERC OFF) # TODO: Do we want an offline shader compiler?

if(APPLE)
  set(CF_FRAMEWORK_APPLE_FRAMEWORK ON)
endif()

include(FetchContent)
FetchContent_Declare(
  cute
  GIT_REPOSITORY https://github.com/RandyGaul/cute_framework
  GIT_TAG master
  GIT_SHALLOW
)
FetchContent_MakeAvailable(cute)
