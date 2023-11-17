require_relative "date_tools.rb"
PATH = "D:\\DGU\\CassandraMy\\SMCorpora\\"

forum = "flashback"
#subforums = ["resor"]

subforums = ["dator", "droger", "ekonomi", "flashback", "fordon", "hem", "kultur", "livsstil", "mat", "ovrigt", "politik", "resor", "samhalle", "sex", "sport", "vetenskap"]

threshold_time_distance = 5
threshold_post_distance = 3

authorhash = Hash.new{|hash,key| hash[key] = Hash.new}
authorfile = File.open("results\\flashback_hbt(q).tsv","r:utf-8")
authors = {}

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
        else
            authorhash[year][username] = "conservative"
        end
    end
end


c_to_c = Hash.new(0.0)
c_to_i = Hash.new(0.0)
i_to_i = Hash.new(0.0)

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
                        if authorhash[current_year][current_user] != nil #authors[current_user]
                            prev_posts.each do |prev_post|
                                if authorhash[current_year][prev_post[0]] != nil
                                    if (abs_day(date_to_array(current_date, "-")) - abs_day(date_to_array(prev_post[1], "-")) <= threshold_time_distance) and (current_user != prev_post[0]) 
                                        #userlabel = [current_user,prev_post[0]].sort
                                        #proximity_hash[userlabel] += 1
                                        #interactions[subforum][userlabel] << abs_day(date_to_array(current_date, "-"))
                                        if authorhash[current_year][current_user] == authorhash[current_year][prev_post[0]]
                                            if authorhash[current_year][current_user] == "conservative"
                                                c_to_c[current_year] += 1
                                            elsif
                                                i_to_i[current_year] += 1
                                            end
								    
                                        else
                                            c_to_i[current_year] += 1
                                        end
                                    end
                                end
                            end
                                
                            if !(prev_posts.length < threshold_post_distance)
                                prev_posts.shift
                            end
                            prev_posts << [current_user, current_date]
                        end
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

STDOUT.puts "year\tc_to_c\tc_to_i\ti_to_i\ttotal"
authorhash.keys.sort.each do |year|
    total = c_to_c[year] + c_to_i[year] + i_to_i[year]
    STDOUT.puts "#{year}\t#{c_to_c[year]/total}\t#{c_to_i[year]/total}\t#{i_to_i[year]/total}\t#{total}"
end