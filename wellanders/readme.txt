Built a pipeline for steps 1-4 and ran it for the 29 verbs from the NJL manuscript.

1. Search in (almost) all modern newspaper corpora at Språkbanken for all active infinitives that occur after:
Query1a: VERB1.PRS att (INF.AKT)
Query1b: VERB1.PRS (INF.AKT)

Corpus composition: GP2001,GP2002,GP2003,GP2004,GP2005,GP2006,GP2007,GP2008,GP2009,GP2010,GP2011,GP2012,GP2013,SVT-2004,SVT-2005,SVT-2006,SVT-2007,SVT-2008,SVT-2009,SVT-2010,SVT-2011,SVT-2012,SVT-2013,SVT-2014,SVT-2015,SVT-2016,SVT-2017,SVT-2018,SVT-2019,SVT-2020,SVT-2021,SVT-2022,SVT-2023,da,PRESS76,PRESS95,PRESS96,PRESS97,PRESS98,WEBBNYHETER2001,WEBBNYHETER2002,WEBBNYHETER2003,WEBBNYHETER2004,WEBBNYHETER2005,WEBBNYHETER2006,WEBBNYHETER2007,WEBBNYHETER2008,WEBBNYHETER2009,WEBBNYHETER2010,WEBBNYHETER2011,WEBBNYHETER2012,WEBBNYHETER2013
Change? Don't really think it matters.

2. 
From each search, extract n most frequent infinitives that cover a larger proportion of the total number of hits found by Query1a than a given threshold.
Same for Query1b.
Threshold = 0.5
Change?

Note that n is different for Query1a and Query1b, we ignore that in the future. We compare the lump sums, not per infinitive (if we want to do that instead, we have to change the procedure so that the infinitive list is the same for "att" and "omission", or maybe even across different VERB1s).

3. For every VERB1, generate two "naive" queries that can be used in Retriever and potentially tidningar.kb.se (and Mediesök) using the infinitives found in 2. 
Query2a: "VERB1.PRS att INF1" OR "VERB1.PRS att INF2" ... OR "VERB1.PRS att INF25"
Query2b: "VERB1.PRS INF1" OR "VERB1.PRS INF2" ... OR "VERB1.PRS INF25"

NB: we lump together all possible combinations of VERB1 + INF into a single query conjoining them by OR. This means we have to run two manual queries per verb and not 20-50. 
Unfortunately, in Retriever the numbers of hits for the query A OR B is a bit different than the sum of hits for A and for B separately (I guess it counts not the occurrences, but sentences where the search item appears or smth like that). The deviation, however, seems to be small. No such problem in tidningar.kb.se.

4. Test whether Query2 ("half query") is as good as Query1 ("full query").
Choose a test corpus (SVT).
Run a diachronic query in the usual Cassandra style (counting/plotting the proportion of the innovative variant): 1a vs 1b, 2a vs 2b. The qualitative picture should be the same. See https://github.com/spraakbanken/Cassandra/tree/main/wellanders/comparisons
Plot the two trajectories (see pdfs)
For every verb, calculate the difference between the values for the same year (see separate tsvs per verb)
As a single measure per verb, use the sum of square differences (see allverbs.tsv). This measure is difficult to interpret, we need some comparison ground.

NEXT STEPS:
5. If we are happy with the results of 4, run the Query2 manually at Retriever, download and process the results.

6. Perhaps: do the same for tidningar.kb.se. Prerequisite: write a script for parsing their html output (should not be difficult).
Problem: data available only up to 1926. 
Solution: use the bookable computer at our university library which gives full access. It is possible to email the results from there, so should be OK.
Problem: some queries will be adjusted wrt historical variants (taga, hava, bliva, giva osv). Plural forms?

7. Mediesök: leave for now.
