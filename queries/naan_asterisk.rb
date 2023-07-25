def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if tokenc == "någon.*" or tokenc == "något.*" or tokenc == "några.*" 
        condition = 1
    elsif (tokenc == "nån.*" and tokenc != "nånå") or (tokenc == "nåt.*" and pos != "VB") or tokenc == "nåra." or tokenc == "nårra.*"
        condition = 2
    else
        condition = 0
    end

    return condition
end