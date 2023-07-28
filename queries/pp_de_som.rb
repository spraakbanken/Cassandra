def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if prevprev_pos == "PP" and ((prev_tokenc == "dem") and (prev_pos == "DT" or prev_pos == "PN")) and tokenc == "som"
        condition = 1
    elsif prevprev_pos == "PP" and ((prev_tokenc == "de") and (prev_pos == "DT" or prev_pos == "PN")) and tokenc == "som"
        condition = 2
    else
        condition = 0
    end

    return condition
end