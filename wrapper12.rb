variables = ["ss90_anse", "ss90_behaga", "ss90_fortsätta", "ss90_försöka", "ss90_glömma", "ss90_komma", "ss90_lova", "ss90_planera", "ss90_riskera","ss90_slippa", "ss90_sluta", "ss90_vägra"]

variables.each do |variable|
    #system "ruby korp16.rb --variable #{variable} --corpus press-all"
    #system "ruby korp16.rb --variable #{variable} --corpus press2-all"
    #system "ruby korp16.rb --variable #{variable} --corpus webbnyheter-all"
    #system "ruby korp16.rb --variable #{variable} --corpus gp-all2"
    #system "ruby merge_results.rb --variable #{variable} --corpus press2-all,webbnyheter-all,press-all,gp-all2 --merged_label earlypress"
    #system "ruby plot.rb --variable #{variable} --corpus earlypress-all --format png --defaultyaxis no --showplot no"
    system "ruby korp16.rb --variable #{variable} --corpus flashback-all"

end