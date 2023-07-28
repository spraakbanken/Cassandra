def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if tokenc[-3..-1] == "nde" and pos == "PC" and msd.include?("PRS")
        condition = 1
    elsif tokenc[-4..-1] == "ndes" and msd.include?("PRS")
        condition = 2
    else
        condition = 0
    end

    return condition
end