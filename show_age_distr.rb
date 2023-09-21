subforums = ["adoption","allmanna-ekonomi","allmanna-familjeliv","allmanna-fritid","allmanna-husdjur","allmanna-hushem","allmanna-kropp","allmanna-noje","allmanna-samhalle","allmanna-sandladan","anglarum","foralder","gravid","kansliga","medlem-allmanna","medlem-foraldrar","medlem-planerarbarn","medlem-vantarbarn","pappagrupp","planerarbarn","sexsamlevnad","svartattfabarn","expert"]


PATH = "C:\\Sasha\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
#PATH = "D:\\D\\DGU\\CassandraMy\\SMCorpora\\familjeliv-age\\"
token_threshold = 10000
firstage = 18
#total_threshold = 10
        
yob_authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
age_authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
cohort_authorhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
yearhash = Hash.new(0.0)


subforums.each do |subforum|
    STDERR.puts subforum
    f = File.open("#{PATH}familjeliv-#{subforum}_sentence_age#{token_threshold}_#{firstage}.conllu","r:utf-8")
    
    current_age = ""
    current_agebin = ""
    current_username = ""
    current_year = ""
    yob = ""
    
    prevprev_tokenc = ""
    prev_tokenc = ""
    prev_pos = ""
    prevprev_pos = ""
    prevprev_deprel = ""
    prev_deprel = ""
    prev_lemma = []
    prevprev_lemma = []
    prevprevprev_lemma = []

    prev_msd = ""
    prevprev_msd = ""
    prevprevprev_msd = ""

    
    f.each_line do |line|
        line1 = line.strip
    
        if line1 == "" #not necessary to reset all variables, but may be worth it for safety's sake
            current_age = ""
            current_agebin = ""
            current_username = ""
            current_year = ""
            yob = ""
            prevprev_tokenc = ""
            prev_tokenc = ""
            prev_pos = ""
            prevprev_pos = ""
            prevprev_deprel = ""
            prev_deprel = ""
        elsif line1[0] == "#"
            if line1.include?("# agebin")
                current_agebin = line1.split(" = ")[1]
            elsif line1.include?("# age")
                current_age = line1.split(" = ")[1]
            elsif line1.include?("# yob")
                yob = line1.split(" = ")[1].to_i
            elsif line1.include?("# username")
                current_username = line1.split(" = ")[1]
            elsif line1.include?("# post_date")
                current_year = line1.split(" = ")[1].split("-")[0].to_i
            
                #authorhash[current_username] = true
            end
        else
            if yob != 1970
                #yob_authorhash[current_year][yob] += 1
                #age_authorhash[current_year[current_age] += 1
                cohort_authorhash[current_year][current_agebin] += 1
                yearhash[current_year] += 1
                
            end
        end
    end


end

o = File.open("age\\distr.tsv","w:utf-8")
o.puts "year\tcohort\tproportion"

cohort_authorhash.each_pair do |year,cohorthash|
    cohorthash.each_pair do |cohort,n|
        o.puts "#{year}\t#{cohort}\t#{n/yearhash[year]}"
    end

end
