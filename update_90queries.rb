#verblist = ["besluta"]

verblist = ["besluta","hota","planera","lova","tendera","riskera","avse","fortsätta","komma","förmå","glömma","behaga","vägra","anse","sluta","idas","slippa","försöka","låtsas","lyckas","hinna","börja","orka","våga","behöva","bruka","råka","torde","ämna","förefalla"]

verblist.each do |verb|
    system "ruby korp16.rb --variable att2026_#{verb} --corpus forum-all"
    system "ruby korp16.rb --variable att2026_#{verb} --corpus familjeliv-all"
    system "ruby korp16.rb --variable att2026_#{verb} --corpus flashback-all"
end