def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if tokenc == "sämre" or tokenc == "sämst"
        condition = 1
    elsif tokenc == "dåligare" or tokenc == "dåligast"
        condition = 2
    else
        condition = 0
    end

    return condition
end