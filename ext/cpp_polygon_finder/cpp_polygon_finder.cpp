/*
 * cpp_polygon_finder.cpp
 *
 *  Created on: 25 apr 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <iostream>
#include <list>
#include <rice/rice.hpp>
#include <rice/stl.hpp>
#include <vector>
#include <map>
#include <string>

#include "PolygonFinder/src/polygon/finder/PolygonFinder.h"
#include "PolygonFinder/src/polygon/finder/PolygonFinder.cpp"
#include "PolygonFinder/src/polygon/finder/NodeCluster.cpp"
#include "PolygonFinder/src/polygon/finder/NodeCluster.h"
#include "PolygonFinder/src/polygon/finder/Node.cpp"
#include "PolygonFinder/src/polygon/finder/Node.h"
#include "PolygonFinder/src/polygon/finder/List.cpp"
#include "PolygonFinder/src/polygon/finder/List.h"
#include "PolygonFinder/src/polygon/finder/Lists.cpp"
#include "PolygonFinder/src/polygon/finder/Lists.h"
#include "PolygonFinder/src/polygon/finder/Polygon.h"
#include "PolygonFinder/src/polygon/bitmaps/Bitmap.h"
#include "PolygonFinder/src/polygon/bitmaps/Bitmap.cpp"
#include "PolygonFinder/src/polygon/bitmaps/FastPngBitmap.h"
#include "PolygonFinder/src/polygon/bitmaps/FastPngBitmap.cpp"
#include "PolygonFinder/src/polygon/bitmaps/RemoteFastPngBitmap.h"
#include "PolygonFinder/src/polygon/bitmaps/RemoteFastPngBitmap.cpp"
#include "PolygonFinder/src/polygon/matchers/Matcher.h"
#include "PolygonFinder/src/polygon/matchers/Matcher.cpp"
#include "PolygonFinder/src/polygon/matchers/ValueNotMatcher.h"
#include "PolygonFinder/src/polygon/matchers/ValueNotMatcher.cpp"
#include "PolygonFinder/src/polygon/matchers/RGBMatcher.h"
#include "PolygonFinder/src/polygon/matchers/RGBMatcher.cpp"
#include "PolygonFinder/src/polygon/matchers/RGBNotMatcher.h"
#include "PolygonFinder/src/polygon/matchers/RGBNotMatcher.cpp"
#include "PolygonFinder/src/polygon/reducers/Reducer.cpp"
#include "PolygonFinder/src/polygon/reducers/Reducer.h"
#include "PolygonFinder/src/polygon/reducers/UniqReducer.cpp"
#include "PolygonFinder/src/polygon/reducers/UniqReducer.h"
#include "PolygonFinder/src/polygon/reducers/LinearReducer.cpp"
#include "PolygonFinder/src/polygon/reducers/LinearReducer.h"
#include "PolygonFinder/src/polygon/reducers/VisvalingamReducer.cpp"
#include "PolygonFinder/src/polygon/reducers/VisvalingamReducer.h"
#include "png++/png.hpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Finder.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Finder.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Poolable.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Poolable.cpp"
#include "PolygonFinder/src/polygon/finder/FinderUtils.h"
#include "PolygonFinder/src/polygon/finder/FinderUtils.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/ClippedPolygonFinder.h"
#include "PolygonFinder/src/polygon/finder/concurrent/ClippedPolygonFinder.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Tile.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Tile.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Polyline.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Polyline.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Partitionable.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Partitionable.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Shape.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Shape.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/FakeCluster.h"
#include "PolygonFinder/src/polygon/finder/concurrent/FakeCluster.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Cluster.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Cluster.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Hub.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Hub.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Part.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Part.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Position.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Position.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/EndPoint.h"
#include "PolygonFinder/src/polygon/finder/concurrent/EndPoint.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Cursor.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Cursor.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/Sequence.h"
#include "PolygonFinder/src/polygon/finder/concurrent/Sequence.cpp"
#include "PolygonFinder/src/polygon/finder/concurrent/PartPool.h"
#include "PolygonFinder/src/polygon/finder/concurrent/PartPool.cpp"
extern "C" {
  #include "PolygonFinder/src/polygon/bitmaps/spng.h"
}

using namespace Rice;

namespace Rice::detail
{ template<>
  class To_Ruby<std::vector<Point*>>
  { public:
      VALUE convert(const std::vector<Point*>& x)
      { Rice::Array arr;
        for (Point* p : x)
          arr.push(p);
        return arr;
      }
  };

  template<>
  class To_Ruby<std::list<std::vector<Point*>>>
  { public:
      VALUE convert(const std::list<std::vector<Point*>>& x)
      { Rice::Array arr;
        for (const std::vector<Point*>& vec : x)
        { arr.push(vec);
        }
        return arr;
      }
  };

  template<>
  class To_Ruby<Point*>
  { public:
      VALUE convert(Point* const & x)
      {  Rice::Hash h = Rice::Hash();
         h[Symbol("x")] = x->x;
         h[Symbol("y")] = x->y;
         return(h);
      }
  };

  template<>
  class To_Ruby<std::map<std::string, double>*>
  { public:
      VALUE convert(std::map<std::string, double>* const & x)
      { Rice::Hash return_me = Rice::Hash();
        std::map<std::string, double>::iterator it;
        for ( it = x->begin(); it != x->end(); it++ )
        {  return_me[String(it->first)] = it->second;
        }
        return return_me;
      }
  };

  template<>
  class From_Ruby<std::vector<std::string>*>
  { public:
    Convertible is_convertible(VALUE value)
    { switch (rb_type(value))
      { case RUBY_T_HASH:
          return Convertible::Cast;
          break;
        default:
          return Convertible::None;
      }
    }
    std::vector<std::string>* convert(VALUE value)
    { std::vector<std::string> *arguments = new std::vector<std::string>();
      if (rb_type(value) == RUBY_T_NIL) return(arguments);
      Rice::Hash hash = (Rice::Hash) value;
      for (Rice::Hash::iterator it = hash.begin(); it != hash.end(); ++it) {
        Rice::String keyString = it->key.to_s();
        Rice::Object value = it->value;
        switch (value.rb_type()) {
          case T_STRING:
            arguments->push_back("--" + keyString.str()+"="+((Rice::String) value).str());
            break;
          case T_SYMBOL:
            arguments->push_back("--" + keyString.str()+"="+((Rice::Symbol) value).str());
            break;
          case T_FLOAT:
            arguments->push_back("--" + keyString.str()+"="+std::to_string(NUM2DBL(value.value())));
            break;
          case T_FIXNUM:
            arguments->push_back("--" + keyString.str()+"="+std::to_string(NUM2INT(value.value())));
            break;
          case T_TRUE:
            arguments->push_back("--" + keyString.str()+"=true");
            break;
          case T_FALSE:
            arguments->push_back("--" + keyString.str()+"=false");
            break;
          case T_HASH:
            std::vector<std::string>* iv = From_Ruby<std::vector<std::string>*>::convert(value);
            for (std::vector<std::string>::iterator it_iv = iv->begin() ; it_iv != iv->end(); ++it_iv)
            { (*it_iv).replace(0, 2, "_");
              arguments->push_back("--" + keyString.str() + *it_iv);
            }
            break;
         }
      }
      return arguments;
    }
  };

  template<>
  struct Type<ProcessResult>
  { static bool verify()
    { return true;
    }
  };

  template<>
  class To_Ruby<ProcessResult*>
  { public:
    VALUE convert(ProcessResult* const & pr)
    { Rice::Hash return_me = Rice::Hash();
      return_me[Symbol("benchmarks")] = &pr->benchmarks;
      return_me[Symbol("groups")] = pr->groups;
      return_me[Symbol("named_sequence")] = pr->named_sequence;
      Rice::Array out;
      for (Polygon& x : pr->polygons)
      { Rice::Hash h = Rice::Hash();
        h[Symbol("outer")] = x.outer;
        h[Symbol("inner")] = x.inner;
        out.push(h);
      }
      return_me[Symbol("polygons")] = out;
      Rice::Array tmapout;
      for (const auto& tm : pr->treemap) {
        Rice::Array tmentry;
        tmentry.push(tm.first);   // outer
        tmentry.push(tm.second);  // inner
        tmapout.push(tmentry);
      }
      return_me[Symbol("treemap")] = tmapout;
      delete pr;
      return(return_me);
    }
  };
}  // namespace Rice::detail

extern "C"
void Init_cpp_polygon_finder() {
  Data_Type<Bitmap> rb_cBitmap =
    define_class<Bitmap>("CPPBitMap")
    .define_constructor(Constructor<Bitmap, std::string, int>())
    .define_method("value_set", &Bitmap::value_set)
    .define_method("value_at", &Bitmap::value_at)
    .define_method("w", &Bitmap::w)
    .define_method("h", &Bitmap::h)
    .define_method("error", &Bitmap::error)
    .define_method("clear", &Bitmap::clear)
    .define_method("print", &Bitmap::print);

  Data_Type<RemoteFastPngBitmap> rb_cRemotePngBitmap =
    define_class<RemoteFastPngBitmap, Bitmap>("CPPRemotePngBitMap")
    .define_constructor(Constructor<RemoteFastPngBitmap, std::string*>(), Arg("url"))
    .define_method("value_set", &FastPngBitmap::value_set)
    .define_method("value_at", &FastPngBitmap::value_at)
    .define_method("rgb_value_at", &FastPngBitmap::rgb_value_at)
    .define_method("w", &FastPngBitmap::w)
    .define_method("h", &FastPngBitmap::h)
    .define_method("error", &FastPngBitmap::error)
    .define_method("print", &FastPngBitmap::print);

  Data_Type<FastPngBitmap> rb_cPngBitmap =
    define_class<FastPngBitmap, Bitmap>("CPPPngBitMap")
    .define_constructor(Constructor<FastPngBitmap, std::string>(), Arg("filename"))
    .define_method("value_set", &FastPngBitmap::value_set)
    .define_method("value_at", &FastPngBitmap::value_at)
    .define_method("rgb_value_at", &FastPngBitmap::rgb_value_at)
    .define_method("w", &FastPngBitmap::w)
    .define_method("h", &FastPngBitmap::h)
    .define_method("error", &FastPngBitmap::error)
    .define_method("print", &FastPngBitmap::print);

  Data_Type<Matcher> rb_cMatcher =
    define_class<Matcher>("CPPMatcher")
    .define_constructor(Constructor<Matcher, char>())
    .define_method("match", &Matcher::match);

  Data_Type<ValueNotMatcher> rb_cValueNotMatcher =
    define_class<ValueNotMatcher, Matcher>("CPPValueNotMatcher")
    .define_constructor(Constructor<ValueNotMatcher, char>())
    .define_method("match", &ValueNotMatcher::match);

  Data_Type<RGBMatcher> rb_cRGBMatcher =
    define_class<RGBMatcher, Matcher>("CPPRGBMatcher")
    .define_constructor(Constructor<RGBMatcher, unsigned int>())
    .define_method("match", &RGBMatcher::match);

  Data_Type<RGBNotMatcher> rb_cRGBNotMatcher =
    define_class<RGBNotMatcher, Matcher>("CPPRGBNotMatcher")
    .define_constructor(Constructor<RGBNotMatcher, int>())
    .define_method("match", &RGBNotMatcher::match);

  Data_Type<PolygonFinder> rb_cPolygonFinder =
    define_class<PolygonFinder>("CPPPolygonFinder")
    .define_constructor(Constructor<PolygonFinder, Bitmap*, Matcher*, Bitmap*, std::vector<std::string>*>(), Arg("bitmap"), Arg("matcher"), Arg("test_bitmap") = nullptr, Arg("options") = nullptr)
    .define_method("get_shapelines", &PolygonFinder::get_shapelines)
    .define_method("process_info", &PolygonFinder::process_info);

  Data_Type<Finder> rb_cFinder =
    define_class<Finder>("CPPFinder")
    .define_constructor(Constructor<Finder, int, Bitmap*, Matcher*, std::vector<std::string>*>(), Arg("number_of_threads"), Arg("bitmap"), Arg("matcher"), Arg("options") = nullptr)
    .define_method("process_info", &Finder::process_info);
}
