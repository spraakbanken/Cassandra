#for a single verb: check that y1, y2 and diffs are correct
#check single perm2
#check several perm2s


require "rinruby"
require_relative "math_tools.rb"
corpus = "flashback"
corpus1 = "flashback-1"
corpus2 = "flashback-2"

#threshold1 = 100
threshold = 50
@xaxis = "full"
@yaxis = "full"
@perms = 1000
@perms2 = 1000
#smoothings = [1]
smoothings = [1,3,5]
#@mode = "predict"



output = {}

#verb_centered = Hash.new{|hash,key| hash[key]=Hash.new}
#verblist = ["komma"]#,"våga","lova"]
verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]


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

def extract(corpus,verblist,threshold)
    path = "C:\\D\\DGU\\Repos\\Cassandra\\results\\att2026\\#{corpus}"
    
    files = Dir.children(path)
    verbs = Hash.new{|hash,key| hash[key]=Hash.new}
    verbs_total = Hash.new(0)

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
    return verbs,verbs_total
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

def fitlm(directyearhash,verb,colobserved,colfitted,smoothing,threshold,corpus,trainyears_set,plot,evaluate,reversed,directyearhash2,corpus2)
    colobserved2 = "orange"
    colfitted2 = "red"
    R.assign "x",directyearhash.keys
    #STDERR.puts "x=#{directyearhash.keys}"
    directvalues = smooth(directyearhash.values,smoothing)
    #STDERR.puts "Unsmoothed direct =#{directyearhash.values}"
    #STDERR.puts "directvalues=#{directvalues}"
    R.assign "directy",directvalues
        
    reversedyearhash = {}
    directyearhash.each_pair do |year,value|
        reversedyearhash[year] = 1 - value
    end
    reversedvalues = smooth(reversedyearhash.values,smoothing)
    R.assign "reversedy",reversedvalues
        
    #reversed = nil
    if reversed.nil? 
        #R.assign "x",directyearhash.keys
        R.eval "try(direct.log.ss <- nls(directy ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
        R.eval "try(reversed.log.ss <- nls(reversedy ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
        
        directres = R.pull "try(sum(abs(summary(direct.log.ss)$residuals^2)),silent=TRUE)"
        reversedres = R.pull "try(sum(abs(summary(reversed.log.ss)$residuals^2)),silent=TRUE)"
        #values = directvalues
        if directres.nil? and reversedres.nil?
            res = nil
            R.eval "y <- directy"
        elsif directres.nil?
            reversed = true
        elsif reversedres.nil?    
            reversed = false
        elsif directres <= reversedres
            reversed = false
        else
            reversed = true
        end
    
    
        if reversed == true
            res = reversedres
            yearhash = reversedyearhash
            R.eval "y <- reversedy"
            R.eval "log.ss <- reversed.log.ss"
            
        elsif reversed == false
            res = directres
            yearhash = directyearhash
            R.eval "y <- directy"
            R.eval "log.ss <- direct.log.ss"
            
        end
        if !directres.nil?
            R.eval "try(rm(direct.log.ss),silent=TRUE)"
        end
        if !reversedres.nil?
            R.eval "try(rm(reversed.log.ss),silent=TRUE)"
        end
    
    else
        #if !directyearhash2.nil?
        #R.assign "x2",directyearhash2.keys
        #STDERR.puts "reversed = #{reversed}"
        if reversed == false
            
            R.eval "y <- directy"
            directvalues2 = smooth(directyearhash2.values,smoothing)
            R.assign "y2",directvalues2
            #STDERR.puts "y2 = #{directvalues2}"
            yearhash2 = directyearhash2
        elsif reversed == true
            R.eval "y <- reversedy"
            reversedyearhash2 = {}
            directyearhash2.each_pair do |year,value|
                reversedyearhash2[year] = 1 - value
            end
            reversedvalues2 = smooth(reversedyearhash2.values,smoothing)
            yearhash2 = reversedyearhash2
            R.assign "y2",reversedvalues2
            #STDERR.puts "y2 = #{reversedvalues2}"
        end
        
        R.eval "try(log.ss1 <- nls(y ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
        res1 = R.pull "try(sum(abs(summary(log.ss1)$residuals^2)),silent=TRUE)"
        R.eval "try(log.ss2 <- nls(y2 ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
        res2 = R.pull "try(sum(abs(summary(log.ss2)$residuals^2)),silent=TRUE)"

    end
    
    if @mode == "predict" and !res.nil?
        STDERR.puts "Real data"
        testres = predict(yearhash,trainyears_set,smoothing)
        STDERR.puts testres
    end
    
    
    
    if plot
        if evaluate == "significance"
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
        elsif evaluate == "robustness"
            R.eval "png(file='att2026results/robustness/#{verb}_#{corpus}_#{corpus2}_lf_s#{smoothing}_t#{threshold}_x#{@xaxis}_y#{@yaxis}.png')"
            
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
                R.eval "lines(start:finish, predict(log.ss1, data.frame(x=start:finish)), pch=22, col = '#{colfitted}', bg='#{colfitted}',type='l')"
                
                R.eval "lines(y2 ~ x, pch=21, col = '#{colobserved2}', bg='#{colobserved2}',type='b')"
                R.eval "lines(start:finish, predict(log.ss2, data.frame(x=start:finish)), pch=22, col = '#{colfitted2}', bg='#{colfitted2}',type='l')"
                
            elsif reversed == true
                R.eval "plot((1-y) ~ x, xlim = c(start,finish)#{ylim}, pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
                R.eval "lines(start:finish, (1-predict(log.ss1, data.frame(x=start:finish))), pch=22, col = '#{colfitted}', bg='#{colfitted}',type='l')"
                
                R.eval "lines((1-y2) ~ x, pch=21, col = '#{colobserved2}', bg='#{colobserved2}',type='b')"
                R.eval "lines(start:finish, (1-predict(log.ss2, data.frame(x=start:finish))), pch=22, col = '#{colfitted2}', bg='#{colfitted2}',type='l')"
                
            else
                R.eval "plot(y ~ x, xlim = c(start,finish)#{ylim}, pch=21, col = '#{colobserved}', bg='#{colobserved}',type='b')"
                R.eval "lines(y2 ~ x, pch=21, col = '#{colobserved2}', bg='#{colobserved2}',type='b')"
                
            end    
                
            R.eval "invisible(dev.off())"
        
        end
           
    end

    if evaluate == "significance"
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
                R.assign "yprim",values2
                R.eval "try(log.ss.prim <- nls(yprim ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
                resprim = R.pull "try(sum(abs(summary(log.ss.prim)$residuals^2)),silent=TRUE)"
                #STDERR.puts "resprim: #{resprim}"
                if !resprim.nil? 
                    R.eval "try(rm(log.ss.prim),silent=TRUE)"
                    if resprim <= res
                        counter += 1
                    end
                elsif
                    counternil += 1
                end
                if @mode == "predict"
                    if !resprim.nil?
                        yearhash_shuffled = {}
                        yearhash.keys.each.with_index do |year,index|
                            yearhash_shuffled[year] = shuffled[index]
                        end                  
                        testresprim = predict(yearhash_shuffled,trainyears_set,smoothing)
             #           STDERR.puts "Shuffled: #{i} #{testresprim}"
                        if testresprim <= testres
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
    elsif evaluate == "robustness"
        #if res1.nil?
        #    STDERR.puts "first corpus failed"
        #end
        #if res2.nil?
        #    STDERR.puts "second corpus failed"
        #end
        if !res1.nil? and !res2.nil?
            pcurve = 0.0
            pasym = 0.0
            pmid = 0.0
            pgrowth = 0.0
            #STDERR.puts "fine!"
            R.eval "asym1 <- summary(log.ss1)$coef[1]"
            R.eval "mid1 <- summary(log.ss1)$coef[2]"
            R.eval "growth1 <- summary(log.ss1)$coef[3]"
            asym1 = R.pull "asym1"
            mid1 = R.pull "mid1"
            growth1 =  R.pull "growth1"
            
            R.eval "asym2 <- summary(log.ss2)$coef[1]"
            R.eval "mid2 <- summary(log.ss2)$coef[2]"
            R.eval "growth2 <- summary(log.ss2)$coef[3]"
            asym2 = R.pull "asym2"
            mid2 = R.pull "mid2"
            growth2 =  R.pull "growth2"
            
            diffasym = (asym1-asym2).abs
            diffmid = (mid1-mid2).abs
            diffgrowth = (growth1-growth2).abs
            
            #STDERR.puts "Diffs: #{diffasym} #{diffmid} #{diffgrowth}"
            
            for i in 1..@perms2 do
                if i % 1000 == 0 
                    STDERR.puts "permutation #{i}"
                end
                shuffled = yearhash2.values.shuffle
                values2 = smooth(shuffled,smoothing)
                #STDERR.puts "smoothed shuffled = #{values2}"
                #values2 = smooth(randomwalk(yearhash).values,smoothing)
                R.assign "y2prim",values2
                R.eval "try(log.ss2.prim <- nls(y2prim ~ SSlogis(x, phi1, phi2, phi3)),silent=TRUE)"
                res2prim = R.pull "try(sum(abs(summary(log.ss2.prim)$residuals^2)),silent=TRUE)"
                #STDERR.puts "resprim: #{resprim}"
                if !res2prim.nil? 
                    #R.eval "lines(y2prim ~ x, pch=21, col = 'green', bg='green',type='b')"
                    #R.eval "lines(start:finish, predict(log.ss2.prim, data.frame(x=start:finish)), pch=22, col = 'yellow', bg='yellow',type='l')"
                
                    R.eval "asym2prim <- summary(log.ss2.prim)$coef[1]"
                    R.eval "mid2prim <- summary(log.ss2.prim)$coef[2]"
                    R.eval "growth2prim <- summary(log.ss2.prim)$coef[3]"
                    asym2prim = R.pull "asym2prim"
                    mid2prim = R.pull "mid2prim"
                    growth2prim =  R.pull "growth2prim"
                    
                    diffasymprim = (asym1-asym2prim).abs
                    diffmidprim = (mid1-mid2prim).abs
                    diffgrowthprim = (growth1-growth2prim).abs
                    
                    if diffasymprim <= diffasym
                        pasym += 1
                    end
                    
                    if diffmidprim <= diffmid
                        pmid += 1
                    end
                    if diffgrowthprim <= diffgrowth
                        pgrowth += 1
                    end
                    
                    if diffasymprim <= diffasym and  diffmidprim <= diffmid and diffgrowthprim <= diffgrowth
                        pcurve += 1
                    end
                    
                    #STDERR.puts "Diffsprim: #{diffasymprim} #{diffmidprim} #{diffgrowthprim}"
                    R.eval "try(rm(log.ss2.prim),silent=TRUE)"
                #elsif
                    #counternil += 1
                else
                    #STDERR.puts "The shuffled model did not converge"
                end
                
            end
            pasym = pasym/@perms2
            pgrowth = pgrowth/@perms2
            pmid = pmid/@perms2
            pcurve = pcurve/@perms2
        else
            #STDERR.puts "res1=#{res1}"
            #STDERR.puts "res2=#{res2}"
        end
    
        if !res1.nil?
            R.eval "try(rm(log.ss1),silent=TRUE)"
        end
        
        
        if !res2.nil?
            R.eval "try(rm(log.ss2),silent=TRUE)"
        end
        
    end
   
    if evaluate != "robustness"
        if reversed
            asym = 1 - asym
            growth = -growth
        end
    end
   
    return asym,mid,growth,rp,counternil,res,reversed,testres,predrp,pasym,pmid,pgrowth,pcurve
end





verbs, verbs_total = extract(corpus,verblist,threshold)

STDERR.puts "After general: #{verblist}"


=begin
min = 1
max = 0

verbs.each_pair do |verb,yearhash|
    prev_value = nil
    yearhash.each_value do |v2rel|
        if !prev_value.nil?
            diff = (v2rel - prev_value).abs
            if diff < min
                min = diff.clone
            end
            if diff > max
                max = diff.clone
            end
        end
        prev_value = v2rel.clone
    end
end
STDERR.puts min,max
=end

#__END__
o = File.open("summary2_lf_rw_#{corpus}_t#{threshold}.tsv","w:utf-8")

o.puts "verb\tsignif\tfreq\tmax\tmin\tspan\ts1signif\ts1reversed\ts1failedmodels\ts1asym\ts1mid\ts1growth\ts3signif\ts3reversed\ts3failedmodels\ts3asym\ts3mid\ts3growth\ts5signif\ts5reversed\ts5failedmodels\ts5asym\ts5mid\ts5growth\tagreement"

###R.eval "pdf(file='#{corpus}_s#{smoothing}_t#{threshold}.pdf')"
###R.eval "par(mfrow=c(10,3))"

pthreshold = 0.05

trainyears_set = []

#for j in 0..9 do
#    trainyears_set[j] = verbs[verbs.keys[0]].keys.sample(15).sort
#end

reversed_status = {}

verblist.each do |verb|
    signif = 0
    signs = []
    STDERR.puts verb
    yearhash = verbs[verb]
    output = "#{verb}\t#{verbs_total[verb].round(0)}\t#{yearhash.values.max.round(3)}\t#{yearhash.values.min.round(3)}\t#{(yearhash.values.max-yearhash.values.min).round(3)}"
    
    smoothings.each do |smoothing|    
        STDERR.puts "smoothing #{smoothing}"
        
        asym,mid,growth,rp,counternil,res,reversed,testres,predrp,pasym,pmid,pgrowth = fitlm(yearhash,verb,"black","blue",smoothing,pthreshold,corpus,trainyears_set,true,"significance",nil,nil,"")
        
        if rp != "NA"
            if rp < pthreshold
                signif += 1
            end
            if growth > 0
                signs << 1
            elsif growth < 0
                signs << -1
            end
        end
        
        
        output << "\t#{(rp)}\t#{reversed}\t#{counternil}\t#{asym.to_f.round(3)}\t#{mid.to_f.round(0).abs}\t#{growth.to_f.round(2)}"
        reversed_status[verb] = reversed
    end
    if signs.uniq.length > 1
        agreement = "no"
        STDERR.puts "No agreement about reversal!"
    else
        agreement = "yes"
    end
        
    
    output = [output.split("\t")[0],signif,output.split("\t")[1..-1],agreement].join("\t")
    o.puts output
end
###R.eval "dev.off()"
#__END__
verbs1, verbs1_total = extract(corpus1,verblist,threshold)

STDERR.puts "After 1: #{verblist}"

verbs2, verbs2_total = extract(corpus2,verblist,threshold)

STDERR.puts "After 2: #{verblist}"

o2 = File.open("summary2_lf_rw_#{corpus1}_#{corpus2}_t#{threshold}.tsv","w:utf-8")
o2.puts "verb\tcsignif\tpcurves1\tpasyms1\tpmids1\tpgrowths1\tpcurves3\tpasyms3\tpmids3\tpgrowths3\tpcurves5\tpasyms5\tpmids5\tpgrowths5"



verblist.each do |verb|
    curvesignif = 0
    yearhash = verbs1[verb]
    STDERR.puts verb
    output2 = "#{verb}"
    #STDERR.puts output2
    
    smoothings.each do |smoothing|
        STDERR.puts smoothing
        asym,mid,growth,rp,counternil,res,reversed,testres,predrp,pasym,pmid,pgrowth,pcurve = fitlm(yearhash,verb,"black","blue",smoothing,pthreshold,corpus1,trainyears_set,true,"robustness",reversed_status[verb],verbs2[verb],corpus2)
        
        if !pcurve.nil?
            if pcurve < pthreshold
                curvesignif += 1
            end
            
        end
        
        
        output2 << "\t#{pcurve}\t#{pasym}\t#{pmid}\t#{pgrowth}"
    end
    output2 = [output2.split("\t")[0],curvesignif,output2.split("\t")[1..-1]].join("\t")
    o2.puts output2
end