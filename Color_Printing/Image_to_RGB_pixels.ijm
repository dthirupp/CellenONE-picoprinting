macro "Display Pixel Values_rgb" { 
     getSelectionBounds(xbase, ybase, width, height); 
     if (width&height >72) 
         exit("Image or selection width and height limited to 72 pixels"); 
     rgb = bitDepth == 24; 
     run("Clear Results"); 
     r = 1; 
     for (row=0; row<height; row++) { 
        for (i=0; i<width; i++) { 
              v = getPixel(xbase+i, ybase+row); 
              if (rgb) { 
                 setResult(0, 0, "Red"); setResult(1, 0, "Green"); setResult(2, 0, "Blue");setResult(3,0,"Yellow");  
	     red = (v>>16)&0xff; green = (v>>8)&0xff; blue = v&0xff;yellow=round((red+green)/2); 
	     if((blue<20 && (red+green)>100)) 
		setResult(3,r,yellow); 
	     else if((blue/(red+green+blue))>=0.5) 
		setResult(2,r,blue); 
	     else if((green/(red+blue+green))>=0.5) 
		setResult(1,r,green); 
	     else if((red/(red+green+blue))>=0.5) 
		setResult(0,r,red); 
	     else 
		//setResult(0,r,red); setResult(1,r,green); setResult(2,r,blue); 
		setResult(1,r,0); 
                 } 
              else 
                 setResult(0, r, v); 
	  r++; 
        } 
     } 
     updateResults(); 
 }
