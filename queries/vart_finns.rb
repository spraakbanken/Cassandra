def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if prev_tokenc == "var" and (lemma.include?("finnas") or lemma.include?("stå") or lemma.include?("ligga"))
        condition = 1
    elsif prev_tokenc == "vart" and (lemma.include?("finnas") or lemma.include?("stå") or lemma.include?("ligga"))
        condition = 2
    else
        condition = 0
    end

    return condition
end