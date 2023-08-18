f = File.open("infinitival_verbs.tsv","r:utf-8")
o = File.open("ss90_overview.tsv","w:utf-8")
o.puts "verb\ttotal\tv1\tv2\ttotal_2009\tv1_2009\tv2_2009\tv2rel_2009\tv2rel_total"

#deponents = ["hoppas", "idas", "låtsas", "lyckas", "nännas", "täckas", "tyckas"]
deponents = ["befinnas", "töras", "synas"]

f.each_line.with_index do |line,index|
    if index > 0
        line2 = line.split("\t")
        verb = line2[1]
        #STDOUT.puts "#{verb}\t#{line2[-4]}"
        if line2[-4] == "Include"
            #verb = line2[1]
            STDERR.puts verb

            #if deponents.include?(verb)
            #    system "ruby korp16.rb --variable ss90_#{verb} --corpus familjeliv-all"
            #    system "ruby plot.rb --variable ss90_#{verb} --corpus familjeliv-all --showplot no --format png"
            #end
#=begin
            v12009 = 0
            v22009 = 0
            
            v1 = 0
            v2 = 0
            file = File.open("variables\\ss90_#{verb}\\familjeliv\\all\\all_users.tsv","r:utf-8")
            file.each_line.with_index do |fline,findex|
                #STDERR.puts fline
                if findex > 0
                    fline2 = fline.strip.split("\t")
                
                    v1 += fline2[2].to_i
                    v2 += fline2[3].to_i 
                    if fline2[0] == "2009"
                        v12009 = fline2[2].to_i
                        v22009 = fline2[3].to_i
                    end
                end
            end
            file.close

            o.puts "#{verb}\t#{v1+v2}\t#{v1}\t#{v2}\t#{v12009 + v22009}\t#{v12009}\t#{v22009}\t#{v22009.to_f/(v12009 + v22009)}\t#{v2.to_f/(v1+v2)}"
            system "ruby plot.rb --variable ss90_#{verb} --corpus familjeliv-all --showplot no --format png"
            
#=end
        end
    end
end