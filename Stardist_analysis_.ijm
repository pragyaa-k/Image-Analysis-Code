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
		
		setOption("BlackBackground", true);
		run("Convert to Mask");
	
		// analyse particles - only shows results table  
		run("Analyze Particles...", "display add composite slice");
		
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