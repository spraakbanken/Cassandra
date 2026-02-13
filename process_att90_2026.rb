#plot regression lines
#check unpredictability

require "rinruby"
require_relative "math_tools.rb"
corpus = "forum"
threshold = 200
smoothing = 3
path = "C:\\D\\DGU\\Repos\\Cassandra\\results\\att2026\\#{corpus}"
files = Dir.children(path)



verbs = Hash.new{|hash,key| hash[key]=Hash.new}
verb_centered = Hash.new{|hash,key| hash[key]=Hash.new}
#verblist = ["komma"]
verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","anse","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]
verbs_total = Hash.new(0)

#,
@startyear = 2004
@lastyear = 2023




def unpredictability(values,slope)
    unpredictability = 0
    prevvalue = nil
    values.each.with_index do |value,index|
        if index > 0 
            localslope = value - prevvalue
        
            if (localslope.positive? and slope.negative?) or (localslope.negative? and slope.positive?)
                #if localslope > slope/38
                    unpredictability += 1
                #end
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


def fitlm(yearhash,verb,colobserved,colfitted,smoothing,threshold,corpus)
    link = ""
    R.assign "years",yearhash.keys      
    values = smooth(yearhash.values,smoothing)
    R.assign "values",values
    R.eval "pdf(file='#{verb}_#{corpus}_s#{smoothing}_t#{threshold}.pdf')"
    R.eval "plot(values ~ years, ylim = c(#{values.min},#{values.max}), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
    #if function == "linear"
    R.eval "m<-lm(values~years)"
    #elsif function == "log"
    
    #end    
    
    #R.eval "mlog<-lm(values~log(years))"
    #r2lin = R.pull "summary(mlin)$r.squared"
    #r2log = R.pull "summary(mlog)$r.squared"
    #if 2<1#r2log > r2lin 
    #    R.eval "m<-mlog"
    #    link = "log"
    #else
    #    R.eval "m<-mlin"
    #    link = "lin"
    #end
    
    slope = R.pull "m$coefficients[2]"
    #slope = slope.round(7)
    intercept = R.pull "m$coefficients[1]"
    
    
    #if link == "lin"
    R.eval "fittedline <- m$coefficients[1] + m$coefficients[2]*years"
    R.eval "lines(fittedline ~ years, pch=20, col = '#{colfitted}', bg='#{colfitted}',type='b')"
    #elsif link == "log"
        #R.eval "fittedline <- m$coefficients[1] + m$coefficients[2]*log(years)"
        #R.eval "lines(fittedline ~ years, pch=20, col = '#{colfitted}', bg='#{colfitted}',type='b')"
    #end
    R.eval "dev.off()"
    r2 = R.pull "summary(m)$r.squared"
    #r2 = r2.round(7)
    p = R.pull "summary(m)$coefficients[2,4]"
    #p = p.round(7)
    unpredictability = unpredictability(values,slope)     
    #jagged = jaggedness(verb,centeredyears,centeredvalues)
    #R.eval "rm(list = ls())"
    return slope,unpredictability,r2,p,values,link
end


o = File.open("summary_#{corpus}_s#{smoothing}_t#{threshold}.tsv","w:utf-8")

#o.puts "verb\tfreq\tslope\tunpredictability\tr2\tp\tmax"
o.puts "verb\tfreq\tslope\tabs_slope\tr2\tmax-min\tmax"
###R.eval "pdf(file='#{corpus}_s#{smoothing}_t#{threshold}.pdf')"
###R.eval "par(mfrow=c(10,3))"
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
    
    
    slope,unpredictability,r2,p,values,link = fitlm(yearhash,verb,"black","blue",smoothing,threshold,corpus)
    
    #o.puts "#{verb}\t#{verbs_total[verb]}\t#{jagged.round(9)}\t#{slope}\t#{unpredictability}\t#{r2}\t#{p}\t#{values.max}"
    #o.puts "#{verb}\t#{verbs_total[verb]}\t#{slope}\t#{unpredictability}\t#{r2}\t#{p}\t#{values.max}"
    
    o.puts "#{verb}\t#{verbs_total[verb]}\t#{slope.round(5)}\t#{slope.round(5).abs}\t#{r2.round(5)}\t#{(values.max-values.min).round(5)}\t#{values.max.round(5)}"
end
###R.eval "dev.off()"