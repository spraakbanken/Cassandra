f = File.open("ss31.tsv","r:utf-8")

f.each_line do |line|
    verb = line.split("\t")[0]
    system "ruby plot.rb --variable ss90_#{verb} --corpus familjeliv-all --showplot no --format png --defaultyaxis yes --smoothing 7"

end