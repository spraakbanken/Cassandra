load 'wellander_vars.rb'
require 'rinruby'

timecorpus = ARGV[0]
corpus = timecorpus.split("-")[0]
label = timecorpus.split("-")[1]


coverage = ARGV[1].to_f

def compare(fullfile,halffile,verb,coverage)
    f1 = File.open(fullfile,"r:utf-8")
    f2 = File.open(halffile,"r:utf-8")
    yearhash1 = {}
    yearhash2 = {}
    diffs = {}
    f1.each_line.with_index do |line,index|
        #STDERR.puts line
        if index > 0
            line2 = line.strip.split("\t")
            yearhash1[line2[0].to_i] = line2[5].to_f
        end
    end
    f2.each_line.with_index do |line,index|
        #STDERR.puts line
        if index > 0
            line2 = line.strip.split("\t")
            yearhash2[line2[0].to_i] = line2[5].to_f
        end
    end
    ssr = 0.0
    yearhash1.each_pair do |year,v2abs1|
        diffs[year] = v2abs1 - yearhash2[year]
        ssr += diffs[year] ** 2
    end
    R.assign "years", yearhash1.keys
    R.assign "values1", yearhash1.values
    R.assign "values2", yearhash2.values
    minyear = yearhash1.keys.min
    maxyear = yearhash1.keys.max
    R.assign "minyear",minyear
    R.assign "maxyear",maxyear

    R.eval "pdf(file='wellanders/comparisons/#{verb}_#{coverage}.pdf')"
    R.eval "plot(values1~years, type='b',xlab = 'time', ylab = 'proportion omission', xlim = c(minyear,maxyear), ylim = c(0,1))"
    R.eval "lines(values2~years, type='b',col='blue',lty=2)"
    return diffs, ssr
end


allverbs = File.open("wellanders\\comparisons\\allverbs_#{coverage}.tsv","w:utf-8")
allverbs.puts "verb\tssr"

$verblist.each do |verb|
    #STDERR.puts verb
    fullfile = "#{$PATH}\\variables\\wellander\\#{verb}_wfull\\#{corpus}\\#{label}\\all_users.tsv"
    halffile = "#{$PATH}\\variables\\wellander\\#{verb}_whalf\\#{corpus}\\#{label}\\all_users.tsv"
    odiff = File.open("wellanders\\comparisons\\#{verb}_#{coverage}.tsv","w:utf-8")
    diffs, ssr = compare(fullfile,halffile,verb,coverage)
    odiff.puts "year\tdiff"
    diffs.each_pair do |year,diff|
        odiff.puts "#{year}\t#{diff}"
    end
    allverbs.puts "#{verb}\t#{ssr}"
end
