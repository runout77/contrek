# frozen_string_literal: true

require "ffi"
require "cpp_polygon_finder"

module Contrek
  module Bitmaps
    module Streaming
      module Sources
        class Png
          attr_reader :width, :height

          module LibSpng
            extend FFI::Library

            ffi_lib FFI::Library::CURRENT_PROCESS

            SPNG_FMT_RGBA8 = 1
            SPNG_DECODE_PROGRESSIVE = 256
            SPNG_EOI = 75

            class Ihdr < FFI::Struct
              layout(
                :width, :uint32,
                :height, :uint32,
                :bit_depth, :uint8,
                :color_type, :uint8,
                :compression_method, :uint8,
                :filter_method, :uint8,
                :interlace_method, :uint8
              )
            end

            attach_function :spng_ctx_new, [:int], :pointer
            attach_function :spng_ctx_free, [:pointer], :void
            attach_function :spng_set_png_file, [:pointer, :pointer], :int
            attach_function :spng_get_ihdr, [:pointer, :pointer], :int
            attach_function :spng_decode_image, [:pointer, :pointer, :size_t, :int, :int], :int
            attach_function :spng_decode_row, [:pointer, :pointer, :size_t], :int
          end

          module LibC
            extend FFI::Library

            ffi_lib FFI::Library::LIBC

            attach_function :fopen, [:string, :string], :pointer
            attach_function :fclose, [:pointer], :int
          end

          def initialize(filepath)
            @fp = LibC.fopen(filepath, "rb")
            raise "Unable to open PNG: #{filepath}" if @fp.null?

            @ctx = LibSpng.spng_ctx_new(0)
            raise "Unable to create spng context" if @ctx.null?

            ret = LibSpng.spng_set_png_file(@ctx, @fp)
            raise "spng_set_png_file failed: #{ret}" unless ret == 0

            ihdr = LibSpng::Ihdr.new

            ret = LibSpng.spng_get_ihdr(@ctx, ihdr)
            raise "spng_get_ihdr failed: #{ret}" unless ret == 0

            @width = ihdr[:width]
            @height = ihdr[:height]

            ret = LibSpng.spng_decode_image(
              @ctx,
              nil,
              0,
              LibSpng::SPNG_FMT_RGBA8,
              LibSpng::SPNG_DECODE_PROGRESSIVE
            )
            raise "Unable to initialize progressive decoding: #{ret}" unless ret == 0
          end

          def get_bytes_per_pixel
            4
          end

          def read_next_row(destination, row_size)
            ret = LibSpng.spng_decode_row(@ctx, destination, row_size)
            unless ret == 0 || ret == LibSpng::SPNG_EOI
              raise "spng_decode_row failed: #{ret}"
            end
            true
          end

          def close
            unless @ctx.nil? || @ctx.null?
              LibSpng.spng_ctx_free(@ctx)
              @ctx = nil
            end
            unless @fp.nil? || @fp.null?
              LibC.fclose(@fp)
              @fp = nil
            end
          end
        end
      end
    end
  end
end
