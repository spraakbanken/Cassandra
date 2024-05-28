s = 0.0
for j in 0..999999

    c = []
    
    for i in 0..5 do
        c[i] = rand(2)
    end
    #STDERR.puts c.join(" ")
    coherence = (((2 * c.count(1).to_f ) / c.length) - 1).abs
    s += coherence
    #if coherence >= 0.50
    #    s += 1
    #end
end
STDERR.puts s/j
