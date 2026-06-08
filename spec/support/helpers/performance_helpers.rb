# frozen_string_literal: true

module PerformanceHelpers
  HISTORY_PATH = File.expand_path("../../files/performance_history.json", __dir__)
  MAX_SAMPLES = Integer(ENV.fetch("CONTREK_PERF_MAX_SAMPLES", "100"))
  MIN_SAMPLES = Integer(ENV.fetch("CONTREK_PERF_MIN_SAMPLES", "20"))
  TOLERANCE = Float(ENV.fetch("CONTREK_PERF_TOLERANCE", "1.25"))
  STDDEV_FACTOR = Float(ENV.fetch("CONTREK_PERF_STDDEV_FACTOR", "3.0"))

  def expect_performance(name = nil)
    benchmark_name = name || RSpec.current_example.full_description

    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = yield
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at

    history = load_performance_history
    entry = history[benchmark_name] || {}

    samples = Array(entry["samples"])
    previous_stats = stats(samples)

    if samples.size >= MIN_SAMPLES
      limit = performance_limit(previous_stats)
      expect(elapsed).to be <= limit
    end

    samples << elapsed
    samples = samples.last(MAX_SAMPLES)

    history[benchmark_name] = {
      "samples" => samples,
      "stats" => stats(samples)
    }
    save_performance_history(history)

    result
  end

  private

  def load_performance_history
    return {} unless File.exist?(HISTORY_PATH)

    JSON.parse(File.read(HISTORY_PATH))
  end

  def save_performance_history(history)
    FileUtils.mkdir_p(File.dirname(HISTORY_PATH))

    File.write(
      HISTORY_PATH,
      JSON.pretty_generate(history.sort.to_h)
    )
  end

  def performance_limit(stats)
    relative_limit = stats["median"] * TOLERANCE
    statistical_limit = stats["median"] + stats["stddev"] * STDDEV_FACTOR

    [relative_limit, statistical_limit].max
  end

  def stats(values)
    return empty_stats if values.empty?

    sorted = values.sort
    mean = values.sum / values.size.to_f
    variance = values.sum { |value| (value - mean)**2 } / values.size.to_f
    stddev = Math.sqrt(variance)

    {
      "runs" => values.size,
      "min" => sorted.first,
      "median" => sorted[values.size / 2],
      "mean" => mean,
      "max" => sorted.last,
      "stddev" => stddev
    }
  end

  def empty_stats
    {
      "runs" => 0,
      "min" => nil,
      "median" => nil,
      "mean" => nil,
      "max" => nil,
      "stddev" => 0.0
    }
  end
end

RSpec.configure do |config|
  config.include PerformanceHelpers
end
