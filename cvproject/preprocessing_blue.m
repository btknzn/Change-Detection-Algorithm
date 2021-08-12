function [Iblur1] = preprocessing_blue(im1)
	
    im1eq = histeq(im1); %HISTOGRAM EQUALIZATION - MAKE THE BRIGHTNESS SAME  IN BOTH IMAGES
    Iblur1 = imgaussfilt(im1eq ,2); %GAUSSIAN FILTER TO REMOVE SALT PEPPER NOISE 
    Iblur1 = im1;
    imageBlue = Iblur1(:,:,3);
    %TAKE THE ONLY THE PIXELS WITH THE HIGHEST INTENSITY OF BLUE COLOR
    imageBlueBw = imageBlue > 120;
    %APPLY ACQUIRED FILTER TO THE IMAGE - TURN BLUE PARTS TO BLACK 
    im1(:,:,1) = double(im1(:,:,1)).*double(imageBlueBw);
    im1(:,:,2) = double(im1(:,:,2)).*double(imageBlueBw);
    im1(:,:,3) = double(im1(:,:,3)).*double(imageBlueBw);
    Iblur1 = im1;
end