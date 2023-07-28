def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if prevprev_tokenc == "än" and (prev_tokenc == "jag" or prev_tokenc == "du" or prev_tokenc == "han" or prev_tokenc == "hon" or prev_tokenc == "vi" or prev_tokenc == "ni") and (pos == "MAD" or pos == "MID" or pos == "PAD")
        condition = 1
    elsif prevprev_tokenc == "än" and (prev_tokenc == "mig" or prev_tokenc == "dig" or prev_tokenc == "honom" or prev_tokenc == "henne" or prev_tokenc == "oss" or prev_tokenc == "er") and (pos == "MAD" or pos == "MID" or pos == "PAD")
        condition = 2
    else
        condition = 0
    end

    return condition
end