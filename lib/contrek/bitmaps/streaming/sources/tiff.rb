# frozen_string_literal: true

require "ffi"

module Contrek
  module Bitmaps
    module Streaming
      module Sources
        class Tiff
          attr_reader :width, :height, :geo_localization

          module LibTiff
            extend FFI::Library

            ffi_lib "tiff"

            TIFFTAG_IMAGEWIDTH = 256
            TIFFTAG_IMAGELENGTH = 257
            TIFFTAG_BITSPERSAMPLE = 258
            TIFFTAG_PHOTOMETRIC = 262
            TIFFTAG_SAMPLESPERPIXEL = 277
            TIFFTAG_PLANARCONFIG = 284
            TIFFTAG_SAMPLEFORMAT = 339
            TIFFTAG_MODELPIXELSCALE = 33550
            TIFFTAG_MODELTIEPOINT = 33922
            TIFFTAG_MODELTRANSFORMATION = 34264

            PHOTOMETRIC_MINISWHITE = 0
            PHOTOMETRIC_MINISBLACK = 1
            PHOTOMETRIC_RGB = 2

            PLANARCONFIG_CONTIG = 1

            SAMPLEFORMAT_UINT = 1

            attach_function :TIFFOpen, [:string, :string], :pointer
            attach_function :TIFFClose, [:pointer], :void
            attach_function :TIFFGetField, [:pointer, :uint32, :varargs], :int
            attach_function :TIFFGetFieldDefaulted, [:pointer, :uint32, :varargs], :int
            attach_function :TIFFScanlineSize64, [:pointer], :uint64
            attach_function :TIFFReadScanline, [:pointer, :pointer, :uint32, :uint16], :int
            attach_function :TIFFIsTiled, [:pointer], :int
            attach_function :TIFFSetWarningHandler, [:pointer], :pointer
          end

          module LibGeoTiff
            extend FFI::Library

            ffi_lib "geotiff"

            GTMODELTYPEGEOKEY = 1024
            GEOGRAPHICTYPEGEOKEY = 2048
            PROJECTEDCSTYPEGEOKEY = 3072

            MODELTYPE_PROJECTED = 1
            MODELTYPE_GEOGRAPHIC = 2

            attach_function :XTIFFOpen, [:string, :string], :pointer
            attach_function :GTIFNew, [:pointer], :pointer
            attach_function :GTIFFree, [:pointer], :void
            attach_function :GTIFKeyGetSHORT, [:pointer, :int, :pointer, :int, :int], :int
          end

          def initialize(filepath, suppress_warnings: false)
            @suppress_warnings = suppress_warnings
            disable_warnings! if @suppress_warnings

            @tiff = LibGeoTiff.XTIFFOpen(filepath, "r")
            raise "Unable to open TIFF: #{filepath}" if @tiff.null?

            @width = read_uint32(LibTiff::TIFFTAG_IMAGEWIDTH)
            @height = read_uint32(LibTiff::TIFFTAG_IMAGELENGTH)
            @bits_per_sample = read_uint16(LibTiff::TIFFTAG_BITSPERSAMPLE, defaulted: true)
            @samples_per_pixel = read_uint16(LibTiff::TIFFTAG_SAMPLESPERPIXEL, defaulted: true)
            @photometric = read_uint16(LibTiff::TIFFTAG_PHOTOMETRIC)
            @planar_config = read_uint16(LibTiff::TIFFTAG_PLANARCONFIG, defaulted: true)
            @sample_format = read_uint16(LibTiff::TIFFTAG_SAMPLEFORMAT, defaulted: true)

            validate_format

            @source_row_size = LibTiff.TIFFScanlineSize64(@tiff)
            @source_row = FFI::MemoryPointer.new(:uint8, @source_row_size)
            @current_row = 0
            @geo_localization = read_coordinates
          end

          def get_bytes_per_pixel
            4
          end

          def read_next_row(destination, row_size)
            return false if @current_row >= @height

            expected_row_size = @width * get_bytes_per_pixel
            raise "Invalid TIFF destination row size: #{row_size}" unless row_size == expected_row_size

            ret = LibTiff.TIFFReadScanline(@tiff, @source_row, @current_row, 0)
            raise "TIFFReadScanline failed at row #{@current_row}" if ret < 0

            convert_row(destination)

            @current_row += 1
            true
          end

          def close
            unless @gtif.nil? || @gtif.null?
              LibGeoTiff.GTIFFree(@gtif)
              @gtif = nil
            end
            unless @tiff.nil? || @tiff.null?
              LibTiff.TIFFClose(@tiff)
              @tiff = nil
            end
            if @suppress_warnings
              LibTiff.TIFFSetWarningHandler(@previous_warning_handler)
              @previous_warning_handler = nil
            end
          end

          private

          def validate_format
            if LibTiff.TIFFIsTiled(@tiff) != 0
              raise "Tiled TIFF is not supported yet"
            end

            unless @planar_config == LibTiff::PLANARCONFIG_CONTIG
              raise "Unsupported TIFF planar configuration: #{@planar_config}"
            end

            unless [8, 16].include?(@bits_per_sample)
              raise "Unsupported TIFF bits per sample: #{@bits_per_sample}"
            end

            unless [1, 3, 4].include?(@samples_per_pixel)
              raise "Unsupported TIFF samples per pixel: #{@samples_per_pixel}"
            end

            unless @sample_format == LibTiff::SAMPLEFORMAT_UINT
              raise "Unsupported TIFF sample format: #{@sample_format}"
            end

            unless [
              LibTiff::PHOTOMETRIC_MINISWHITE,
              LibTiff::PHOTOMETRIC_MINISBLACK,
              LibTiff::PHOTOMETRIC_RGB
            ].include?(@photometric)
              raise "Unsupported TIFF photometric: #{@photometric}"
            end
          end

          def convert_row(destination)
            case [@samples_per_pixel, @bits_per_sample]
            when [1, 8]
              convert_gray8_row(destination)
            when [1, 16]
              convert_gray16_row(destination)
            when [3, 8]
              convert_rgb8_row(destination)
            when [3, 16]
              convert_rgb16_row(destination)
            when [4, 8]
              convert_rgba8_row(destination)
            when [4, 16]
              convert_rgba16_row(destination)
            else
              raise "Unsupported TIFF pixel format"
            end
          end

          def convert_rgba8_row(dest)
            dest.put_bytes(0, @source_row.read_bytes(@width * 4))
          end

          def convert_rgb8_row(dest)
            @width.times do |x|
              source_offset = x * 3
              dest_offset = x * 4
              dest.put_uint8(dest_offset, @source_row.get_uint8(source_offset))
              dest.put_uint8(dest_offset + 1, @source_row.get_uint8(source_offset + 1))
              dest.put_uint8(dest_offset + 2, @source_row.get_uint8(source_offset + 2))
              dest.put_uint8(dest_offset + 3, 255)
            end
          end

          def convert_gray8_row(dest)
            @width.times do |x|
              value = @source_row.get_uint8(x)
              value = 255 - value if @photometric == LibTiff::PHOTOMETRIC_MINISWHITE
              dest_offset = x * 4
              dest.put_uint8(dest_offset, value)
              dest.put_uint8(dest_offset + 1, value)
              dest.put_uint8(dest_offset + 2, value)
              dest.put_uint8(dest_offset + 3, 255)
            end
          end

          def convert_gray16_row(dest)
            @width.times do |x|
              value = @source_row.get_uint16(x * 2) >> 8
              value = 255 - value if @photometric == LibTiff::PHOTOMETRIC_MINISWHITE
              dest_offset = x * 4
              dest.put_uint8(dest_offset, value)
              dest.put_uint8(dest_offset + 1, value)
              dest.put_uint8(dest_offset + 2, value)
              dest.put_uint8(dest_offset + 3, 255)
            end
          end

          def convert_rgb16_row(dest)
            @width.times do |x|
              source_offset = x * 6
              dest_offset = x * 4
              dest.put_uint8(dest_offset, @source_row.get_uint16(source_offset) >> 8)
              dest.put_uint8(dest_offset + 1, @source_row.get_uint16(source_offset + 2) >> 8)
              dest.put_uint8(dest_offset + 2, @source_row.get_uint16(source_offset + 4) >> 8)
              dest.put_uint8(dest_offset + 3, 255)
            end
          end

          def convert_rgba16_row(dest)
            @width.times do |x|
              source_offset = x * 8
              dest_offset = x * 4
              dest.put_uint8(dest_offset, @source_row.get_uint16(source_offset) >> 8)
              dest.put_uint8(dest_offset + 1, @source_row.get_uint16(source_offset + 2) >> 8)
              dest.put_uint8(dest_offset + 2, @source_row.get_uint16(source_offset + 4) >> 8)
              dest.put_uint8(dest_offset + 3, @source_row.get_uint16(source_offset + 6) >> 8)
            end
          end

          def read_uint32(tag, defaulted: false)
            value = FFI::MemoryPointer.new(:uint32)
            ret = if defaulted
              LibTiff.TIFFGetFieldDefaulted(@tiff, tag, :pointer, value)
            else
              LibTiff.TIFFGetField(@tiff, tag, :pointer, value)
            end
            raise "Unable to read TIFF tag: #{tag}" unless ret == 1
            value.read_uint32
          end

          def read_uint16(tag, defaulted: false)
            value = FFI::MemoryPointer.new(:uint16)
            ret = if defaulted
              LibTiff.TIFFGetFieldDefaulted(@tiff, tag, :pointer, value)
            else
              LibTiff.TIFFGetField(@tiff, tag, :pointer, value)
            end
            raise "Unable to read TIFF tag: #{tag}" unless ret == 1
            value.read_uint16
          end

          def read_coordinates
            transform = read_model_transformation || read_pixel_scale_and_tiepoint
            return nil unless transform
            @gtif = LibGeoTiff.GTIFNew(@tiff)

            {transform: transform,
             crs: read_crs}
          end

          def read_pixel_scale_and_tiepoint
            scale_count = FFI::MemoryPointer.new(:uint16)
            scale_data = FFI::MemoryPointer.new(:pointer)
            ret = LibTiff.TIFFGetField(
              @tiff, LibTiff::TIFFTAG_MODELPIXELSCALE, :pointer, scale_count, :pointer, scale_data
            )
            return nil unless ret == 1

            tiepoint_count = FFI::MemoryPointer.new(:uint16)
            tiepoint_data = FFI::MemoryPointer.new(:pointer)

            ret = LibTiff.TIFFGetField(
              @tiff, LibTiff::TIFFTAG_MODELTIEPOINT, :pointer, tiepoint_count, :pointer, tiepoint_data
            )
            return nil unless ret == 1

            scale_ptr = scale_data.read_pointer
            tiepoint_ptr = tiepoint_data.read_pointer
            x_pixel_size = scale_ptr.get_double(0)
            y_pixel_size = scale_ptr.get_double(8)
            pixel_x = tiepoint_ptr.get_double(0)
            pixel_y = tiepoint_ptr.get_double(8)
            model_x = tiepoint_ptr.get_double(24)
            model_y = tiepoint_ptr.get_double(32)

            {x_origin: model_x - pixel_x * x_pixel_size,
             y_origin: model_y + pixel_y * y_pixel_size,
             x_pixel_size: x_pixel_size,
             y_pixel_size: -y_pixel_size,
             x_row_offset: 0.0,
             y_column_offset: 0.0}
          end

          def read_model_transformation
            count = FFI::MemoryPointer.new(:uint16)
            data = FFI::MemoryPointer.new(:pointer)

            ret = LibTiff.TIFFGetField(
              @tiff, LibTiff::TIFFTAG_MODELTRANSFORMATION, :pointer, count, :pointer, data
            )

            return nil unless ret == 1
            ptr = data.read_pointer
            return nil unless count.read_uint16 >= 16

            {x_origin: ptr.get_double(3 * 8),
             y_origin: ptr.get_double(7 * 8),
             x_pixel_size: ptr.get_double(0 * 8),
             y_column_offset: ptr.get_double(4 * 8),
             x_row_offset: ptr.get_double(1 * 8),
             y_pixel_size: ptr.get_double(5 * 8)}
          end

          def read_crs
            return nil if @gtif.nil? || @gtif.null?

            model_type = read_geokey_short(LibGeoTiff::GTMODELTYPEGEOKEY)
            code =
              case model_type
              when LibGeoTiff::MODELTYPE_PROJECTED
                read_geokey_short(LibGeoTiff::PROJECTEDCSTYPEGEOKEY)
              when LibGeoTiff::MODELTYPE_GEOGRAPHIC
                read_geokey_short(LibGeoTiff::GEOGRAPHICTYPEGEOKEY)
              end
            return nil unless code

            {authority: "EPSG",
             code: code}
          end

          def read_geokey_short(key)
            value = FFI::MemoryPointer.new(:uint16)
            ret = LibGeoTiff.GTIFKeyGetSHORT(@gtif, key, value, 0, 1)

            return nil unless ret == 1
            value.read_uint16
          end

          def disable_warnings!
            LibTiff.TIFFSetWarningHandler(nil)
          end
        end
      end
    end
  end
end
