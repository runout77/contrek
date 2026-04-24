# Changelog

All notable changes to this project will be documented in this file.

## [1.0.1] - 2025-05-18
### Added
- The project is made available as a Ruby gem

## [1.0.3] - 2025-11-15
### Changed
- Minor changes

## [1.0.5] - 2025-11-16
### Added
- Added ruby side multithreading supports

## [1.0.6] - 2026-01-06
### Added
- Added C++ multithreading supports
- Optimized old just present C++ code
- Removed Png++ dependency in place of libspng

## [1.0.7] - 2026-01-10
### Added
- Optimized C++/Ruby data transfer: Implemented NumPy-compatible binary serialization for coordinate outputs. This reduces serialization overhead and significantly increases data throughput between the C++ core and the Ruby interface.

## [1.0.8] - 2026-01-25
### Changed
- Fixed ARGB/RGBA format discrepancies between Ruby and C++.
- Updated the multithreading-side algorithm for rejoining mono-connected orphan polygons to other orphan polygons. The algorithm can now identify them and defer their processing within the pipeline.
- Improved, on the multithreading side, the polygon intersection detection mechanism; the geometric approach has been dropped in favor of a purely topological one.

## [1.0.9] - 2026-01-31
### Added
- **CMake Integration**: The library is now fully modularized via CMake, enabling seamless integration as a dependency in external C++ projects.
- Multithreading Algorithm Optimization.

## [1.1.0] - 2026-02-08
### Changes
- Resolved connectivity issues between internal zones and the outer boundary.
- Refined the internal parts stitching algorithm (sew method) for better performance.
- Miscellaneous optimizations and improvements.

## [1.1.1] - 2026-02-09
### Changes
- Removed forgotten png++ dependency in Rice bridge file.

## [1.1.2] - 2026-02-09
### Changed
- Transitioned to an Open Core licensing model: Ruby Gem (MIT) and C++ Core Engine (AGPLv3).

## [1.1.3] - 2026-02-21
### Changed
- Added support for 8-way pixel connectivity (omnidirectional) in addition to the standard 4-way mode.
- Optimized C++ and Ruby algorithms for initial spatial pixel tracking to improve performance.

## [1.1.4] - 2026-02-28
### Changed
- Fixed an infinite loop bug in multithreading during inner sequence joining in Omnidirectional mode.
- Optimized C++ and Ruby algorithms for initial spatial tangential sequence determination.

## [1.1.5] - 2026-03-08
### Changed
- **RawBitmap Integration (Ruby/C++):** Introduced a native buffer class for direct contour extraction, bypassing PNG encoding to significantly reduce latency and memory overhead.
- **Tiled Polygon Merger:** Added a spatial merger for `Finder` outputs to stitch polygons from discrete sub-areas (requiring only a 1px overlap). This multi-phase workflow supports coordinate translation and eliminates monolithic buffer requirements, optimizing the peak memory footprint.

## [1.1.6] - 2026-03-21
### Changed
- Added strict_bounds tracing mode: enables more accurate shape tracing by strictly adhering to pixel boundaries.
- Topological Consistency Fixes: improved the Topologically Consistent Merging algorithm to support progressive polygon tracing during sequential data streaming.

## [1.1.7] - 2026-03-23
### Changed
- Removed docs directory from gem.

## [1.1.8] - 2026-04-19
### Changed
- Treemap now available on multiprocessing side too.

## [1.1.9] - 2026-04-24
### Changed
- Improved the internal parts joining algorithm, which was imprecise in some circumstances.
