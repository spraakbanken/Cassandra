def check_lemma(lemma, criterion)
    result = false
    lemma.each do |lemmavar|
        if lemmavar == criterion
            result = true
            break
        end
    end
    return result
end

def apply_criteria_ss30(tokenc, lemma, prev_lemma, prevprev_lemma, prevprevprev_lemma, pos, msd, prev_msd, prevprev_msd, prevprevprev_msd, dephead, deprel, prev_tokenc, prevprev_tokenc, prev_pos, prevprev_pos, prev_deprel, prevprev_deprel, verb_of_interest)
    if check_lemma(prevprevprev_lemma,verb_of_interest) and ((prevprevprev_msd.include("VB.PRT.AKT") and verb_of_interest[-1] != "s") or (prevprevprev_msd.include("VB.PRT.SFO") and verb_of_interest[-1] == "s")) and prevprev_tokenc == "att" and prev_msd.include?("INF") and !msd.include?("INF")
        condition = 1
    elsif check_lemma(prevprev_lemma,verb_of_interest) and ((prevprev_msd.include("VB.PRT.AKT") and verb_of_interest[-1] != "s") or (prevprev_msd.include("VB.PRT.SFO") and verb_of_interest[-1] == "s")) and prev_msd.include?("INF") and !msd.include?("INF")
        condition = 2
    else
        condition = 0
    end

    return condition
end

