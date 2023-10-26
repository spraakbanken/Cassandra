# encoding: UTF-8

#input
#total_threshold
#condition on threshold

require 'rinruby'
require_relative 'read_cmd.rb'
require_relative 'date_tools.rb'
require_relative 'math_tools.rb'


gran_hash = {"m" => "-----m"}

qtype = "time"
query = "time"

def extract_data(corpus_and_label,inputdir,variable,username,gran_addendum,whattoplot,nvariants,total_threshold,window)
    maincorpus = corpus_and_label.split("-")[0]
    subcorpus = corpus_and_label.split("-")[1]
    file = File.open("#{inputdir}\\#{variable}#{gran_addendum}\\#{maincorpus}\\#{subcorpus}\\#{username}.tsv","r:utf-8")
    #verb = variable.split("_")[1]
    #file = File.open("results\\ss30dia\\#{verb}_t10.tsv","r:utf-8")
    #file = File.open("C:\\Sasha\\D\\DGU\\CassandraMy\\hbt_authors\\Varnagel.tsv","r:utf-8")
    header = []
    years = []
    labels = []
    values = []
    values_copy = []
    values_copy2 = []
    whattoplot_id = nil
    period_id = nil
    #absmonth_id = nil
    array_ndatapoints = []
    file.each_line.with_index do |line,index|
        if index > 0
            line1 = line.split("\t")
            if gran_addendum.nil?
                years << line1[period_id].to_i
            elsif gran_addendum == "-----m"
                labels << line1[period_id]
                years << absmonth(line1[period_id])
            end
            ndatapoints = line1[1].to_i
            array_ndatapoints << ndatapoints
            
            if nvariants == 1 or (nvariants == 2 and ndatapoints >= total_threshold)
            
                values << line1[whattoplot_id].to_f
                values_copy2 << line1[whattoplot_id].to_f
            else
                values << "NA"
            end
            values_copy << line1[whattoplot_id].to_f
            
        else
            header = line.strip.split("\t")
            whattoplot_id = header.index(whattoplot)
            period_id = header.index("period")
            #absmonth_id = header.index("absmonth")
        end
    end
    file.close
    if window > 1
        values = smooth(values_copy,window,array_ndatapoints,total_threshold)
    end

    return [years,values,labels,maincorpus,subcorpus,values_copy2]
end

outhash = process_cmd
corpus_and_label = outhash["corpus_and_label"]
more_corpora_and_labels = outhash["more_corpora_and_labels"].to_s.split(",")
more_variables = outhash["more_variables"].to_s.split(",")
whattoplot = outhash["whattoplot"] 
max_predef = outhash["max"]
var_output = outhash["var_output"]
if var_output.to_s == ""
    dir = outhash["dir"]
else
    dir = "#{var_output}\\#{outhash["dir"]}"
end
nyl_year = outhash["nyl_year"]
#variable = outhash["variable"]
username = outhash["username"]
nvariants = outhash["nvariants"] 
only_process_local = outhash["only_process_local"]
granularity = outhash["granularity"]
total_threshold = outhash["total_threshold"]
format = outhash["format"]
showplot = outhash["showplot"]
window = outhash["window"]
defaultyaxis = outhash["defaultyaxis"]

#dir = "#{var_output}#{dir}"

if !Dir.exist?(dir)
    Dir.mkdir(dir)
end
R.eval "setwd('#{dir}')"

R.eval "#{format}(file='ss12_#{corpus_and_label}_all-users_#{whattoplot}_#{granularity}_#{window}_dyaxis#{defaultyaxis}.#{format}')"
plotfilename = "#{dir}\\ss12_#{corpus_and_label}_all-users_#{whattoplot}_#{granularity}_#{window}_dyaxis#{defaultyaxis}.#{format}"

R.eval "par(mfrow=c(4,3))"


if ARGV.include?("nyordslistor")
    inputdir = "#{var_output}variables\\nyordslistor2"
else
    inputdir = "#{var_output}variables"
end

variables = ["ss90_behaga", "ss90_fortsätta", "ss90_försöka", "ss90_glömma", "ss90_komma", "ss90_lova", "ss90_planera", "ss90_riskera","ss90_slippa", "ss90_sluta", "ss90_vägra"]

gran_addendum = gran_hash[granularity]

variables.each do |variable|

    verb = variable.split("_")[1].encode("windows-1252")
    STDERR.puts verb
    more_years = []
    more_values = []
    var_more_values = []
    #more_labels = []
    colors = ["black","blue","green","red","gray","magenta","brown","orange"]
    ltys = [1,5,3,4,2]
    
    plot_data = extract_data(corpus_and_label,inputdir,variable,username,gran_addendum,whattoplot,nvariants,total_threshold,window)
    years = plot_data[0]
    values = plot_data[1]
    labels = plot_data[2]
    maincorpus = plot_data[3]
    subcorpus = plot_data[4]
    values_no_nas = plot_data[5]

    if values_no_nas.empty?
        maxvalue2 = 1
        minvalue2 = 0
    else
        maxvalue2 = values_no_nas.max.round(2)+0.01
        if maxvalue2 > 1
            maxvalue2 = 1
        end
        
        minvalue2 = values_no_nas.min.round(2)-0.01
        if minvalue2 < 0
            minvalue2 = 0
        end
    end
    R.assign "maxvalue2",maxvalue2
    R.assign "minvalue2",minvalue2
    if defaultyaxis == "no"
        yinfo = "ylim = c(0,maxvalue), "
    elsif defaultyaxis == "yes"
        yinfo = "ylim = c(minvalue2,maxvalue2), "
    end


    
    if !years.empty?
        
        
        R.assign "years", years
        R.assign "values", values
        R.assign "labels",labels
        all_names = ["#{maincorpus}_#{subcorpus}"]
        all_values = [values]
        all_years = [years]
        var_all_names = [variable]
        
        
    
        if !more_corpora_and_labels.empty?
            #all_values = [values]
            
            
            more_corpora_and_labels.each.with_index do |extra_corpus_and_label,index|
                plot_data = extract_data(extra_corpus_and_label,inputdir,variable,username,gran_addendum,whattoplot,nvariants,total_threshold,window)
                more_years[index] = plot_data[0]
                more_values[index] = plot_data[1]
                #more_labels[index] = plot_data[2]
                all_values << plot_data[1]
                all_years << plot_data[0]
                all_names << "#{plot_data[3]}_#{plot_data[4]}"
            end
            
        end
    
        if !more_variables.empty?
            more_variables.each.with_index do |extra_variable,index|
                plot_data = extract_data(corpus_and_label,inputdir,extra_variable,username,gran_addendum,whattoplot,nvariants,total_threshold,window)
                var_more_values[index] = plot_data[1]
                all_values << plot_data[1]
                var_all_names << extra_variable.gsub(":","_colon_")
            end
        end
        all_values.flatten!
        all_years.flatten!
        all_years.uniq!
        
        minyear = all_years.min
        maxyear = all_years.max
        #STDERR.puts minyear
        #STDERR.puts maxyear
        R.assign "minyear",minyear
        R.assign "maxyear",maxyear
     
        namelist = all_names.join("_")
        var_namelist = var_all_names.join("_")
        
        if max_predef != nil
            max = max_predef
        #elsif (nvariants == 1 or whattoplot == "total") and more_corpora_and_labels.empty? and more_variables.
        #    max = values.max
        elsif (nvariants == 1 or whattoplot == "total") #and !more_corpora_and_labels.empty?
            max = all_values.max
        elsif nvariants == 2
            max = 1
        end
        #STDERR.puts max
        R.assign "maxvalue", max
        

    
        #R.eval "#{format}(file='#{var_namelist}_#{namelist}_#{username.gsub(":","_colon_")}_#{whattoplot}_#{granularity}_#{window}.#{format}')"
        #plotfilename = "#{dir}\\#{var_namelist}_#{namelist}_#{username.gsub(":","_colon_")}_#{whattoplot}_#{granularity}_#{window}.#{format}"
    
        if nvariants == 1
            ylab = "ipm"
        else
            ylab = "proportion incoming"
        end
        if granularity == "y"
            #R.eval "plot(0,0,xlab = 'HEY', ylab = '#{ylab}', xlim = c(minyear,maxyear), ylim = c(0,maxvalue),frame.plot=FALSE)"
            #R.eval "plot(values~years, type='b',xlab = 'time', ylab = '#{ylab}', xlim = c(minyear,maxyear), #{yinfo}lwd =2, main = #{verb})"
            R.eval "plot(values~years, type='b', xlab = '', ylab = '', xlim = c(minyear,maxyear), #{yinfo}main = \"#{verb}\", yaxt='n')"
            
            if defaultyaxis == "no"
                R.eval "axis(2, at=c(0,maxvalue),labels = c(0,maxvalue))"
            elsif
                R.eval "axis(2, at=c(minvalue2,maxvalue2),labels = c(minvalue2,maxvalue2))"
            else

            end
        elsif granularity == "m" #does not work for plot_par
            R.eval "plot(years, values, type='l',xaxt='n', ylab = '#{ylab}', xlim = c(minyear,maxyear), #{yinfo}lwd =2)"
            
            R.eval "axis(1, at=years,labels = labels)"
        end
        
        if !more_corpora_and_labels.empty?
            for i in 0..more_corpora_and_labels.length-1
                R.assign "years2", more_years[i]
                R.assign "values2", more_values[i]
                color = colors[i+1]
                if granularity == "y"
                    type = "b"
                elsif granularity == "m"
                    type = "l" 
                end
    
                R.eval "lines(years2, values2, type='#{type}', col = '#{color}', lwd = 2)"
            end
            R.assign "namelist",all_names
            R.assign "colors",colors
            R.eval "legend('topleft', legend=namelist,col=colors,lty=1,bty='n')"
        end
        
        if !more_variables.empty?
            for i in 0..more_variables.length-1
                R.assign "values2", var_more_values[i]
                lty = ltys[i+1]
                if granularity == "y"
                    type = "b"
                elsif granularity == "m"
                    type = "l" 
                end
    
                R.eval "lines(years, values2, type='#{type}', lty = #{lty}, lwd = 2)"
            end
            R.assign "namelist",var_all_names
            R.assign "ltys",ltys
            R.eval "legend('topleft', legend=namelist,lty=ltys,bty='n')"
        end
    
        if !nyl_year.nil?
            R.eval "abline(v=#{nyl_year}, col = 'red', lwd = 2)"
        end
    	
    	
        
        #R.eval "dev.off()"
        #STDERR.puts plotfilename
        
    end

end
R.eval "dev.off()"

if showplot != "no"
    system "start #{plotfilename}"
end
