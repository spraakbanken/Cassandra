f = File.open("flashback_hbtq_actual_per_speaker_individual.tsv","r:utf-8")

users_innov = Hash.new(0.0)
users_exp = Hash.new(0.0)
users_tot = Hash.new(0.0)

userhash_innov = Hash.new{|hash,key| hash[key] = Hash.new}
userhash_exp_c = Hash.new{|hash,key| hash[key] = Hash.new}
userhash_exp_i = Hash.new{|hash,key| hash[key] = Hash.new}
f.each_line.with_index do |line,index|
    if index > 0
        line2 = line.strip.split("\t")
        year = line2[0].to_i
        user = line2[1]
        if line2[2].to_s != ""
            users_innov[user] += 1
            innov = line2[2].to_f
            userhash_innov[user][year] = innov
        end

        exp_c = line2[3].to_f
        exp_i = line2[4].to_f
        if exp_c > 0 or exp_i > 0
            users_exp[user] += 1
        end
        userhash_exp_c[user][year] = exp_c
        userhash_exp_i[user][year] = exp_i
        users_tot[user] = users_exp[user] + users_innov[user]
    end

end

STDOUT.puts "username\tdatapoints_t\tchange\tinnov_start\tinnov_end\tdatapoints_i\tdatapoints_e"


users_tot.each_pair do |user,tot|
    uservals = userhash_innov[user].values
    diff = uservals.max - uservals.min
    
    STDOUT.puts "#{user}\t#{tot}\t#{diff}\t#{uservals[0]}\t#{uservals[-1]}\t#{users_innov[user]}\t#{users_exp[user]}"
end