def m_absolute_deviation(array, refpoint, type)
    #median = median(array)
    devs = []
    array.each do |v|
        devs << (v - refpoint).abs
    end
    if type == "median"
        mad = median(devs)
    elsif type == "mean"
        mad = mean(devs)
    end
    return mad
end

def center(array)
    array2 = []
    mmean = mean(array)
    mstdev = stdev(array)
    array.each do |element|
        array2 << (element - mmean)/mstdev
    end
    return array2
end


def median(array)
  return nil if array.empty?
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

def smooth(array,window,totalcontrol=false,ndatapoints=[],total_threshold=10000)
    if window % 2 == 0
        abort("Cassandra says: Smoothing window must be an odd number")
    end
    smoother = (window - 1) / 2
    #hash = Hash.new{|hash, key| hash[key] = Array.new}
    array2 = []
    array3 = []
    array.each.with_index do |element, index|
        array2[index] = 0.0
        array3[index] = 0.0
        #if (index + 1 - smoother) > = 0 and (index + 1 + smoother) <= array.length
            ntotal = 0.0
            for i in correct((index - smoother), 0, "lower")..correct((index+smoother), array.length-1, "higher")
                #if array[i] != "NA"
                    array2[index] += array[i]
                    ntotal += 1
                #end
                if totalcontrol
                    array3[index] += ndatapoints[i]
                end
            end
            array2[index] = array2[index]/ntotal
            if totalcontrol
                array3[index] = array3[index]/ntotal
                if array3[index] < total_threshold
                    array2[index] = "NA"
                end
            end
        #end

    end
    return array2
end

def correct(number, limit, type)
    if (type == "lower" and number < limit) or (type == "higher" and number > limit)
        number = limit
    end
    return number
end

def mean(array)
    sum = sumarray(array)
    mean = sum / array.length
    return mean
end

def sumarray(array)

    sum = 0.0
    array.each do |x|
        sum += x
    end
    return sum
end

def stdev(array) #calculate standard deviation
    n = array.length.to_f
    squaresum = 0.0
    mean = mean(array)
    array.each do |x|
        squaresum += (x - mean) ** 2
    end
    stdev = Math.sqrt(squaresum/(n-1))
    return stdev
end


def zscore(array)
    zscores = []
    mean = mean(array)
    stdev = stdev(array)
    array.each do |x|
        zscores << (x - mean) / stdev
    end
    return zscores
end

def cosine_delta(array1,array2)
    z1 = zscore(array1)
    z2 = zscore(array2)
    dist = 1 - (dot_product(z1,z2) / (euclidean_norm(z1) * euclidean_norm(z2)))
    return dist
end

def cosine_sim(array1,array2)
    sim = (dot_product(array1,array2) / (euclidean_norm(array1) * euclidean_norm(array2)))
    return sim
end



def dot_product(array1,array2)
    dp = 0.0
    array1.each_index do |index|
        dp += array1[index] * array2[index]
    end
    return dp
end

def euclidean_norm(array)
    norm = Math.sqrt(dot_product(array,array))
    return norm
end

def div_by_zero(a,b)
    if b != 0
        c = a.to_f/b
    else
        c = 0.0
    end 
    return c
end 

def div_by_zero_marked(a,b)
    if b != 0
        c = a.to_f/b
    else
        c = -0.5
    end 
    return c
end 


def entropy(array)
    e = 0.0
    array.each do |p|
        if p != 0
            e += p * Math.log(p, 2)
        end
    end
    e = -e
    return e
end

class Levenshtein

  def lev_compare(s1, s2)
    s1_len = s1.size
    s2_len = s2.size

    return 0 if 0 == s2_len || 0 == s1_len

    #Define and seed matrix
    matrix = Array.new(s1_len + 1).map! {
      Array.new(s2_len + 1).map! {
        0
      }
    }
    (s1_len + 1).times { |i| matrix[i][0] = i }
    (s2_len + 1).times { |i| matrix[0][i] = i }

    for i in 1..s1_len
      c = s1[i - 1]
      for j in 1..s2_len
        cost = (c == s2[j - 1]) ? 0 : 1
        matrix[i][j] = [ matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost].min
      end
    end

    return (1.0 - (matrix[s1_len][s2_len] / Float([s1_len, s2_len].max)))
  end

end