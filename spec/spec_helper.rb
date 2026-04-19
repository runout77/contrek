require "contrek"
require "digest"
require "tempfile"
require "ruby-prof"

RSpec.configure do |config|
  # config.before(:example) do |example|
  #  puts "Running: #{example.full_description}"
  # end
  Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def same_image?(path1, path2)
  a = File.open(path1)
  b = File.open(path2)
  a_md5 = Digest::MD5.file(a.path).hexdigest
  b_md5 = Digest::MD5.file(b.path).hexdigest
  a_md5 == b_md5
end

def verify_treemap(result)
  result.metadata[:treemap].each_with_index do |treemap_entry, treemap_entry_index|
    puts "Examing treemap entry: #{treemap_entry_index}"
    outer_sequence = result.points[treemap_entry_index][:outer]
    if treemap_entry == [-1, -1]
      result.points.each_with_index do |container, container_index|
        next if container_index == treemap_entry_index
        container_sequence = container[:outer]
        if Contrek::Concurrent::Polyline.is_within?(outer_sequence, container_sequence)
          raise "No parent declared outer sequence #{treemap_entry_index} found inside other sequence!"
        end
      end
    else
      parent_seq = result.points[treemap_entry[0]]
      parent_inner = parent_seq[:inner][treemap_entry[1]]
      if !Contrek::Concurrent::Polyline.is_within?(outer_sequence, parent_inner)
        raise "With parent declared outer sequence #{treemap_entry_index} not inside declared parent!"
      end
    end
  end
end

#  tt = TerminalTracker.new
#  result = @polygon_finder_class.new(...).process_info do |worker|
#    worker.iterate do |position, ch|
#      tt.screen_track!(position, ch)
#    end
#    tt.wait_next!
#  end
#  tt.close
require "curses"
class TerminalTracker
  include Curses

  def initialize
    @initialized_screen = false
  end

  def wait_next!
    if @initialized_screen
      setpos(0, 0)
      addstr("press 'n'                                 ")
      loop do
        if Curses.getch == "n"
          Curses.clear
          break
        end
      end
    end
  end

  def screen_track!(position, character)
    init_screen!
    begin
      sleep 0.1
      crmode
      pos = position
      if !pos.nil?
        setpos(position[:y] + 1, position[:x])
        addstr(character)
      end
      setpos(0, 0)
      str = pos.nil? ? "Nil" : "#{position[:x]},#{position[:y]}"
      addstr("w#{@name} (#{str})")
      refresh
    end
  end

  def close
    if @initialized_screen
      Curses.close_screen
    end
  end

  private

  def init_screen!
    unless @initialized_screen
      init_screen
      @initialized_screen = true
    end
  end
end
