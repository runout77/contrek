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
- Removed Png++ dependency in place of libspn

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
