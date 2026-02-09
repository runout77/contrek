# Licensing Information

Contrek is distributed under a dual-license model:

### 1. Ruby Gem & Infrastructure
The Ruby code, wrappers, and gem packaging are licensed under the **MIT License**.
You are free to use, modify, and distribute this part of the project in any application, including commercial ones, with minimal restrictions.

### 2. C++ Core Engine (ext/cpp_polygon_finder/PolygonFinder)
The standalone C++17 engine, which contains the high-performance tile-based loading and contour tracking logic, is licensed under the **GNU Affero General Public License v3 (AGPLv3)**.

**What this means for you:**
- **Reciprocity:** If you modify the C++ core engine to improve performance or features, you must share those modifications under the same AGPLv3 license.
- **Network Services (SaaS):** If you run a public service that leverages the C++ core engine, you must make the source code of your version of the core available to the users of that service.
- **Commercial Use:** If your organization cannot comply with the AGPLv3 for the C++ core, please contact the author for a private commercial license.

For the full license texts, see [LICENSE-MIT](LICENSE-MIT.md) and [LICENSE_AGPL](ext/cpp_polygon_finder/PolygonFinder/LICENSE_AGPL.txt).
