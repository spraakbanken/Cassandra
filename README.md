# Cassandra
This is a very preliminary release of some scripts we are using within the Cassandra project to study language change in contemporary Swedish.

## Requirements: 
- Ruby (recommended version:  2.6.3p62. Any other version should in principle also be fine, but if you use 3.0+, you may have to tweak some of the scripts, since some methods have become deprecated)
- The necessary gems (=libraries, packages) should be included in the default Ruby installation, but if not, use "gem install gem_name". For plotting, you would have to install the `rinruby` gem
- For plotting, you would need to have R installed (tested on 4.0.2)

## Usage
### General
`korp16.rb` will output a json and a tsv that contain the relative frequencies of the given variant(s) across the years. It will do so by running `count_time` in the Korp API: https://ws.spraakbanken.gu.se/docs/korp. So basically it's a wrapper for running this command and processing its output in a convenient way

`plot.rb` draws a nice graph, using the tsv file

### Variable
`korp16.rb` needs to know what to look for. You have to descripe your variable using the CQP language (https://cwb.sourceforge.io/files/CQP_Tutorial.pdf) in the file `korp_queries.rb`. The description consists of two or three lines.

Line 1: a unique label of your choice. "#label = your_label"

Line 2: variant1 = your_variant1_in_CQP (see examples in the file)

Line 3 (optional): variant2 = your_variant2_in_CQP (see examples in the file)

Use only variant1 if you want to know how its frequency (both absolute and normalized by corpus size, measured in instances per million, ipm) change over time). Use variant1 and variant2 if you want to know how they compete against each other. In this case, you will see frequencies of both variants, both absolute and relative (normalized by the sum of the frequencies of both variant1 and variant2; measured as proportion of 0 to 1). It is recommended to have the innovative variant as variant2. `plot.rb` will plot the relative frequency of variant2. 

When launching `korp16.rb`, provide the label of your variable in the command line: `korp16.rb --variable your_label --corpus your_corpus`
If you are using only one variant, add `--nvariants 1`. The default is `--nvariants 2`, it's not necessary to specify it.

### Corpus
`korp16.rb` needs to know where to look for your variable. You may name a specific corpus at Språkbanken Text (the list of all corpora is available here: https://ws.spraakbanken.gu.se/ws/korp/v8/info?indent=4). In this case, add `--nolabel` to the command line.

Example: `korp16.rb --variable your_label --corpus familjeliv-pappagrupp --nolabel`

It is, however, usually convenient to search in several corpora at once. You may, for instance, want to look in the whole Familjeliv. In this case, use:

Example: `korp16.rb --variable your_label --corpus familjeliv-all`

Since there is no `--nolabel` flag, the script will look up your corpus label in `subforum_labels.tsv` (first column) and search in all subcorpora specified in the second column. The third column says how the forum names should be generated. 

Feel free to add your own labels to `subforum_labels.tsv`. 

### Other

There is some additional functionality (which may not always work properly), for instance:
`--granularity`: (m)onth or (y)ear (default)
`--user`: whether the script should look only in texts authored by the user with a specific `username`. Might now work correctly for some corpora.

The script is using `corpus_tools.rb` as an auxiliary script.
Output will be stored in the folder `variables` (`\\variable_name\\corpus_name\\subcorpus_name\\username.{json,tsv}.` By default, `username = all_users`.

## Contact
aleksandrs.berdicevskis@gu.se


