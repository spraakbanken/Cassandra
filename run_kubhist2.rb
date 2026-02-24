f = File.open("modernpress.txt","r:utf-8")
f.each_line do |line|
    system "ruby korp16.rb --corpus #{line.strip} --variable att2026kommer --nolabel"
end

