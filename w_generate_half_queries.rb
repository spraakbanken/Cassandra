load 'wellander_vars.rb'

corpus = ARGV[0]
coverage = ARGV[1].to_f

def generate_half_query(file,coverage,verb1,att)
    f = File.open(file,"r:utf-8")
    total = 0.0
    coveredabs = 0.0
    coveredrel = 0.0
    inflist = []
    #STDERR.puts "going in"
    f.each_line.with_index do |line,index|
        #STDERR.puts line
        if index > 0
            line2 = line.strip.split("\t")
            if index == 1
                total = line2[1].to_f
            else
                inf = line2[0]
                abs = line2[1].to_f
                inflist << inf
                coveredabs += abs
                coveredrel = coveredabs/total
                if coveredrel > coverage
                    break
                end
            end
        end
    end
    halfquery = "[word = '#{verb1}' %c]"
    halfquery_naive = ""
    if att
        halfquery << " [word = 'att']"
        att_naive = "att "
    end
    
    halfquery << " ["
    
    inflist.each do |inf|
        halfquery << "word = '#{inf}' %c | "
        halfquery_naive << "\"#{verb1} #{att_naive}#{inf}\" OR "
    end
    halfquery = halfquery[0..-4]
    halfquery_naive = halfquery_naive[0..-5]
    halfquery << "]"
    return halfquery, halfquery_naive
end

ohalf = File.open("w_half_queries.txt","w:utf-8")
naive = File.open("w_naive_queries.txt","w:utf-8")

$verblist.each do |verb|
    #STDERR.puts verb
    attfile = "#{$PATH}\\variables\\wellander\\#{verb}_att_infstat\\#{corpus}\\statistics.tsv"
    attqueries = generate_half_query(attfile,coverage,$inflhash[verb],true)
    
    noattfile = "#{$PATH}\\variables\\wellander\\#{verb}_noatt_infstat\\#{corpus}\\statistics.tsv"
    noattqueries = generate_half_query(noattfile,coverage,$inflhash[verb],false)
    
    ohalf.puts "#label = #{verb}_whalf"
    ohalf.puts "variant1 = #{attqueries[0]}"
    ohalf.puts "variant2 = #{noattqueries[0]}"
    
    naive.puts attqueries[1]
    naive.puts noattqueries[1]
    
    ohalf.puts "#label = #{verb}_wfull"
    ohalf.puts "variant1 = [word = '#{$inflhash[verb]}' %c] [word = 'att' %c] [msd = '.*INF\\.AKT.*']"
    ohalf.puts "variant2 = [word = '#{$inflhash[verb]}' %c] [msd = '.*INF\\.AKT.*']"
    ohalf.puts ""
    
end
