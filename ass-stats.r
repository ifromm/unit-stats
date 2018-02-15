#!/usr/bin/env Rscript
#
# The script takes UoB .CSV files containing the grades and marks for a
# specifiv assessment and computes the relevant plots and statics. The
# output are a .pdf file and a .txt file. The .CSV file is passed as
# command line argument and must have the suffic .CSV
#
# Author: Ingo Frommholz <ingo.frommholz@beds.ac.uk>
#

options(echo=FALSE) # if you want see commands in output file

csvFile <- commandArgs(trailingOnly = TRUE)


cat("Processing",csvFile, "\n");
pdfFile=paste(csvFile, "_plots.pdf",sep="")
pdfFile
pdf(pdfFile)
assCSV <- read.csv(file=paste(csvFile,'.CSV',sep=""), header=TRUE, sep=",")
#head(assCSV)
marksall <- assCSV$Mark
marks <- marksall[marksall>0]
marks_pass <- marks[marks>39]
zeromarks <- marksall[marksall==0]
marks.freq = table(marks)
maxmark <- max(marks.freq)
#cbind(marks.freq)

#
# Barplot for each mark
#
bartitle=paste(csvFile, "Distribution of marks > 0")
barplot(marks.freq, main=bartitle, xlab="Marks", ylab="Frequency",col=c("deepskyblue"), border=c("deepskyblue"),ylim=c(0,maxmark+3))
#legendtext <- sprintf("Marks > 0: %s (%s%%) / Zero marks: %s (%s%%)\nTotal: %s / Pass rate: %s%% of attendees (%s%% of total)",  length(marks), round(length(marks)/length(marksall) * 100,2),  length(zeromarks), round(length(zeromarks)/length(marksall) * 100,2), length(marksall),  round(length(marks_pass)/length(marks) * 100,2),round(length(marks_pass)/length(marksall) * 100,2))
legendtext <- sprintf("Marks > 0: %s (%s%%) / Zero marks: %s (%s%%)\nTotal: %s / Pass rate: %s%% of attendees",  length(marks), round(length(marks)/length(marksall) * 100,2),  length(zeromarks), round(length(zeromarks)/length(marksall) * 100,2), length(marksall),  round(length(marks_pass)/length(marks) * 100,2))
cat(legendtext, "\n")                     
legend('topleft', legend=legendtext)

#
# Boxplot
#
boxtitle=paste(csvFile, "Marks > 0 Boxplot")
boxplot(marks, horizontal=TRUE, main=boxtitle, xlab="Mark", outline=TRUE,col=c("deepskyblue"), border=c("blue"))
legendtext <- sprintf("Mean: %s / Median: %s / StdDev: %s" , round(mean(marks),2), median(marks),  round(sd(marks),2))
cat(legendtext, "\n") 
legend('topleft', legend=legendtext)
cat("Attendance (marks > 0):", length(marks), paste("(",round(length(marks)/length(marksall) * 100,2), "%)", sep=""),"\n")
cat("Zero marks:",  length(zeromarks), paste("(",round(length(zeromarks)/length(marksall) * 100,2), "%)", sep=""), "\n")
cat("Total entries:", length(marksall),"\n")

#
# Barplot for the old grade interval 
#
bartitle <-paste(csvFile, "Distribution of marks")
grades <- c("0","1-34","35-39","40-49","50-59","60-69", "70-79","80-100") # the old grades and ranges
binnedMarks <- ordered(findInterval(assCSV$Mark, c(0,1,35,40,50,60,70,80)), levels=c(1,2,3,4,5,6,7,8), grades)
binnedMarks.freq = table(binnedMarks)
maxbinnedmark <- max(binnedMarks.freq)
barplot(binnedMarks.freq, main=bartitle, xlab="Mark ranges", ylab="Frequency",col=c("deepskyblue"), border=c("deepskyblue"),ylim=c(0,maxbinnedmark+1))

# The best and the worst
sData <- assCSV[,c('Name', 'Mark', 'Grade', 'X.Cand.Key')]
excellentmarks <- sData[which(sData$Mark>=70),]
cat("A students\n")
excellentmarks
badmarks <- sData[which(sData$Mark>0 & sData$Mark<40),]
cat("\n\nStudents who failed\n")
badmarks 
dev.off()


