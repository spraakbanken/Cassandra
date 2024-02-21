def smooth(array,window,ndatapoints,total_threshold)
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
                array3[index] += ndatapoints[i]
            end
            array2[index] = array2[index]/ntotal
            array3[index] = array3[index]/ntotal
            if array3[index] < total_threshold
                array2[index] = "NA"
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
    sum = 0.0
    array.each do |x|
        sum += x
    end
    mean = sum / array.length
    return mean
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
