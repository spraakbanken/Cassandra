PATH = "C:\\D\\DGU\\Repos\\Cassandra"

corpus = ARGV[0]
coverage = ARGV[1].to_f
verblist = ["vägra"]

#verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]

inflhash = {"besluta" => "beslutar","hota" => "hotar","planera" => "planerar","lova" => "lovar","tendera" => "tenderar","riskera" => "riskerar","avse" => "avser","fortsätta" => "fortsätter","komma" => "kommer","förmå" => "förmår","glömma" => "glömmer","behaga" => "behagar","vägra" => "vägrar","sluta" => "slutar","idas" => "ids","slippa" => "slipper","försöka" => "försöker","låtsas" => "låtsas","lyckas" => "lyckas","hinna" => "hinner","börja" => "börjar","orka" => "orkar","våga" => "vågar","behöva" => "behöver","bruka" => "brukar","råka" => "råkar","torde" => "torde","ämna" => "ämnar","förefalla" => "förefaller"}

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

ohalf = File.open("wellanders\\half_queries.txt","w:utf-8")
naive = File.open("wellanders\\naive_queries.txt","w:utf-8")

verblist.each do |verb|
    #STDERR.puts verb
    attfile = "#{PATH}\\variables\\wellander\\#{verb}_att_infstat\\#{corpus}\\statistics.tsv"
    attqueries = generate_half_query(attfile,coverage,inflhash[verb],true)
    
    noattfile = "#{PATH}\\variables\\wellander\\#{verb}_noatt_infstat\\#{corpus}\\statistics.tsv"
    noattqueries = generate_half_query(noattfile,coverage,inflhash[verb],false)
    
    ohalf.puts "variant1 = #{attqueries[0]}"
    ohalf.puts "variant2 = #{noattqueries[0]}"
    
    naive.puts attqueries[1]
    naive.puts noattqueries[1]
end
