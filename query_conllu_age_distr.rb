token_threshold = 10000
firstage = 18

corpus = "familjeliv"

require_relative "queries\\query_tools.rb"

#subforums = ["pappagrupp"]
subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","expert","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn"]





PATH = "C:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
cohorts_source = "results\\cohorts_min1960_step4.tsv"
f = File.open(cohorts_source,"r:utf-8")

cohorts = {}
f.each_line.with_index do |line,index|
    if index > 0
        line2 = line.strip.split("\t")
        min = line2[0].to_i
        max = line2[1].to_i
        for i in min..max
            if i != 1970
                cohorts[i] = index
            end
        end
    end
end
#STDERR.puts "#{cohorts}"

#__END__
cohorts_per_year = Hash.new{|hash,key| hash[key] = Hash.new(0)}
posts_per_age = Hash.new{|hash,key| hash[key] = Hash.new(0)}

subforums.each do |subforum|
    STDERR.puts subforum
    f = File.open("#{PATH}familjeliv-#{subforum}_sentence_age#{token_threshold}_#{firstage}.conllu","r:utf-8")
    
    current_age = ""
    current_cohort = ""
    current_username = ""
    current_year = ""
    yob = ""
    current_agebin = ""
    
    
    
    f.each_line do |line|
        line1 = line.strip
    
        if line1 == "" #not necessary to reset all variables, but may be worth it for safety's sake
            current_cohort = cohorts[yob]
            if !current_cohort.nil?
                cohorts_per_year[current_year][current_cohort] += 1           
            end
            
            #STDERR.puts current_age
            if yob != 1970
                posts_per_age[current_year][current_age] += 1
            end
            
            current_age = ""
            current_cohort = ""
            current_username = ""
            current_year = ""
            yob = ""
            #break
        elsif line1[0] == "#"
            if line1.include?("# age ")
                current_age = line1.split(" = ")[1].to_i
                #STDERR.puts line1
                #STDERR.puts current_age
                #break
            elsif line1.include?("# yob")
                yob = line1.split(" = ")[1].to_i
            elsif line1.include?("# username")
                current_username = line1.split(" = ")[1]
            elsif line1.include?("# post_date")
                current_year = line1.split(" = ")[1].split("-")[0].to_i
            end        
        end
    end
end

#STDERR.puts cohorts_per_year.keys

o1 = File.open("familjeliv_weighted_average_age_per_year.tsv","w:utf-8")
o1.puts "year\tweighted_average"

#STDERR.puts "#{posts_per_age}"

posts_per_age.keys.sort.each do |year|
    ave = 0.0
    totalposts = 0.0
    posts_per_age[year].each_value do |posts| 
        totalposts += posts
    end
    #STDERR.puts totalposts
    posts_per_age[year].each_pair do |age, posts|
        ave += age * (posts/totalposts)
    end
    o1.puts "#{year}\t#{ave}"
end



#__END__
o = File.open("familjeliv_diachronic_cohort_distribution.tsv","w:utf-8")

o.puts "year\tcohort1\tcohort2\tcohort3\tcohort4\tcohort5\tcohort6\tcohort7\tcohort8"
cohorts_per_year.keys.sort.each do |year|
    output = "#{year}"    
    for i in 1..8 do
        output << "\t#{cohorts_per_year[year][i]}"
    end
    o.puts output
    #cohorts_per_year[year].each_value do |cohort,freq|
    #    STDERR.puts "#{year}\t#{cohort}\t#{freq}"
    #end
end

