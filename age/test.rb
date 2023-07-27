word = ARGV[0]

c = word =~ /19\d\d\z/
#STDERR.puts c

#__END__

if c.nil?
    c = word =~ /19\d\d\D/
end

if c.nil?
    STDERR.puts "no"
else
    STDERR.puts "yes: #{word[c..c+3]}"
end
