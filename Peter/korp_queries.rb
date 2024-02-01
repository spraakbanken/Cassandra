#label = ss_mej
variant1 = [word = 'mig' %c | word = 'dig' %c | word = 'sig' %c]
variant2 = [word = 'mej' %c | word = 'dej' %c | word = 'sej' %c]

#label = ss_kommer_att
variant1 = [word = 'kommer' %c] [word = 'att' %c] [pos = 'VB' & msd = '.*INF.*']
variant2 = [word = 'kommer' %c] [pos = 'VB' & msd = '.*INF.*']

#label = ss_naan_asterisk
variant1 = [word = 'någon.*' %c | word = 'något.*' %c | word = 'några.*' %c ]
variant2 = [(word = 'nån.*' %c & word != 'nånå' %c) | (word = 'nåt.*' %c & pos != 'VB') | (word = 'nåra.*' %c) | (word = 'nårra.*' %c)]

#label = med_vs_paa_kort_varsel
variant1 = [lex contains 'med\.\.pp\.1'] [lex contains 'kort\.\.av\.1'] [lex contains 'varsel\.\.nn\.1']
variant2 = [lex contains 'på\.\.pp\.1'] [lex contains 'kort\.\.av\.1'] [lex contains 'varsel\.\.nn\.1']

#sade_vs_sa
variant1 = [(word = 'sade' %c) & msd = '.*PRT.*' & pos = 'VB']
variant2 = [(word = 'sa' %c) & msd = '.*PRT.*' & pos = 'VB']

#lade_vs_la
variant1 = [(word = 'lade' %c) & msd = '.*PRT.*' & pos = 'VB']
variant2 = [(word = 'la' %c) & msd = '.*PRT.*' & pos = 'VB']

#tipsa_(om)
variant1 = [lex contains 'tipsa\.\.vb\.1'] [word = 'om'] [lex contains "att\.\.sn\.1"]
variant2 = [lex contains 'tipsa\.\.vb\.1'] [lex contains "att\.\.sn\.1"]


#label = de_filtered_subj
variant1 = [word = 'de' %c  & (pos = 'PN') & (deprel = 'SS' | deprel = 'FS' | deprel = 'ES')] [word != 'som' %c]

#label = dem_filtered_subj
variant1 = [word = 'dem' %c  & (pos = 'PN') & (deprel = 'SS' | deprel = 'FS' | deprel = 'ES')] [word != 'som' %c]

#label = dom_filtered_subj
variant1 = [deprel != 'DT' & deprel != 'AT'] [word = 'dom' %c  & (pos = 'PN') & (deprel = 'SS' | deprel = 'FS' | deprel = 'ES')] [word != 'som' %c]

#label = de_filtered
variant1 = [(word = 'de' %c | word = 'dem' %c) & (pos = 'PN' | pos = 'DT')]

#label = dem_filtered
variant1 = [word = 'dem' %c  & (pos = 'PN' | pos = 'DT')]

#label = demsom_vs_desom
variant1 = [(word = 'dem' %c) & (pos = 'PN' | pos = 'DT')] [word = 'som' %c]
variant2 = [(word = 'de' %c) & (pos = 'PN' | pos = 'DT')] [word = 'som' %c]

#label = pp_demsom_vs_desom
variant1 = [pos = "PP"] [(word = 'dem' %c) & (pos = 'PN' | pos = 'DT')] [word = 'som' %c]
variant2 = [pos = "PP"] [(word = 'de' %c) & (pos = 'PN' | pos = 'DT')] [word = 'som' %c]


#label = de(m)_vs_dom
variant1 = [(word = 'de' %c | word = 'dem' %c) & (pos = 'PN' | pos = 'DT')] [word != 'som' %c]
variant2 = [deprel != 'DT' & deprel != 'AT'] [word = 'dom' %c & (pos = 'PN' | pos = 'DT')] [word != 'som' %c]


#label = hbt(q)2
variant1 = [(word = 'hbt[^q].*' %c )]
variant2 = [(word = 'hbtq.*' %c )]

#label = hbt(q)3
variant1 = [word != 'hbtv' %c] [] [word = 'hbt[^q].*' %c] [word != '\\']
variant2 = [word != '\\'] [(word = 'hbtq.*' %c )]

#label = aen
variant1 = [word = 'än' %c & pos = 'KN'] [msd = '.*SUB.*' & (lex contains 'jag\.\.pn\.1' | lex contains 'du\.\.pn\.1' | lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'vi\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]
variant2 = [word = 'än' %c & pos = 'KN'] [msd = '.*OBJ.*' & (lex contains 'jag\.\.pn\.1' | lex contains 'du\.\.pn\.1' | lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'vi\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]

#label = krya
variant1 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'du\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]
variant2 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'de\.\.pn\.1' | lex contains 'son\.\.nn\.1' | lex contains 'dotter\.\.nn\.1')]
#variant1 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'du\.\.pn\.1' | lex contains 'sig\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]


#sa_la
variant1 = [(word = 'sade' %c | word = 'lade' %c) & msd = '.*PRT.*' & pos = 'VB'#{useradd}]
variant2 = [(word = 'sa' %c | word = 'la' %c) & msd = '.*PRT.*' & pos = 'VB'#{useradd}]


#label = pm_dm
variant1 = [(word = 'pm:a' %c | word = 'pm:ar' %c | word = 'pm:ade' %c | word = 'pm:at' %c | word = 'pm:as' %c | word = 'pm:ades' %c | word = 'pm:ats' %c | word = 'pma' %c | word = 'pmar' %c | word = 'pmade' %c | word = 'pmat' %c | word = 'pmas' %c | word = 'pmades' %c | word = 'pmats' %c )]
variant2 = [(word = 'dm:a' %c | word = 'dm:ar' %c | word = 'dm:ade' %c | word = 'dm:at' %c | word = 'dm:as' %c | word = 'dm:ades' %c | word = 'dm:ats' %c | word = 'dma' %c | word = 'dmar' %c | word = 'dmade' %c | word = 'dmat' %c | word = 'dmas' %c | word = 'dmades' %c | word = 'dmats' %c )]


#label = krya
variant1 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'du\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]
variant2 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'de\.\.pn\.1' | lex contains 'son\.\.nn\.1' | lex contains 'dotter\.\.nn\.1')]
#variant1 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'du\.\.pn\.1' | lex contains 'sig\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]


#label = ss_eftersom_att
variant1 = [word = 'eftersom' %c] [word != 'att' %c]
variant2 = [word = 'eftersom' %c] [word = 'att' %c]

#label = styv_bonus
variant1 = [word = 'styv.*'+%c & (word = '.*familj.*' %c | word = '.*far.*' %c | word = '.*mor.*' %c | word = '.*papp.*' %c | word = '.*mamm.*' %c | word = '.*bror.*' %c | word = '.*syst.*' %c | word = '.*syskon.*' %c | word = '.*dott.*' %c | word = '.*son.*' %c | word = '.*barn.*' %c)]
variant2 = [word = 'bonus.*'+%c & (word = '.*familj.*' %c| word = '.*far.*' %c | word = '.*mor.*' %c | word = '.*papp.*' %c | word = '.*mamm.*' %c | word = '.*bror.*' %c | word = '.*syst.*' %c | word = '.*syskon.*' %c | word = '.*dott.*' %c | word = '.*son.*' %c | word = '.*barn.*' %c)]


#label = ndes
variant1 = [word = '.*nde' %c & msd = '.*PRS.*' & pos = 'PC']
variant2 = [word = '.*ndes' %c & msd = '.*PRS.*' & pos = 'VB']


#label = kommer_att0
variant1 = [word = 'kommer' %c] [word = 'att' %c] [pos = 'VB' & msd = '.*INF.*']
variant2 = [word = 'kommer' %c] [pos = 'VB' & msd = '.*INF.*']

#label = hen_svebe
variant1 = [(word = 'hon' %c ) | (word = 'han' %c ) | (word = 'henne' %c ) | (word = 'honom' %c )]
variant2 = [(word = 'hen' %c )]

#label = kommer_att_vs_ska
variant1 = ([lex contains 'skola\.\.vb\.2' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*'])
variant2 = ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*']) | ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [word = 'att'] [pos = 'VB' & msd = '.*INF.*'])

#label = nyord_elsparkcykel
variant1 = [(word = 'elsparkcykel' )]

#label = nyord_elsparkcykel2
variant1 = [(word = 'elsparkcyk.*' )]

#label = nyord_blogg
variant1 = [(lex contains 'blogg..nn.1' )]

#label = nyord_googla
variant1 = [(lex contains 'googla..vb.1' )]

#label = nyord_app
variant1 = [(lex contains 'app..nn.1' )]

#label = nyord_covid-19,covid,covid19
variant1 = [(word = 'covid' %c | word = 'covid-19' %c | word = 'covid19' %c )]

#label = nyord_foliehatt
variant1 = [(lex contains 'foliehatt..nn.1' )]

#label = nyord_buda
variant1 = [(lex contains 'buda..vb.1' )]

#label = nyord_svininfluensa
variant1 = [(lex contains 'svininfluensa..nn.1' )]

#label = nyord_wiki
variant1 = [(lex contains 'wiki..nn.1' )]

#label = nyord_blogga
variant1 = [(lex contains 'blogga..vb.1' )]

#label = nyord_stalker
variant1 = [(lex contains 'stalker..nn.1' )]

#label = nyord_följare
variant1 = [(word = 'följare' %c | word = 'följaren' %c | word = 'följarna' %c | word = 'följares' %c | word = 'följarens' %c | word = 'följarnas' %c )]

#label = nyord_curla
variant1 = [(lex contains 'curla..vb.2' )]

#label = nyord_twittra,tvittra,kvittra
variant1 = [(lex contains 'twittra..vb.1' | lex contains 'tvittra..vb.1' | lex contains 'kvittra..vb.1' )]

#label = nyord_bloggare
variant1 = [(lex contains 'bloggare..nn.1' )]

#label = nyord_lockdown
variant1 = [(word = 'lockdown' %c | word = 'lockdowns' %c | word = 'lockdownen' %c | word = 'lockdownens' %c | word = 'lockdowner' %c | word = 'lockdownerna' %c | word = 'lockdownsen' %c | word = 'lockdowners' %c )]

#label = nyord_prio
variant1 = [(word = 'prio' %c )]

#label = nyord_padda
variant1 = [(word = 'padda' %c | word = 'paddan' %c | word = 'paddor' %c | word = 'paddorna' %c | word = 'paddas' %c | word = 'paddans' %c | word = 'paddors' %c | word = 'paddornas' %c )]

#label = nyord_näthat
variant1 = [(lex contains 'näthat..nn.1' )]

#label = nyord_Haffa
variant1 = [(lex contains 'haffa..vb.1' )]

#label = nyord_hypa
variant1 = [(lex contains 'hypa..vb.1' )]

#label = nyord_#metoo,metoo
variant1 = [(word = 'metoo' %c | word = 'metoos' %c )]

#label = nyord_stalka
variant1 = [(lex contains 'stalka..vb.1' )]

#label = nyord_matkasse
variant1 = [(word = 'matkasse' %c | word = 'matkasses' %c | word = 'matkassen' %c | word = 'matkassens' %c | word = 'matkassar' %c | word = 'matkassars' %c | word = 'matkassarna' %c | word = 'matkassarnas' %c )]

#label = nyord_menskopp
variant1 = [(word = 'menskopp' %c | word = 'menskopps' %c | word = 'menskoppen' %c | word = 'menskoppens' %c | word = 'menskoppar' %c | word = 'menskoppars' %c | word = 'menskopparna' %c | word = 'menskopparnas' %c )]

#label = nyord_sprita
variant1 = [(lex contains 'sprita..vb.3' )]

#label = nyord_fronta
variant1 = [(lex contains 'fronta..vb.1' )]

#label = nyord_vaccinpass
variant1 = [(word = 'vaccinpass' %c | word = 'vaccinpasset' %c | word = 'vaccinpassets' %c | word = 'vaccinpassen' %c | word = 'vaccinpassens' %c )]

#label = nyord_incel
variant1 = [(word = 'incel' %c | word = 'incelen' %c | word = 'inceln' %c | word = 'inceler' %c | word = 'incelerna' %c | word = 'incels' %c | word = 'inselsen' %c | word = 'incell' %c | word = 'incellen' %c | word = 'inceller' %c | word = 'incellerna' %c | word = 'incells' %c | word = 'incellsen' %c )]

#label = nyord_brexit
variant1 = [(word = 'brexit' %c )]

#label = nyord_anime
variant1 = [(word = 'anime' %c )]

#label = nyord_barnvagnsbio,babybio,bebisbio,spädbarnsbio
variant1 = [(word = 'babybio' %c | word = 'babybion' %c | word = 'babybios' %c | word = 'babybions' %c | word = 'bebisbio' %c | word = 'bebisbion' %c | word = 'bebisbios' %c | word = 'bebisbions' %c | word = 'barnvagnsbio' %c | word = 'barnvagnsbios' %c | word = 'barnvagnsbion' %c | word = 'barnvagnsbions' %c )]

#label = nyord_åsiktskorridor
variant1 = [(word = 'åsiktskorridor' %c | word = 'åsiktskorridoren' %c | word = 'åsiktskorridorn' %c | word = 'åsiktskorridors' %c | word = 'åsiktskorridorens' %c | word = 'åsiktskorridorns' %c | word = 'åsiktskorridorer' %c | word = 'åsiktskorridorerna' %c | word = 'åsiktskorridorers' %c | word = 'åsiktskorridorernas' %c )]

#label = nyord_stalking,stalkning
variant1 = [(lex contains 'stalking..nn.1' | lex contains 'stalkning..nn.1' )]

#label = nyord_selfie
variant1 = [(word = 'selfie' %c | word = 'selfien' %c | word = 'selfies' %c | word = 'selfiens' %c | word = 'selfier' %c | word = 'selfierna' %c | word = 'selfiers' %c | word = 'selfiernas' %c | word = 'selfiesar' %c | word = 'selfiesars' %c | word = 'selfiesarna' %c | word = 'selfiesen' %c | word = 'selfiesens' %c | word = 'selfiesarnas' %c )]

#label = nyord_digitalbox
variant1 = [(lex contains 'digitalbox..nn.1' )]

#label = nyord_topsa
variant1 = [(lex contains 'topsa..vb.1' )]

#label = nyord_spikmatta
variant1 = [(lex contains 'spikmatta..nn.1' )]

#label = nyord_sporta
variant1 = [(lex contains 'sporta..vb.1' )]

#label = nyord_trängselskatt
variant1 = [(word = 'trängselskatt' %c | word = 'trängselskatts' %c | word = 'trängselskatten' %c | word = 'trängselskattens' %c | word = 'trängselskatter' %c | word = 'trängselskatters' %c | word = 'trängselskatterna' %c | word = 'trängselskatternas' %c )]

#label = nyord_pimpa
variant1 = [(lex contains 'pimpa..vb.1' )]

#label = nyord_framåtlutad
variant1 = [(lex contains 'framåtlutad..av.1' )]

#label = nyord_klimathot
variant1 = [(lex contains 'klimathot..nn.1' )]

#label = nyord_sars
variant1 = [(word = 'sars' %c )]

#label = nyord_hedersvåld
variant1 = [(word = 'hedersvåld' %c | word = 'hedersvålds' %c | word = 'hedersvåldet' %c | word = 'hedersvåldets' %c )]

#label = nyord_entourage
variant1 = [(word = 'entourage' %c | word = 'entouraget' %c | word = 'entouragen' %c | word = 'entourages' %c | word = 'entouragets' %c | word = 'entouragens' %c )]

#label = nyord_Foppatoffel
variant1 = [(lex contains 'foppatoffel..nn.1' )]

#label = nyord_vintage
variant1 = [(word = 'vintage' %c )]

#label = nyord_EU-migrant
variant1 = [(lex contains 'EU-migrant..nn.1' )]

#label = nyord_svinna
variant1 = [(lex contains 'svinna..vb.1' )]

#label = nyord_hbt
variant1 = [(word = 'hbt' %c )]

#label = nyord_hbt2
variant1 = [(word = 'hbt*' %c )]


#label = nyord_hbtq
variant1 = [(word = 'hbtq' %c )]

#label = nyord_hbtq2
variant1 = [(word = 'hbtq*' %c )]



#label = nyord_Halmdocka
variant1 = [(word = 'halmdocka' %c | word = 'halmdockas' %c | word = 'halmdockan' %c | word = 'halmdockans' %c | word = 'halmdockor' %c | word = 'halmdockors' %c | word = 'halmdockorna' %c | word = 'halmdockornas' %c )]

#label = nyord_chippa
variant1 = [(word = 'chippa' %c | word = 'chippar' %c | word = 'chippade' %c | word = 'chippat' %c | word = 'chippas' %c | word = 'chippades' %c | word = 'chippats' %c )]

#label = nyord_transfett
variant1 = [(lex contains 'transfett..nn.1' )]

#label = nyord_e-sport
variant1 = [(word = 'e-sport' %c | word = 'e-sports' %c | word = 'e-sporten' %c | word = 'e-sportens' %c | word = 'e-sporter' %c | word = 'e-sporters' %c | word = 'e-sporterna' %c | word = 'e-sporternas' %c )]

#label = nyord_snackis
variant1 = [(word = 'snackis' %c | word = 'snackisen' %c | word = 'snackisens' %c | word = 'snackisar' %c | word = 'snackisarna' %c | word = 'snackisars' %c | word = 'snackisarnas' %c )]

#label = nyord_dampa
variant1 = [(lex contains 'dampa..vb.2' )]

#label = nyord_transponder
variant1 = [(word = 'transponder' %c | word = 'transpondern' %c | word = 'transponders' %c | word = 'transponderns' %c | word = 'transpondrar' %c | word = 'transpondrarna' %c | word = 'transpondrars' %c | word = 'transpondrarnas' %c )]

#label = nyord_rondellhund
variant1 = [(lex contains 'rondellhund..nn.1' )]

#label = nyord_instegsjobb
variant1 = [(word = 'instegsjobb' %c | word = 'instegsjobbet' %c | word = 'instegsjobbs' %c | word = 'instegsjobbets' %c | word = 'instegsjobben' %c | word = 'instegsjobbens' %c )]

#label = nyord_bröllopsklänning
variant1 = [(lex contains 'bröllopsklänning..nn.1' )]

#label = nyord_Trollfabrik
variant1 = [(word = 'trollfabrik' %c | word = 'trollfabriken' %c | word = 'trollfabriks' %c | word = 'trollfabrikens' %c | word = 'trollfabriker' %c | word = 'trollfabrikerna' %c | word = 'trollfabrikers' %c | word = 'trollfabrikernas' %c )]

#label = nyord_kubtest
variant1 = [(word = 'kubtest' %c | word = 'kubtesten' %c | word = 'kubtestet' %c | word = 'kubtester' %c | word = 'kubtesterna' %c | word = 'kubtests' %c | word = 'kubtestens' %c | word = 'kubtestets' %c | word = 'kubtesters' %c | word = 'kubtesternas' %c | word = 'kubbtest' %c | word = 'kubbtesten' %c | word = 'kubbtestet' %c | word = 'kubbtester' %c | word = 'kubbtesterna' %c | word = 'kubbtests' %c | word = 'kubbtestens' %c | word = 'kubbtestets' %c | word = 'kubbtesters' %c | word = 'kubbtesternas' %c | word = 'kub-test' %c | word = 'kub-testen' %c | word = 'kub-testet' %c | word = 'kub-tester' %c | word = 'kub-testerna' %c | word = 'kub-tests' %c | word = 'kub-testens' %c | word = 'kub-testets' %c | word = 'kub-testers' %c | word = 'kub-testernas' %c | word = 'kubb-test' %c | word = 'kubb-testen' %c | word = 'kubb-testet' %c | word = 'kubb-tester' %c | word = 'kubb-testerna' %c | word = 'kubb-tests' %c | word = 'kubb-testens' %c | word = 'kubb-testets' %c | word = 'kubb-testers' %c | word = 'kubb-testernas' %c )]

#label = nyord_videosamtal
variant1 = [(word = 'videosamtal' %c | word = 'videosamtalet' %c | word = 'videosamtals' %c | word = 'videosamtalets' %c | word = 'videosamtalen' %c | word = 'videosamtalens' %c )]

#label = nyord_cringe
variant1 = [(word = 'cringe' %c )]

#label = nyord_Svischa
variant1 = [(word = 'svischa' %c | word = 'svischar' %c | word = 'svischade' %c | word = 'svischat' %c | word = 'svischas' %c | word = 'svischades' %c | word = 'svischats' %c | word = 'swischa' %c | word = 'swischar' %c | word = 'swischade' %c | word = 'swischat' %c | word = 'swischas' %c | word = 'swischades' %c | word = 'swischats' %c | word = 'swisha' %c | word = 'swishar' %c | word = 'swishade' %c | word = 'swishat' %c | word = 'swishas' %c | word = 'swishades' %c | word = 'swishats' %c | word = 'svisha' %c | word = 'svishar' %c | word = 'svishade' %c | word = 'svishat' %c | word = 'svishas' %c | word = 'svishades' %c | word = 'svishats' %c )]

#label = nyord_curlingförälder
variant1 = [(lex contains 'curlingförälder..nn.1' )]

#label = nyord_Youtuber
variant1 = [(word = 'youtuber' %c | word = 'youtubern' %c | word = 'youtubers' %c | word = 'youtuberns' %c | word = 'youtuberna' %c | word = 'youtubernas' %c | word = 'youtubeare' %c | word = 'youtubearna' %c | word = 'youtubeares' %c | word = 'youtubearrnas' %c )]

#label = nyord_nätpoker
variant1 = [(word = 'nätpoker' %c | word = 'nätpokern' %c | word = 'nätpokers' %c | word = 'nätpokerns' %c )]

#label = nyord_blingbling
variant1 = [(word = 'blingbling' %c | word = 'blingblinget' %c | word = 'blingblings' %c | word = 'blingblingets' %c | word = 'bingblingen' %c | word = 'blingblingens' %c )]

#label = nyord_nystartsjobb
variant1 = [(word = 'nystartsjobb' %c | word = 'nystartsjobbs' %c | word = 'nystartsjobbet' %c | word = 'nystartsjobbets' %c | word = 'nystartsjobben' %c | word = 'nystartsjobbens' %c )]

#label = nyord_klimatsmart
variant1 = [(lex contains 'klimatsmart..av.1' )]

#label = nyord_livspussel
variant1 = [(word = 'livspussel' %c | word = 'livspussels' %c | word = 'livspusslet' %c | word = 'livspusslets' %c | word = 'livspusslen' %c | word = 'livspusslens' %c )]

#label = nyord_killgissa
variant1 = [(word = 'killgissa' %c | word = 'killgissar' %c | word = 'killgissade' %c | word = 'killgissat' %c | word = 'killgissas' %c | word = 'killgissades' %c | word = 'killgissats' %c )]

#label = nyord_backslick
variant1 = [(word = 'backslick' %c | word = 'backslicket' %c | word = 'backslicken' %c | word = 'backslicks' %c | word = 'backslickets' %c | word = 'backslickens' %c )]

#label = nyord_skypa,skajpa
variant1 = [(word = 'skypar' %c | word = 'skajpar' %c | word = 'skypas' %c | word = 'skajpas' %c | word = 'skypade' %c | word = 'skajpade' %c | word = 'skypades' %c | word = 'skajpades' %c | word = 'skypa' %c | word = 'skajpa' %c | word = 'skypat' %c | word = 'skajpat' %c | word = 'skypats' %c | word = 'skajpade' %c | word = 'skypande' %c | word = 'skajpande' %c | word = 'skypandes' %c | word = 'skajpandes' %c )]

#label = nyord_blåljuspersonal
variant1 = )]

#label = nyord_geocaching
variant1 = )]

#label = nyord_rasifierad
variant1 = )]

#label = nyord_bjästa
variant1 = [(word = 'bjästa' %c | word = 'bjästar' %c | word = 'bjästade' %c | word = 'bjästat' %c | word = 'bjästas' %c | word = 'bjästades' %c | word = 'bjästats' %c )]

#label = nyord_sudoku
variant1 = )]

#label = nyord_Douche
variant1 = )]

#label = nyord_ankarbarn
variant1 = )]

#label = nyord_polyamorös
variant1 = )]

#label = nyord_blockkedja
variant1 = )]

#label = nyord_antivaxxare
variant1 = )]

#label = nyord_paltkoma
variant1 = [(lex contains 'paltkoma..nn.1' )]

#label = nyord_väggord
variant1 = [(word = 'väggord' %c | word = 'väggordet' %c | word = 'väggorden' %c | word = 'väggordena' %c | word = 'väggords' %c | word = 'väggordets' %c | word = 'väggordens' %c | word = 'väggordenas' %c )]

#label = nyord_whataboutism
variant1 = )]

#label = nyord_facebooka,fejsbooka
variant1 = [(word = 'facebookar' %c | word = 'fejsbookar' %c | word = 'facebookas' %c | word = 'fejsbookas' %c | word = 'facebookade' %c | word = 'fejsbookade' %c | word = 'facebookades' %c | word = 'fejsbookades' %c | word = 'facebooka' %c | word = 'fejsbooka' %c | word = 'facebookat' %c | word = 'fejsbookat' %c | word = 'facebookats' %c | word = 'fejsbookats' %c | word = 'facebookande' %c | word = 'fejsbookande' %c | word = 'facebookandes' %c | word = 'fejsbookandes' %c | word = 'facebookad' %c | word = 'fejsbookad' %c | word = 'facebookads' %c | word = 'fejsbookads' %c )]

#label = nyord_filterbubbla
variant1 = [(word = 'filterbubbla' %c | word = 'filterbubblan' %c | word = 'filterbubblor' %c | word = 'filterbubblorna' %c | word = 'filterbubblas' %c | word = 'filterbubblans' %c | word = 'filterbubblors' %c | word = 'filterbubblornas' %c )]

#label = nyord_regnbågsbarn
variant1 = )]

#label = nyord_burkini
variant1 = )]

#label = nyord_köttberg
variant1 = )]

#label = nyord_Faktaresistens
variant1 = )]

#label = nyord_vuvuzela
variant1 = [(lex contains 'vuvuzela..nn.1' )]



#label = oevertagit_vs_oevertatt
variant1 = [word = 'övertagit']
variant2 = [word = 'övertatt']

#label = oevertaga_vs_oeverta_inf
variant1 = [word = 'övertaga']
variant2 = [word = 'överta']

#label = tagit_vs_tatt
variant1 = [word = 'har'] [word = 'tagit']
variant2 = [word = 'har'] [word = 'tatt']

#label = givit_vs_gett
variant1 = [word = 'har'] [word = 'givit']
variant2 = [word = 'har'] [word = 'gett']



#label = spridit
variant1 = [(word = 'spritt' %c) & msd = '.*SUP.*' & pos = 'VB']
variant2 = [(word = 'spridit' %c) & msd = '.*SUP.*' & pos = 'VB']


#label = vaext
variant1 = [(word = 'vuxit' %c) & msd = '.*SUP.*' & pos = 'VB']
variant2 = [(word = 'växt' %c) & msd = '.*SUP.*' & pos = 'VB']


#label = beslutade
variant1 = [(word = 'beslöt' %c) & msd = '.*PRT.*' & pos = 'VB']
variant2 = [(word = 'beslutade' %c) & msd = '.*PRT.*' & pos = 'VB']



#label = pm_dm
variant1 = [(word = 'pm:a' %c | word = 'pm:ar' %c | word = 'pm:ade' %c | word = 'pm:at' %c | word = 'pm:as' %c | word = 'pm:ades' %c | word = 'pm:ats' %c | word = 'pma' %c | word = 'pmar' %c | word = 'pmade' %c | word = 'pmat' %c | word = 'pmas' %c | word = 'pmades' %c | word = 'pmats' %c )]
variant2 = [(word = 'dm:a' %c | word = 'dm:ar' %c | word = 'dm:ade' %c | word = 'dm:at' %c | word = 'dm:as' %c | word = 'dm:ades' %c | word = 'dm:ats' %c | word = 'dma' %c | word = 'dmar' %c | word = 'dmade' %c | word = 'dmat' %c | word = 'dmas' %c | word = 'dmades' %c | word = 'dmats' %c )]





#label = ss90_riskera
variant1 = [lemma contains 'riskera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'riskera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_upphöra
variant1 = [lemma contains 'upphöra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'upphöra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_bruka
variant1 = [lemma contains 'bruka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'bruka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_börja
variant1 = [lemma contains 'börja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'börja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_råka
variant1 = [lemma contains 'råka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'råka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_pläga
variant1 = [lemma contains 'pläga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'pläga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_begynna
variant1 = [lemma contains 'begynna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'begynna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_sluta
variant1 = [lemma contains 'sluta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'sluta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_fortsätta
variant1 = [lemma contains 'fortsätta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'fortsätta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_hota
variant1 = [lemma contains 'hota' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'hota' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_tendera
variant1 = [lemma contains 'tendera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'tendera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_vänta sig
variant1 = [lemma contains 'vänta sig' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'vänta sig' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_hoppas
variant1 = [lemma contains 'hoppas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'hoppas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_önska
variant1 = [lemma contains 'önska' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'önska' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_vänta
variant1 = [lemma contains 'vänta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'vänta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_frukta
variant1 = [lemma contains 'frukta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'frukta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_låta
variant1 = [lemma contains 'låta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'låta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_avböja
variant1 = [lemma contains 'avböja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'avböja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_negligera
variant1 = [lemma contains 'negligera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'negligera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_låtsas
variant1 = [lemma contains 'låtsas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'låtsas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_försöka
variant1 = [lemma contains 'försöka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'försöka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_söka
variant1 = [lemma contains 'söka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'söka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_glömma
variant1 = [lemma contains 'glömma' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'glömma' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_försumma
variant1 = [lemma contains 'försumma' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'försumma' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_underlåta
variant1 = [lemma contains 'underlåta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'underlåta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_undvika
variant1 = [lemma contains 'undvika' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'undvika' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_gitta
variant1 = [lemma contains 'gitta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'gitta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_idas
variant1 = [lemma contains 'idas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'idas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_avse
variant1 = [lemma contains 'avse' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'avse' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_diskutera
variant1 = [lemma contains 'diskutera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'diskutera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_överväga
variant1 = [lemma contains 'överväga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'överväga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_svära
variant1 = [lemma contains 'svära' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'svära' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_välja
variant1 = [lemma contains 'välja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'välja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_ämna
variant1 = [lemma contains 'ämna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'ämna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_nännas
variant1 = [lemma contains 'nännas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'nännas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_täckas
variant1 = [lemma contains 'täckas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'täckas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_besluta
variant1 = [lemma contains 'besluta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'besluta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_lova
variant1 = [lemma contains 'lova' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'lova' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_vägra
variant1 = [lemma contains 'vägra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'vägra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_planera
variant1 = [lemma contains 'planera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'planera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_hota
variant1 = [lemma contains 'hota' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'hota' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_anses
variant1 = [lemma contains 'anses' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'anses' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_anse
variant1 = [lemma contains 'anse' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'anse' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_tänka
variant1 = [lemma contains 'tänka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'tänka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_behaga
variant1 = [lemma contains 'behaga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'behaga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_böra
variant1 = [lemma contains 'böra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'böra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_lär
variant1 = [lemma contains 'lär' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'lär' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_må
variant1 = [lemma contains 'må' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'må' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_måste
variant1 = [lemma contains 'måste' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'måste' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_vilja
variant1 = [lemma contains 'vilja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'vilja' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_skola
variant1 = [lemma contains 'skola' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'skola' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_kunna
variant1 = [lemma contains 'kunna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'kunna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_få
variant1 = [lemma contains 'få' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'få' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_synas
variant1 = [lemma contains 'synas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'synas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_tyckas
variant1 = [lemma contains 'tyckas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'tyckas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_borde
variant1 = [lemma contains 'borde' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'borde' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_måtte
variant1 = [lemma contains 'måtte' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'måtte' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_torde
variant1 = [lemma contains 'torde' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'torde' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_befinnas
variant1 = [lemma contains 'befinnas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'befinnas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_skall
variant1 = [lemma contains 'skall' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'skall' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_bör
variant1 = [lemma contains 'bör' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'bör' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_äga
variant1 = [lemma contains 'äga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'äga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_ha
variant1 = [lemma contains 'ha' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'ha' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_behöva
variant1 = [lemma contains 'behöva' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'behöva' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_förefalla
variant1 = [lemma contains 'förefalla' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'förefalla' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_slippa
variant1 = [lemma contains 'slippa' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'slippa' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_verka
variant1 = [lemma contains 'verka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'verka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_töras
variant1 = [lemma contains 'töras' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'töras' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_mäkta
variant1 = [lemma contains 'mäkta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'mäkta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_förstå
variant1 = [lemma contains 'förstå' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'förstå' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_hinna med
variant1 = [lemma contains 'hinna med' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'hinna med' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_vara i stånd
variant1 = [lemma contains 'vara i stånd' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'vara i stånd' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_våga
variant1 = [lemma contains 'våga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'våga' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_hinna
variant1 = [lemma contains 'hinna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'hinna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_lyckas
variant1 = [lemma contains 'lyckas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'lyckas' & (msd = '.*VB.PRS.SFO.*' | msd = '.*VB.PRT.SFO.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_förtjäna
variant1 = [lemma contains 'förtjäna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'förtjäna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_förmå
variant1 = [lemma contains 'förmå' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'förmå' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_tåla
variant1 = [lemma contains 'tåla' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'tåla' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_orka
variant1 = [lemma contains 'orka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'orka' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_skola
variant1 = [lemma contains 'skola' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'skola' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_komma
variant1 = [lemma contains 'komma' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'komma' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_avsky
variant1 = [lemma contains 'avsky' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'avsky' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_förakta
variant1 = [lemma contains 'förakta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'förakta' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_föredra
variant1 = [lemma contains 'föredra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'föredra' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_acceptera
variant1 = [lemma contains 'acceptera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'acceptera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_älska
variant1 = [lemma contains 'älska' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'älska' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_gilla
variant1 = [lemma contains 'gilla' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'gilla' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_hata
variant1 = [lemma contains 'hata' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'hata' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_sakna
variant1 = [lemma contains 'sakna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'sakna' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = ss90_tolerera
variant1 = [lemma contains 'tolerera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [word = 'att' %c] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']
variant2 = [lemma contains 'tolerera' & (msd = '.*VB.PRS.AKT.*' | msd = '.*VB.PRT.AKT.*')] [msd = '.*INF.AKT.*'] [msd != '.*INF.*']

#label = smiley1vs2neg
variant1 = [word = ':-\(']
variant2 = [word = ':\(']

#label = smiley1vs2
variant1 = [word = ':-\)']
variant2 = [word = ':\)']

#label = smiley1
variant1 = [word = ':-\)']

#label = smiley2
variant1 = [word = ':\)']

#label = smiley1neg
variant1 = [word = ':-\(']

#label = smiley2neg
variant1 = [word = ':\(']
