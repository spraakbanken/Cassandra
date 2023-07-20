def apply_criteria(tokenc, lemma, pos, msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel)
    if tokenc == "nån" or tokenc == "nåt" or tokenc == "nåra" or tokenc == "nårra" or tokenc == "nåns" or tokenc == "nåts" or tokenc == "nåras" or tokenc == "nårras" #nått? Saldo?
        condition = 1
    elsif tokenc == "någon" or tokenc == "något" or tokenc == "några" or tokenc == "någons" or tokenc == "någots" or tokenc == "någras" 
        condition = 2
    else
        condition = 0
    end

    return condition
end