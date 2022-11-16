# Cassandra
This is a very preliminary release of some scripts we are using within the Cassandra project to study language change in contemporary Swedish.

## Requirements: 
- Ruby (recommended version:  2.6.3p62. Any other version should in principle also be fine, but if you use 3.0+, you may have to tweak some of the scripts, since some methods have become deprecated)
- The necessary gems (=libraries, packages) should be included in the default Ruby installation, but if not, use "gem install gem_name". For plotting, you would have to install the `rinruby` gem
- For plotting, you would need to have R installed (tested on 4.0.2)

## Usage
### General
- `korp16.rb` will output a json and a tsv that contain the relative frequencies of the given variant(s) across the years. It will do so by running `count_time` in the Korp API: https://ws.spraakbanken.gu.se/docs/korp. So basically it's a wrapper for running this command and processing its output in a convenient way
- `plot.rb` draws a nice graph, using the tsv file

### Variable
- `korp16.rb` needs to know what to look for. You have to descripe your variable using the CQP language (https://cwb.sourceforge.io/files/CQP_Tutorial.pdf) in the file `korp_queries.rb`. The description consists of two or three lines.

Line 1: a unique label of your choice. "#label = your_label"

Line 2: variant1 = your_variant1_in_CQP (see examples in the file)

Line 3 (optional): variant2 = your_variant2_in_CQP (see examples in the file)



### Corpus



## Contact
aleksandrs.berdicevskis@gu.se


