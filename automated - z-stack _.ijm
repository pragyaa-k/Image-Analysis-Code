// allows the user to choose the files to edit 
directory = getDirectory("Choose a Directory"); 

// creates a new directory for the user to save the results of the analysis 
// requires user input for the name of the directory 
Dialog.create("New Directory Name");
Dialog.addString("Enter name for a new directory", "Tif_Images");
Dialog.show();

newDirName = Dialog.getString();
newDir = directory + File.separator + newDirName;
File.makeDirectory(newDir);

// this stores the files in the selected directory in a new variable 
imagelist = getFileList(directory);

for (j = 0; j < imagelist.length; j++) {
	if (endsWith(imagelist[j], ".nd2")) {
		 imagePath = directory + File.separator + imagelist[j];
		 
		 run("Bio-Formats (Windowless)", "open=[" + imagePath + "]");
		 run("Z Project...", "projection=[Max Intensity]");
		 //run("Brightness/Contrast...");
		 run("Enhance Contrast", "saturated=0.35");

		saveAs("Tiff", newDir + File.separator + replace(imagelist[j], ".nd2", ".tif"));

		close();
		run("Close All");

	}
}
// message that pops up when task is complete 
showMessage("Images Ready For Analysis:)");



