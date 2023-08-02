def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if msd.include?("KOM") and pos == "JJ"
        condition = 1
    elsif prev_tokenc == "mer" and pos == "JJ" and !lemma.include?("själv")
        condition = 2
    else
        condition = 0
    end

    return condition
end