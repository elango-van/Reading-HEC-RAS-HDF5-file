

loadPackages <- function(x)
{
    if (!require(x,character.only = TRUE,quietly=TRUE))
    {
      install.packages(x,dep=TRUE,repos='https://cran.rstudio.com/')
	if(!require(x,character.only = TRUE)) {
		stop(paste0(x, " Package not found"))
	}
    }
}


loadPackages("hdf5r");
loadPackages("jsonlite");
loadPackages("rapportools")

hdfplanfile <- 'D:/Tapovan2D.p02.hdf'
outputfolder <- 'D:/Outputfolder/'

hdfdata <- h5file(hdfplanfile, 'r')

lstdata <- c("Results/Unsteady/Output/Output Blocks/DSS Hydrograph Output/Unsteady Time Series/2D Flow Areas/Tapovan2D/Boundary Conditions/alak",
	"Results/Unsteady/Output/Output Blocks/DSS Hydrograph Output/Unsteady Time Series/2D Flow Areas/Tapovan2D/Boundary Conditions/kosa",
	"Results/Unsteady/Output/Output Blocks/DSS Hydrograph Output/Unsteady Time Series/2D Flow Areas/Tapovan2D/Boundary Conditions/raini",
	"Results/Unsteady/Output/Output Blocks/DSS Hydrograph Output/Unsteady Time Series/2D Flow Areas/Tapovan2D/Boundary Conditions/pp")

# Reading unsteady Time Series
timedset <- hdfdata[["Results/Unsteady/Output/Output Blocks/DSS Hydrograph Output/Unsteady Time Series/Time Date Stamp"]]
timevals <- readDataSet(timedset)

# Convert to time format
timelist <- strptime(timevals,format='%d%b%Y %H:%M:%S')
ftime <- strptime(rundatetime,format='%d%b%Y %H:%M:%S')

for(r in 1:nrow(lstdata)){

	hdfdset <- hdfdata[[lstdata[r]]]
	hdfvals <- readDataSet(hdfdset)
	
	# Converting into data frame
	hdfresult <- data.frame(datetime=timevals,"Discharge"=hdfvals[2,]) ## "Level"=hdfvals[1,],
	# Convert to json format		
	hdfjsonoutput <- toJSON(hdfresult) ##hdfresult[1,]

	hdfoutfile = paste0(outputfolder, "Discharge_",lstdata[r,1],"_",refid,".json")
	write(hdfjsonoutput, hdfoutfile)

}


hdfdata$close_all()
h5flush(hdfdata)

detach("package:hdf5r", unload=TRUE)
detach("package:jsonlite", unload=TRUE)
detach("package:rapportools", unload=TRUE)

gc()	



