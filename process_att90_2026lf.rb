#plot regression lines
#check unpredictability


require "rinruby"
require_relative "math_tools.rb"
corpus = "familjeliv-1"
threshold = 50
@xaxis = "zoom"
@yaxis = "full"
@perms = 1000
smoothings = [1,3,5]
#@mode = "predict"

path = "C:\\D\\DGU\\Repos\\Cassandra\\results\\att2026\\#{corpus}"
files = Dir.children(path)

output = {}

verbs = Hash.new{|hash,key| hash[key]=Hash.new}
verb_centered = Hash.new{|hash,key| hash[key]=Hash.new}
#verblist = ["komma"]#,"våga","lova"]
verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","anse","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]
verbs_total = Hash.new(0)

@startyear = 2004
@lastyear = 2023


def predict(yearhash,trainyears_set,smoothing)
    sumtestres = 0
    counter = 0
    yearhash2 = yearhash.clone
    smoothedvalues = smooth(yearhash2.values,smoothing)
    yearhash2.keys.each.with_index do |year,index|
        yearhash2[year] = smoothedvalues[index]
        STDERR.puts "#{year} #{smoothedvalues[index].round(3)}"
    end

    trainyears_set.each do |trainyears|        
        STDERR.puts "#{trainyears}"
        #trainyears = yearhash2.keys.sample(15)
        train = {}
        test = {}
        yearhash2.each_pair do |year,value|
            if trainyears.include?(year)
                train[year] = value
            else
                test[year] = value
            end
        end
        R.assign "trainx",train.keys
        R.assign "trainy",train.values
        R.assign "testx",test.keys
        R.assign "testy",test.values
        #STDERR.puts test.keys
        R.eval "try(trainlog.ss <- nls(trainy ~ SSlogis(trainx, phi1, phi2, phi3)),silent=TRUE)"
        trainres = R.pull "try(sum(abs(summary(trainlog.ss)$residuals^2)),silent=TRUE)"
        if !trainres.nil?
            R.eval "predictions <- predict(trainlog.ss, data.frame(x=testx))"
            R.eval "testres <- sum((predictions-testy)^2)"
            testres = R.pull "testres"
            sumtestres += testres
            counter += 1
        else    
            testres = "NA"
            STDERR.puts "Couldn't train a model"
        end
    end
    #STDERR.puts "PREDICTION: #{testres}"
    avetestres = sumtestres/counter
    return avetestres

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
                       verblist.delete(verb) 
                       STDERR.puts "#{verb} excluded: #{year} #{total}"
                       break
                    end
                    verbs_total[verb] += total
                    v2rel = line2[5].to_f
                    verbs[verb][year] = v2rel
                end
            end
        end
    end
end


def randomwalk(yearhash)
    yearhash_randomized = {}
    span = yearhash.values.max - yearhash.values.min
    #span = 1

    yearhash.keys.sort.each.with_index do |year,index|
        #STDERR.puts year
        if index == 0
            yearhash_randomized[year] = yearhash[year]
            
        else
            if rand(2)==0                
                #STDERR.puts "+"
                yearhash_randomized[year] = (yearhash_randomized[year-1] + rand*span)
            else
                #STDERR.puts "-"
                yearhash_randomized[year] = (yearhash_randomized[year-1] - rand*span)
            end
            if yearhash_randomized[year] > 1
                yearhash_randomized[year] = 1
            elsif yearhash_randomized[year] < 0
                yearhash_randomized[year] = 0
            end
            
        end
        #STDERR.puts verbs_randomized[verb][year]
    end

    #STDERR.puts yearhash_randomized
    return yearhash_randomized
end

def fitlm(directyearhash,verb,colobserved,colfitted,smoothing,threshold,corpus,trainyears_set)
    reversed = nil

    R.assign "x",directyearhash.keys      
    directvalues = smooth(directyearhash.values,smoothing)
    R.assign "directy",directvalues
    
    #STDERR.puts "train = c(#{directvalues[0..-6].join(",")})"
    #STDERR.puts "test = c(#{directvalues[-5..-1].join(",")})"
    
    if 2 == 3
        #differencing/ACF 
        directdiffs = []
        diffx = []
        directvalues.each.with_index do |value,index|
            if index > 0 
                directdiffs << value - directvalues[index-1]
                diffx << index
            end
        end
        R.assign "directdiffs",directdiffs
        R.assign "diffx",diffx
        R.eval "png(file='att2026results/DIFF_#{verb}_#{corpus}_lf_s#{smoothing}_t#{threshold}_x#{@xaxis}_y#{@yaxis}.png')"
        R.eval "plot(directdiffs ~ diffx, pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
        #ylim = c(0,1),
        R.eval "invisible(dev.off())"
    end
    reversedyearhash = {}
    
    directyearhash.each_pair do |year,value|
        reversedyearhash[year] = 1 - value
    end
    reversedvalues = smooth(reversedyearhash.values,smoothing)
    R.assign "reversedy",reversedvalues
    
    R.eval "try(direct.log.ss <- nls(directy ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
    R.eval "try(reversed.log.ss <- nls(reversedy ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
    directres = R.pull "try(sum(abs(summary(direct.log.ss)$residuals^2)),silent=TRUE)"
    reversedres = R.pull "try(sum(abs(summary(reversed.log.ss)$residuals^2)),silent=TRUE)"
    
    #values = directvalues
    if directres.nil? and reversedres.nil?
        res = nil
        R.eval "y <- directy"
    elsif directres.nil?
        res = reversedres
        yearhash = reversedyearhash
        R.eval "y <- reversedy"
        R.eval "log.ss <- reversed.log.ss"
        reversed = true
    elsif reversedres.nil?    
        res = directres
        yearhash = directyearhash
        R.eval "y <- directy"
        R.eval "log.ss <- direct.log.ss"
        reversed = false
    elsif directres <= reversedres
        res = directres
        yearhash = directyearhash
        R.eval "y <- directy"
        R.eval "log.ss <- direct.log.ss"
        reversed = false
    else
        res = reversedres
        yearhash = reversedyearhash
        R.eval "y <- reversedy"
        R.eval "log.ss <- reversed.log.ss"
        reversed = true
    end
    
    if @mode == "predict" and !res.nil?
        STDERR.puts "Real data"
        testres = predict(yearhash,trainyears_set,smoothing)
        STDERR.puts testres
    end
    
    
    if !directres.nil?
        R.eval "try(rm(direct.log.ss),silent=TRUE)"
    end
    if !reversedres.nil?
        R.eval "try(rm(reversed.log.ss),silent=TRUE)"
    end
    
    R.eval "png(file='att2026results/#{verb}_#{corpus}_lf_s#{smoothing}_t#{threshold}_x#{@xaxis}_y#{@yaxis}.png')"

    if @xaxis == "zoom"
        R.assign "start",@startyear
        R.assign "finish",@lastyear
    elsif @xaxis == "full"    
        R.assign "start",1950
        R.assign "finish",2050
    end
    if @yaxis == "zoom"
        ylim = ""
    elsif @yaxis == "full"    
        ylim =", ylim = c(0,1)"    
    end
    
    
    if reversed == false
        R.eval "plot(y ~ x, xlim = c(start,finish)#{ylim}, pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
        R.eval "lines(start:finish, predict(log.ss, data.frame(x=start:finish)), pch=22, col = '#{colfitted}', bg='#{colfitted}',type='l')"
    elsif reversed == true
        R.eval "plot((1-y) ~ x, xlim = c(start,finish)#{ylim}, pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
        R.eval "lines(start:finish, (1-predict(log.ss, data.frame(x=start:finish))), pch=22, col = '#{colfitted}', bg='#{colfitted}',type='l')"
    else
        R.eval "plot(y ~ x, xlim = c(start,finish)#{ylim}, pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
    end    
        
    R.eval "invisible(dev.off())"
    

    
    if !res.nil?
        R.eval "asym <- summary(log.ss)$coef[1]"
        R.eval "mid <- summary(log.ss)$coef[2]"
        R.eval "growth <- summary(log.ss)$coef[3]"
        asym = R.pull "asym"
        mid = R.pull "mid"
        growth =  R.pull "growth"
        R.eval "try(rm(log.ss),silent=TRUE)"
        counter = 0
        counternil = 0
        predcounter = 0
        
        
        for i in 1..@perms do
            if i % 1000 == 0 
                STDERR.puts "permutation #{i}"
            end
            shuffled = yearhash.values.shuffle
            values2 = smooth(shuffled,smoothing)
            #values2 = smooth(randomwalk(yearhash).values,smoothing)
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
            if @mode == "predict"
                if !res2.nil?
                    yearhash_shuffled = {}
                    yearhash.keys.each.with_index do |year,index|
                        yearhash_shuffled[year] = shuffled[index]
                    end                  
                    testres2 = predict(yearhash_shuffled,trainyears_set,smoothing)
                    STDERR.puts "Shuffled: #{i} #{testres2}"
                    if testres2 <= testres
                        predcounter += 1
                    end
                else
                
                end
                
            end
            
        end
        rp = counter.to_f/@perms
        predrp = predcounter.to_f/@perms
    else
        rp = "NA"
    end
   
    if reversed
        asym = 1 - asym
        growth = -growth
    end
   
    return asym,mid,growth,rp,counternil,res,reversed,testres,predrp
end


o = File.open("summary_lf_rw_#{corpus}_t#{threshold}.tsv","w:utf-8")

o.puts "verb\tsignif\tfreq\tmax\tmin\tspan\ts1signif\ts1reversed\ts1failedmodels\ts1asym\ts1mid\ts1growth\ts3signif\ts3reversed\ts3failedmodels\ts3asym\ts3mid\ts3growth\ts5signif\ts5reversed\ts5failedmodels\ts5asym\ts5mid\ts5growth\tagreement"

###R.eval "pdf(file='#{corpus}_s#{smoothing}_t#{threshold}.pdf')"
###R.eval "par(mfrow=c(10,3))"

pthreshold = 0.05

trainyears_set = []

for j in 0..9 do
    trainyears_set[j] = verbs[verbs.keys[0]].keys.sample(15).sort
end

verblist.each do |verb|
    signif = 0
    signs = []
    STDERR.puts verb
    yearhash = verbs[verb]
    output = "#{verb}\t#{verbs_total[verb].round(0)}\t#{yearhash.values.max.round(3)}\t#{yearhash.values.min.round(3)}\t#{(yearhash.values.max-yearhash.values.min).round(3)}"
    
    
    
    
    smoothings.each do |smoothing|    
        STDERR.puts "smoothing #{smoothing}"
        
        asym,mid,growth,rp,counternil,res,reversed,testres,predrp = fitlm(yearhash,verb,"black","blue",smoothing,pthreshold,corpus,trainyears_set)
        
        if rp != "NA"
            if rp < threshold
                signif += 1
            end
            if growth > 0
                signs << 1
            elsif growth < 0
                signs << -1
            end
        end
        
        
        output << "\t#{(rp)}\t#{reversed}\t#{counternil}\t#{asym.to_f.round(3)}\t#{mid.to_f.round(0).abs}\t#{growth.to_f.round(2)}"
    end
    if signs.uniq.length > 1
        agreement = "no"
    else
        agreement = "yes"
    end
        
    
    output = [output.split("\t")[0],signif,output.split("\t")[1..-1],agreement].join("\t")
    o.puts output
end
###R.eval "dev.off()"
