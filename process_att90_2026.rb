#plot regression lines
#check unpredictability

require "rinruby"
require_relative "math_tools.rb"
path = "C:\\D\\DGU\\Repos\\Cassandra\\results\\ss90_2026"
files = Dir.children(path)

smoothing = 3
verbs = Hash.new{|hash,key| hash[key]=Hash.new}
verb_centered = Hash.new{|hash,key| hash[key]=Hash.new}
#verblist = ["komma"]
verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","anse","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]
verbs_total = Hash.new(0)

#,
@startyear = 2004
@lastyear = 2022

threshold = 100


def unpredictability(values,slope)
    unpredictability = 0
    prevvalue = nil
    values.each.with_index do |value,index|
        if index > 0 
            localslope = value - prevvalue
        
            if (localslope.positive? and slope.negative?) or (localslope.negative? and slope.positive?)
                if localslope > slope/19
                    unpredictability += 1
                end
            end
        end
        prevvalue = value.clone
    end
    
    return unpredictability
end


def jaggedness(verb,years,values)
    prevyear = nil
    
    indirect = 0
    
    years.each_pair do |year,centeredyear|
        
        if year != @startyear
            slope = Math.sqrt((centeredyear - years[prevyear]).abs2 + (values[year] - values[prevyear]).abs2)
            indirect += slope
        end
        prevyear = year.clone
        #prevcenteredyear = centeredyear.clone
    end
    direct = Math.sqrt((years[@lastyear] - years[@startyear]).abs2 + (values[@lastyear] - values[@startyear]).abs2)
    
    jagged = div_by_zero(indirect, direct)
    return jagged
end

files.each do |file|
    verb = file.split(".")[0].split("_")[1]
    if verblist.include?(verb)
        f = File.open("#{path}\\#{file}","r:utf-8")
        f.each_line.with_index do |line,index|
            if index > 0
                line2 = line.strip.split("\t")
                year = line2[0].to_i
                if year >= @startyear
                    total = line2[1].to_f
                    if total < threshold
                       #STDERR.puts "#{verb}\t#{year}\t#{total}"
                       verblist.delete(verb) 
                    end
                    verbs_total[verb] += total
                    v2rel = line2[5].to_f
                    verbs[verb][year] = v2rel
                end
            end
        end
    end
end

#STDERR.puts verblist
#__END__

o = File.open("summary.tsv","w:utf-8")
o.puts "verb\tfreq\tjaggedness\tslope\tunpredictability\tr2\tp"
#verbs.each_pair do |verb,yearhash|
verblist.each do |verb|
    yearhash = verbs[verb]
    centeredyears_a = center(yearhash.keys)
    #STDERR.puts centeredyears_a
    centeredvalues_a = smooth(center(yearhash.values),smoothing)
    centeredyears = {}
    centeredvalues = {}
    yearhash.keys.each.with_index do |year,index|
        centeredyears[year] = centeredyears_a[index]
        centeredvalues[year] = centeredvalues_a[index]
    end
    
    R.assign "years",yearhash.keys
    
    
    values = smooth(yearhash.values,smoothing)
    R.assign "values",values
    R.eval "pdf(file='#{verb}_smoothed.pdf')"
    R.eval "plot(values ~ years, ylim = c(#{values.min},#{values.max}), pch=21, col = 'black', bg='black',type='l')"
    R.eval "dev.off()"
    
    
    R.eval "m<-lm(values~years)"
    slope = R.pull "m$coefficients[2]"
    slope = slope.round(7)
    r2 = R.pull "summary(m)$r.squared"
    r2 = r2.round(7)
    p = R.pull "summary(m)$coefficients[2,4]"
    p = p.round(7)
    unpredictability = unpredictability(values,slope) 
    
    jagged = jaggedness(verb,centeredyears,centeredvalues)
    o.puts "#{verb}\t#{verbs_total[verb]}\t#{jagged.round(9)}\t#{slope}\t#{unpredictability}\t#{r2}\t#{p}"
end