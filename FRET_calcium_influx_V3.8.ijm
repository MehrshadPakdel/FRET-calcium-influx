/*
---------------------------------------------------------------------------------------------------
					FRET Ca2+ influx V3.8

REQUIRES PLUGIN 'Ratio_Plus.java' available on https://imagej.nih.gov/ij/plugins/ratio-plus.html

	* This macro facilitates FRET-based Ca2+ influx analysis of Golgi objects used in Deng et al., 2018
	* Optimized for Go-D1-cpv (Lissandron et al. 2010) based Ca2+ sensor localizing to Golgi compartments
	* User assigns channels FRET and CFP for up to 3 channel hyperstacks
	* Standard image processing and thresholding to extract Golgi objects
	* Improved semi-automated Golgi detection module developed for FRET_Ca2+_influx_V3.7
		+ V3.8 works only for one cell per analysis
		+ Module can now also analyze fragmented objects
 		+ User inputs the Golgi objects by rectangle ROI
 		+ Macro module reads out the coordinates and size of the ROI
 		+ Analyzes all objects within the selection by Find Maxima function
 		+ Adds and merges all objects within one selection to Roi Manager for subsequent analysis
 	* Mean intensity measurement of FRET ratio in the calculated FRET ratio image

Mehrshad Pakdel

mehrshad.pakdel@posteo.de
https://github.com/MehrshadPakdel

December 03, 2019
----------------------------------------------------------------------------------------------------
*/

//This macro can only process one opened image at a time.
//Exits the macro if more than one image is opened. 
//Can process images with min. 2 and max. 3 channels.
//Requires multi-frame hyperstacks.

list = getList("image.titles");										
	if (list.length>=2) {
 		waitForUser("Only one image can be processed at a time. Please close all other images.");
		print("Only one image can be processed at a time. Please close all other images.");
	}
list = getList("image.titles");
	if (list.length>=2) {
 		exit("Error: Please open just one image at a time and rerun the macro.");
 		print("Error: This macro works only with one image at a time.");
	}

getDimensions(width, height, channels, slices, frames);
noCh = channels;
noFrames = frames;

	if (noCh<=1) {
		exit("Error: This macro requires at least two channel hyperstack");
		print("Error: This macro requires at least two channel hyperstacks FRET and CFP");
	}
	if (noCh>=4) {
		exit("Error: This macro cannot process more than three channel hyperstacks");
		print("Error: This macro cannot process more than three channel hyperstacks");
	}

	if (noFrames<=1) {
		exit("Error: This macro requires more than one frame hyperstack");
		print("Error: This macro requires more than one frame hyperstack");
	}

//Defining variables and image directory for analysis.
ScrW = screenWidth;
ScrH = screenHeight;
ScrHLog = ScrW/2.25;
ScrWLog = ScrH/3.5;
ScrHROI = ScrW/3.1;
ScrWROI = ScrH/3.5;
ScrHResults = ScrW/1.55;
ScrWResults = ScrH/3.5;
ScrHWindow = ScrW/17;
ScrWWindow = ScrH/4.2;	
originalImage = getTitle();
selectWindow(originalImage);
	setLocation(ScrHWindow, ScrWWindow);
print("Running: FRET_Ca2+_influx_V3.8.ijm");
if (isOpen("Log")) {
selectWindow("Log");
	setLocation(ScrHLog, ScrWLog);
	script =
    "lw = WindowManager.getFrame('Log');\n"+
    "if (lw!=null) {\n"+
    "   lw.setSize(400, 400)\n"+
    "}\n";
  eval("script", script); 
} 												
dir = getDirectory("image");
fileNameWithoutExtension = File.nameWithoutExtension;
	print("Image name: " + fileNameWithoutExtension);
splitDir = dir + "/Results_" + fileNameWithoutExtension + "/";
File.makeDirectory(splitDir);
selectWindow(originalImage);
saveAs("tiff", splitDir + "Orig_" + fileNameWithoutExtension);

//Setting options required for analysis.

run("Options...", "iterations=1 count=1 black do=Nothing");
setOption("Stack position", true);
run("Set Measurements...", "mean stack redirect=None decimal=3");

//Assign channel module to assign Ch1, Ch2, Ch3 to FRET or CFP channel. 
//Optional third channel will be discarded. 

dialChannel = newArray("FRET", "CFP", "Other"); //dialog array for channel selection

	Dialog.create("Assign channels");
		setSlice(1);
		Dialog.addChoice("Choose channel for Ch1", dialChannel, dialChannel[0]);
	Dialog.show();
		Ch1 = Dialog.getChoice();
	Dialog.create("Assign channels");
		setSlice(2);
		Dialog.addChoice("Choose channel for Ch2", dialChannel, dialChannel[0]);
	Dialog.show();
		Ch2 = Dialog.getChoice();	
	if (noCh>=3) {
		Dialog.create("Assign channels");
			setSlice(3);
			Dialog.addChoice("Choose channel for Ch3", dialChannel, dialChannel[0]);
		Dialog.show();
		Ch3 = Dialog.getChoice();		
	}
	//Exits the macro if channels were assigned twice
	if (Ch1 == Ch2) {
		exit("Error: Cannot assign channels twice");
		}
	if (noCh>=3) {
	if (Ch1 == Ch3) {
		exit("Error: Cannot assign channels twice");
		}
	if (Ch2 == Ch3) {
		exit("Error: Cannot assign channels twice");
		}
	}
print("Channel1 assigned to: " + Ch1);
print("Channel2 assigned to: " + Ch2);
if (noCh>=3) {
	print("Channel3 assigned to: " + Ch3);
	}	
	
	run("Split Channels");	
	selectWindow("C1-" + "Orig_" + fileNameWithoutExtension + ".tif");
	rename("Ch1");
	//run("Duplicate...", "title=[Bin_C1_FRET] duplicate");
	selectWindow("C2-" + "Orig_" + fileNameWithoutExtension + ".tif");	
	rename("Ch2");
	//run("Duplicate...", "title=[Bin_C2_CFP] duplicate");
	if (noCh>=3){									//closing the optional third channel
	selectWindow("C3-" + "Orig_" + fileNameWithoutExtension + ".tif");
	rename("Ch3");
	} 

//if number of channels are 3 rename for Channel1 to specify the Channel

	if (Ch1==dialChannel[0]) {
		selectWindow("Ch1");
		rename("FRET");
		channelFRET = getTitle();	
	} 
	
	if (Ch1==dialChannel[1]) {
		selectWindow("Ch1");
		rename("CFP");
		channelCFP = getTitle();
	} 
	
	if (Ch1==dialChannel[2]) 	{
		selectWindow("Ch1");
		close("Ch1");
		print("Image window Channel1 closed");	
	}

//rename for Channel2 to specify the Channel
	
	if (Ch2==dialChannel[0]) {
		selectWindow("Ch2");
		rename("FRET");
		channelFRET = getTitle();
	} 
	
	if (Ch2==dialChannel[1]) {
		selectWindow("Ch2");
		rename("CFP");
		channelCFP = getTitle();
	}
	if (Ch2==dialChannel[2]) 	{
		selectWindow("Ch2");
		close("Ch2");
		print("Image window Channel2 closed");
	}

//rename for Channel3 to specify the Channel
if (noCh>=3)	{ //includes the possibility for 3 channels
	if (Ch3==dialChannel[0]) {
		selectWindow("Ch3");
		rename("FRET");
		channelFRET = getTitle();	
	}
	if (Ch3==dialChannel[1]) {
		selectWindow("Ch3");
		rename("CFP");
		channelCFP = getTitle();
	}
	if (Ch3==dialChannel[2]) {
		selectWindow("Ch3");
		close("Ch3");
		print("Image window Channel3 closed");			
	}
}
selectWindow(channelFRET);
run("Duplicate...", "title=[Bin_FRET] duplicate");
selectWindow(channelCFP);	
run("Duplicate...", "title=[Bin_CFP] duplicate");

//Assign channel module end

//Background subtraction by rolling ball algorithm
//type changed to 8-bit for binary image generation
//Auto Threshold algorithm Moments used to generate binary image

list = getList("image.titles");
	
 for (i=2; i<list.length; i++) {
  selectWindow(list[i]);
  	run("8-bit");
  	run("Subtract Background...", "rolling=80 stack");
	run("Mean...", "radius=4 stack");
		 for (n=1; n<=nSlices; n++) {
        	setSlice(n);
			run("Auto Threshold", "method=Moments white");		//Note: Change Auto Threshold algorithm here to improve thresholding for your protein of interest. Current: "Moments".
		}
	run("Fill Holes", "stack");
 }
print("Subtracting background");
//Image Calculator to multiply intensities from each channel to its binary threshold image

imageCalculator("Multiply create 32-bit stack", channelFRET, "Bin_FRET");
imageCalculator("Multiply create 32-bit stack", channelCFP, "Bin_CFP");  	

//Generating a Ratio image by dividing FRET/CFP

run("Ratio Plus", "image1=[Result of FRET] image2=[Result of CFP] background1=0 clipping_value1=0 background2=0 clipping_value2=0 multiplication=1");
	print("Generating Ratio FRET image of FRET / CFP channel");

//Generating multiplied binary image of Bin_C1_FRET and Bin_C2_CFP to generate a Bin_ROI_image 
//Selects the inner circle of the Ratio image objects and add them to the ROI Manager

imageCalculator("Multiply create stack", "Bin_FRET","Bin_CFP");
selectWindow("Result of Bin_FRET");
rename("Bin_ROI_image");
selectWindow("Bin_ROI_image");


/* Semi-automated Golgi object detection module. Introduced in V3.5
 * Based on semi-automated Golgi detection module from FRET_Ca2+_influx_V3.4
 * Can now also analyze fragmented objects
 * User inputs the Golgi objects by rectangle ROI
 * Macro module reads out the coordinates and size of the ROI
 * Analyzes the particls by using the analyze particles function
 * Adds Golgi objects to ROI manager for subsequent analysis
 */
 
print("Detecting Golgi objects");
roiManager("reset");
run("ROI Manager...");
	if (isOpen("ROI Manager")) {
		selectWindow("ROI Manager");
		setLocation(ScrHROI, ScrWROI);
			script =
    		"lw = WindowManager.getFrame('ROI Manager');\n"+
    		"if (lw!=null) {\n"+
    		"   lw.setSize(230, 400)\n"+
   			"}\n";
  		eval("script", script); 
	}	
	waitForUser("Select one cell including Golgi\nobjects you want to analyze");
	type = selectionType();
	while (type==-1) {
		waitForUser("Select one cell including Golgi\nobjects you want to analyze");
		type = selectionType();
	}
	Roi.getBounds(x, y, width, height);
    	print("Selection size: " + width + " x " + height);
    	print("Selection position: " + x + ", " + y); 

	//loop to select all ROI objects detected by Find Maxima function
	//Result: Fragmented objects can also be analyzed
	  
		for (n=1; n<=nSlices; n++) {
        	setSlice(n);
			makeRectangle(x, y, width, height);
			run("Find Maxima...", "noise=5 output=List exclude");
			roiManager("Deselect");
			run("Select None");			
        		for (i=0; i<=(nResults-1); i++) { 
					xObjects = getResult("X", i);
					yObjects = getResult("Y", i); 
					setKeyDown("Shift");
					doWand(xObjects, yObjects);
					}
					roiManager("Add");
					run("Select None");
					setKeyDown("none");
			}
							 
//End of Semi-automated Golgi detection module

//measurement of mean intensity of Ratio FRET image by using the detected ROIs
if (isOpen("Results")) {
selectWindow("Results");
	setLocation(ScrHResults, ScrWResults);
	script =
    "lw = WindowManager.getFrame('Results');\n"+
    "if (lw!=null) {\n"+
    "   lw.setSize(400, 500)\n"+
    "}\n";
  eval("script", script); 
}
run("Clear Results");
selectWindow("Ratio");
rois = roiManager("Count"); 
	for(i=0; i<rois; i++){
	roiManager("Select", i);
	run("Measure");
}
print("Measuring Ratio intensity");

//Normalization of mean Ratio FRET intensities to first frame
//Normalizing to relative Ca2+ influx for each frame

	R0_Cell1 = getResult("Mean", 0);	
	for(i=0; i<noFrames; i++){
	R_Cell1 = getResult("Mean", i);
	DeltaR_Cell1 = R_Cell1-R0_Cell1;
	Norm_R_Cell1 = DeltaR_Cell1/R0_Cell1;
	Norm_R_pct_Cell1 = Norm_R_Cell1*100;
	setResult("DeltaR/R0", i, Norm_R_Cell1);
	setResult("DeltaR/R0(%)", i, Norm_R_pct_Cell1);
	}	
print("Normalizing to relative Ca2+ influx for each frame");

//saving files to directory

	selectWindow("Bin_FRET");
	saveAs("tiff", splitDir + "Bin_FRET_" + fileNameWithoutExtension);
	selectWindow("Bin_CFP");
	saveAs("tiff", splitDir + "Bin_CFP_" + fileNameWithoutExtension);
	selectWindow("Bin_ROI_image");
	saveAs("tiff", splitDir + "Bin_ROI_image_" + fileNameWithoutExtension);
	selectWindow("Ratio");
	saveAs("tiff", splitDir + "Ratio_" + fileNameWithoutExtension);
	roiManager("Save", splitDir + "ROIs_" + fileNameWithoutExtension + ".zip");
	selectWindow("Results");
	saveAs("Results", splitDir + "Results_" + fileNameWithoutExtension + ".xls");
	selectWindow("Log");
	saveAs("text", splitDir + "Log_" +  fileNameWithoutExtension);
print("Saving all files in directory: " + splitDir);	
//macro end	
