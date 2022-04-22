MIDTERM PROJECT
Authors: John Bass, Margaret Luffman, Matthew Callahan

INSTRUCTIONS:
Run 'MidtermProject' in the command window to open the GUI.

Use the browse button to read an image. The image will display on the left. Image information will display beneath the image.

Use the spinner to specify the amount of filters you want. This will create a number of dropdowns on the rightmost pane.
Use the dropdowns to specify filter types, then fill in filter parameters in the boxes that open up.

When you wish to get a processed image, press the "Process Image" button. THIS DOES NOT HAPPEN AUTOMATICALLY. I could have added that
but I think it would make the program a lot.

There are buttons to switch between viewing the original image and viewing the processed image. 
You can also view the FFT and histograms for each image using the tabs on top. This can help immensely when doing image processing work.

Use the "Save Processed Image" button to save an image.

Note: Currently you can only have 4 concurrent filters. While my codebase technically supports more, the GUI code becomes a struggle
with more than 4 filters due to the way that MATLAB handles scrollable UI containers. This could potentially be changed for the final.