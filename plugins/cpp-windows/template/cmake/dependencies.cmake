# Every third-party dependency, fetched at configure time from a pinned
# release archive and built from source as a static library. Add new ones
# here, each with a URL to a release archive and its SHA-256.

include(FetchContent)

set(BUILD_SHARED_LIBS OFF)

FetchContent_Declare(
  Catch2
  URL https://github.com/catchorg/Catch2/archive/refs/tags/v3.16.1.tar.gz
  URL_HASH SHA256=d16bd1b8b2364918bd472cb216394acb93bde6784890df0d91bccfb3f28d777d
  SYSTEM
  EXCLUDE_FROM_ALL)

FetchContent_MakeAvailable(Catch2)
