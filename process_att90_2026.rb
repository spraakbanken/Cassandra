require_relative "math_tools.rb"
path = "C:\\D\\DGU\\Repos\\Cassandra\\results\\ss90_2026"
files = Dir.children(path)

verbs = Hash.new{|hash,key| hash[key]=Hash.new}
verb_centered = Hash.new{|hash,key| hash[key]=Hash.new}
#verblist = ["komma"]
verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","anse","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]
verbs_total = Hash.new(0)

#,
@startyear = 2004
@lastyear = 2022

threshold = 1000



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
    return [jagged,direct]
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
STDOUT.puts "verb\tfreq\tjaggedness"
#verbs.each_pair do |verb,yearhash|
verblist.each do |verb|
    yearhash = verbs[verb]
    centeredyears_a = center(yearhash.keys)
    #STDERR.puts centeredyears_a
    centeredvalues_a = smooth(center(yearhash.values),3)
    centeredyears = {}
    centeredvalues = {}
    yearhash.keys.each.with_index do |year,index|
        centeredyears[year] = centeredyears_a[index]
        centeredvalues[year] = centeredvalues_a[index]
    end
    MOVE TO R
    R.eval "plot(values ~ years, ylim = c(0,1), pch=21, col = 'black', bg='black',type='l')"
    jagged = jaggedness(verb,centeredyears,centeredvalues)
    STDOUT.puts "#{verb}\t#{verbs_total[verb]}\t#{jagged[0].round(9)}"
end