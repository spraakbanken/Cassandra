def process_cmd
    if !ARGV.include?("--corpus")
        abort "Cassandra says: corpus not specified"
        #abort "Cassandra says: qtype not specified, must be \"time\" or \"authors\""
    else
        corpus_and_label = ARGV[ARGV.index("--corpus") + 1]
        if ARGV.include?("--corpus2")
            corpus_and_label2 = ARGV[ARGV.index("--corpus2") + 1]
        end
    
        if !ARGV.include?("--qtype")
            query = "time"
        else
            query = ARGV[ARGV.index("--qtype") + 1]
        end
        
        if query == "time"
    
            if !ARGV.include?("--variable")
                abort "Cassandra says: variable not specified, must be specified if qtype == time"
            else    
                variable = ARGV[ARGV.index("--variable") + 1]
                if !ARGV.include?("--user")
                    username = "all_users"
                else
                    username = code_space(ARGV[ARGV.index("--user") + 1],"decode")
                end
    
                if !ARGV.include?("--nvariants")
                    nvariants = 2
                else
                    nvariants = ARGV[ARGV.index("--nvariants") + 1].to_i
                end
    
                if !ARGV.include?("--granularity")
                    granularity = "y"
                else
                    granularity = ARGV[ARGV.index("--granularity") + 1]
                end
    
                if !ARGV.include?("--whattoplot")
                    if nvariants == 2
                        whattoplot = "v2rel"
                    elsif nvariants == 1
                        whattoplot = "v1ipm"
                    end
                else
                    whattoplot = ARGV[ARGV.index("--whattoplot") + 1]
                end
    
                if !ARGV.include?("--max")
                    max_predef = nil
                else
                    max_predef = ARGV[ARGV.index("--max") + 1].to_f
                end
    
                if !ARGV.include?("--dir")
                    dir = "all_plots"
                else
                    dir = ARGV[ARGV.index("--dir") + 1]
                end
    
                if ARGV.include?("--nyl_year")
                    nyl_year = ARGV[ARGV.index("--nyl_year") + 1].to_i
                end

                if !ARGV.include?("--plot_threshold")
                    total_threshold = 20
                else
                    total_threshold = ARGV[ARGV.index("--plot_threshold") + 1].to_i
                end

                if !ARGV.include?("--variable_source")
                    variable_source = "korp_queries.rb"
                else
                    variable_source = ARGV[ARGV.index("--variable_source") + 1]
                end

            end
        elsif query == "authors"
            if ARGV.include?("--year")
                year_for_authors = ARGV[ARGV.index("--year") + 1].to_i
            end
        else 
            abort "Cassandra says: unknown qtype, must be \"time\" or \"authors\""
        end
        if ARGV.include?("--local")
            only_process_local = true
        end
    end
    outhash = {"corpus_and_label" => corpus_and_label, "corpus_and_label2" => corpus_and_label2, "query" => query, "variable" => variable, "username" => username, "nvariants" => nvariants, "whattoplot" => whattoplot, "max" => max_predef, "dir" => dir, "nyl_year" => nyl_year, "only_process_local" => only_process_local, "granularity" => granularity, "total_threshold" => total_threshold, "variable_source" => variable_source}
    return outhash
end