Built a pipeline for steps 1-5 and ran it for the 29 verbs from the NJL manuscript. 
Excluded: "torde" never occurred with "att", "idas" almost never

1. Search in (almost) all modern newspaper corpora at Språkbanken for all active infinitives that occur after:
Query1a: VERB1.PRS att (INF.AKT)
Query1b: VERB1.PRS (INF.AKT)

General question: should we add preteritum (both here and in the main queries below)? Or other forms? Separately or jointly?
EVIE: It seems logical to copy the search of our NJL article, i.e., (msd = ".*VB\.PRS\.AKT.*" | msd = ".*VB\.PRT\.AKT.*"). But, then, this multiplies searching for seperate wordforms downstream. It think just focusing on msd = ".*VB\.PRS\.AKT.*" only is probably easiest.

Corpus composition: GP2001,GP2002,GP2003,GP2004,GP2005,GP2006,GP2007,GP2008,GP2009,GP2010,GP2011,GP2012,GP2013,SVT-2004,SVT-2005,SVT-2006,SVT-2007,SVT-2008,SVT-2009,SVT-2010,SVT-2011,SVT-2012,SVT-2013,SVT-2014,SVT-2015,SVT-2016,SVT-2017,SVT-2018,SVT-2019,SVT-2020,SVT-2021,SVT-2022,SVT-2023,da,PRESS76,PRESS95,PRESS96,PRESS97,PRESS98,WEBBNYHETER2001,WEBBNYHETER2002,WEBBNYHETER2003,WEBBNYHETER2004,WEBBNYHETER2005,WEBBNYHETER2006,WEBBNYHETER2007,WEBBNYHETER2008,WEBBNYHETER2009,WEBBNYHETER2010,WEBBNYHETER2011,WEBBNYHETER2012,WEBBNYHETER2013
Change? Don't really think it matters.

EVIE: I agree.

2. 
From each search, extract n most frequent infinitives that cover a larger proportion of the total number of hits found by Query1a than a given threshold.
Same for Query1b.
Threshold = 0.5
Change?

EVIE: We could argue in a publication that the treshold 0.5 works well for our purposes due to the Zipfian distribution of VERB2s (which I assume will be there to some extent for all constructions, we could show that - I would be very interested in that, as I have a paper submitted on this topic). As the result of this Zipfian distribution, by taking a small set of the most frequent VERB2s, one covers most of the full frequency of the VERB1 (att) VERB2. 

Note that n is different for Query1a and Query1b, we ignore that in the future. We compare the lump sums, not per infinitive (if we want to do that instead, we have to change the procedure so that the infinitive list is the same for "att" and "omission", or maybe even across different VERB1s).

EVIE: Using lump sums sounds like a good idea, as the aim of the list is to extract VERB1 (att) VERB1 constructions.

3. For every VERB1, generate two "naive" queries that can be used in Retriever and potentially tidningar.kb.se (and Mediesök) using the infinitives found in 2. 
Query2a: "VERB1.PRS att INF1" OR "VERB1.PRS att INF2" ... OR "VERB1.PRS att INF25"
Query2b: "VERB1.PRS INF1" OR "VERB1.PRS INF2" ... OR "VERB1.PRS INF25"
See: https://github.com/spraakbanken/Cassandra/blob/main/w_naive_queries.txt

NB: we lump together all possible combinations of VERB1 + INF into a single query conjoining them by OR. This means we have to run two manual queries per verb and not 20-50. 
Unfortunately, in Retriever the numbers of hits for the query A OR B is a bit different than the sum of hits for A and for B separately (I guess it counts not the occurrences, but sentences where the search item appears or smth like that). The deviation, however, seems to be small. I tried both approaches for "komma", have a look at the plot (black: each query "kommer INF" separately, then summed up, blue: all queries conjoined by OR): https://github.com/spraakbanken/Cassandra/blob/main/wellanders/comparisons/komma_0.5_separate_queries_vs_OR.pdf
No such problem in tidningar.kb.se.

EVIE: okay

4. Test whether Query2 ("half query") is as good as Query1 ("full query").
Choose a test corpus (SVT).
Run a diachronic query in the usual Cassandra style (counting/plotting the proportion of the innovative variant): 1a vs 1b, 2a vs 2b. The qualitative picture should be the same. See https://github.com/spraakbanken/Cassandra/tree/main/wellanders/comparisons
Plot the two trajectories (see pdfs). "Full" query is solid black, "half" query is dashed blue. 
For every verb, calculate the difference between the values for the same year (see separate tsvs per verb)
As a single measure per verb, use the sum of square differences (see allverbs.tsv). This measure is difficult to interpret, we need some comparison ground.
Seems to depend on the frequency of VERB1. Take that into account somehow?

EVIE: very good idea with this test! Visual comparison in the pdf's looks good. The sum of square of differences is not that informative, as it depends on frequency of construction (very infrequent constructions will have large diffs in relative frequency, I expect) and maybe also how close a construction is to 0% or 100% omission?

NEXT STEPS:
5. If we are happy with the results of 4, run the Query2 manually at Retriever, download and process the results.
Tested that, see: https://github.com/spraakbanken/Cassandra/tree/main/wellanders/retriever. Years with total <20 are excluded.

EVIE: Looks exciting!

6. Perhaps: do the same for tidningar.kb.se. Prerequisite: write a script for parsing their html output (should not be difficult).
Problem: data available only up to 1926. 
Solution: use the bookable computer at our university library which gives full access. It is possible to email the results from there, so should be OK.
Problem: some queries will be adjusted wrt historical variants (taga, hava, bliva, giva osv). Plural forms?
Problem: OCR on historical newspapers might be quite bad. Some kind of evaluation desirable.

EVIE: This sounds like a good idea after finalizing the retriever results.

7. Mediesök: leave for now.
