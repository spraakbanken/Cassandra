def median(array)
  return nil if array.empty?
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end


def median_absolute_deviation(array, refpoint)
    median = median(array)
    devs = []
    array.each do |v|
        devs << (v - median).abs
    end
    mad = median(devs)
    return mad
end

array = [1, 1, 2, 2, 4, 6, 9]

STDERR.puts median_absolute_deviation(array)
STDERR.puts median(array)