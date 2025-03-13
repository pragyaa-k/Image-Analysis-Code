// allows the user to choose the files to edit 
directory = getDirectory("Choose a Directory"); 

// creates a new directory for the user to save the results of the analysis 
// requires user input for the name of the directory 
Dialog.create("New Directory Names");
Dialog.addString("Enter name for a new directory for results table", "Results_Tables");	
	
Dialog.show();

newDirName1 = Dialog.getString();


newDir1 = directory + File.separator + newDirName1;
File.makeDirectory(newDir1);

// this stores the files in the selected directory in a new variable 
filelist = getFileList(directory);

for (i = 0; i < lengthOf(filelist); i++) {
	showProgress(i + 1, lengthOf(filelist) );
	if (endsWith(filelist[i], ".tif")) {
		// open the file - without "/"
		open(directory + File.separator + filelist[i]);
			
		// Get dimensions of the Z-projected image
        getDimensions(width, height, channels, slices, frames);

        // Loop through each channel
        for (c = 1; c <= channels; c++) {
            Stack.setChannel(c);

            // Duplicate the current channel
            run("Duplicate...", "title=Channel_" + c);
            title = "Channel_" + c;

            // Switch to the duplicated channel
            selectWindow(title);

		
			setOption("BlackBackground", true);
			run("Convert to Mask");
	
			// analyse particles - only shows results table  
			run("Analyze Particles...", "display add composite slice");
		
			// Save the processed duplicate
            processedName = replace(filelist[i], ".tif", "_Channel" + c + "_Processed.tif");
            saveAs("Tiff", newDir1 + File.separator + processedName);

            // Save the results for this channel
            resultsName = replace(filelist[i], ".tif", "_Channel" + c + "_Results.csv");
            saveAs("Results", newDir1 + File.separator + resultsName);

            // Close results and duplicate
            close("Results");
            close(processedName);
       	}

        // Close the original Z-projected file
        close();
    } 
}
            
// message that pops up when task is complete 
showMessage("Image Analysis Complete");