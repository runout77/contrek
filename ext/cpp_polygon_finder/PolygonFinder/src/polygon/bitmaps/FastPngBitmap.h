/*
 * FastPngBitmap.h
 *
 *  Created on: 17 gen 2019
 *      Author: ema
 */

#ifndef POLYGON_BITMAPS_FASTPNGBITMAP_H_
#define POLYGON_BITMAPS_FASTPNGBITMAP_H_

#include "Bitmap.h"
#include <vector>
#include <cstddef>
class RGBMatcher;

static const std::string base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

class FastPngBitmap : public Bitmap {
public:
  FastPngBitmap(std::string filename);
  virtual ~FastPngBitmap();
  bool pixel_match(int x,int y,Matcher *matcher);
  int h();
  int w();
  virtual int error();
  char value_at(int x,int y);
  unsigned int rgb_value_at(int x,int y);
protected:
  std::vector<unsigned char> buffer;
  std::vector<unsigned char> base64_decode(std::string &encoded_string);
  std::vector<unsigned char> image;
  unsigned long width,height;
  unsigned char *last_red = nullptr;
  int png_error;
  int decodePNG(std::vector<unsigned char>& out_image, unsigned long& image_width, unsigned long& image_height, const unsigned char* in_png, size_t in_size, bool convert_to_rgba32 = true);

private:
  void loadFile(std::vector<unsigned char>& buffer, const std::string& filename);

};

#endif /* POLYGON_BITMAPS_FASTPNGBITMAP_H_ */
