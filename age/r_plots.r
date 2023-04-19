
df <- read.csv("familjeliv-kansliga_sentence_10000_firstage18_de_vs_dem_vs_dom.tsv",header=TRUE,sep="\t")

#my_colors = c("Gen2" = 	"blue","Gen3" = )

gen = "Gen5"
threshold = 20
x = sort(unique(df$post_year))
y = c()
for (year in x) {
    #if (length(df[(df$agebin=="Gen1" | df$agebin=="Gen2") & df$post_year==year,]$username) >= threshold) {
    if (length(df[df$agebin==gen & df$post_year==year,]$username) >= threshold) {
        #y = append(y,mean(df[(df$agebin=="Gen1" | df$agebin=="Gen2") & df$post_year==year,]$v3rel))
        y = append(y,mean(df[df$agebin==gen & df$post_year==year,]$v3rel))
    }
else {
    y = append(y,NaN)
}
}
points(x,y, type="b",ylim=c(0,1),col="orange")
#plot(x,y, type="b",ylim=c(0,1))





stripchart(v3rel ~ post_year, data = gen3, xlab = "year", ylab = "Andel 'dom'",main = "Generation 3", vertical=TRUE)
boxplot(v3rel ~ post_year, data = gen1, xlab = "year", ylab = "Andel 'dom'",main = "Generation 1", varwidth = TRUE

gen1 = df[df$agebin=="Gen1",]
df <- read.csv(> df <- read.csv("familjeliv-kansliga_sentence_10000_firstage20_de_vs_dem_vs_dom.tsv","r:utf-8")
