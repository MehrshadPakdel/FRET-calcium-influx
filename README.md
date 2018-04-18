# FRET-calcium-influx
A FIJI / ImageJ macro to measure FRET based calcium entry into Golgi compartments

# Goal
This macro facilitates FRET-based Ca2+ influx analysis of Golgi objects. The macro was designed for the Go-D1-cpv FRET Ca2+ sensor (Lissandron et al. 2010) using CFP and YFP as a FRET pair. It will also work for other common FRET pairs and sensors.   

# Installation
Simply copy the macro file to your macro folder in your Fiji directory and restart Fiji. You can access the macro from the Plugin section in Fiji.    

# Usage
Acquire multi-channel hyperstack images by live cell imaging. Acquire FRET and CFP channels in a time-lapse acquisition. Run the macro and assign FRET and CFP channels. By using a selection, choose the object you want to analyze. The macro will measure mean intensities for the FRET Ratio image (FRET/CFP) followed by normalization to the first frame to calculate relative Ca2+ influx for each frame.

# Citation
Will be updated as soon as the publication is released. 
