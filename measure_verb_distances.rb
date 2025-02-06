require_relative "math_tools.rb"

def read_vectors(file)
    vectors = {}
    file.each_line do |line|
        line2 = line.strip.split("\t")
        vector = []
        line2[1..-1].each do |number|
            vector << number.to_f
        end
        vectors[line2[0]] = vector
    end
    return vectors
end

verb_vectors = File.open("verb_vectors.tsv","r:utf-8")

out = File.open("verb_distances.tsv", "w:utf-8")
out.puts "verb1\tverb2\tcosine_distance\tlevenshtein_distance"

used_pairs = []
vectors = read_vectors(verb_vectors)
vectors.each_pair do |verb1,vector1|
    vectors.each_pair do |verb2,vector2|
        if verb1 != verb2 and !used_pairs.include?([verb1,verb2].sort)
            used_pairs << [verb1,verb2].sort
            distance = 1 - cosine_sim(vector1, vector2)
            @l = Levenshtein.new
            lev_distance =  @l.lev_compare(verb1, verb2)
            out.puts "#{verb1}\t#{verb2}\t#{distance}\t#{lev_distance}"
        end
    end
end

