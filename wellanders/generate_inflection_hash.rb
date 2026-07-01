verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]

verblist2 = ["beslutar","hotar","planerar","lovar","tenderar","riskerar","avser","fortsätter","kommer","förmår","glömmer","behagar","vägrar","slutar","ids","slipper","försöker","låtsas","lyckas","hinner","börjar","orkar","vågar","behöver","brukar","råkar","torde","ämnar","förefaller"]

verblist.each.with_index do |verb,index|
    STDERR.puts "\"#{verb}\" => \"#{verblist2[index]}\""
end