require_relative "date_tools.rb"
PATH = "D:\\DGU\\CassandraMy\\SMCorpora\\"

forum = "flashback"
countinteractions = false
countusers = true
#subforums = ["resor"]

subforums = ["dator", "droger", "ekonomi", "flashback", "fordon", "hem", "kultur", "livsstil", "mat", "ovrigt", "politik", "resor", "samhalle", "sex", "sport", "vetenskap"]

threshold_time_distance = 5
threshold_post_distance = ARGV[0].to_i

authorhash = Hash.new{|hash,key| hash[key] = Hash.new}
#authorfile = File.open("results\\flashback_hbt(q)_resor.tsv","r:utf-8")
authorfile = File.open("results\\flashback_hbt(q).tsv","r:utf-8")
authors = {}
yearhash = Hash.new{|hash,key| hash[key] = Hash.new(0.0)}
authorfile.each_line.with_index do |line,index|
    if index > 0
        line2 = line.strip.split("\t")
        year = line2[0].to_i
        username = line2[1]
        #authors[username] = true
        v1rel = line2[-2].to_f
        v2rel = line2[-1].to_f
        if v2rel > v1rel
            authorhash[year][username] = "innovative"
            yearhash[year]["innovative"] += 1
        else
            authorhash[year][username] = "conservative"
            yearhash[year]["conservative"] += 1
        end
    end
end


=begin
#STDOUT.puts "year\tc\ti"


authorhash.each_pair do |year,users|
    c = 0
    i = 0
    users.each_pair do |user,status|
        if status == "conservative"
            c += 1
            
        elsif status == "innovative"
            i += 1
        end
    end   
    #STDOUT.puts "#{year}\t#{c}\t#{i}"
end

__END__
=end
c_to_c = Hash.new(0.0)
c_to_i = Hash.new(0.0)
i_to_i = Hash.new(0.0)
i_to_n = Hash.new(0.0)
c_to_n = Hash.new(0.0)
n_to_n = Hash.new(0.0)

cusers_to_iusers = Hash.new{|hash,key| hash[key] = Hash.new}
cusers_to_cusers = Hash.new{|hash,key| hash[key] = Hash.new}
cusers_to_nusers = Hash.new{|hash,key| hash[key] = Hash.new}

subforums.each do |subforum|
    f = File.open("#{PATH}#{forum}-#{subforum}_post.conllu","r:utf-8")
    
    current_user = ""
    prev_thread = ""
    current_thread = ""
    users_in_thread = {}
    #post_in_thread = 0
    current_year = ""
    current_date = ""
    prev_year = ""
    prev_posts = []

    STDERR.puts subforum
    
    f.each_line do |line|
        line1 = line.strip
        if line1 != ""
            if line1.include?("# username")
                    
                    if !line1.split("=")[1].nil?
                        #post_in_thread += 1
                        current_user = line1.split("=")[1].strip
                        ###if authorhash[current_year][current_user] != nil #authors[current_user]
                            prev_posts.each do |prev_post|
                                ###if authorhash[current_year][prev_post[0]] != nil
                                    if (abs_day(date_to_array(current_date, "-")) - abs_day(date_to_array(prev_post[1], "-")) <= threshold_time_distance) and (current_user != prev_post[0]) 
                                        #userlabel = [current_user,prev_post[0]].sort
                                        #proximity_hash[userlabel] += 1
                                        #interactions[subforum][userlabel] << abs_day(date_to_array(current_date, "-"))
                                        if countinteractions
                                            if authorhash[current_year][current_user] == authorhash[current_year][prev_post[0]]
                                            
                                                if authorhash[current_year][current_user] == "conservative"
                                                    c_to_c[current_year] += 1
                                                elsif authorhash[current_year][current_user] == "innovative"
                                                    i_to_i[current_year] += 1
                                                else
                                                    n_to_n[current_year] += 1
                                                end
										    
                                            else
                                                if authorhash[current_year][prev_post[0]] == nil
                                                    if authorhash[current_year][current_user] == "conservative" 
                                                        c_to_n[current_year] += 1
                                                    else
                                                        i_to_n[current_year] += 1
                                                    end
                                                elsif authorhash[current_year][current_user] == nil
                                                    if authorhash[current_year][prev_post[0]] == "conservative" 
                                                        c_to_n[current_year] += 1
                                                    else
                                                        i_to_n[current_year] += 1
                                                    end
                                                else
                                                    c_to_i[current_year] += 1
                                                end
                                                
                                            end
                                        end
                                        if countusers
                                            if authorhash[current_year][current_user] == "conservative"
                                                if authorhash[current_year][prev_post[0]] == "conservative"
                                                    cusers_to_cusers[current_year][current_user] = true
                                                    cusers_to_cusers[current_year][prev_post[0]] = true
                                                elsif authorhash[current_year][prev_post[0]] == "innovative"
                                                    cusers_to_iusers[current_year][current_user] = true
                                                    #cusers_to_cusers[current_year][prev_post[0]] = true
                                                else
                                                    cusers_to_nusers[current_year][current_user] = true
                                                end
                                            elsif authorhash[current_year][prev_post[0]] == "conservative"
                                                if authorhash[current_year][current_user] == "innovative"
                                                    cusers_to_iusers[current_year][prev_post[0]] = true
                                                    #cusers_to_cusers[current_year][prev_post[0]] = true
                                                else
                                                    cusers_to_nusers[current_year][prev_post[0]] = true
                                                end

                                            end

                                        end
                                    end
                                #end
                            end
                                
                            if !(prev_posts.length < threshold_post_distance)
                                prev_posts.shift
                            end
                            prev_posts << [current_user, current_date]
                        #end
                    end

            elsif line1.include?("# post_date")
                current_date = line1.split("=")[1].strip.split(" ")[0]
                current_year = line1.split(" = ")[1].split("-")[0].to_i

            elsif line1.include?("# thread_id")
                current_thread = line1.split("=")[1].strip
                if current_thread != prev_thread
                    if prev_thread != ""
                        prev_posts = []
                    end

                    if prev_thread != ""
                        prev_thread = current_thread
                    end
                    
                end
            end
        end
    end
end

#add direction?
if countinteractions
    o1 = File.open("flashback_hbtq_interactions_n.tsv","w:utf8")
    o1.puts "year\tc_to_n_by_c\tc_to_c_by_c\tc_to_i_by_c\tc_total\tc_to_i_by_i\ti_to_n_by_i\ti_to_i_by_i\ti_total\tn_to_n"
    authorhash.keys.sort.each do |year|
        c_total = c_to_c[year] + c_to_i[year] + c_to_n[year]
        i_total = i_to_i[year] + c_to_i[year] + i_to_n[year]
        #total = c_to_c[year] + c_to_i[year] + i_to_i[year] + c_to_n[year] + i_to_n[year]
        #STDOUT.puts "#{year}\t#{c_to_c[year]/total}\t#{c_to_i[year]/total}\t#{i_to_i[year]/total}\t#{c_to_n[year]/total}\t#{i_to_n[year]/total}\t#{total}"
        o1.puts "#{year}\t#{c_to_n[year]/c_total}\t#{c_to_c[year]/c_total}\t#{c_to_i[year]/c_total}\t#{c_total}\t#{c_to_i[year]/i_total}\t#{i_to_n[year]/i_total}\t#{i_to_i[year]/i_total}\t#{i_total}\t#{n_to_n[year]}"
    end
    o1.close
end
if countusers
    STDOUT.puts "year\tcusers_to_cusers\tcusers_to_iusers\tcusers_to_nusers\ttotal"
    authorhash.keys.sort.each do |current_year|
        total = (cusers_to_cusers[current_year].keys.length + cusers_to_iusers[current_year].keys.length + cusers_to_nusers[current_year].keys.length).to_f
        STDOUT.puts "#{current_year}\t#{cusers_to_cusers[current_year].keys.length/total}\t#{cusers_to_iusers[current_year].keys.length/total}\t#{cusers_to_nusers[current_year].keys.length/total}\t#{total}"
    end
end