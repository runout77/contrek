# ⚡ Contrek Performance Tuning

This document describes optional dependencies and configuration tips to get the best performance out of Contrek on large images.

All optimizations are **optional** — Contrek works correctly without any of them. However, on high-resolution images (10k×10k and above), the combined effect is significant.

---

## Benchmark Reference

> System: AMD Ryzen 7 3700X 8-Core Processor (BogoMIPS: 7199,99) on Ubuntu distro
> Image: 20480×20480 pixels — 8 threads / 8 tiles
>
> **Note:** Benchmarks were measured inside a VMware virtual machine.

| Configuration | Time |
|---|---|
| Baseline (no tuning) | 5316 ms |
| **Fully tuned** | **2938.05 ms** |

---

## 1. zlib-ng — Faster PNG Decoding

**Impact: ~57% reduction in PNG decode time**

Contrek uses [libspng](https://libspng.org/) for PNG decoding, which internally relies on zlib for decompression. [zlib-ng](https://github.com/zlib-ng/zlib-ng) is a high-performance, drop-in replacement for zlib that uses modern CPU instructions (AVX2, SSE4) to significantly accelerate deflate decompression.

If zlib-ng is not installed, standard zlib is used automatically — no errors, just slower PNG decoding.

### Installation

**Ubuntu / Debian** — not available in standard repos, build from source:

```bash
git clone https://github.com/zlib-ng/zlib-ng.git
cd zlib-ng && mkdir build && cd build
cmake .. -DZLIB_COMPAT=ON -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
sudo ldconfig
```

> ⚠️ The `-DZLIB_COMPAT=ON` flag is mandatory. Without it, zlib-ng uses a different ABI and CMake's `find_package(ZLIB)` won't detect it.

**macOS:**
```bash
brew install zlib-ng
```

**Arch Linux:**
```bash
sudo pacman -S zlib-ng
```

After installation, rebuild Contrek — CMake will automatically detect zlib-ng in `/usr/local` and use it instead of system zlib.

---

## 2. tcmalloc — Faster Memory Allocation

**Impact: significant reduction in allocator contention under multithreaded load**

Contrek creates and destroys large numbers of small objects during processing. Under multithreaded workloads, the standard glibc allocator serializes many of these operations, causing thread contention. [tcmalloc](https://github.com/google/tcmalloc) (Thread-Caching Malloc) is Google's high-performance allocator that maintains per-thread caches, dramatically reducing lock contention.

### Installation

**Ubuntu / Debian:**
```bash
sudo apt-get install libgoogle-perftools-dev
```

**macOS:**
```bash
brew install gperftools
```

CMake will detect tcmalloc automatically. You will see this confirmation during the build:
```
-- Contrek: tcmalloc found in /usr/lib/x86_64-linux-gnu/libtcmalloc.so
```

### Tuning tcmalloc cache size

For large images with many threads, increasing the per-thread cache size reduces requests to the central allocator. Add this at the very beginning of your `main()`:

```cpp
#include <gperftools/malloc_extension.h>

int main() {
    MallocExtension::instance()->SetNumericProperty(
        "tcmalloc.max_total_thread_cache_bytes",
        1024 * 1024 * 1024  // 1GB total thread cache
    );
    // ...
}
```

The default is 32MB total. On systems with 16GB+ RAM, 1GB is a safe value that virtually eliminates allocator contention.

---

## 3. Thread and Tile Configuration

**Impact: up to ~35% reduction in processing time on multi-core systems**

Contrek splits the image into vertical tiles processed in parallel. The optimal configuration depends on your hardware.

### General rule

Set both `threads` and `tiles` to the number of **physical cores** on your machine.

```cpp
Contrek::Config cfg;
cfg.threads = 8;  // match your physical core count
cfg.tiles   = 8;  // same as threads for best results
```

```ruby
result = Contrek.contour!(
  png_file_path: "image.png",
  options: {
    number_of_threads: 8,
    finder: { number_of_tiles: 8 }
  }
)
```

### Why threads == tiles?

- **Fewer tiles than threads**: some cores sit idle waiting for others to finish
- **More tiles than threads**: merge overhead increases without adding parallelism  
- **threads == tiles**: optimal balance between parallel scan and merge cost

Consider this depends your system. Probably is better not to saturate all cores leaving one ot two to the system and the others to Contrek. So on 8 cpu core 6 thread/tiles at maximum.

---

## 4. Combining All Optimizations

Install zlib-ng and tcmalloc, then configure:

```ruby
# Ruby
result = Contrek.contour!(
  png_file_path: "large_image.png",
  options: {
    number_of_threads: 8,   # match your core count (or 1-2 less)
    class: "value_not_matcher",
    color: { r: 255, g: 255, b: 255, a: 255 },
    finder: {
      number_of_tiles: 8,   # same as threads
      compress: { uniq: true }
    }
  }
)
```

```cpp
// C++ standalone
#include <gperftools/malloc_extension.h>
#include "ContrekApi.h"

int main() {
    MallocExtension::instance()->SetNumericProperty(
        "tcmalloc.max_total_thread_cache_bytes",
        1024 * 1024 * 1024
    );

    Contrek::Config cfg;
    cfg.threads = 8;
    cfg.tiles   = 8;

    auto result = Contrek::trace("large_image.png", cfg);
    std::cout << "Time: " << result->total_time << " ms" << std::endl;
}
```