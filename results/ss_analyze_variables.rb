#check that the order within arrays is equivalent
#solve the 1970 mystery and bugs
#do cohorts 


require "rinruby"


variables = ["kommer_att", "naan_asterisk"]
year = 2009
t = 10

intersection = []
flag = true
intersection_age = {}

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

#STDERR.puts entropy([0.01, 0.99])


#__END__
def age_to_cohort(age)
    
    return cohort
end
avar_enthash = {}
var_v2 = {}
var_age = {}
innovativity = {}
avar_community = {}

variables.each do |variable|
    agehash = {}
    v2hash = {}
    enthash = {}
    entsum = 0.0

    STDERR.puts variable

    fcommunity = "C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\variables\\ss_#{variable}\\familjeliv\\all\\all_users.tsv"
    fc = File.open(fcommunity, "r:utf-8")
    community_average = nil
    fc.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            period = line2[0].to_i
            if period == year
                community_average = line2[5].to_f
                break
            end
            
        end
    end
    avar_community[variable] = community_average
    fc.close

    filename = "familjeliv_#{variable}_t#{t}_#{year}_a.tsv"
    f = File.open(filename, "r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            speaker = line2[1]
            agehash[speaker] = line2[2].to_i
            v2hash[speaker] = line2[-1].to_f
            enthash[speaker] = entropy([v2hash[speaker],1-v2hash[speaker]])
            entsum += enthash[speaker]
            #STDOUT.puts "#{line2[1]}\t#{v2hash[speaker]}\t#{enthash[speaker]}"
            
        end
    end
    var_v2[variable] = v2hash
    var_age[variable] = agehash
    
    if flag
        intersection = agehash.keys
#        STDERR.puts intersection.length
    else
        intersection = intersection & agehash.keys
#        STDERR.puts intersection.length
    end

    flag = false
    v2array = v2hash.values
    avar_enthash[variable] = entsum/v2array.length
    R.eval "pdf(file='intra_#{variable}_t#{t}_#{year}.pdf')"
    R.assign "v2rels",v2array
    R.eval "hist(v2rels)"
    R.eval "dev.off()"
    
    R.eval "pdf(file='entropy_#{variable}_t#{t}_#{year}.pdf')"
    R.assign "entropy",enthash.values
    R.eval "hist(entropy)"
    R.eval "dev.off()"

    R.eval "pdf(file='entropybyage_#{variable}_t#{t}_#{year}.pdf')"
    R.assign "age",agehash.values
    R.eval "plot(entropy~age)"
    R.eval "dev.off()"


    #STDERR.puts intersection.keys.length
end

STDERR.puts "#{avar_enthash}"
STDERR.puts intersection.length

intersection_v2 = Hash.new{|hash, key| hash[key] = Hash.new}
consistency = {}

intersection.each do |speaker|
    i_sum = 0.0
    more = 0.0
    less = 0.0
        
    variables.each do |variable|
        intersection_v2[variable][speaker] = var_v2[variable][speaker]
        i_sum += var_v2[variable][speaker]
        intersection_age[speaker] = var_age[variable][speaker]

        if var_v2[variable][speaker] >= avar_community[variable]
            more += 1
        else
            less += 1
        end
        
        

    end
    nvariables = variables.length
    innovativity[speaker] = i_sum/nvariables
    consistency[speaker] = entropy([more/nvariables,less/nvariables])

end

used_pairs = []
variables.each do |variable1|
    variables.each do |variable2|
        if variable1 != variable2 and !used_pairs.include?([variable1, variable2].sort)
            R.eval "pdf(file='#{variable1}by#{variable2}_t#{t}_#{year}.pdf')"
            R.assign "var1",intersection_v2[variable1].values
            R.assign "var2",intersection_v2[variable2].values
            R.eval "plot(var1~var2)"
            R.eval "dev.off()"
            used_pairs << [variable1, variable2].sort
        end
    end
end
R.eval "pdf(file='innovativity_t#{t}_#{year}.pdf')"
R.assign "innov",innovativity.values
R.eval "hist(innov)"
R.eval "dev.off()"

R.eval "pdf(file='innovbyage_t#{t}_#{year}.pdf')"
R.assign "int_age",intersection_age.values
R.eval "plot(innov~int_age)"
R.eval "dev.off()"

R.eval "pdf(file='consistency_t#{t}_#{year}.pdf')"
R.assign "consistency",consistency.values
R.eval "hist(consistency)"
R.eval "dev.off()"

R.eval "pdf(file='consbyage_t#{t}_#{year}.pdf')"
R.eval "plot(consistency~int_age)"
R.eval "dev.off()"