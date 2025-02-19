def check_lemma(lemma, criterion)
    result = false
    lemma.each do |lemmavar|
        if lemmavar == criterion
            result = true
            break
        end
    end
    return result
end

def apply_criteria_ss30(tokenc, lemma, prev_lemma, prevprev_lemma, prevprevprev_lemma, pos, msd, prev_msd, prevprev_msd, prevprevprev_msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel, verb_of_interest)
    if check_lemma(prevprevprev_lemma,verb_of_interest) and (((prevprevprev_msd.include?("VB.PRT.AKT") or prevprevprev_msd.include?("VB.PRS.AKT")) and verb_of_interest[-1] != "s") or ((prevprevprev_msd.include?("VB.PRT.SFO") or prevprevprev_msd.include?("VB.PRS.SFO")) and verb_of_interest[-1] == "s")) and prevprev_tokenc == "att" and prev_msd.include?("INF.AKT") and !msd.include?("INF")
        condition = 1
        #if rand(1000) == 0
        #    STDOUT.puts "1 #{prevprevprev_lemma} #{prevprev_tokenc} #{prev_tokenc} #{tokenc}"
        #end
    elsif check_lemma(prevprev_lemma,verb_of_interest) and (((prevprev_msd.include?("VB.PRT.AKT") or prevprev_msd.include?("VB.PRS.AKT")) and verb_of_interest[-1] != "s") or ((prevprev_msd.include?("VB.PRT.SFO") or prevprev_msd.include?("VB.PRS.SFO")) and verb_of_interest[-1] == "s")) and prev_msd.include?("INF.AKT") and !msd.include?("INF")
        condition = 2
        #if rand(1000) == 0
        #    STDOUT.puts "2 #{prevprev_tokenc} #{prev_tokenc} #{tokenc}"
        #end
        
    else
        condition = 0
        #if rand(1000000) == 0
        #    STDOUT.puts "0 #{prevprevprev_lemma} #{prevprev_tokenc} #{prev_tokenc} #{tokenc}"
        #end
    end

    return condition
end



def apply_criteria_hbtq2(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if tokenc[0..2] == "hbt" and tokenc[3] != "q"
        condition = 1
    elsif tokenc[0..3] == "hbtq"
        condition = 2
    else
        condition = 0
    end

    return condition
end

def apply_criteria_vadmenardumed(tokenc, prev_tokenc, prevprev_tokenc, prevprevprev_tokenc, flag)
    if tokenc == "med" and prev_tokenc == "du" and prevprev_tokenc == "menar" and prevprevprev_tokenc == "vad"
        condition = 1
    else
        condition = 0
    end
    if flag
        STDERR.puts condition
    end
    return condition
end


def apply_criteria_kommer_att(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if prevprev_tokenc == "kommer" and prev_tokenc == "att" and pos == "VB" and msd.include?("INF") 
        condition = 1
    elsif prev_tokenc == "kommer" and pos == "VB" and msd.include?("INF")
        condition = 2
    else
        condition = 0
    end

    return condition
end