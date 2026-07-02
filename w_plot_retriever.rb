load 'wellander_vars.rb'
require 'rubyxl'
require_relative 'math_tools.rb'
require 'rinruby'

coverage = ARGV[0]

$verblist.each do |verb|
    STDERR.puts verb
    #verb = "komma" #
    #workbook = RubyXL::Parser.parse("wellanders\\retriever\\#{verb}_#{coverage}_special.xlsx") #
    workbook = RubyXL::Parser.parse("wellanders\\retriever\\#{verb}_#{coverage}.xlsx")
    o = File.open("wellanders\\retriever\\#{verb}_#{coverage}.tsv","w:utf-8")
    o.puts "year\ttotal\tv1abs\tv2abs\tv1rel\tv2rel"
    worksheet = workbook[0]
    nrows = worksheet.sheet_data.rows.size
    years = []
    values = []
    #values2 = [] #
    
    #Retriever output has different order of att and omission. Check which is which
    if worksheet[0][1].value.include?(" att ") and !worksheet[0][2].value.include?(" att ")
        attindex = 1
        noattindex = 2
    elsif worksheet[0][2].value.include?(" att ") and !worksheet[0][1].value.include?(" att ")
        attindex = 2
        noattindex = 1
    else
        STDERR.puts "ERROR! Check retriever xlsx!"
    end
    
    for i in 1..nrows-1 do
        year = worksheet[i][0].value.to_i
        att = worksheet[i][attindex].value.to_f
        noatt = worksheet[i][noattindex].value.to_f
        total = att + noatt
        v2rel = div_by_zero(noatt,att+noatt) 
        #att2 = worksheet[i][3].value.to_f #
        #noatt2 = worksheet[i][4].value.to_f #
        if total > 20
            years << year
            values << v2rel
            #values2 << div_by_zero(noatt2,att2+noatt2) #
            o.puts "#{year}\t#{total}\t#{att}\t#{noatt}\t#{ div_by_zero(att,att+noatt)}\t#{v2rel}"
        end
    end
    
    R.assign "years", years
    R.assign "values", values
    #R.assign "values2", values2 #
    minyear = years.min
    maxyear = years.max
    R.assign "minyear",minyear
    R.assign "maxyear",maxyear
    R.eval "pdf(file='wellanders/retriever/#{verb}_#{coverage}.pdf')"
    R.eval "plot(values~years, type='l',xlab = 'time', ylab = 'proportion omission', xlim = c(minyear,maxyear), ylim = c(0,1))"
    #R.eval "lines(values2~years, type='l',col='blue',lty=2)"  #
    o.close
end