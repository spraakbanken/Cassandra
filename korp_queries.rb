### Use single quotes, not double quotes in this file!

#label = sprita
variant1 = [lemma contains 'sprita']

#label = hbt(q)
variant1 = [(word = 'hbt' %c )]
variant2 = [(word = 'hbtq' %c )]

#label = hbt(q)2
variant1 = [(word = 'hbt*' %c )]
variant2 = [(word = 'hbtq*' %c )]

#label = aen
variant1 = [word = 'än' %c & pos = 'KN'] [msd = '.*SUB.*' & (lex contains 'jag\.\.pn\.1' | lex contains 'du\.\.pn\.1' | lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'vi\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]
variant2 = [word = 'än' %c & pos = 'KN'] [msd = '.*OBJ.*' & (lex contains 'jag\.\.pn\.1' | lex contains 'du\.\.pn\.1' | lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'vi\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]
































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


#label = ish_typ
variant1 = [word = 'typ']
variant2 = [word = 'ish']


#label = ish_word
variant1 = [word = 'ish']

#label = ish_affix
variant1 = [word = '.*ish']

#label = ish_word_or_clitic
variant1 = [word = '.*\[-:;,\]ish']



#label = kommer_att0
variant1 = [word = 'kommer' %c] [word = 'att' %c] [pos = 'VB' & msd = '.*INF.*']
variant2 = [word = 'kommer' %c] [pos = 'VB' & msd = '.*INF.*']


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

#label = dom1_filtered
variant1 = [((word = 'de' %c ) | (word = 'dem' %c )) & (pos = 'PN' | pos = 'DT')]
variant2 = [deprel != 'DT' & deprel != 'AT'] [word = 'dom' %c & (pos = 'PN' | pos = 'DT')]

#in-between option
#[deprel != "DT" & deprel != "AT" & word !=".*domstols.*" & word != ".*rätts.*"] [word = "dom" %c & pos = "PN"]

#a slightly more reliable but much slower filter
#variant2 = [word != 'en' %c & word != 'villkorlig' %c & word != 'fällande' %c & word != 'gammal' %c & word != 'sin' %c & word != 'sådan' %c & word != 'friande' %c & word != '.*ens.*' %c & word != '.*ets.*' %c & deprel != 'DT' & deprel != 'AT'] [word = 'dom' %c & pos = 'PN']

#this is to check false negatives
#[(word = "en" %c | word = "villkorlig" %c | word = "fällande" %c | word = "gammal" %c | word = "sin" %c | word = "sådan" %c | word = ".*ens.*" %c | word = ".*ets.*" %c | deprel = "DT" | deprel = "AT")] [word = "dom" %c & pos = "PN"]

#label = dom_svebe
variant1 = [((word = 'de' %c ) | (word = 'dem' %c )) & (pos = 'PN' | pos = 'DT')]
variant2 = [(word = 'dom' %c ) & (pos = 'PN' | pos = 'DT') & ]

#label = hen_svebe
variant1 = [(word = 'hon' %c ) | (word = 'han' %c ) | (word = 'henne' %c ) | (word = 'honom' %c )]
variant2 = [(word = 'hen' %c )]

#label = hbt(q)(i)
variant1 = [(word = 'hbtq' %c )]
variant2 = [(word = 'hbtqi' %c )]


#label = test
variant1 = ([pos = 'VB' & msd = '.*PRS.*'])
variant2 = ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*'])

#label = test1
variant1 = ([pos = 'NN'])
variant2 = ([word= 'människa'] [pos = 'VB'])

#label = kommer_att1
variant1 = ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*']) | ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [word = 'att'] [pos = 'VB' & msd = '.*INF.*'])

#label = pres1
variant1 = ([pos = 'VB' & msd = '.*PRS.*'])

#label = ska1
variant1 = ([lex contains 'skola\.\.vb\.2' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*'])

#label = kommer_att_vs_ska
variant1 = ([lex contains 'skola\.\.vb\.2' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*'])
variant2 = ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*']) | ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [word = 'att'] [pos = 'VB' & msd = '.*INF.*'])



#label = kommer_att_vs_al
variant1 = ([lex contains 'skola\.\.vb\.2' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*']) | ([pos = 'VB' & msd = '.*PRS.*'])
variant2 = ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*']) | ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [word = 'att'] [pos = 'VB' & msd = '.*INF.*'])




#label = kommer_att_vs_al1
variant1 = ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [pos = 'VB' & msd = '.*INF.*']) | ([lex contains 'komma\.\.vb\.1' & msd = '.*PRS.*'] [word = 'att'] [pos = 'VB' & msd = '.*INF.*'])



#label = authors
variant1 = []

# START NYORD2

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

# END NYORD2




#label = de1
variant1 = [(word = 'de' %c )] [(word != 'som'  %c )]

#label = dem1
variant1 = [(word = 'dem' %c )] [(word != 'som'  %c )]

#label = dom1
variant1 = [(word = 'dom' %c & pos != 'NN')] [(word != 'som' %c )]

#label = dom1a
variant1 = [(word = 'dom' %c & pos != 'NN')] [(word != 'som')]


#label = dom_pron
variant1 = [(word = 'dem' %c | word = 'de' %c ) & pos = 'PN'] [(word != 'som' %c )]
variant2 = [(word = 'dom' %c & pos = 'PN')] [(word != 'som' %c )]

#The next three are the same what you called Steg 1, but paired, so that I get my favourite var1 vs var2 plots :)
#label = de_vs_dem_dom
variant1 = [(word = 'de' %c )] [(word != 'som'  %c )]
variant2 = [(word = 'dem' %c | (word = 'dom' %c & pos != 'NN'))] [(word != 'som'  %c )]

#label = dem_vs_de_dom
variant1 = [(word = 'dem' %c )] [(word != 'som'  %c )]
variant2 = [(word = 'de' %c | (word = 'dom' %c & pos != 'NN'))] [(word != 'som'  %c )]

#label = dom_vs_de_dem
variant1 = [(word = 'de' %c | word = 'dem' %c )] [(word != 'som'  %c )]
variant2 = [(word = 'dom' %c & pos != 'NN')] [(word != 'som'  %c )]

#For the next three: Should we exclude "dom"? Do we still need to keep the "next word != som" part?
#label = dem_det
variant1 = [(word = 'dom' %c | word = 'de' %c ) & pos = 'DT'] [(word != 'som' %c )]
variant2 = [(word = 'dem' %c & pos = 'DT')] [(word != 'som' %c )]

#label = dem_subjekt1
variant1 = [(word = 'dem' %c & (deprel = 'SS' | deprel = 'FS'))] [(word != 'som' %c )]

#label = de_subjekt1
variant1 = [(word = 'de' %c & (deprel = 'SS' | deprel = 'FS'))] [(word != 'som' %c )]

#label = dom_subjekt1
variant1 = [(word = 'dom' %c & pos != 'NN' & (deprel = 'SS' | deprel = 'FS'))] [(word != 'som' %c )]

#label = dem_objekt1
variant1 = [(word = 'dem' %c & deprel = 'OO' )] [(word != 'som' %c )]

#label = de_objekt1
variant1 = [(word = 'de' %c & deprel = 'OO' )] [(word != 'som' %c )]

#label = dom_objekt1
variant1 = [(word = 'dom' %c & pos != 'NN' & deprel = 'OO' )] [(word != 'som' %c )]





#label = dem_subjekt
variant1 = [(word = 'dom' %c | word = 'de' %c ) & (deprel = 'SS' | deprel = 'FS')] [(word != 'som' %c )]
variant2 = [(word = 'dem' %c & (deprel = 'SS' | deprel = 'FS'))] [(word != 'som' %c )]


!Wrong syntax
#label = de_objekt
variant1 = [(word = 'dom' %c | word = 'dem' %c ) & deprel = 'OO'] [(word != 'som' %c )]
variant2 = [(word = 'de' %c & deprel = 'OO')] [(word != 'som' %c )]



#label = eftersom_att
variant1 = [word = 'eftersom'] [word != 'att']
variant2 = [word = 'eftersom'] [word = 'att']

#label = styv_bonus
variant1 = [word = 'styv.*'+%c & (word = '.*familj.*' %c | word = '.*far.*' %c | word = '.*mor.*' %c | word = '.*papp.*' %c | word = '.*mamm.*' %c | word = '.*bror.*' %c | word = '.*syst.*' %c | word = '.*syskon.*' %c | word = '.*dott.*' %c | word = '.*son.*' %c | word = '.*barn.*' %c)]
variant2 = [word = 'bonus.*'+%c & (word = '.*familj.*' %c| word = '.*far.*' %c | word = '.*mor.*' %c | word = '.*papp.*' %c | word = '.*mamm.*' %c | word = '.*bror.*' %c | word = '.*syst.*' %c | word = '.*syskon.*' %c | word = '.*dott.*' %c | word = '.*son.*' %c | word = '.*barn.*' %c)]


#label = ndes
variant1 = [word = '.*nde' %c & msd = '.*PRS.*' & pos = 'PC']
variant2 = [word = '.*ndes' %c & msd = '.*PRS.*' & pos = 'VB']


#label = buda
variant1 = [(lex contains 'kvittra..vb.1' )]
variant2 = [(lex contains 'buda..vb.1' )]


#label = kvittra
variant1 = [(lex contains 'kvittra..vb.1' )]
variant2 = [(lex contains 'tvittra..vb.1' | lex contains 'twittra..vb.1' )]

#label = pm_dm
variant1 = [(word = 'pm:a' %c | word = 'pm:ar' %c | word = 'pm:ade' %c | word = 'pm:at' %c | word = 'pm:as' %c | word = 'pm:ades' %c | word = 'pm:ats' %c | word = 'pma' %c | word = 'pmar' %c | word = 'pmade' %c | word = 'pmat' %c | word = 'pmas' %c | word = 'pmades' %c | word = 'pmats' %c )]
variant2 = [(word = 'dm:a' %c | word = 'dm:ar' %c | word = 'dm:ade' %c | word = 'dm:at' %c | word = 'dm:as' %c | word = 'dm:ades' %c | word = 'dm:ats' %c | word = 'dma' %c | word = 'dmar' %c | word = 'dmade' %c | word = 'dmat' %c | word = 'dmas' %c | word = 'dmades' %c | word = 'dmats' %c )]





#label = inversion
variant1 = [ref = '1' & (deprel = 'SS' | deprel = 'FS')] 
variant2 = [ref = '1' & deprel != 'SS' & deprel != "FS" & pos != "DT" & pos != "IN" & deprel != "TT" & pos != "MAD" & pos != "MID" & pos != "PAD"]

#label = krya
variant1 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'du\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]
variant2 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'de\.\.pn\.1' | lex contains 'son\.\.nn\.1' | lex contains 'dotter\.\.nn\.1')]
#variant1 = [word = 'krya' & msd = '.*IMP.*' %c] [word = 'på' %c] [(lex contains 'du\.\.pn\.1' | lex contains 'sig\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]


#label = spridit
variant1 = [(word = 'spritt' %c) & msd = '.*SUP.*' & pos = 'VB']
variant2 = [(word = 'spridit' %c) & msd = '.*SUP.*' & pos = 'VB']


#label = vaext
variant1 = [(word = 'vuxit' %c) & msd = '.*SUP.*' & pos = 'VB']
variant2 = [(word = 'växt' %c) & msd = '.*SUP.*' & pos = 'VB']


#label = beslutade
variant1 = [(word = 'beslöt' %c) & msd = '.*PRT.*' & pos = 'VB']
variant2 = [(word = 'beslutade' %c) & msd = '.*PRT.*' & pos = 'VB']


#label = hen
variant1 = [(lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1')]
variant2 = [lex contains 'hen\\.\\.pn\\.1']

#label = dom
variant1 = [word = 'de'+%c | word = 'dem'+%c]
variant2 = [word = 'dom'+%c]

#label = de_dem
variant1 = [(word = 'de'+%c & deprel = 'SS') | (word = 'dem'+%c & deprel = 'OO')]
variant2 = [(word = 'de'+%c & deprel = 'OO') | (word = 'dem'+%c & deprel = 'SS')]

#label = anime
variant1 = [word = 'anime']

#han_eller_hon:
variant1 = "[lex contains 'han\.\.pn\.1'] [lex not contains 'eller\.\.kn\.1' #{useradd}]"
variant2 = "[lex contains 'han\.\.pn\.1'] [lex contains 'eller\.\.kn\.1' #{useradd}] [lex contains 'hon\.\.pn\.1']"



#ska
variant1 = "[word = 'skall' %c & pos = 'VB'#{useradd}]"
variant2 = "[word = 'ska' %c & pos = 'VB'#{useradd}]"

#sa_la
variant1 = "[(word = 'sade' %c | word = 'lade' %c) & msd = '.*PRT.*' & pos = 'VB'#{useradd}]"
variant2 = "[(word = 'sa' %c | word = 'la' %c) & msd = '.*PRT.*' & pos = 'VB'#{useradd}]"


#verb1
variant1 = "[(word = 'tvang' %c | word = 'vek' %c | word = 'stöp' %c | word = 'ströp' %c | word = 'stred' %c | word = 'spratt' %c | word = 'spred' %c | word = 'smalt' %c | word = 'small' %c | word = 'slök' %c | word = 'skalv' %c | word = 'sam' %c | word = 'rök' %c | word = 'röck' %c | word = 'pös' %c | word = 'nös' %c | word = 'mös' %c | word = 'löd' %c | word = 'försåg' %c | word = 'fnös' %c | word = 'beslöt' %c | word = 'begrov' %c | word = 'bragte' %c) & msd = '.*PRT.*' & pos = 'VB'#{useradd}]"
variant2 = "[(word = 'tvingade' %c | word = 'vikte' %c | word = 'stupade' %c | word = 'strypte' %c | word = 'stridde' %c | word = 'spritte' %c | word = 'spridde' %c | word = 'smälte' %c | word = 'smällde' %c | word = 'slukade' %c | word = 'skälvde' %c | word = 'simmade' %c | word = 'rykte' %c | word = 'ryckte' %c | word = 'pyste' %c | word = 'nyste' %c | word = 'myste' %c | word = 'lydde' %c | word = 'försedde' %c | word = 'fnyste' %c | word = 'beslutade' %c | word = 'begravde' %c | word = 'bringade' %c) & msd = '.*PRT.*' & pos = 'VB'#{useradd}]"

#hen
variant1 = "[(lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1')#{useradd}]" #*
variant2 = "[lex contains 'hen\\.\\.pn\\.1'#{useradd}]"

#naan:
variant1 = "[(word = 'någon.*'  %c | word = 'något.*'  %c | word = 'några.*'  %c | word = 'sådan'  %c | word = 'sådant'  %c | word = 'sådana' %c)#{useradd}]"
variant2 = "[(word = 'nån.*'  %c | word = 'nåt.*'  %c | word = 'nåra.*'  %c  | word = 'sån'  %c | word = 'sånt'  %c | word = 'såna' %c)#{useradd}]"







#label = nyord_googla_quote
variant1 = [word = '"'] [(lex contains 'googla..vb.1' )] [word = '"']
variant2 = [(lex contains 'googla..vb.1' )]

#label = nyord_blogga_quote
variant1 = [word = '"'] [(lex contains 'blogga..vb.1' )] [word = '"']
variant2 = [(lex contains 'blogga..vb.1' )]

#label = nyord_buda_quote
variant1 = [word = '"'] [(lex contains 'buda..vb.1' )] [word = '"']
variant2 = [(lex contains 'buda..vb.1' )]

#label = nyord_fronta_quote
variant1 = [word = '"'] [(lex contains 'fronta..vb.1' )] [word = '"']
variant2 = [(lex contains 'fronta..vb.1' )]

#label = nyord_curla_quote
variant1 = [word = '"'] [(lex contains 'curla..vb.2' )] [word = '"']
variant2 = [(lex contains 'curla..vb.2' )]

#label = nyord_sprita_quote
variant1 = [word = '"'] [(lex contains 'sprita..vb.2' )] [word = '"']
variant2 = [(lex contains 'sprita..vb.2' )]

#label = nyord_stalka_quote
variant1 = [word = '"'] [(lex contains 'stalka..vb.1' )] [word = '"']
variant2 = [(lex contains 'stalka..vb.1' )]

#label = nyord_chippa_quote
variant1 = [word = '"'] [(word = 'chippa' %c  | word = 'chippar' %c  | word = 'chippade' %c  | word = 'chippat' %c  | word = 'chippas' %c  | word = 'chippades' %c  | word = 'chippats' %c  )] [word = '"']
variant2 = [(word = 'chippa' %c  | word = 'chippar' %c  | word = 'chippade' %c  | word = 'chippat' %c  | word = 'chippas' %c  | word = 'chippades' %c  | word = 'chippats' %c  )]

#label = nyord_pimpa_quote
variant1 = [word = '"'] [(lex contains 'pimpa..vb.1' )] [word = '"']
variant2 = [(lex contains 'pimpa..vb.1' )]

#label = nyord_sporta_quote
variant1 = [word = '"'] [(lex contains 'sporta..vb.1' )] [word = '"']
variant2 = [(lex contains 'sporta..vb.1' )]

#label = nyord_hypa_quote
variant1 = [word = '"'] [(lex contains 'hypa..vb.1' )] [word = '"']
variant2 = [(lex contains 'hypa..vb.1' )]

#label = nyord_topsa_quote
variant1 = [word = '"'] [(lex contains 'topsa..vb.1' )] [word = '"']
variant2 = [(lex contains 'topsa..vb.1' )]

#label = nyord_dampa_quote
variant1 = [word = '"'] [(lex contains 'dampa..vb.2' )] [word = '"']
variant2 = [(lex contains 'dampa..vb.2' )]

#label = nyord_skypa_quote
variant1 = [word = '"'] [(lex contains 'skypa..vb.1' )] [word = '"']
variant2 = [(lex contains 'skypa..vb.1' )]

#label = nyord_ghosta_quote
variant1 = [word = '"'] [(word = 'ghosta' %c  | word = 'ghostar' %c  | word = 'ghostade' %c  | word = 'ghostat' %c  | word = 'ghostas' %c  | word = 'ghostades' %c  | word = 'ghostats' %c  )] [word = '"']
variant2 = [(word = 'ghosta' %c  | word = 'ghostar' %c  | word = 'ghostade' %c  | word = 'ghostat' %c  | word = 'ghostas' %c  | word = 'ghostades' %c  | word = 'ghostats' %c  )]

#label = nyord_skamma_quote
variant1 = [word = '"'] [(word = 'skamma' %c  | word = 'skammar' %c  | word = 'skammade' %c  | word = 'skammat' %c  | word = 'skammas' %c  | word = 'skammades' %c  | word = 'skammats' %c  )] [word = '"']
variant2 = [(word = 'skamma' %c  | word = 'skammar' %c  | word = 'skammade' %c  | word = 'skammat' %c  | word = 'skammas' %c  | word = 'skammades' %c  | word = 'skammats' %c  )]

#label = nyord_legga_quote
variant1 = [word = '"'] [(word = 'legga' %c  | word = 'leggar' %c  | word = 'leggade' %c  | word = 'leggat' %c  | word = 'leggas' %c  | word = 'leggades' %c  | word = 'leggats' %c  )] [word = '"']
variant2 = [(word = 'legga' %c  | word = 'leggar' %c  | word = 'leggade' %c  | word = 'leggat' %c  | word = 'leggas' %c  | word = 'leggades' %c  | word = 'leggats' %c  )]

#label = nyord_facebooka_quote
variant1 = [word = '"'] [(lex contains 'facebooka..vb.1' )] [word = '"']
variant2 = [(lex contains 'facebooka..vb.1' )]

#label = nyord_prio_quote
variant1 = [word = '"'] [(word = 'prio' %c  )] [word = '"']
variant2 = [(word = 'prio' %c  )]

#label = nyord_Haffa_quote
variant1 = [word = '"'] [(lex contains 'haffa..vb.1' )] [word = '"']
variant2 = [(lex contains 'haffa..vb.1' )]

#label = nyord_blinga_quote
variant1 = [word = '"'] [(lex contains 'blinga..vb.1' )] [word = '"']
variant2 = [(lex contains 'blinga..vb.1' )]

#label = nyord_dabba_quote
variant1 = [word = '"'] [(word = 'dabba' %c  | word = 'dabbar' %c  | word = 'dabbade' %c  | word = 'dabbat' %c  | word = 'dabbas' %c  | word = 'dabbades' %c  | word = 'dabbats' %c  )] [word = '"']
variant2 = [(word = 'dabba' %c  | word = 'dabbar' %c  | word = 'dabbade' %c  | word = 'dabbat' %c  | word = 'dabbas' %c  | word = 'dabbades' %c  | word = 'dabbats' %c  )]

#label = nyord_nixa_quote
variant1 = [word = '"'] [(word = 'nixa' %c  | word = 'nixar' %c  | word = 'nixade' %c  | word = 'nixat' %c  | word = 'nixas' %c  | word = 'nixades' %c  | word = 'nixats' %c  )] [word = '"']
variant2 = [(word = 'nixa' %c  | word = 'nixar' %c  | word = 'nixade' %c  | word = 'nixat' %c  | word = 'nixas' %c  | word = 'nixades' %c  | word = 'nixats' %c  )]

#label = nyord_killgissa_quote
variant1 = [word = '"'] [(word = 'killgissa' %c  | word = 'killgissar' %c  | word = 'killgissade' %c  | word = 'killgissat' %c  | word = 'killgissas' %c  | word = 'killgissades' %c  | word = 'killgissats' %c  )] [word = '"']
variant2 = [(word = 'killgissa' %c  | word = 'killgissar' %c  | word = 'killgissade' %c  | word = 'killgissat' %c  | word = 'killgissas' %c  | word = 'killgissades' %c  | word = 'killgissats' %c  )]

#label = nyord_terja_quote
variant1 = [word = '"'] [(word = 'terja' %c  | word = 'terjar' %c  | word = 'terjade' %c  | word = 'terjat' %c  | word = 'terjas' %c  | word = 'terjades' %c  | word = 'terjats' %c  )] [word = '"']
variant2 = [(word = 'terja' %c  | word = 'terjar' %c  | word = 'terjade' %c  | word = 'terjat' %c  | word = 'terjas' %c  | word = 'terjades' %c  | word = 'terjats' %c  )]

#label = nyord_podda_quote
variant1 = [word = '"'] [(word = 'podda' %c  | word = 'poddar' %c  | word = 'poddade' %c  | word = 'poddat' %c  | word = 'poddas' %c  | word = 'poddades' %c  | word = 'poddats' %c  )] [word = '"']
variant2 = [(word = 'podda' %c  | word = 'poddar' %c  | word = 'poddade' %c  | word = 'poddat' %c  | word = 'poddas' %c  | word = 'poddades' %c  | word = 'poddats' %c  )]

#label = nyord_krana_quote
variant1 = [word = '"'] [(word = 'krana' %c  | word = 'kranar' %c  | word = 'kranade' %c  | word = 'kranat' %c  | word = 'kranas' %c  | word = 'kranades' %c  | word = 'kranats' %c  )] [word = '"']
variant2 = [(word = 'krana' %c  | word = 'kranar' %c  | word = 'kranade' %c  | word = 'kranat' %c  | word = 'kranas' %c  | word = 'kranades' %c  | word = 'kranats' %c  )]

#label = nyord_appa_quote
variant1 = [word = '"'] [(lex contains 'appa..vb.1' )] [word = '"']
variant2 = [(lex contains 'appa..vb.1' )]

#label = nyord_twerka_quote
variant1 = [word = '"'] [(word = 'twerka' %c  | word = 'twerkar' %c  | word = 'twerkade' %c  | word = 'twerkat' %c  | word = 'twerkas' %c  | word = 'twerkades' %c  | word = 'twerkats' %c  )] [word = '"']
variant2 = [(word = 'twerka' %c  | word = 'twerkar' %c  | word = 'twerkade' %c  | word = 'twerkat' %c  | word = 'twerkas' %c  | word = 'twerkades' %c  | word = 'twerkats' %c  )]

#label = nyord_smygöppna_quote
variant1 = [word = '"'] [(word = 'smygöppna' %c  | word = 'smygöppnar' %c  | word = 'smygöppnade' %c  | word = 'smygöppnat' %c  | word = 'smygöppnas' %c  | word = 'smygöppnades' %c  | word = 'smygöppnats' %c  )] [word = '"']
variant2 = [(word = 'smygöppna' %c  | word = 'smygöppnar' %c  | word = 'smygöppnade' %c  | word = 'smygöppnat' %c  | word = 'smygöppnas' %c  | word = 'smygöppnades' %c  | word = 'smygöppnats' %c  )]

#label = nyord_cringe_quote
variant1 = [word = '"'] [(word = 'cringe' %c  )] [word = '"']
variant2 = [(word = 'cringe' %c  )]

#label = nyord_incel_quote
variant1 = [word = '"'] [(word = 'incel' %c  | word = 'incelen' %c  | word = 'inceln' %c  | word = 'inceler' %c  | word = 'incelerna' %c  | word = 'incels' %c  | word = 'inselsen' %c  | word = 'incell' %c  | word = 'incellen' %c  | word = 'inceller' %c  | word = 'incellerna' %c  | word = 'incells' %c  | word = 'incellsen' %c  )] [word = '"']
variant2 = [(word = 'incel' %c  | word = 'incelen' %c  | word = 'inceln' %c  | word = 'inceler' %c  | word = 'incelerna' %c  | word = 'incels' %c  | word = 'inselsen' %c  | word = 'incell' %c  | word = 'incellen' %c  | word = 'inceller' %c  | word = 'incellerna' %c  | word = 'incells' %c  | word = 'incellsen' %c  )]

#label = nyord_brexit_quote
variant1 = [word = '"'] [(word = 'brexit' %c  )] [word = '"']
variant2 = [(word = 'brexit' %c  )]

#label = nyord_wiki_quote
variant1 = [word = '"'] [(lex contains 'wiki..nn.1' )] [word = '"']
variant2 = [(lex contains 'wiki..nn.1' )]

#label = nyord_blogg_quote
variant1 = [word = '"'] [(lex contains 'blogg..nn.1' )] [word = '"']
variant2 = [(lex contains 'blogg..nn.1' )]

#label = nyord_vobba_quote
variant1 = [word = '"'] [(lex contains 'vobba..vb.1' )] [word = '"']
variant2 = [(lex contains 'vobba..vb.1' )]

#label = nyord_flossa_quote
variant1 = [word = '"'] [(lex contains 'flossa..vb.1' )] [word = '"']
variant2 = [(lex contains 'flossa..vb.1' )]

#label = nyord_svinna_quote
variant1 = [word = '"'] [(lex contains 'svinna..vb.1' )] [word = '"']
variant2 = [(lex contains 'svinna..vb.1' )]

#label = nyord_ångerrösta_quote
variant1 = [word = '"'] [(word = 'ångerrösta' %c  | word = 'ångerröstar' %c  | word = 'ångerröstade' %c  | word = 'ångerröstat' %c  | word = 'ångerröstas' %c  | word = 'ångerröstades' %c  | word = 'ångerröstats' %c  )] [word = '"']
variant2 = [(word = 'ångerrösta' %c  | word = 'ångerröstar' %c  | word = 'ångerröstade' %c  | word = 'ångerröstat' %c  | word = 'ångerröstas' %c  | word = 'ångerröstades' %c  | word = 'ångerröstats' %c  )]

#label = nyord_solduscha_quote
variant1 = [word = '"'] [(word = 'solduscha' %c  | word = 'solduschar' %c  | word = 'solduschade' %c  | word = 'solduschat' %c  | word = 'solduschas' %c  | word = 'solduschades' %c  | word = 'solduschats' %c  )] [word = '"']
variant2 = [(word = 'solduscha' %c  | word = 'solduschar' %c  | word = 'solduschade' %c  | word = 'solduschat' %c  | word = 'solduschas' %c  | word = 'solduschades' %c  | word = 'solduschats' %c  )]

#label = nyord_paltkoma_quote
variant1 = [word = '"'] [(lex contains 'paltkoma..nn.1' )] [word = '"']
variant2 = [(lex contains 'paltkoma..nn.1' )]

#label = nyord_spikmatta_quote
variant1 = [word = '"'] [(lex contains 'spikmatta..nn.' )] [word = '"']
variant2 = [(lex contains 'spikmatta..nn.' )]

#label = nyord_doxa_quote
variant1 = [word = '"'] [(word = 'doxa' %c  | word = 'doxar' %c  | word = 'doxade' %c  | word = 'doxat' %c  | word = 'doxas' %c  | word = 'doxades' %c  )] [word = '"']
variant2 = [(word = 'doxa' %c  | word = 'doxar' %c  | word = 'doxade' %c  | word = 'doxat' %c  | word = 'doxas' %c  | word = 'doxades' %c  )]

#label = nyord_stalker_quote
variant1 = [word = '"'] [(lex contains 'stalker..nn.1' )] [word = '"']
variant2 = [(lex contains 'stalker..nn.1' )]

#label = nyord_tvittra_quote
variant1 = [word = '"'] [(lex contains 'tvittra..vb.1' | lex contains 'twittra..vb.1' )] [word = '"']
variant2 = [(lex contains 'tvittra..vb.1' | lex contains 'twittra..vb.1' )]

#label = nyord_skajpa_quote
variant1 = [word = '"'] [(lex contains 'skypa..vb.1' )] [word = '"']
variant2 = [(lex contains 'skypa..vb.1' )]

#label = nyord_mjuta_quote
variant1 = [word = '"'] [(lex contains 'muta..vb.2' )] [word = '"']
variant2 = [(lex contains 'muta..vb.2' )]

#label = nyord_sverka_quote
variant1 = [word = '"'] [(word = 'sverka' %c  | word = 'sverkar' %c  | word = 'sverkade' %c  | word = 'sverkat' %c  | word = 'sverkas' %c  | word = 'sverkades' %c  | word = 'sverkats' %c  )] [word = '"']
variant2 = [(word = 'sverka' %c  | word = 'sverkar' %c  | word = 'sverkade' %c  | word = 'sverkat' %c  | word = 'sverkas' %c  | word = 'sverkades' %c  | word = 'sverkats' %c  )]

#label = nyord_loba_quote
variant1 = [word = '"'] [(word = 'loba' %c  | word = 'lobar' %c  | word = 'lobade' %c  | word = 'lobat' %c  | word = 'lobas' %c  | word = 'lobades' %c  | word = 'lobats' %c  )] [word = '"']
variant2 = [(word = 'loba' %c  | word = 'lobar' %c  | word = 'lobade' %c  | word = 'lobat' %c  | word = 'lobas' %c  | word = 'lobades' %c  | word = 'lobats' %c  )]

#label = nyord_plogga_quote
variant1 = [word = '"'] [(word = 'plogga' %c  | word = 'ploggar' %c  | word = 'ploggade' %c  | word = 'ploggat' %c  | word = 'ploggas' %c  | word = 'ploggades' %c  | word = 'ploggats' %c  )] [word = '"']
variant2 = [(word = 'plogga' %c  | word = 'ploggar' %c  | word = 'ploggade' %c  | word = 'ploggat' %c  | word = 'ploggas' %c  | word = 'ploggades' %c  | word = 'ploggats' %c  )]

#label = nyord_bjästa_quote
variant1 = [word = '"'] [(word = 'bjästa' %c  | word = 'bjästar' %c  | word = 'bjästade' %c  | word = 'bjästat' %c  | word = 'bjästas' %c  | word = 'bjästades' %c  | word = 'bjästats' %c  )] [word = '"']
variant2 = [(word = 'bjästa' %c  | word = 'bjästar' %c  | word = 'bjästade' %c  | word = 'bjästat' %c  | word = 'bjästas' %c  | word = 'bjästades' %c  | word = 'bjästats' %c  )]

#label = nyord_barista_quote
variant1 = [word = '"'] [(word = 'barista' %c  | word = 'baristan' %c  | word = 'baristor' %c  | word = 'baristas' %c  | word = 'baristans' %c  | word = 'baristors' %c  )] [word = '"']
variant2 = [(word = 'barista' %c  | word = 'baristan' %c  | word = 'baristor' %c  | word = 'baristas' %c  | word = 'baristans' %c  | word = 'baristors' %c  )]

#label = nyord_veganisera_quote
variant1 = [word = '"'] [(word = 'veganisera' %c  | word = 'veganiserar' %c  | word = 'veganiserade' %c  | word = 'veganiserat' %c  | word = 'veganiseras' %c  | word = 'veganiserades' %c  | word = 'veganiserats' %c  )] [word = '"']
variant2 = [(word = 'veganisera' %c  | word = 'veganiserar' %c  | word = 'veganiserade' %c  | word = 'veganiserat' %c  | word = 'veganiseras' %c  | word = 'veganiserades' %c  | word = 'veganiserats' %c  )]

#label = nyord_Dumpstra_quote
variant1 = [word = '"'] [(word = 'dumpstra' %c  | word = 'dumpstrar' %c  | word = 'dumpstrade' %c  | word = 'dumpstrat' %c  | word = 'dumpstras' %c  | word = 'dumpstrades' %c  | word = 'dumpstrats' %c  )] [word = '"']
variant2 = [(word = 'dumpstra' %c  | word = 'dumpstrar' %c  | word = 'dumpstrade' %c  | word = 'dumpstrat' %c  | word = 'dumpstras' %c  | word = 'dumpstrades' %c  | word = 'dumpstrats' %c  )]

#label = nyord_väggord_quote
variant1 = [word = '"'] [(word = 'väggord' %c  | word = 'väggordet' %c  | word = 'väggorden' %c  | word = 'väggordena' %c  | word = 'väggords' %c  | word = 'väggordets' %c  | word = 'väggordens' %c  | word = 'väggordenas' %c  )] [word = '"']
variant2 = [(word = 'väggord' %c  | word = 'väggordet' %c  | word = 'väggorden' %c  | word = 'väggordena' %c  | word = 'väggords' %c  | word = 'väggordets' %c  | word = 'väggordens' %c  | word = 'väggordenas' %c  )]

#label = nyord_hbt_quote
variant1 = [word = '"'] [(word = 'hbt' %c  )] [word = '"']
variant2 = [(word = 'hbt' %c  )]

#label = nyord_yoloa_quote
variant1 = [word = '"'] [(lex contains 'yoloa..vb.1' )] [word = '"']
variant2 = [(lex contains 'yoloa..vb.1' )]

#label = nyord_emoji_quote
variant1 = [word = '"'] [(word = 'emoj' %c  | word = 'emojen' %c  | word = 'emojer' %c  | word = 'emojar' %c  | word = 'emojsar' %c  | word = 'emojs' %c  | word = 'emojsen' %c  | word = 'emojers' %c  | word = 'emojsars' %c  | word = 'emojsens' %c  | word = 'emoji' %c  | word = 'emojien' %c  | word = 'emoijen' %c  | word = 'emoijer' %c  | word = 'emojisar' %c  | word = 'emojis' %c  | word = 'emojisen' %c  | word = 'emojiens' %c  | word = 'emoijers' %c  | word = 'emojisars' %c  | word = 'emoij' %c  | word = 'emoijs' %c  | word = 'emoijer' %c  | word = 'emoijis' %c  )] [word = '"']
variant2 = [(word = 'emoj' %c  | word = 'emojen' %c  | word = 'emojer' %c  | word = 'emojar' %c  | word = 'emojsar' %c  | word = 'emojs' %c  | word = 'emojsen' %c  | word = 'emojers' %c  | word = 'emojsars' %c  | word = 'emojsens' %c  | word = 'emoji' %c  | word = 'emojien' %c  | word = 'emoijen' %c  | word = 'emoijer' %c  | word = 'emojisar' %c  | word = 'emojis' %c  | word = 'emojisen' %c  | word = 'emojiens' %c  | word = 'emoijers' %c  | word = 'emojisars' %c  | word = 'emoij' %c  | word = 'emoijs' %c  | word = 'emoijer' %c  | word = 'emoijis' %c  )]

#label = nyord_fejsbooka_quote
variant1 = [word = '"'] [(lex contains 'facebooka..vb.1' )] [word = '"']
variant2 = [(lex contains 'facebooka..vb.1' )]

#label = nyord_blattesvenska_quote
variant1 = [word = '"'] [(word = 'blattesvenska' %c  | word = 'blattesvenskan' %c  | word = 'blattesvenskas' %c  | word = 'blattesvenskans' %c  )] [word = '"']
variant2 = [(word = 'blattesvenska' %c  | word = 'blattesvenskan' %c  | word = 'blattesvenskas' %c  | word = 'blattesvenskans' %c  )]

#label = nyord_groma_quote
variant1 = [word = '"'] [(word = 'groma' %c  | word = 'gromar' %c  | word = 'gromade' %c  | word = 'gromat' %c  | word = 'gromas' %c  | word = 'gromades' %c  | word = 'gromats' %c  | word = 'grooma' %c  | word = 'groomar' %c  | word = 'groomade' %c  | word = 'groomat' %c  | word = 'groomas' %c  | word = 'groomades' %c  | word = 'groomats' %c  )] [word = '"']
variant2 = [(word = 'groma' %c  | word = 'gromar' %c  | word = 'gromade' %c  | word = 'gromat' %c  | word = 'gromas' %c  | word = 'gromades' %c  | word = 'gromats' %c  | word = 'grooma' %c  | word = 'groomar' %c  | word = 'groomade' %c  | word = 'groomat' %c  | word = 'groomas' %c  | word = 'groomades' %c  | word = 'groomats' %c  )]

#label = nyord_nätpoker_quote
variant1 = [word = '"'] [(word = 'nätpoker' %c  | word = 'nätpokern' %c  | word = 'nätpokers' %c  | word = 'nätpokerns' %c  )] [word = '"']
variant2 = [(word = 'nätpoker' %c  | word = 'nätpokern' %c  | word = 'nätpokers' %c  | word = 'nätpokerns' %c  )]

#label = nyord_svennefiera_quote
variant1 = [word = '"'] [(word = 'svennefiera' %c  | word = 'svennefierar' %c  | word = 'svennefierade' %c  | word = 'svennefierat' %c  | word = 'svennefieras' %c  | word = 'svennefierades' %c  | word = 'svennefieras' %c  | word = 'svennifiera' %c  | word = 'svennifierar' %c  | word = 'svennifierade' %c  | word = 'svennifierat' %c  | word = 'svennifieras' %c  | word = 'svennifierades' %c  | word = 'svennifieras' %c  )] [word = '"']
variant2 = [(word = 'svennefiera' %c  | word = 'svennefierar' %c  | word = 'svennefierade' %c  | word = 'svennefierat' %c  | word = 'svennefieras' %c  | word = 'svennefierades' %c  | word = 'svennefieras' %c  | word = 'svennifiera' %c  | word = 'svennifierar' %c  | word = 'svennifierade' %c  | word = 'svennifierat' %c  | word = 'svennifieras' %c  | word = 'svennifierades' %c  | word = 'svennifieras' %c  )]

#label = nyord_plastbanta_quote
variant1 = [word = '"'] [(word = 'plastbanta' %c  | word = 'plastbantar' %c  | word = 'plastbantade' %c  | word = 'plastbantat' %c  | word = 'plastbantas' %c  | word = 'plastbantades' %c  | word = 'plastbantats' %c  )] [word = '"']
variant2 = [(word = 'plastbanta' %c  | word = 'plastbantar' %c  | word = 'plastbantade' %c  | word = 'plastbantat' %c  | word = 'plastbantas' %c  | word = 'plastbantades' %c  | word = 'plastbantats' %c  )]

#label = nyord_snålsurfa_quote
variant1 = [word = '"'] [(word = 'snålsurfa' %c  | word = 'snålsurfar' %c  | word = 'snålsurfade' %c  | word = 'snålsurfat' %c  | word = 'snålsurfas' %c  | word = 'snålsurfades' %c  | word = 'snålsurfats' %c  )] [word = '"']
variant2 = [(word = 'snålsurfa' %c  | word = 'snålsurfar' %c  | word = 'snålsurfade' %c  | word = 'snålsurfat' %c  | word = 'snålsurfas' %c  | word = 'snålsurfades' %c  | word = 'snålsurfats' %c  )]

#label = nyord_grexit_quote
variant1 = [word = '"'] [(word = 'grexit' %c  )] [word = '"']
variant2 = [(word = 'grexit' %c  )]

#label = nyord_backslick_quote
variant1 = [word = '"'] [(word = 'backslick' %c  | word = 'backslicket' %c  | word = 'backslicken' %c  | word = 'backslicks' %c  | word = 'backslickets' %c  | word = 'backslickens' %c  )] [word = '"']
variant2 = [(word = 'backslick' %c  | word = 'backslicket' %c  | word = 'backslicken' %c  | word = 'backslicks' %c  | word = 'backslickets' %c  | word = 'backslickens' %c  )]

#label = nyord_bloppa_quote
variant1 = [word = '"'] [(word = 'bloppa' %c  | word = 'bloppar' %c  | word = 'bloppade' %c  | word = 'bloppat' %c  | word = 'bloppas' %c  | word = 'bloppades' %c  | word = 'bloppats' %c  )] [word = '"']
variant2 = [(word = 'bloppa' %c  | word = 'bloppar' %c  | word = 'bloppade' %c  | word = 'bloppat' %c  | word = 'bloppas' %c  | word = 'bloppades' %c  | word = 'bloppats' %c  )]

#label = nyord_rödgrönrosa_quote
variant1 = [word = '"'] [(word = 'rödgrönrosa' %c  )] [word = '"']
variant2 = [(word = 'rödgrönrosa' %c  )]

#label = nyord_menscertifiera_quote
variant1 = [word = '"'] [(word = 'menscertifiera' %c  | word = 'menscertifierar' %c  | word = 'menscertifierade' %c  | word = 'menscertifierat' %c  | word = 'menscertifieras' %c  | word = 'menscertifierades' %c  | word = 'menscertifierats' %c  )] [word = '"']
variant2 = [(word = 'menscertifiera' %c  | word = 'menscertifierar' %c  | word = 'menscertifierade' %c  | word = 'menscertifierat' %c  | word = 'menscertifieras' %c  | word = 'menscertifierades' %c  | word = 'menscertifierats' %c  )]

#label = nyord_döstäda_quote
variant1 = [word = '"'] [(word = 'döstäda' %c  | word = 'döstädar' %c  | word = 'döstädade' %c  | word = 'döstädat' %c  | word = 'döstädas' %c  | word = 'döstädades' %c  | word = 'döstädats' %c  )] [word = '"']
variant2 = [(word = 'döstäda' %c  | word = 'döstädar' %c  | word = 'döstädade' %c  | word = 'döstädat' %c  | word = 'döstädas' %c  | word = 'döstädades' %c  | word = 'döstädats' %c  )]

#label = nyord_simp_quote
variant1 = [word = '"'] [(word = 'simp' %c  | word = 'simpen' %c  | word = 'simpar' %c  | word = 'simparna' %c  | word = 'simps' %c  | word = 'simpens' %c  | word = 'simpars' %c  | word = 'simparnas' %c  )] [word = '"']
variant2 = [(word = 'simp' %c  | word = 'simpen' %c  | word = 'simpar' %c  | word = 'simparna' %c  | word = 'simps' %c  | word = 'simpens' %c  | word = 'simpars' %c  | word = 'simparnas' %c  )]

#label = nyord_friva_quote
variant1 = [word = '"'] [(word = 'friva' %c  )] [word = '"']
variant2 = [(word = 'friva' %c  )]

#label = nyord_filterbubbla_quote
variant1 = [word = '"'] [(word = 'filterbubbla' %c  | word = 'filterbubblan' %c  | word = 'filterbubblor' %c  | word = 'filterbubblorna' %c  | word = 'filterbubblas' %c  | word = 'filterbubblans' %c  | word = 'filterbubblors' %c  | word = 'filterbubblornas' %c  )] [word = '"']
variant2 = [(word = 'filterbubbla' %c  | word = 'filterbubblan' %c  | word = 'filterbubblor' %c  | word = 'filterbubblorna' %c  | word = 'filterbubblas' %c  | word = 'filterbubblans' %c  | word = 'filterbubblors' %c  | word = 'filterbubblornas' %c  )]

#label = nyord_Svischa_quote
variant1 = [word = '"'] [(word = 'svischa' %c  | word = 'svischar' %c  | word = 'svischade' %c  | word = 'svischat' %c  | word = 'svischas' %c  | word = 'svischades' %c  | word = 'svischats' %c  | word = 'swischa' %c  | word = 'swischar' %c  | word = 'swischade' %c  | word = 'swischat' %c  | word = 'swischas' %c  | word = 'swischades' %c  | word = 'swischats' %c  | word = 'swisha' %c  | word = 'swishar' %c  | word = 'swishade' %c  | word = 'swishat' %c  | word = 'swishas' %c  | word = 'swishades' %c  | word = 'swishats' %c  | word = 'svisha' %c  | word = 'svishar' %c  | word = 'svishade' %c  | word = 'svishat' %c  | word = 'svishas' %c  | word = 'svishades' %c  | word = 'svishats' %c  )] [word = '"']
variant2 = [(word = 'svischa' %c  | word = 'svischar' %c  | word = 'svischade' %c  | word = 'svischat' %c  | word = 'svischas' %c  | word = 'svischades' %c  | word = 'svischats' %c  | word = 'swischa' %c  | word = 'swischar' %c  | word = 'swischade' %c  | word = 'swischat' %c  | word = 'swischas' %c  | word = 'swischades' %c  | word = 'swischats' %c  | word = 'swisha' %c  | word = 'swishar' %c  | word = 'swishade' %c  | word = 'swishat' %c  | word = 'swishas' %c  | word = 'swishades' %c  | word = 'swishats' %c  | word = 'svisha' %c  | word = 'svishar' %c  | word = 'svishade' %c  | word = 'svishat' %c  | word = 'svishas' %c  | word = 'svishades' %c  | word = 'svishats' %c  )]

#label = nyord_kubtest_quote
variant1 = [word = '"'] [(word = 'kubtest' %c  | word = 'kubtesten' %c  | word = 'kubtestet' %c  | word = 'kubtester' %c  | word = 'kubtesterna' %c  | word = 'kubtests' %c  | word = 'kubtestens' %c  | word = 'kubtestets' %c  | word = 'kubtesters' %c  | word = 'kubtesternas' %c  | word = 'kubbtest' %c  | word = 'kubbtesten' %c  | word = 'kubbtestet' %c  | word = 'kubbtester' %c  | word = 'kubbtesterna' %c  | word = 'kubbtests' %c  | word = 'kubbtestens' %c  | word = 'kubbtestets' %c  | word = 'kubbtesters' %c  | word = 'kubbtesternas' %c  | word = 'kub-test' %c  | word = 'kub-testen' %c  | word = 'kub-testet' %c  | word = 'kub-tester' %c  | word = 'kub-testerna' %c  | word = 'kub-tests' %c  | word = 'kub-testens' %c  | word = 'kub-testets' %c  | word = 'kub-testers' %c  | word = 'kub-testernas' %c  | word = 'kubb-test' %c  | word = 'kubb-testen' %c  | word = 'kubb-testet' %c  | word = 'kubb-tester' %c  | word = 'kubb-testerna' %c  | word = 'kubb-tests' %c  | word = 'kubb-testens' %c  | word = 'kubb-testets' %c  | word = 'kubb-testers' %c  | word = 'kubb-testernas' %c  )] [word = '"']
variant2 = [(word = 'kubtest' %c  | word = 'kubtesten' %c  | word = 'kubtestet' %c  | word = 'kubtester' %c  | word = 'kubtesterna' %c  | word = 'kubtests' %c  | word = 'kubtestens' %c  | word = 'kubtestets' %c  | word = 'kubtesters' %c  | word = 'kubtesternas' %c  | word = 'kubbtest' %c  | word = 'kubbtesten' %c  | word = 'kubbtestet' %c  | word = 'kubbtester' %c  | word = 'kubbtesterna' %c  | word = 'kubbtests' %c  | word = 'kubbtestens' %c  | word = 'kubbtestets' %c  | word = 'kubbtesters' %c  | word = 'kubbtesternas' %c  | word = 'kub-test' %c  | word = 'kub-testen' %c  | word = 'kub-testet' %c  | word = 'kub-tester' %c  | word = 'kub-testerna' %c  | word = 'kub-tests' %c  | word = 'kub-testens' %c  | word = 'kub-testets' %c  | word = 'kub-testers' %c  | word = 'kub-testernas' %c  | word = 'kubb-test' %c  | word = 'kubb-testen' %c  | word = 'kubb-testet' %c  | word = 'kubb-tester' %c  | word = 'kubb-testerna' %c  | word = 'kubb-tests' %c  | word = 'kubb-testens' %c  | word = 'kubb-testets' %c  | word = 'kubb-testers' %c  | word = 'kubb-testernas' %c  )]

#label = nyord_entourage_quote
variant1 = [word = '"'] [(word = 'entourage' %c  | word = 'entouraget' %c  | word = 'entouragen' %c  | word = 'entourages' %c  | word = 'entouragets' %c  | word = 'entouragens' %c  )] [word = '"']
variant2 = [(word = 'entourage' %c  | word = 'entouraget' %c  | word = 'entouragen' %c  | word = 'entourages' %c  | word = 'entouragets' %c  | word = 'entouragens' %c  )]

#label = nyord_fomo_quote
variant1 = [word = '"'] [(word = 'fomo' %c  )] [word = '"']
variant2 = [(word = 'fomo' %c  )]

#label = nyord_dm:a_quote
variant1 = [word = '"'] [(word = 'dm:a' %c  | word = 'dm:ar' %c  | word = 'dm:ade' %c  | word = 'dm:at' %c  | word = 'dm:as' %c  | word = 'dm:ades' %c  | word = 'dm:ats' %c  | word = 'dma' %c  | word = 'dmar' %c  | word = 'dmade' %c  | word = 'dmat' %c  | word = 'dmas' %c  | word = 'dmades' %c  | word = 'dmats' %c  )] [word = '"']
variant2 = [(word = 'dm:a' %c  | word = 'dm:ar' %c  | word = 'dm:ade' %c  | word = 'dm:at' %c  | word = 'dm:as' %c  | word = 'dm:ades' %c  | word = 'dm:ats' %c  | word = 'dma' %c  | word = 'dmar' %c  | word = 'dmade' %c  | word = 'dmat' %c  | word = 'dmas' %c  | word = 'dmades' %c  | word = 'dmats' %c  )]

#label = nyord_tjejsamla_quote
variant1 = [word = '"'] [(word = 'tjejsamla' %c  | word = 'tjejsamlar' %c  | word = 'tjejsamlade' %c  | word = 'tjejsamlat' %c  | word = 'tjejsamlas' %c  | word = 'tjejsamlades' %c  | word = 'tjejsamlats' %c  )] [word = '"']
variant2 = [(word = 'tjejsamla' %c  | word = 'tjejsamlar' %c  | word = 'tjejsamlade' %c  | word = 'tjejsamlat' %c  | word = 'tjejsamlas' %c  | word = 'tjejsamlades' %c  | word = 'tjejsamlats' %c  )]

#label = nyord_henifiera_quote
variant1 = [word = '"'] [(word = 'henifiera' %c  | word = 'henifierar' %c  | word = 'henifierade' %c  | word = 'henifierat' %c  | word = 'henifieras' %c  | word = 'henifierades' %c  | word = 'henifierats' %c  | word = 'hennifiera' %c  | word = 'hennifierar' %c  | word = 'hennifierade' %c  | word = 'hennifierat' %c  | word = 'hennifieras' %c  | word = 'hennifierades' %c  | word = 'hennifierats' %c  )] [word = '"']
variant2 = [(word = 'henifiera' %c  | word = 'henifierar' %c  | word = 'henifierade' %c  | word = 'henifierat' %c  | word = 'henifieras' %c  | word = 'henifierades' %c  | word = 'henifierats' %c  | word = 'hennifiera' %c  | word = 'hennifierar' %c  | word = 'hennifierade' %c  | word = 'hennifierat' %c  | word = 'hennifieras' %c  | word = 'hennifierades' %c  | word = 'hennifierats' %c  )]

#label = nyord_Vejpa_quote
variant1 = [word = '"'] [(word = 'vejpa' %c  | word = 'vejpar' %c  | word = 'vejpade' %c  | word = 'vejpat' %c  | word = 'vejpas' %c  | word = 'vejpades' %c  | word = 'vejpats' %c  | word = 'vapea' %c  | word = 'vapear' %c  | word = 'vapeade' %c  | word = 'vapeat' %c  | word = 'vapeas' %c  | word = 'vapeades' %c  | word = 'vapeats' %c  )] [word = '"']
variant2 = [(word = 'vejpa' %c  | word = 'vejpar' %c  | word = 'vejpade' %c  | word = 'vejpat' %c  | word = 'vejpas' %c  | word = 'vejpades' %c  | word = 'vejpats' %c  | word = 'vapea' %c  | word = 'vapear' %c  | word = 'vapeade' %c  | word = 'vapeat' %c  | word = 'vapeas' %c  | word = 'vapeades' %c  | word = 'vapeats' %c  )]

#label = nyord_bebisbio_quote
variant1 = [word = '"'] [(word = 'bebisbio' %c  | word = 'bebisbion' %c  | word = 'bebisbios' %c  | word = 'bebisbions' %c  )] [word = '"']
variant2 = [(word = 'bebisbio' %c  | word = 'bebisbion' %c  | word = 'bebisbios' %c  | word = 'bebisbions' %c  )]

#label = nyord_elcertifikat_quote
variant1 = [word = '"'] [(word = 'elcertifikat' %c  | word = 'elcertifikatet' %c  | word = 'elcertifikaten' %c  | word = 'elcertifikats' %c  | word = 'elcertifikatets' %c  | word = 'elcertifikatens' %c  )] [word = '"']
variant2 = [(word = 'elcertifikat' %c  | word = 'elcertifikatet' %c  | word = 'elcertifikaten' %c  | word = 'elcertifikats' %c  | word = 'elcertifikatets' %c  | word = 'elcertifikatens' %c  )]

#label = nyord_vintage_quote
variant1 = [word = '"'] [(word = 'vintage' %c  )] [word = '"']
variant2 = [(word = 'vintage' %c  )]

#label = nyord_Svajpa_quote
variant1 = [word = '"'] [(word = 'svajpa' %c  | word = 'svajpar' %c  | word = 'svajpade' %c  | word = 'svajpat' %c  | word = 'svajpas' %c  | word = 'svajpades' %c  | word = 'svajpats' %c  | word = 'swajpa' %c  | word = 'swajpar' %c  | word = 'swajpade' %c  | word = 'swajpat' %c  | word = 'swajpas' %c  | word = 'swajpades' %c  | word = 'swajpats' %c  | word = 'swipa' %c  | word = 'swipar' %c  | word = 'swipade' %c  | word = 'swipat' %c  | word = 'swipas' %c  | word = 'swipades' %c  | word = 'swipats' %c  | word = 'swipea' %c  | word = 'swipear' %c  | word = 'swipeade' %c  | word = 'swipeat' %c  | word = 'swipeas' %c  | word = 'swipeades' %c  | word = 'swipeats' %c  )] [word = '"']
variant2 = [(word = 'svajpa' %c  | word = 'svajpar' %c  | word = 'svajpade' %c  | word = 'svajpat' %c  | word = 'svajpas' %c  | word = 'svajpades' %c  | word = 'svajpats' %c  | word = 'swajpa' %c  | word = 'swajpar' %c  | word = 'swajpade' %c  | word = 'swajpat' %c  | word = 'swajpas' %c  | word = 'swajpades' %c  | word = 'swajpats' %c  | word = 'swipa' %c  | word = 'swipar' %c  | word = 'swipade' %c  | word = 'swipat' %c  | word = 'swipas' %c  | word = 'swipades' %c  | word = 'swipats' %c  | word = 'swipea' %c  | word = 'swipear' %c  | word = 'swipeade' %c  | word = 'swipeat' %c  | word = 'swipeas' %c  | word = 'swipeades' %c  | word = 'swipeats' %c  )]

#label = nyord_anime_quote
variant1 = [word = '"'] [(word = 'anime' %c  )] [word = '"']
variant2 = [(word = 'anime' %c  )]

#label = nyord_vuvuzela_quote
variant1 = [word = '"'] [(lex contains 'vuvuzela..nn.1' )] [word = '"']
variant2 = [(lex contains 'vuvuzela..nn.1' )]





#label = nyord_googla
variant1 = [(lex contains 'googla..vb.1' )]

#label = nyord_VAR
variant1 = [(word = 'VAR' )]

#label = nyord_blogga
variant1 = [(lex contains 'blogga..vb.1' )]

#label = nyord_buda
variant1 = [(lex contains 'buda..vb.1' )]

#label = nyord_fronta
variant1 = [(lex contains 'fronta..vb.1' )]

#label = nyord_curla
variant1 = [(lex contains 'curla..vb.2' )]

#label = nyord_sprita
variant1 = [(lex contains 'sprita..vb.2' )]

#label = nyord_stalka
variant1 = [(lex contains 'stalka..vb.1' )]

#label = nyord_chippa
variant1 = [(word = 'chippa' %c | word = 'chippar' %c | word = 'chippade' %c | word = 'chippat' %c | word = 'chippas' %c | word = 'chippades' %c | word = 'chippats' %c )]

#label = nyord_pimpa
variant1 = [(lex contains 'pimpa..vb.1' )]

#label = nyord_spår
variant1 = [(lex contains 'spår..nn.1' )]

#label = nyord_sporta
variant1 = [(lex contains 'sporta..vb.1' )]

#label = nyord_hypa
variant1 = [(lex contains 'hypa..vb.1' )]

#label = nyord_topsa
variant1 = [(lex contains 'topsa..vb.1' )]

#label = nyord_kvittra
variant1 = [(lex contains 'kvittra..vb.1' )]

#label = nyord_dampa
variant1 = [(lex contains 'dampa..vb.2' )]

#label = nyord_skypa
variant1 = [(lex contains 'skypa..vb.1' )]

#label = nyord_ghosta
variant1 = [(word = 'ghosta' %c | word = 'ghostar' %c | word = 'ghostade' %c | word = 'ghostat' %c | word = 'ghostas' %c | word = 'ghostades' %c | word = 'ghostats' %c )]

#label = nyord_skamma
variant1 = [(word = 'skamma' %c | word = 'skammar' %c | word = 'skammade' %c | word = 'skammat' %c | word = 'skammas' %c | word = 'skammades' %c | word = 'skammats' %c )]

#label = nyord_legga
variant1 = [(word = 'legga' %c | word = 'leggar' %c | word = 'leggade' %c | word = 'leggat' %c | word = 'leggas' %c | word = 'leggades' %c | word = 'leggats' %c )]

#label = nyord_facebooka
variant1 = [(lex contains 'facebooka..vb.1' )]

#label = nyord_prio
variant1 = [(word = 'prio' %c )]

#label = nyord_Haffa
variant1 = [(lex contains 'haffa..vb.1' )]

#label = nyord_blinga
variant1 = [(lex contains 'blinga..vb.1' )]

#label = nyord_dabba
variant1 = [(word = 'dabba' %c | word = 'dabbar' %c | word = 'dabbade' %c | word = 'dabbat' %c | word = 'dabbas' %c | word = 'dabbades' %c | word = 'dabbats' %c )]

#label = nyord_nixa
variant1 = [(word = 'nixa' %c | word = 'nixar' %c | word = 'nixade' %c | word = 'nixat' %c | word = 'nixas' %c | word = 'nixades' %c | word = 'nixats' %c )]

#label = nyord_killgissa
variant1 = [(word = 'killgissa' %c | word = 'killgissar' %c | word = 'killgissade' %c | word = 'killgissat' %c | word = 'killgissas' %c | word = 'killgissades' %c | word = 'killgissats' %c )]

#label = nyord_terja
variant1 = [(word = 'terja' %c | word = 'terjar' %c | word = 'terjade' %c | word = 'terjat' %c | word = 'terjas' %c | word = 'terjades' %c | word = 'terjats' %c )]

#label = nyord_podda
variant1 = [(word = 'podda' %c | word = 'poddar' %c | word = 'poddade' %c | word = 'poddat' %c | word = 'poddas' %c | word = 'poddades' %c | word = 'poddats' %c )]

#label = nyord_krana
variant1 = [(word = 'krana' %c | word = 'kranar' %c | word = 'kranade' %c | word = 'kranat' %c | word = 'kranas' %c | word = 'kranades' %c | word = 'kranats' %c )]

#label = nyord_appa
variant1 = [(lex contains 'appa..vb.1' )]

#label = nyord_twerka
variant1 = [(word = 'twerka' %c | word = 'twerkar' %c | word = 'twerkade' %c | word = 'twerkat' %c | word = 'twerkas' %c | word = 'twerkades' %c | word = 'twerkats' %c )]

#label = nyord_smygöppna
variant1 = [(word = 'smygöppna' %c | word = 'smygöppnar' %c | word = 'smygöppnade' %c | word = 'smygöppnat' %c | word = 'smygöppnas' %c | word = 'smygöppnades' %c | word = 'smygöppnats' %c )]

#label = nyord_cringe
variant1 = [(word = 'cringe' %c )]

#label = nyord_padda
variant1 = [(word = 'padda' %c | word = 'paddan' %c | word = 'paddor' %c | word = 'paddorna' %c | word = 'paddas' %c | word = 'paddans' %c | word = 'paddors' %c | word = 'paddornas' %c )]

#label = nyord_incel
variant1 = [(word = 'incel' %c | word = 'incelen' %c | word = 'inceln' %c | word = 'inceler' %c | word = 'incelerna' %c | word = 'incels' %c | word = 'inselsen' %c | word = 'incell' %c | word = 'incellen' %c | word = 'inceller' %c | word = 'incellerna' %c | word = 'incells' %c | word = 'incellsen' %c )]

#label = nyord_brexit
variant1 = [(word = 'brexit' %c )]

#label = nyord_wiki
variant1 = [(lex contains 'wiki..nn.1' )]

#label = nyord_blogg
variant1 = [(lex contains 'blogg..nn.1' )]

#label = nyord_vobba
variant1 = [(lex contains 'vobba..vb.1' )]

#label = nyord_flossa
variant1 = [(lex contains 'flossa..vb.1' )]

#label = nyord_svinna
variant1 = [(lex contains 'svinna..vb.1' )]

#label = nyord_ångerrösta
variant1 = [(word = 'ångerrösta' %c | word = 'ångerröstar' %c | word = 'ångerröstade' %c | word = 'ångerröstat' %c | word = 'ångerröstas' %c | word = 'ångerröstades' %c | word = 'ångerröstats' %c )]

#label = nyord_solduscha
variant1 = [(word = 'solduscha' %c | word = 'solduschar' %c | word = 'solduschade' %c | word = 'solduschat' %c | word = 'solduschas' %c | word = 'solduschades' %c | word = 'solduschats' %c )]

#label = nyord_paltkoma
variant1 = [(lex contains 'paltkoma..nn.1' )]

#label = nyord_spikmatta
variant1 = [(lex contains 'spikmatta..nn.' )]

#label = nyord_doxa
variant1 = [(word = 'doxa' %c | word = 'doxar' %c | word = 'doxade' %c | word = 'doxat' %c | word = 'doxas' %c | word = 'doxades' %c )]

#label = nyord_stalker
variant1 = [(lex contains 'stalker..nn.1' )]

#label = nyord_tvittra
variant1 = [(lex contains 'tvittra..vb.1' | lex contains 'twittra..vb.1' )]

#label = nyord_skajpa
variant1 = [(lex contains 'skypa..vb.1' )]

#label = nyord_mjuta
variant1 = [(lex contains 'muta..vb.2' )]

#label = nyord_sverka
variant1 = [(word = 'sverka' %c | word = 'sverkar' %c | word = 'sverkade' %c | word = 'sverkat' %c | word = 'sverkas' %c | word = 'sverkades' %c | word = 'sverkats' %c )]

#label = nyord_loba
variant1 = [(word = 'loba' %c | word = 'lobar' %c | word = 'lobade' %c | word = 'lobat' %c | word = 'lobas' %c | word = 'lobades' %c | word = 'lobats' %c )]

#label = nyord_labrador
variant1 = [(lex contains 'labrador..nn.1' )]

#label = nyord_plogga
variant1 = [(word = 'plogga' %c | word = 'ploggar' %c | word = 'ploggade' %c | word = 'ploggat' %c | word = 'ploggas' %c | word = 'ploggades' %c | word = 'ploggats' %c )]

#label = nyord_bjästa
variant1 = [(word = 'bjästa' | word = 'bjästar' %c | word = 'bjästade' %c | word = 'bjästat' %c | word = 'bjästas' %c | word = 'bjästades' %c | word = 'bjästats' %c )]

#label = nyord_barista
variant1 = [(word = 'barista' %c | word = 'baristan' %c | word = 'baristor' %c | word = 'baristas' %c | word = 'baristans' %c | word = 'baristors' %c )]

#label = nyord_veganisera
variant1 = [(word = 'veganisera' %c | word = 'veganiserar' %c | word = 'veganiserade' %c | word = 'veganiserat' %c | word = 'veganiseras' %c | word = 'veganiserades' %c | word = 'veganiserats' %c )]

#label = nyord_Dumpstra
variant1 = [(word = 'dumpstra' %c | word = 'dumpstrar' %c | word = 'dumpstrade' %c | word = 'dumpstrat' %c | word = 'dumpstras' %c | word = 'dumpstrades' %c | word = 'dumpstrats' %c )]

#label = nyord_väggord
variant1 = [(word = 'väggord' %c | word = 'väggordet' %c | word = 'väggorden' %c | word = 'väggordena' %c | word = 'väggords' %c | word = 'väggordets' %c | word = 'väggordens' %c | word = 'väggordenas' %c )]

#label = nyord_hbt
variant1 = [(word = 'hbt' %c )]

#label = nyord_yoloa
variant1 = [(lex contains 'yoloa..vb.1' )]

#label = nyord_emoji
variant1 = [(word = 'emoj' %c | word = 'emojen' %c | word = 'emojer' %c | word = 'emojar' %c | word = 'emojsar' %c | word = 'emojs' %c | word = 'emojsen' %c | word = 'emojers' %c | word = 'emojsars' %c | word = 'emojsens' %c | word = 'emoji' %c | word = 'emojien' %c | word = 'emoijen' %c | word = 'emoijer' %c | word = 'emojisar' %c | word = 'emojis' %c | word = 'emojisen' %c | word = 'emojiens' %c | word = 'emoijers' %c | word = 'emojisars' %c | word = 'emoij' %c | word = 'emoijs' %c | word = 'emoijer' %c | word = 'emoijis' %c )]

#label = nyord_fejsbooka
variant1 = [(lex contains 'facebooka..vb.1' )]

#label = nyord_blattesvenska
variant1 = [(word = 'blattesvenska' %c | word = 'blattesvenskan' %c | word = 'blattesvenskas' %c | word = 'blattesvenskans' %c )]

#label = nyord_groma
variant1 = [(word = 'groma' %c | word = 'gromar' %c | word = 'gromade' %c | word = 'gromat' %c | word = 'gromas' %c | word = 'gromades' %c | word = 'gromats' %c | word = 'grooma' %c | word = 'groomar' %c | word = 'groomade' %c | word = 'groomat' %c | word = 'groomas' %c | word = 'groomades' %c | word = 'groomats' %c )]

#label = nyord_nätpoker
variant1 = [(word = 'nätpoker' %c | word = 'nätpokern' %c | word = 'nätpokers' %c | word = 'nätpokerns' %c )]

#label = nyord_svennefiera
variant1 = [(word = 'svennefiera' %c | word = 'svennefierar' %c | word = 'svennefierade' %c | word = 'svennefierat' %c | word = 'svennefieras' %c | word = 'svennefierades' %c | word = 'svennefieras' %c | word = 'svennifiera' %c | word = 'svennifierar' %c | word = 'svennifierade' %c | word = 'svennifierat' %c | word = 'svennifieras' %c | word = 'svennifierades' %c | word = 'svennifieras' %c )]

#label = nyord_plastbanta
variant1 = [(word = 'plastbanta' %c | word = 'plastbantar' %c | word = 'plastbantade' %c | word = 'plastbantat' %c | word = 'plastbantas' %c | word = 'plastbantades' %c | word = 'plastbantats' %c )]

#label = nyord_snålsurfa
variant1 = [(word = 'snålsurfa' %c | word = 'snålsurfar' %c | word = 'snålsurfade' %c | word = 'snålsurfat' %c | word = 'snålsurfas' %c | word = 'snålsurfades' %c | word = 'snålsurfats' %c )]

#label = nyord_grexit
variant1 = [(word = 'grexit' %c )]

#label = nyord_backslick
variant1 = [(word = 'backslick' %c | word = 'backslicket' %c | word = 'backslicken' %c | word = 'backslicks' %c | word = 'backslickets' %c | word = 'backslickens' %c )]

#label = nyord_bloppa
variant1 = [(word = 'bloppa' %c | word = 'bloppar' %c | word = 'bloppade' %c | word = 'bloppat' %c | word = 'bloppas' %c | word = 'bloppades' %c | word = 'bloppats' %c )]

#label = nyord_rödgrönrosa
variant1 = [(word = 'rödgrönrosa' %c )]

#label = nyord_menscertifiera
variant1 = [(word = 'menscertifiera' %c | word = 'menscertifierar' %c | word = 'menscertifierade' %c | word = 'menscertifierat' %c | word = 'menscertifieras' %c | word = 'menscertifierades' %c | word = 'menscertifierats' %c )]

#label = nyord_döstäda
variant1 = [(word = 'döstäda' %c | word = 'döstädar' %c | word = 'döstädade' %c | word = 'döstädat' %c | word = 'döstädas' %c | word = 'döstädades' %c | word = 'döstädats' %c )]

#label = nyord_simp
variant1 = [(word = 'simp' %c | word = 'simpen' %c | word = 'simpar' %c | word = 'simparna' %c | word = 'simps' %c | word = 'simpens' %c | word = 'simpars' %c | word = 'simparnas' %c )]

#label = nyord_friva
variant1 = [(word = 'friva' %c )]

#label = nyord_filterbubbla
variant1 = [(word = 'filterbubbla' %c | word = 'filterbubblan' %c | word = 'filterbubblor' %c | word = 'filterbubblorna' %c | word = 'filterbubblas' %c | word = 'filterbubblans' %c | word = 'filterbubblors' %c | word = 'filterbubblornas' %c )]

#label = nyord_Svischa
variant1 = [(word = 'svischa' %c | word = 'svischar' %c | word = 'svischade' %c | word = 'svischat' %c | word = 'svischas' %c | word = 'svischades' %c | word = 'svischats' %c | word = 'swischa' %c | word = 'swischar' %c | word = 'swischade' %c | word = 'swischat' %c | word = 'swischas' %c | word = 'swischades' %c | word = 'swischats' %c | word = 'swisha' %c | word = 'swishar' %c | word = 'swishade' %c | word = 'swishat' %c | word = 'swishas' %c | word = 'swishades' %c | word = 'swishats' %c | word = 'svisha' %c | word = 'svishar' %c | word = 'svishade' %c | word = 'svishat' %c | word = 'svishas' %c | word = 'svishades' %c | word = 'svishats' %c )]

#label = nyord_kubtest
variant1 = [(word = 'kubtest' %c | word = 'kubtesten' %c | word = 'kubtestet' %c | word = 'kubtester' %c | word = 'kubtesterna' %c | word = 'kubtests' %c | word = 'kubtestens' %c | word = 'kubtestets' %c | word = 'kubtesters' %c | word = 'kubtesternas' %c | word = 'kubbtest' %c | word = 'kubbtesten' %c | word = 'kubbtestet' %c | word = 'kubbtester' %c | word = 'kubbtesterna' %c | word = 'kubbtests' %c | word = 'kubbtestens' %c | word = 'kubbtestets' %c | word = 'kubbtesters' %c | word = 'kubbtesternas' %c | word = 'kub-test' %c | word = 'kub-testen' %c | word = 'kub-testet' %c | word = 'kub-tester' %c | word = 'kub-testerna' %c | word = 'kub-tests' %c | word = 'kub-testens' %c | word = 'kub-testets' %c | word = 'kub-testers' %c | word = 'kub-testernas' %c | word = 'kubb-test' %c | word = 'kubb-testen' %c | word = 'kubb-testet' %c | word = 'kubb-tester' %c | word = 'kubb-testerna' %c | word = 'kubb-tests' %c | word = 'kubb-testens' %c | word = 'kubb-testets' %c | word = 'kubb-testers' %c | word = 'kubb-testernas' %c )]

#label = nyord_entourage
variant1 = [(word = 'entourage' %c | word = 'entouraget' %c | word = 'entouragen' %c | word = 'entourages' %c | word = 'entouragets' %c | word = 'entouragens' %c )]

#label = nyord_fomo
variant1 = [(word = 'fomo' %c )]

#label = nyord_dm:a
variant1 = [(word = 'dm:a' %c | word = 'dm:ar' %c | word = 'dm:ade' %c | word = 'dm:at' %c | word = 'dm:as' %c | word = 'dm:ades' %c | word = 'dm:ats' %c | word = 'dma' %c | word = 'dmar' %c | word = 'dmade' %c | word = 'dmat' %c | word = 'dmas' %c | word = 'dmades' %c | word = 'dmats' %c )]

#label = nyord_tjejsamla
variant1 = [(word = 'tjejsamla' %c | word = 'tjejsamlar' %c | word = 'tjejsamlade' %c | word = 'tjejsamlat' %c | word = 'tjejsamlas' %c | word = 'tjejsamlades' %c | word = 'tjejsamlats' %c )]

#label = nyord_henifiera
variant1 = [(word = 'henifiera' %c | word = 'henifierar' %c | word = 'henifierade' %c | word = 'henifierat' %c | word = 'henifieras' %c | word = 'henifierades' %c | word = 'henifierats' %c | word = 'hennifiera' %c | word = 'hennifierar' %c | word = 'hennifierade' %c | word = 'hennifierat' %c | word = 'hennifieras' %c | word = 'hennifierades' %c | word = 'hennifierats' %c )]

#label = nyord_Vejpa
variant1 = [(word = 'vejpa' %c | word = 'vejpar' %c | word = 'vejpade' %c | word = 'vejpat' %c | word = 'vejpas' %c | word = 'vejpades' %c | word = 'vejpats' %c | word = 'vapea' %c | word = 'vapear' %c | word = 'vapeade' %c | word = 'vapeat' %c | word = 'vapeas' %c | word = 'vapeades' %c | word = 'vapeats' %c )]

#label = nyord_bebisbio
variant1 = [(word = 'bebisbio' %c | word = 'bebisbion' %c | word = 'bebisbios' %c | word = 'bebisbions' %c )]

#label = nyord_elcertifikat
variant1 = [(word = 'elcertifikat' %c | word = 'elcertifikatet' %c | word = 'elcertifikaten' %c | word = 'elcertifikats' %c | word = 'elcertifikatets' %c | word = 'elcertifikatens' %c )]

#label = nyord_vintage
variant1 = [(word = 'vintage' %c )]

#label = nyord_Svajpa
variant1 = [(word = 'svajpa' %c | word = 'svajpar' %c | word = 'svajpade' %c | word = 'svajpat' %c | word = 'svajpas' %c | word = 'svajpades' %c | word = 'svajpats' %c | word = 'swajpa' %c | word = 'swajpar' %c | word = 'swajpade' %c | word = 'swajpat' %c | word = 'swajpas' %c | word = 'swajpades' %c | word = 'swajpats' %c | word = 'swipa' %c | word = 'swipar' %c | word = 'swipade' %c | word = 'swipat' %c | word = 'swipas' %c | word = 'swipades' %c | word = 'swipats' %c | word = 'swipea' %c | word = 'swipear' %c | word = 'swipeade' %c | word = 'swipeat' %c | word = 'swipeas' %c | word = 'swipeades' %c | word = 'swipeats' %c )]

#label = nyord_anime
variant1 = [(word = 'anime' %c )]

#label = nyord_vuvuzela
variant1 = [(lex contains 'vuvuzela..nn.1' )]






#CORPUS:
#"FAMILJELIV-PLANERARBARN"
# "FAMILJELIV-ALLMANNA-FRITID","FAMILJELIV-PAPPAGRUPP,FAMILJELIV-ADOPTION,FAMILJELIV-ALLMANNA-EKONOMI,FAMILJELIV-ALLMANNA-FAMILJELIV,FAMILJELIV-ALLMANNA-FRITID,FAMILJELIV-ALLMANNA-HUSDJUR,FAMILJELIV-ALLMANNA-HUSHEM,FAMILJELIV-ALLMANNA-KROPP,FAMILJELIV-ALLMANNA-NOJE,FAMILJELIV-ALLMANNA-SAMHALLE,FAMILJELIV-ALLMANNA-SANDLADAN,FAMILJELIV-ANGLARUM,FAMILJELIV-EXPERT,FAMILJELIV-FORALDER,FAMILJELIV-GRAVID,FAMILJELIV-KANSLIGA,FAMILJELIV-MEDLEM-ALLMANNA,FAMILJELIV-MEDLEM-FORALDRAR,FAMILJELIV-MEDLEM-PLANERARBARN,FAMILJELIV-MEDLEM-VANTARBARN,FAMILJELIV-PAPPAGRUPP,FAMILJELIV-PLANERARBARN,FAMILJELIV-SEXSAMLEVNAD,FAMILJELIV-SVARTATTFABARN"

# "FLASHBACK-DATOR,FLASHBACK-DROGER,FLASHBACK-EKONOMI,FLASHBACK-FLASHBACK,FLASHBACK-FORDON,FLASHBACK-HEM,FLASHBACK-KULTUR,FLASHBACK-LIVSSTIL,FLASHBACK-MAT,FLASHBACK-OVRIGT,FLASHBACK-POLITIK,FLASHBACK-RESOR,FLASHBACK-SAMHALLE,FLASHBACK-SEX,FLASHBACK-SPORT,FLASHBACK-VETENSKAP"

#corpus =  "FAMILJELIV-ADOPTION,FAMILJELIV-ALLMANNA-EKONOMI,FAMILJELIV-ALLMANNA-FAMILJELIV,FAMILJELIV-ALLMANNA-FRITID,FAMILJELIV-ALLMANNA-HUSDJUR,FAMILJELIV-ALLMANNA-HUSHEM,FAMILJELIV-ALLMANNA-KROPP,FAMILJELIV-ALLMANNA-NOJE,FAMILJELIV-ALLMANNA-SAMHALLE,FAMILJELIV-ALLMANNA-SANDLADAN,FAMILJELIV-ANGLARUM,FAMILJELIV-EXPERT,FAMILJELIV-FORALDER,FAMILJELIV-GRAVID,FAMILJELIV-KANSLIGA,FAMILJELIV-MEDLEM-ALLMANNA,FAMILJELIV-MEDLEM-FORALDRAR,FAMILJELIV-MEDLEM-PLANERARBARN,FAMILJELIV-MEDLEM-VANTARBARN,FAMILJELIV-PAPPAGRUPP,FAMILJELIV-PLANERARBARN,FAMILJELIV-SEXSAMLEVNAD,FAMILJELIV-SVARTATTFABARN"



#VARIANT 1:
#"[word = 'än'+%c#{useradd} & pos = 'KN'] [msd = '.*SUB.*' & (lex contains 'jag\.\.pn\.1' | lex contains 'du\.\.pn\.1' | lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'vi\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]" #*

#"[(lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1')#{useradd}]" #*

#"[word+=+'kommer'+%c#{useradd}]+[word+=+'att'+%c]+[pos+=+'VB'+&+msd+=+'.*INF.*']"

#"[word+=+'kommer']+[word+=+'att']+[pos+=+'VB'+&+msd+=+'.*INF.*']" #"[word+=+'ja']"
#"[word+=+'än']+[word+=+'jag' | word = 'du' | word = 'han' | word = 'hon' | word = 'vi' | word = 'ni']"
#"[word+=+'.*mejl.*']"
#'[word = "styv.*" & (word = ".*familj.*" | word = ".*far.*" | word = ".*mor.*" | word = ".*papp.*" | word = ".*mamm.*" | word = ".*bror.*" | word = ".*syst.*" | word = ".*syskon.*" | word = ".*dott.*" | word = ".*son.*" | word = ".*barn.*")]'
#"[lex+contains+'smörgås\.\.nn\.1']" # "[pos+=+'SN']+[]+[word+=+'inte']+[pos+=+'VB']" #"[word+=+'ja']" #"[word+=+'på']+[word+=+'gång']" #"(word+=+'också')" #"(word+=+'ledsen')" #"(word+=+'mig'+|+word+=+'sig'+|+word+=+'dig')"


#VARIANT 2:
#"[word = 'än'+%c#{useradd} & pos = 'KN'] [msd = '.*OBJ.*' & (lex contains 'jag\.\.pn\.1' | lex contains 'du\.\.pn\.1' | lex contains 'han\.\.pn\.1' | lex contains 'hon\.\.pn\.1' | lex contains 'vi\.\.pn\.1' | lex contains 'ni\.\.pn\.1')]"


#"[word+=+'kommer'+%c#{useradd}]+[pos+=+'VB'+&+msd+=+'.*INF.*']"
#"[word+=+'än']+[word+=+'mig' | word = 'dig' | word = 'honom' | word = 'henne' | word = 'oss' | word = 'er']"
#"[word+=+'.*mail.*']"

#'[word = "bonus.*" & (word = ".*familj.*" | word = ".*far.*" | word = ".*mor.*" | word = ".*papp.*" | word = ".*mamm.*" | word = ".*bror.*" | word = ".*syst.*" | word = ".*syskon.*" | word = ".*dott.*" | word = ".*son.*" | word = ".*barn.*")]' 
#"[lex+contains+'macka\.\.nn\.1']" #[pos+=+'SN']+[]+[pos+=+'VB']+[word+=+'inte']" #"[word+=+'yes']" #"[word+=+'på']+[word+=+'g']" #"(word+=+'oxå')" #"(word+=+'lessen')" #"(word+=+'mej'+|+word+=+'sej'+|+word+=+'dej')"

#AUTHORS:

#safe_uri = URI.escape("https://ws.spraakbanken.gu.se/ws/korp/v8/count?corpus=#{corpus}&cqp=[lex+contains+'ge..vb.1']&group_by_struct=text_username,text_datefrom")
    #safe_uri = URI.escape(#"https://ws.spraakbanken.gu.se/ws/korp/v8/count?corpus=FAMILJELIV-ADOPTION&cqp=[word+=+'kommer'+&+_.text_date+=+'2006.*']+[word+=+'att']+[pos+=+'VB'+&+msd+=+'.*INF.*']&group_by_struct=text_username") #&ignore_case=word #
