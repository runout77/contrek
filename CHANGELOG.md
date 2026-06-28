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

## [1.2.0] - 2026-05-02
### Changed
- Further improvements have been applied to the internal parts joining algorithm using a new structural approach. This update is faster and resolves edge cases where inner parts were mistakenly classified as outer perimeters, ensuring precise contour hierarchy. The simplified logic has led to a significant reduction in codebase complexity and the removal of substantial redundant code.

## [1.2.1] - 2026-05-09
### Changed
- Some c++ optimizations.

## [1.2.2] - 2026-05-20
### Changed
- The treemap determination algorithm has been heavily optimized. Calls to the geometric routine that checks whether a newly generated inner polyline encloses other already-existing ones have been reduced to the minimum. Polylines adjacent to the shared overlap stripe are now excluded from these checks, as they are already identified during the initial polygon detection phase. The geometric approach remains unavoidable in this context and is still a performance bottleneck. It will certainly be the subject of future optimizations.

## [1.2.3] - 2026-05-23
### Changed
* **SVG Conversion:** Added utility methods to convert point coordinates directly into SVG paths.
* **Contrek API & RAII Architecture:** Refactored the Contrek API to utilize an RAII (Resource Acquisition Is Initialization) pattern, safely wrapping both the trace engine and the processing results within a unified context lifecycle shell.
* **ProcessResult Memory Management:** Updated `ProcessResult` to properly manage resource deallocation during cloning operations, ensuring deep-copied or moved internal points are automatically and safely freed when the context scope ends.

## [1.2.4] - 2026-05-26
### Changed
* Fixed an issue in connectivity8 tracing mode that, under specific rare conditions, disrupted the topological continuity of external contours in favor of internal ones.

## [1.2.5] - 2026-05-27
### Changed
- **Refactored `ProcessResult.clone()`:** Switched from fragmented dynamic allocation to a contiguous `std::vector` with explicit `.reserve()`. Eliminates heap fragmentation during high-res streaming.

## [1.2.6] - 2026-05-31
### Changed
- **Refactored `spng.c` function `rgb8_row_to_rgba8`:** Extended a loop counter to `size_t` (previously limited to `uint32_t`), which was causing segmentation faults when reading massive images (e.g., 81920x81920).
- **Refactored `RawBitmap.define` function:** Updated area and size calculations to use full 64-bit integers.
- **Refactored `PolygonFinder.to_svg_stream()` function:** Optimized performance to efficiently handle massive SVG streams of 2 GB and beyond.

## [1.2.7] - 2026-06-02
### Changed
- **Refactored `bounds` option:** Starting from this release, precalculated bounds for each polygon can now be requested in concurrent mode as well, in addition to single-threaded mode.

## [1.2.8] - 2026-06-07
- **Optimize main pixel scanning loop:** Implemented 4-way loop unrolling to maximize L1 cache hits and eliminate redundant RAM lookups via direct register bit-casting.

## [1.2.9] - 2026-06-13
- **Streaming merger:** The streaming merger class extends VerticalMerger and adds a useful feature: the progressive extraction of contours into a disk buffer (SVG file). In this way, all extracted polygons that are no longer within the junction zone of the next stripe are removed from the system and streamed directly to disk. This incredibly reduces memory consumption, allowing the processing of very large files on machines with low memory availability, at the expense of increased processing times. An example of this technique is available in both C++ and Ruby in the repository.

## [1.3.0] - 2026-06-17
- **Streaming merger:** Improvements and bug fixing.
- **CPP code:** All structures now own 'Point' instances by value instead of raw pointers. Removed now-redundant `clone()` method; results from `process_info()` are already self-contained since points are owned by value, so the defensive deep copy is no longer needed.

## [1.3.1] - 2026-06-20
- **Streaming merger:** The progressive streaming extraction mode has now reached new heights of efficiency on the C++ side. This mode allows the data source to be processed in contiguous blocks. All isolated polygons, as well as those extending into the bottom strips, are removed from the list and streamed directly to the SVG file. This drastically reduces RAM requirements. An extreme test on an 81920×81920 pixel image containing a massive number of polygons (20,000,000) was processed using roughly 40 strips of 2000 pixels each in less than 300 seconds, peaking at a RAM usage of just 13GB.

## [1.3.2] - 2026-06-27
- **Streaming merger:** A series of optimizations have been implemented at the C++ memory pool level; using a different strategy, these are now freed as soon as possible depending on the source data content and the morphology of the containing polygons. This has allowed for a further reduction in the peak memory indicated in the previous changelog, specifically from 13GB to 4.3GB, on the same image with 20,000,000 polygons.

## [1.3.3] - 2026-06-28
- **GeoJsonStreamingMerger:** Fixes both Ruby and CPP side.
