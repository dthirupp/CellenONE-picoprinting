# CellenONE-picoprinting
Shiny apps for generating robot field files to assemble synthetic bacterial communities or print custom patterns on agar plates.

Info about the CellenONE X1: https://www.cellenion.com/products/cellenone-x1/

This repository has two apps: 

  1. shiny_pattern: a shiny app that can convert a sqaure image of a pattern or logo (png or jpeg only) into the field file for the CellenONE X1 picoprinter to create a bacterial pattern plate.  
  2. shiny_syncom: a shint app that accepts tsv files with droplet numbers and locations in the form of a 96-well plate as input for N bacteria, and combines them into a field file for the CellenONE X1 picoprinter to assemble an N-member syncom. 

## Definitions:

  1. **Field file**: an x/y coordinate map for the CellenONE X1 pico printer that instructs the robot where to aspirate the bacteria from and where to deposit (print) it.
  2. **Target template file**: a template file with no cooridnate defined that provides the header lines for the field file. This includes infomrtaion regarding the target being printed into (petri dish/ 384-well plate/ 96 well plate, etc) such as the number of target spots on the X and Y dimensions, the spot pitch or distance between spots on X and Y dimension, etc. All this information is pulled form the uploaded blank targte file by the user (see below).

## Package Requirements:

* shiny: https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/
* png: https://doi.org/10.32614/CRAN.package.png
* jpeg: https://doi.org/10.32614/CRAN.package.jpeg
* stringr: https://doi.org/10.32614/CRAN.package.stringr
* dplyr: https://doi.org/10.32614/CRAN.package.dplyr
* https://doi.org/10.32614/CRAN.package.reshape

  The version of R used to write both scripts: R version 4.1.2 (2021-11-01)

## 1. Using shiny_pattern app

This app allows the user to rapidly generate a field file for creating a bacteria pattern plate for any logo or image, so long as the image is uploaded as a square size and is either png or jpeg format. 

**Step 1:** Select your image of the pattern you wish to print.  Resize it to SQUARE shape. Ensure it is png or jpeg format.  
   * The best bacterial patterns on petri dish using CellenONE X1 can be made for logos, or designs with a clear thresholded difference between the subject and the background. So for example, dark details on dark background, or light details on light wont do well at all. But dark details on light, or vice versa work well. 

**Step 2:** Have your blank target template file ready. 
* This target file will depend on the the target you are using. In this case, the target is a petri dish, so make sure you download the blank template file for the right target from the CellenONE X1 robot (can run on simulation mode for this).
* Alternatively, you can download the appropriate blank target template file from the files_resources of this repository. 

**Step 3:** Download the "shiny_pattern.R" file from here and run it on your computer's R. 
* Both apps in this repository were written in R version 4.1.2 (2021-11-01). Ensure all required packages are downloaded. 

**Step 4:** Run the app on your R. 
* The app should pop up in a separate window (if using R Studio). Make sure you click "Open Browser" and run the app on your default browser in case it doesn't automatically open. 

**Step 5:** Input the following in the app's user interface:
  1. Square image (png or jpeg).
     * _for best results, try uploading an image with the background removed. Can use any online tool for this_
  2. Blank target template file.
  3. The well ID of the probe plate where the bacteria (ink for printing) is. Format should be "column name""row number". For eg, A1, A2, ..H12.

  <img width="330" height="239" alt="image" src="https://github.com/user-attachments/assets/16bbbd27-ca68-468d-b4e4-f1c6005af4a6" />


**Step 6:** Adjust the grayscale thresholding to improve crispness of the pattern. 
* Use the slider tool for this. Adjusting this can improve the resolution of your pattern. 

<img width="740" height="226" alt="image" src="https://github.com/user-attachments/assets/0b1af88d-5835-45ed-8a8b-483369275393" /> 

<img width="740" height="236" alt="image" src="https://github.com/user-attachments/assets/789d4bb9-40fc-44dc-8903-4006eee0d6e7" />


**Step 7:** Download the field file once satisfied with the pattern. 


## 2. Using shiny_syncom app

This app allows the user to quickly create the field file for assembling a syncom of N bacteria, combined at different ratios. This avoids needing to use the robot's GUI interface to do this, which can take many hours and is prone to user error. For more info on this, check out the publication: https://doi.org/10.1016/j.xpro.2025.103714

**Step 1:** Create the TSV files on your excel/ libreoffice software for each bacteria part of your SynCom. 
* The key here is to create the template on your computer that matches the locations where each bacteria will go, and the number of "droplets" for that bacteria in those wells (that syncom). For example, for bacteria A, the TSV file may look something like this when you open on excel:

<img width="677" height="302" alt="image" src="https://github.com/user-attachments/assets/b157b94d-4fce-47d3-ad93-e54d1ec34cca" />

Ensure there are no leading blank rows or column above the 96-well plate layout.

**Step 2:** Have the probe plate location well for each bacteria already decided and set. Input this in "column""row" format for each bacteria. 

**Step 3:** Have your blank target template file ready. 
* This target file will depend on the the target you are using. In this case, the target is a 96well wholeplate, so make sure you download the blank template file for the right target from the CellenONE X1 robot (can run on simulation mode for this).
* Alternatively, you can download the appropriate blank target template file from the files_resources of this repository.

**Step 4:** Run the app on your R. 
* The app should pop up in a separate window (if using R Studio). Make sure you click "Open Browser" and run the app on your default browser in case it doesn't automatically open.

**Step 5:** Input the following in the app's user interface:
  1. The number of organisms in your SynCom (at least 3)
  2. The blank target template file (see step 3). 
  3. The layout TSV file (see Step 1) for each bacteria.
  4. The well ID of the probe plate where the bacteria (ink for printing) is. Format should be "column name""row number". For eg, A1, A2, ..H12.
  5. Repeat 2 and 3 for every bacteria in your SynCom (the app will prompt you for this when you hit "Next File").

<img width="436" height="327" alt="image" src="https://github.com/user-attachments/assets/05f8838a-fdee-43b4-88b7-e385e1cbc8a7" />

**Step 6:** Download the field file generated. This can be used with the picoprinter to istantly generate the field coordinates for assembling all your syncoms. 

Happy Pico-Printing!

# Relavant publications:
1. Thiruppathy, D., Lekbua, A., Coker, J., Weng, Y., Askarian, F., Kousha, A., Marotz, C., Hauw, A., Tjuanta, M., Nizet, V., & Zengler, K. (2025). Protocol for the development, assembly, and testing of a synthetic skin microbial community. STAR Protocols, 6(2), 103714. https://doi.org/10.1016/j.xpro.2025.103714

2. Coker, J., Zhalnina, K., Marotz, C., Thiruppathy, D., Tjuanta, M., D’Elia, G., Hailu, R., Mahosky, T., Rowan, M., Northen, T. R., & Zengler, K. (2022). A Reproducible and Tunable Synthetic Soil Microbial Community Provides New Insights into Microbial Ecology. mSystems, 7(6). https://doi.org/10.1128/msystems.00951-22
     






  
