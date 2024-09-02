f = File.open("C:\\Sasha\\D\\DGU\\Repos\\Cassandra\\age\\stats2008-2010.tsv","r:utf-8")

authors = Hash.new(0.0)
tokens = Hash.new(0.0)
yobs = {}

min = 1960

f.each_line.with_index do |line,index|
    if index > 0 
        line2 = line.strip.split("\t")
        yob = line2[1].to_i
        if yob >= min
            yobs[yob] = true
            ntokens = line2[2].to_i
            #cohort = yob_to_cohort(yob)
            
            authors[yob] += 1
            tokens[yob] += ntokens
        end
    end

end

yobs2 = yobs.keys.sort
max = yobs2[-1]

step = 8

o = File.open("cohorts_min#{min}_step#{step}.tsv","w:utf-8")
o.puts "yob_start\tyob_end\tntokens\tnauthors"

i = min
begin
    start = i
    finish =  i + step - 1
    
    if start < 1970 and finish >= 1970
        finish += 1
    end
    if finish > max
        finish = max
    end
    STDERR.puts "#{start}-#{finish}"
    

    ntokens = 0
    nauthors = 0
    for yob in start..finish
        ntokens += tokens[yob]
        nauthors += authors[yob]
    end
    o.puts "#{start}\t#{finish}\t#{ntokens}\t#{nauthors}"
    i = finish + 1
    if i == 1970
        i += 1
    end
end until finish >= max


__END__
def yob_to_cohort(yob,step)
    

end