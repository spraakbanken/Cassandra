load 'wellander_vars.rb'

ofull = File.open("w_inf_queries.txt", "w:utf-8")


$verblist.each.with_index do |verb,index|

    ofull.puts "#label = #{verb}_att_infstat"
    ofull.puts "variant1 = [word = '#{$inflhash[verb]}' %c] [word = 'att' %c] [msd = '.*INF\\.AKT.*']"
    ofull.puts ""
    ofull.puts "#label = #{verb}_noatt_infstat"
    ofull.puts "variant1 = [word = '#{$inflhash[verb]}' %c] [msd = '.*INF\\.AKT.*']"
    ofull.puts ""
    
end

ofull.close


