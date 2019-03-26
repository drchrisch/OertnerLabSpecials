# **OertnerLabSpecials**
[ScanImage](https://vidriotechnologies.com/) (public release, version SI55R1) is a flexible software for operating laser scanning microscopes. For some applications you might want to customize the software.

## Alternating beam scanning
ScanImage can control two laser lines, however, spectral overlapp of fluorophores impedes multiplexed excitation and detection. A technically straightforward solution is to alternate between excitation wavelengths in a frame-by-frame manner ("alternating beam scanning") so that an image stack with interleaved emission data is created (two channels per frame, two channels per optical section).
###### Setup
* Add "OertnerLabSpecials" directory to Matlab search path.
* Replace ScanImage function "calcStreamingBuffer" (part of ScanImage\\+scanimage\\+components\\Beams.m, around line 1180) with the code given in "Beams-calcStreamingBuffer_modified.m".
* Start OertnerLabSpecials from Matlab command line.
* Set Frames=2 in ScanImages "Main Controls" window (all other params as required).
* Activate "Enable Power Box" in ScanImages "Power Controls" (it is not necessary to set a power box).
* Activate "Alternating Beam Scanning" in "OertnerLabSpecials". Set individual power values.
* Run acquisition (alternating beam scanning is active in Grab and Loop mode).


