filterGramA <- function(direc=NULL, cond=c("G"),select=c(),dbug=TRUE) {
# Do not run with mixed data blocks (i.e. those with a mix of G, NG, and/or Ran).  Errors and death will follow.
# 
# IN:
# (1) direc: A folder containing the Eprime Edata files, exported to TSV -
# if left as NULL the PWD is used.
# (2) cond: some coombination of "G","NG" and "Ran"
# (3) select: names columns of interest in the edata file
#
# OUT:
# (1) a single dataframe containing the filtered data.  
# The form:
# out$<filename>$<G/NG/RAN>$<select>

# LIBS:
# needed for invalid()
library(gtools)

# intialize (the control filter )
mask=NULL
out=NULL

# Analysis of invocation args
if (invalid(direc)) {
	direc = getwd()
}
if (invalid(select)) {
	cat("No cols were selected to be filtered.")
	stop
}

# Files to be processed are
files = dir(direc)
#D 
if(dbug) {
	cat("Files to be filtered (by cond=c() then select=c()):", files, "\n")
}
#ED

# settin up for the specified condition.
G=FALSE
NG=FALSE
Ran=FALSE

for (ii in 1:length(cond)) {
	if (cond[ii] == "G" || cond[ii] == "g") {
		G=TRUE
		if(dbug) {
			cat("G found!")
		}
	} else if (cond[ii] == "NG" || cond[ii] == "ng") {
		NG=TRUE	
		if(dbug) {
			cat("NG found!")
		}
	} else if (cond[ii] == "Ran" || cond[ii] == "ran") {
		Ran=TRUE
		if(dbug) {
			cat("Ran found!")
		}
	# if none of the above are true after the first iteration
	# then something is wrong with cond=c(); end script ...
	} else if (!(G || NG || Ran)) {
	cat("Error: <cond> was not specified or was of the wrong type.")
	stop;
	}
}
# For each file
for (ii in 1:length(files)) {
	
	currentFile = files[ii]
	currDat <- read.table(files[ii],sep="\t",skip=1,header=T)

	if(dbug) {
		cat("currentFile:", currentFile, "\n")
	}

	if (G) {
		# create mask for that cond
		mask = currDat[,"cond"] == "s" | currDat[,"cond"] == 1
		if(dbug) {
			cat("G mask:", mask, "\n")
		}
		# then filter using mask and foreach(select)
		for (kk in 1:length(select)) {
			out[[files[ii]]]$G[[select[kk]]] = currDat[mask,select[kk]]
		}
	}
	if (NG) {
		mask = currDat[,"cond"] == "d" 
		if(dbug) {
			cat("NG mask:", mask, "\n")
		}
		for (kk in 1:length(select)) {
			out[[files[ii]]]$NG[[select[kk]]] = currDat[mask,select[kk]]
		}
	}
	if (Ran) {
		mask = currDat[,"cond"] == "f" 
		if(dbug) {
			cat("Ran mask:", mask, "\n")
		}
		for (kk in 1:length(select)) {
			out[[files[ii]]]$Ran[[select[kk]]] = currDat[mask,select[kk]]
		}	
	}
#END for(ii)
}
if(dbug) {
	cat("out:", str(out,max.level=2),"\n")
}

# now concat that data for subjects, adding another set of subframes
if (G) {
	for (ii in 1:length(select)){
		for (kk in 1:length(files)) {
			out$G[[select[ii]]] = c(out$G[[select[ii]]],out[[files[kk]]]$G[[select[ii]]])
		}
	}
}
if (NG) {
	for (ii in 1:length(select)){
		for (kk in 1:length(files)) {
			out$NG[[select[ii]]] = c(out$NG[[select[ii]]],out[[files[kk]]]$NG[[select[ii]]])
		}
	}

}
if (Ran) {
	for (ii in 1:length(select)){
		for (kk in 1:length(files)) {
			out$Ran[[select[ii]]] = c(out$Ran[[select[ii]]],out[[files[kk]]]$Ran[[select[ii]]])
		}
	}
}

out
#EOF	
}




