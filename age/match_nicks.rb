f = File.open("age_10000_firstage18.tsv","r:utf-8")
o = File.open("matching2.tsv","w:utf-8")
o.puts "speaker\tnickyear\tprofileyear"
#yearhash = {}
f.each_line.with_index do |line,index|
    line1 = line.strip.split("\t")
    nick = line1[0]
    year = line1[2].to_i
    ####c = nick =~ /19\d\d\z/
    c = nick =~ /\D[456789]\d\z/

    ####if c.nil?
    ####    c = nick =~ /19\d\d\D/
    ####end
    if c.nil?
        
    else
        ####nickyear = "#{nick[c..c+3]}".to_i
        nickyear = "#{nick[c+1..c+2]}".to_i
        o.puts "#{nick}\t#{nickyear}\t#{year}"
    end
    



    #yearhash[line1[0]] = line1[2].to_i
    
end
f.close
