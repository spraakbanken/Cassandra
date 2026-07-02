load 'wellander_vars.rb'
require 'rubyxl'
require_relative 'math_tools.rb'
require 'rinruby'

coverage = ARGV[0]

$verblist.each do |verb|

    workbook = RubyXL::Parser.parse("wellanders\\retriever\\#{verb}_#{coverage}.xlsx")
    o = File.open("wellanders\\retriever\\#{verb}_#{coverage}.tsv","w:utf-8")
    o.puts "year\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
    worksheet = workbook[0]
    nrows = worksheet.sheet_data.rows.size
    years = []
    values = []
    for i in 1..nrows-1 do
        year = worksheet[i][0].value.to_i
        att = worksheet[i][1].value.to_f
        noatt = worksheet[i][2].value.to_f
        total = att + noatt
        v2rel = div_by_zero(noatt,att+noatt) 
        if total > 20
            years << year
            values << v2rel
            o.puts "#{year}\t#{total}\t#{att}\t#{noatt}\t#{ div_by_zero(att,att+noatt)}\t#{v2rel}"
        end
    end
    
    R.assign "years", years
    R.assign "values", values    
    minyear = years.min
    maxyear = years.max
    R.assign "minyear",minyear
    R.assign "maxyear",maxyear
    R.eval "pdf(file='wellanders/retriever/#{verb}_#{coverage}.pdf')"
    R.eval "plot(values~years, type='l',xlab = 'time', ylab = 'proportion omission', xlim = c(minyear,maxyear), ylim = c(0,1))"
    o.close
end