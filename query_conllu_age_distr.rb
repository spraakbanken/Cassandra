token_threshold = 10000
firstage = 18

corpus = "familjeliv"

require_relative "queries\\query_tools.rb"

#subforums = ["adoption"]
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
   
cohorts_per_year = Hash.new{|hash,key| hash[key] = Hash.new(0)}

subforums.each do |subforum|
    STDERR.puts subforum
    f = File.open("#{PATH}familjeliv-#{subforum}_sentence_age#{token_threshold}_#{firstage}.conllu","r:utf-8")
    
    current_age = ""
    current_agebin = ""
    current_username = ""
    current_year = ""
    yob = ""
    
    
    
    f.each_line do |line|
        line1 = line.strip
    
        if line1 == "" #not necessary to reset all variables, but may be worth it for safety's sake
            current_age = ""
            current_agebin = ""
            current_username = ""
            current_year = ""
            yob = ""
        elsif line1[0] == "#"
            if line1.include?("# age")
                current_age = line1.split(" = ")[1]
            elsif line1.include?("# yob")
                yob = line1.split(" = ")[1].to_i
            elsif line1.include?("# username")
                current_username = line1.split(" = ")[1]
            elsif line1.include?("# post_date")
                current_year = line1.split(" = ")[1].split("-")[0].to_i
            end
            current_agebin = cohorts[yob]
            if !current_agebin.nil?
                cohorts_per_year[current_year][current_agebin] += 1           
            end
        end
    end
end

cohorts_per_year.each_pair do |year, cohort_distr|
    cohort_distr.each_pair do |cohort,freq|
         
    end
end

STDERR.puts 