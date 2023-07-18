def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if prevprev_tokenc == "kommer" and prev_tokenc == "att" and pos == "VB" and msd.include?("INF") 
        condition = 1
    elsif prevprev_tokenc == "kommer" and pos == "VB" and msd.include?("INF")
        condition = 2
    else
        condition = 0
    end

    return condition
end