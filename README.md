# FRET-calcium-influx
A FIJI / ImageJ macro to measure FRET based relative calcium entry into Golgi compartments

# Goal
This macro facilitates FRET-based Ca2+ influx analysis of Golgi objects. The macro was designed for the Go-D1-cpv FRET Ca2+ sensor (Lissandron et al. 2010) using CFP and YFP as a FRET pair. It will also work for other common FRET pairs and sensors.   

# Installation
Simply copy the macro file to your macro folder in your Fiji directory and restart Fiji. You can access the macro from the Plugin section in Fiji.    

# Usage
Acquire multi-channel hyperstack images by live cell imaging. Acquire FRET and CFP channels in a time-lapse acquisition. Run the macro and assign FRET and CFP channels. By using a selection, choose the object you want to analyze. The macro will generate a binary image by Auto Threshold function (if required, change threshold algorithm to improve thresholding for your protein of interest) to detect objects by Find Maxima function and add the outlines to the ROI manager. The mean intensities in the FRET ratio image (FRET/CFP) are then measured for detected ROIs. The results display mean ratio intensity values and the change of Ca2+ influx relative to the first frame in percent. For further detailed protocols for acquisition and analysis, please follow the Materials and Methods section of our publication.  

# Citation
The macro will be uploaded and the citation will be updated as soon as the publication is released. 
