
// allows the user to choose the files to edit 
directory = getDirectory("Choose a Directory"); 

// creates a new directory for the user to save the results of the analysis 
// requires user input for the name of the directory 
Dialog.create("New Directory Names");
Dialog.addString("Enter name for a new directory for results table", "Intensity_Series_Results_Tables");
Dialog.addString("Enter name for a new directory for processed images", "Intensity_Series_Processed_Images");
Dialog.show();

newDirName1 = Dialog.getString();
newDirName2 = Dialog.getString();

newDir1 = directory + File.separator + newDirName1;
File.makeDirectory(newDir1);

newDir2 = directory + File.separator + newDirName2;
File.makeDirectory(newDir2);

// this stores the files in the selected directory in a new variable 
filelist = getFileList(directory);

// allows the editing and anylsis to be done in the background 
// setBatchMode(true);


// loop to go through the files and perform the editing and analysis 
for (i = 0; i < lengthOf(filelist); i++) {
	showProgress(i + 1, lengthOf(filelist) );
	if (endsWith(filelist[i], ".tif")) {
		// open the file - without "/"
		open(directory + File.separator + filelist[i]);

		//run("Brightness/Contrast...");
		run("Enhance Contrast", "saturated=0.35");
		
		// gaussian blur 
		run("Gaussian Blur...", "sigma=2 stack");
		
		// Get dimensions of the Z-projected image
		getDimensions(width, height, channels, slices, frames);

// Loop through each channel
			for (c = 1; c <= channels; c++) {
    // Set the active channel on the original Z-projected image 
    			Stack.setChannel(c); // Ensure the active channel is set
    	
    // Duplicate the current channel
    			run("Duplicate...", "title=Duplicate_Channel_" + c);

    // Switch to the duplicated channel
    			selectWindow("Duplicate_Channel_" + c);

    			// Apply thresholding or other processing to the duplicated channel
   				setAutoThreshold("Otsu dark no-reset");
    			setOption("BlackBackground", true);
				run("Convert to Mask", "method=Otsu background=Dark calculate black");
				
				// erode 
				run("Erode", "stack");
				
				//dilate
				run("Dilate", "stack");
		
				// analyse particles - only shows results table  
				run("Analyze Particles...", "display add composite slice");
		 
				// save the edited image in the new folder with the same name but in .tif format
				saveAs("Tiff", newDir2 + File.separator + replace(filelist[i], ".tif", "_Processed.tif"));

		
				// save the results in the directory created above - with an appropriate name 
				saveAs("Results", newDir1 + File.separator + replace(filelist[i], ".tif", "_Results.csv"));
		
				// only closes the results window - saves results for each image separtely 
				close ("Results");
		
				// close the file 
				close();
	}
}
// message that pops up when task is complete 
showMessage("Image Analysis Complete");
