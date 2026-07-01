verblist = ["vägra"]

#verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]

corpus = ARGV[0]

verblist.each.with_index do |verb,index|
    system "ruby korp16.rb --qtype statistics --corpus #{corpus} --variable #{verb}_att_infstat wellander"
    system "ruby korp16.rb --qtype statistics --corpus #{corpus} --variable #{verb}_noatt_infstat wellander"
end



