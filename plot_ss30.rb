window = 5
f = File.open("ss30.tsv","r:utf-8")
#o = File.open("summary_ss30_wholecorpus_smoothing#{window}.tsv", "w:utf-8")
#o.puts "verb\tv2rel_2009\tbest_model\tr2\tslope\trange"
#o.close
f.each_line do |line|
    verb = line.split("\t")[0]
    system "ruby korp_and_plot.rb --variable ss90_#{verb} --corpus press-all --showplot no --format png --defaultyaxis yes --smoothing #{window}"

end

