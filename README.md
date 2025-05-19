# Contrek
Contrek is a Ruby library (C++ powered) to trace png bitmap areas polygonal contours. Manages png images usign png++ and picoPNG (version 20101224) libraries. 

## About Contrek library
Contrek (contour trekking) simply scans your png bitmap and returns shape contour as close polygonal lines, both for the external and internal sides. It can compute the nesting level of the polygons found with a tree structure. It supports various levels and modes of compression and approximation of the found coordinates.

In the following image all the non-white pixels have been examined and the result is the red polygon for the outer contour and the green one for the inner one
![alt text](contrek.png "Contour tracing")

## Install

Add this line to your application's Gemfile:

```ruby
gem 'contrek'
```

And then execute:

    bundle install

This will install the gem and compile the native extensions. If you get
`fatal error: png++/png.hpp: No such file or directory`

means that you have to install png++ on your system which Contrek C++ code depends on; visit http://download.savannah.nongnu.org/releases/pngpp/
Grab the lattest file (here 0.2.9) 
Go to download directory. Extract to /usr/src with 

    sudo tar -zxf png++-0.2.9.tar.gz -C /usr/src
Change directory to

    cd /usr/src/png++-0.2.9/
Do make and make install

    make
    make install

## Usage
In this example we are asking to examine any pixel that does not have the red color.

```ruby
result = Contrek.contour!(
  png_file_path: "labyrinth3.png",
  options: {
    class: "value_not_matcher",
    color: {r: 255, g: 0, b: 0, a: 255}
  }
)
```
The result reports information about the execution times (microseconds), the polygons found, their coordinates and the nesting tree.
```ruby
{:benchmarks=>{"build_tangs_sequence"=>0.129, "compress"=>0.037, "plot"=>0.198, "scan"=>0.114, "total"=>0.478}, :groups=>2, :named_sequence=>"", :polygons=>[...], :treemap=>[]}

```

By default the C++ version is used. If you want run pure but slower ruby implementation
```ruby
result = Contrek.contour!(
  png_file_path: "labyrinth3.png",
  options: {
    native: false, # force ruby pure
    class: "value_not_matcher",
    color: {r: 241, g: 156, b: 156, a: 255}
  }

```

You can bypass the helper and access low level (here the CPP classes)

```ruby
png_bitmap = CPPPngBitMap.new("labyrinth3.png")
rgb_matcher = CPPRGBNotMatcher.new(png_bitmap.rgb_value_at(0, 0))
polygonfinder = CPPPolygonFinder.new(png_bitmap,
  rgb_matcher,
  nil,
  {versus: :a, compress: {visvalingam: {tolerance: 1.5}}})
result = polygonfinder.process_info
# draws the polygons found
Contrek::Bitmaps::Painting.direct_draw_polygons(result[:polygons], png_image)
png_image.save('result.png') # => inspect the image to feedback the result
```

You can also read base64 png images
```ruby
png_bitmap = CPPRemotePngBitMap.new("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==")
```

## Performances native vs pure
One of the most complex test you can find under the spec folder is named "scans poly 1200x800", scans this [image](spec/files/images/sample_1200x800.png) computing coordinates to draw polygons drawn in this [result](spec/files/stored_samples/sample_1200x800.png).
On pure ruby implementation kept time
```ruby
{ :scan=>1063.146,
  :build_tangs_sequence=>287.114,
  :plot=>79.329,
  :compress=>0.001,
  :total=>1429.59}
```
This the one for the native C++
```ruby
{ :scan=>43.521,
  :build_tangs_sequence=>44.105,
  :plot=>35.718,
  :compress=>0.001,
  :total=>123.34500000000001}
```

About 10 x faster. Times are in microseconds; system: AMD Ryzen 7 3700X 8-Core Processor (BogoMIPS: 7199,99). 

## License

This project is licensed under the terms of the MIT license.

See [LICENSE.md](LICENSE.md).

## History
The algorithm was originally developed by me in 2018 when I was commissioned to create a Rails web application whose main objective was to census buildings from GoogleMAPS; the end user had to be able to select their home building by clicking its roof on the map which had to be identified as a clickable polygon. The solution was to configure GoogleMAPS to render buildings of a well-defined color (red), and at each refresh of the same to transform the div into an image (html2canvas) then process it server side returning the polygons to be superimposed again on the map. This required very fast polygons determination. Searching for a library for tracing the contours I was not able to find anything better except OpenCV which however seemed to me a very heavy dependency. So I decided to write my algorithm directly in the context of the ROR application. Once perfected, it was already usable but a bit slow in the higher image resolutions. So I decided to write the counterpart in C++, which came out much faster and which I then used as an extension on Ruby by means of Rice.

I thought that the algorithm had excellent qualities but I never had the time to develop it further. A few months ago I decided to publish it as a gem, freely usable. The gem includes the C++ extension. There is also a [Rails 7.1 demo project](https://github.com/runout77/contrek_rails) that uses the gem and proposes the same scheme I described above. Starting from a GoogleMAPS map, the server receives the image and returns the outlines to be drawn again on the same. It is a great way to test an applicative use of this gem. Enjoy!.