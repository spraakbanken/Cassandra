#plot regression lines
#check unpredictability

require "rinruby"
require_relative "math_tools.rb"

corpus = "flashback"
axis = "full"
threshold = 100
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


def fitlm(yearhash,verb,colobserved,colfitted,smoothing,threshold,corpus,colfitted2,axis)
    
    R.assign "x",yearhash.keys      
    values = smooth(yearhash.values,smoothing)
    R.assign "y",values
    #R.eval "df <- cbind(years1,values1)"
    
    #R.eval "y <- df[, 2]"
    #R.eval "x <- df[, 1]"
    R.eval "log.ss <- nls(y ~ SSlogis(x, phi1, phi2, phi3))"
    R.eval "logres <- sum(residuals(log.ss)^2)"
    logres = R.pull "logres"
    #R.eval "asym <- summary(log.ss)$coef[1]"
    #R.eval "mid <- summary(log.ss)$coef[2]"
    #R.eval "growth <- summary(log.ss)$coef[3]"
    
    
    
    
    
    #R.eval "stot <- sum((y - mean(y))^2)"
    
    #R.eval "r2 <- 1 - (sres/stot)"
    
    R.eval "m<-lm(y~x)"
    R.eval "linres <- sum(residuals(m)^2)"
    linres = R.pull "linres"

    R.eval "png(file='#{verb}_#{corpus}_s#{smoothing}_t#{threshold}_#{axis}.png')"
    
    if axis == "full"
        R.eval "plot(y ~ x, ylim = c(0,1), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
    elsif axis == "fit"
        R.eval "plot(y ~ x, ylim = c(#{values.min},#{values.max}), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
    end
    R.eval "fittedline <- m$coefficients[1] + m$coefficients[2]*x"
    R.eval "lines(fittedline ~ x, pch=22, col = '#{colfitted}', bg='#{colfitted}',type='b')"
    R.eval "lines(0:2050, predict(log.ss, data.frame(x=0:2050)), pch=2, col = '#{colfitted2}', bg='#{colfitted2}',type='b')"
    
    R.eval "dev.off()"
    #R.eval "png(file='#{verb}_#{corpus}_lf_s#{smoothing}_t#{threshold}.png')"
    #R.eval "plot(y ~ x, ylim = c(#{values.min},#{values.max}), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
    #R.eval "plot(y ~ x, xlim = c(1950,2050), ylim = c(0,1), pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
    #R.eval "lines(0:2050, predict(log.ss, data.frame(x=0:2050)), pch=22, col = '#{colfitted}', bg='#{colfitted}',type='l')"
    
    
    #r2 = R.pull "r2"
    #r2 = R.pull "summary(log.ss)$sigma"
    #asym = R.pull "asym"
    #mid = R.pull "mid"
    #growth = R.pull "growth"
    
    
    return logres,linres
end


o = File.open("summary_compare_#{corpus}_s#{smoothing}_t#{threshold}.tsv","w:utf-8")
#o.puts "verb\tfreq\tslope\tunpredictability\tr2\tp\tmax"
o.puts "verb\tfreq\tlogresiduals\tlinresiduals\tbest"
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
    
    
    logres,linres = fitlm(yearhash,verb,"black","blue",smoothing,threshold,corpus,"red",axis)
    
    #o.puts "#{verb}\t#{verbs_total[verb]}\t#{jagged.round(9)}\t#{slope}\t#{unpredictability}\t#{r2}\t#{p}\t#{values.max}"
    #o.puts "#{verb}\t#{verbs_total[verb]}\t#{slope}\t#{unpredictability}\t#{r2}\t#{p}\t#{values.max}"
    
    if !logres.nil? and logres < linres
        best = "log"
    else
        best = "lin"
    end
    o.puts "#{verb}\t#{verbs_total[verb]}\t#{logres}\t#{linres}\t#{best}"
end
###R.eval "dev.off()"