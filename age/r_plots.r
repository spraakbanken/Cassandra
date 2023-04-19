setwd("C:\\Sasha\\D\\DGU\\Repos\\Cassandra")
df <- read.csv("familjeliv-kansliga_sentence_10000_firstage18_subj_de_vs_dem_vs_dom_t10.tsv",header=TRUE,sep="\t")

my_types = c("Gen1" = 3,"Gen2" = 1, "Gen3" = 1, "Gen4" = 3)
my_cols = c("Gen1" = "black","Gen2" = "gray", "Gen3" = "black", "Gen4" = "gray")


gens = c("Gen1", "Gen2", "Gen3", "Gen4")
threshold = 20
x = sort(unique(df$post_year))

for (gen in gens) {
    y = c()
    for (year in x) {
        #if (length(df[(df$agebin=="Gen1" | df$agebin=="Gen2") & df$post_year==year,]$username) >= threshold) {
        if (length(df[df$agebin==gen & df$post_year==year,]$username) >= threshold) {
            #y = append(y,mean(df[(df$agebin=="Gen1" | df$agebin=="Gen2") & df$post_year==year,]$v3rel))
            y = append(y,mean(df[df$agebin==gen & df$post_year==year,]$v2rel))
        }
        else {
            y = append(y,NaN)
        }
    }
    if (gen=="Gen1"){
        plot(x,y, type="b",ylim=c(0,0.15), lwd = 3, lty = my_types[gen], col = my_cols[gen], xlab = "År", ylab = "Andel innovationer")
        legend("top", c("Gen1", "Gen2", "Gen3", "Gen4"), lty = c(3,1,1,3),col = c("black","gray"))
    }
    else {
        points(x,y, type="b", lwd = 3, lty = my_types[gen], col = my_cols[gen],)
    }
}






#stripchart(v3rel ~ post_year, data = gen3, xlab = "year", ylab = "Andel 'dom'",main = "Generation 3", vertical=TRUE)
#boxplot(v3rel ~ post_year, data = gen1, xlab = "year", ylab = "Andel 'dom'",main = "Generation 1", varwidth = TRUE

#gen1 = df[df$agebin=="Gen1",]
#df <- read.csv(> df <- read.csv("familjeliv-kansliga_sentence_10000_firstage20_de_vs_dem_vs_dom.tsv","r:utf-8")
