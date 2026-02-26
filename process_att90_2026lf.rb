#plot regression lines
#check unpredictability

require "rinruby"
require_relative "math_tools.rb"
corpus = "familjeliv"
threshold = 100
smoothing = ARGV[0].to_i
path = "C:\\D\\DGU\\Repos\\Cassandra\\results\\att2026\\#{corpus}"
files = Dir.children(path)
@perms = 10


verbs = Hash.new{|hash,key| hash[key]=Hash.new}
verb_centered = Hash.new{|hash,key| hash[key]=Hash.new}
#verblist = ["komma","våga"]
verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","anse","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]
verbs_total = Hash.new(0)
@reversed = ["planera","riskera","lova","tendera","låtsas","anse"]

#,
@startyear = 2004
@lastyear = 2023

#R.eval "library(car)"


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
                    if !@reversed.include?(verb)
                        verbs[verb][year] = v2rel
                    else
                        verbs[verb][year] = 1-v2rel
                    end
                end
            end
        end
    end
end

#STDERR.puts verblist
#__END__


def fitlm(yearhash,verb,colobserved,colfitted,smoothing,threshold,corpus)
    
    R.assign "x",yearhash.keys      
    values = smooth(yearhash.values,smoothing)
    R.assign "y",values
    
    #R.eval "df <- cbind(years1,values1)"
    
    #R.eval "y <- df[, 2]"
    #R.eval "x <- df[, 1]"
    R.eval "log.ss <- nls(y ~ SSlogis(x, phi1, phi2, phi3))"
    
    #R.eval "prior <- lm(logit(y) ~ x)"
    #R.eval "intercept <- prior$coef[1]"
    #intercept = R.pull "intercept"
    #R.eval "slope <- prior$coef[2]"
    #slope = R.pull "slope"
    #STDERR.puts intercept,slope
    #R.eval "log.ss <- nls(y ~ theta1/(1+exp(-theta2 + theta3*x)), start=list(theta1=0.70,theta2=intercept,theta3=slope))"
    
    R.eval "asym <- summary(log.ss)$coef[1]"
    R.eval "mid <- summary(log.ss)$coef[2]"
    R.eval "growth <- summary(log.ss)$coef[3]"
    
    
    
    #R.eval "stot <- sum((y - mean(y))^2)"
    #R.eval "sres <- sum(residuals(log.ss)^2)"
    #R.eval "r2 <- 1 - (sres/stot)"
    

    
    R.eval "png(file='#{verb}_#{corpus}_lf_s#{smoothing}_t#{threshold}.png')"
    #R.eval "/(y ~ x, ylim = c(#{values.min},#{values.max}), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
    if !@reversed.include?(verb)
        R.eval "plot(y ~ x, xlim = c(1950,2050), ylim = c(0,1), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
        R.eval "lines(0:2050, predict(log.ss, data.frame(x=0:2050)), pch=22, col = '#{colfitted}', bg='#{colfitted}',type='l')"
    else
        R.eval "plot((1-y) ~ x, xlim = c(1950,2050), ylim = c(0,1), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
        R.eval "lines(0:2050, (1-predict(log.ss, data.frame(x=0:2050))), pch=22, col = '#{colfitted}', bg='#{colfitted}',type='l')"
    end    
        
    R.eval "dev.off()"
    
    #r2 = R.pull "r2"
    res = R.pull "sum(abs(summary(log.ss)$residuals^2))"
    #STDERR.puts "res: #{res}"
    #@perms = 1000#10000
    #res2pre = -1
    if !res.nil?
        R.eval "try(rm(log.ss),silent=TRUE)"
        counter = 0
        counternil = 0
        for i in 1..@perms do
            #res2 = nil
            if i % 1000 == 0 
                STDERR.puts i
            end
            values2 = smooth(yearhash.values.shuffle,smoothing)
            R.assign "y2",values2
            R.eval "try(log.ss2 <- nls(y2 ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
            res2 = R.pull "try(sum(abs(summary(log.ss2)$residuals^2)),silent=TRUE)"
            #STDERR.puts "res2: #{res2}"
            if !res2.nil? 
                R.eval "try(rm(log.ss2),silent=TRUE)"
                if res2 <= res
                    counter += 1
                end
            elsif
                counternil += 1
            end
        end
        rp = counter.to_f/@perms
        #STDERR.puts "Failed: #{counternil}"
    else
        rp = "NA"
    end
    
    asym = R.pull "asym"
    mid = R.pull "mid"
    growth = R.pull "growth"
    
    
    return asym,mid,growth,rp,values,counternil,res
end


o = File.open("summary_lf_#{corpus}_s#{smoothing}_t#{threshold}.tsv","w:utf-8")
#o.puts "verb\tfreq\tslope\tunpredictability\tr2\tp\tmax"
o.puts "verb\tfreq\tasym\tmid\tgrowth\trp\tmax-min\tmax\tfailed\tresiduals"
###R.eval "pdf(file='#{corpus}_s#{smoothing}_t#{threshold}.pdf')"
###R.eval "par(mfrow=c(10,3))"
#verbs.each_pair do |verb,yearhash|
verblist.each do |verb|
    STDERR.puts verb
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
    
    
    asym,mid,growth,rp,values,counternil,res = fitlm(yearhash,verb,"black","blue",smoothing,threshold,corpus)
    
    #o.puts "#{verb}\t#{verbs_total[verb]}\t#{jagged.round(9)}\t#{slope}\t#{unpredictability}\t#{r2}\t#{p}\t#{values.max}"
    #o.puts "#{verb}\t#{verbs_total[verb]}\t#{slope}\t#{unpredictability}\t#{r2}\t#{p}\t#{values.max}"
    
    o.puts "#{verb}\t#{verbs_total[verb]}\t#{asym.to_f.round(5)}\t#{mid.to_f.round(5).abs}\t#{growth.to_f.round(5)}\t#{(rp)}\t#{(values.max-values.min).round(5)}\t#{values.max.round(5)}\t#{counternil}\t#{res}"
end
###R.eval "dev.off()"