load 'wellander_vars.rb'
require 'rubyxl'
require_relative 'math_tools.rb'
require 'rinruby'

coverage = ARGV[0]

$verblist.each do |verb|
    STDERR.puts verb
    
    f = File.open("wellanders\\kbtidningar\\#{verb}_#{coverage}_prelim.tsv","r:utf-8")
    
    o = File.open("wellanders\\kbtidningar\\#{verb}_#{coverage}.tsv","w:utf-8")
    o.puts "year\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
    
    years = []
    values = []
    #values2 = [] #
    
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            year = line2[0].to_i
            v1abs = line2[1].to_i
            v2abs = line2[2].to_i
            total = v1abs + v2abs
            v1rel = div_by_zero(v1abs,total)
            v2rel = div_by_zero(v2abs,total)
            o.puts "#{year}\t#{total}\t#{v1abs}\t#{v2abs}\t#{v1rel}\t#{v2rel}"
            if total > 20
                years << year
                values << v2rel
            end
        end
    end
        
    R.assign "years", years
    R.assign "values", values
    #R.assign "values2", values2 #
    minyear = years.min
    maxyear = years.max
    R.assign "minyear",minyear
    R.assign "maxyear",maxyear
    R.eval "pdf(file='wellanders/kbtidningar/#{verb}_#{coverage}.pdf')"
    R.eval "plot(values~years, type='l',xlab = 'time', ylab = 'proportion omission', xlim = c(minyear,maxyear), ylim = c(0,1))"
    #R.eval "lines(values2~years, type='l',col='blue',lty=2)"  #
    o.close
end