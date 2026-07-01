verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]

verblist2 = ["beslutar","hotar","planerar","lovar","tenderar","riskerar","avser","fortsätter","kommer","förmår","glömmer","behagar","vägrar","slutar","ids","slipper","försöker","låtsas","lyckas","hinner","börjar","orkar","vågar","behöver","brukar","råkar","torde","ämnar","förefaller"]

ofull = File.open("inf_queries.txt", "w:utf-8")

verblist.each.with_index do |verb,index|
   ofull.puts "#label = #{verb}_att_infstat"
   ofull.puts "variant1 = [word = '#{verblist2[index]}' %c] [word = 'att' %c] [msd = '.*INF\\.AKT.*']"
   ofull.puts ""
   ofull.puts "#label = #{verb}_noatt_infstat"
   ofull.puts "variant1 = [word = '#{verblist2[index]}' %c] [msd = '.*INF\\.AKT.*']"
   ofull.puts ""
   ofull.puts "#label = #{verb}_wfull"
   ofull.puts "variant1 = [word = '#{verblist2[index]}' %c] [word = 'att' %c] [msd = '.*INF\\.AKT.*']"
   ofull.puts "variant2 = [word = '#{verblist2[index]}' %c] [msd = '.*INF\\.AKT.*']"
   ofull.puts ""

end

ofull.close

