f = File.open("infinitival_verbs.tsv","r:utf-8")

f.each_line.with_index do |line,index|
    if index > 0
        line2 = line.strip.split("\t")
        if line2[-1] == "Include"
            verb = line2[1]
=begin
            label = "#label = ss90_#{verb}"
            v1 = "variant1 = [lemma contains '#{verb}' & (msd = '.*VB\.PRS\.AKT.*' | msd = '.*VB\.PRT\.AKT.*')] [word = 'att' %c] [msd = '.*INF\.AKT.*'] [msd != '.*INF.*']"
            v2 = "variant2 = [lemma contains '#{verb}' & (msd = '.*VB\.PRS\.AKT.*' | msd = '.*VB\.PRT\.AKT.*')] [msd = '.*INF\.AKT.*'] [msd != '.*INF.*']"
            STDOUT.puts label
            STDOUT.puts v1
            STDOUT.puts v2
            STDOUT.puts 
=end
            #system "ruby korp16.rb --variable ss90_#{verb} --corpus familjeliv-all"
            system "ruby plot.rb --variable ss90_#{verb} --corpus familjeliv-all --showplot no"
        end
    end
end