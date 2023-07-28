def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if tokenc == "mig" or tokenc == "dig" or tokenc == "sig"
        condition = 1
    elsif tokenc == "mej" or tokenc == "dej" or tokenc == "sej"
        condition = 2
    else
        condition = 0
    end

    return condition
end