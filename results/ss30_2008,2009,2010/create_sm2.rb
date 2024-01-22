variables = ["behaga", "fortsätta", "försöka", "glömma", "komma", "lova", "planera", "riskera","slippa", "sluta", "vägra"]


anonhash = {}
yearhash = {}
counter = 1
varhash = Hash.new{|hash,key| hash[key] = Hash.new{|hash2,key2| hash2[key2] = Hash.new}}

variables.each do |variable|
    filename = "familjeliv_#{variable}_t0_2008,2009,2010.tsv"
    f = File.open(filename,"r:utf-8")
    f.each_line.with_index do |line,index|
        if index > 0
            line2 = line.strip.split("\t")
            username = line2[0]
            if anonhash[username].nil?
                anonhash[username] = "user#{counter}"
                counter += 1
            end
            anon = anonhash[username]
            if yearhash[anon].nil?
                yearhash[anon] = line2[1]
            end
            yob = yearhash[anon]
            varhash[anon][variable]["v1"] = line2[4].to_f
            varhash[anon][variable]["v2"] = line2[5].to_f
        end
    end
end

o = File("")
o.puts "#{speaker}\t#{yob}\tbehagav1\tbehagav2\tfortsättav1\tfortsättav2\tförsökav1\tförsökav2\tglömmav1\tglömmav2\tkommav1\tkommav2\tlovav1\tlovav2\tplanerav1\tplanerav2\triskerav1\triskerav2\tslippav1\tslippav2\tslutav1\tslutav2\tvägrav1\tvägrav2"

varhash.each do |anon,hash2|
    oline = "#{anon}\t#{yearhash[anon]}"
    variables.each do |variable|
        oline << "\t#{hash2[variable]["v1"]}\t#{hash2[variable]["v2"]}"
    end

end