# FRET-calcium-influx
A FIJI / ImageJ macro to measure FRET based relative calcium entry into Golgi compartments

# Goal
This macro facilitates FRET-based Ca2+ influx analysis of Golgi objects. The macro was designed for the Go-D1-cpv FRET Ca2+ sensor (Lissandron et al. 2010) using CFP and YFP as a FRET pair. It will also work for other common FRET pairs and sensors. 

Use FRET_calcium_influx_V3.8 to quantify normalized calcium entry to the first frame of the movie presented as percentage ΔR/R0 of one single Golgi object per image. 

Use FRET_ratio_image_generator_V1.1 to generate color-coded images displaying normalized calcium entry to the first frame of the movie presented as percentage ΔR/R0.    

# Installation
Simply copy the macro file to your macro folder in your [Fiji](https://imagej.net/Fiji) directory and restart Fiji. You can access the macro from the Plugin section in Fiji.    

# Usage
Acquire multi-channel hyperstack images by live cell imaging. Acquire FRET and CFP channels in a time-lapse acquisition. Run the macro and assign FRET and CFP channels. By using a selection, choose the object you want to analyze. The macro will generate a binary image by Auto Threshold function (if required, change threshold algorithm to improve thresholding for your protein of interest) to detect objects by Find Maxima function and add the outlines to the ROI manager. The mean intensities in the FRET ratio image (FRET/CFP) are then measured for detected ROIs. The results display mean ratio intensity values and the change of Ca2+ influx relative to the first frame in percent. For further detailed protocols for acquisition and analysis, please follow the Materials and Methods section of our publication.  

# Citation
If you used the FRET-calcium-influx macro or modified it, please cite our work. 

Deng, Y., Pakdel, M., Blank, B., Sundberg, E.L., Burd, C.G., von Blume, J., 2018. Activity of the SPCA1 Calcium Pump Couples Sphingomyelin Synthesis to Sorting of Secretory Proteins in the Trans-Golgi Network. Dev. Cell 47, 464-478.e8.
https://doi.org/10.1016/j.devcel.2018.10.012
