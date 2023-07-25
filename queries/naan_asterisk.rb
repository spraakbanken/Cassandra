def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if tokenc[0..4] == "någon" or tokenc[0..4] == "något" or tokenc[0..4] == "några" 
        condition = 1
    elsif (tokenc[0..2] == "nån" and tokenc != "nånå") or (tokenc[0..2] == "nåt" and pos != "VB") or tokenc[0..3] == "nåra" or tokenc[0..4] == "nårra"
        condition = 2
    else
        condition = 0
    end

    return condition
end