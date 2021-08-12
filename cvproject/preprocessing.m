function [Iblur1] = preprocessing(im1)
	im1eq = histeq(im1); %HISTOGRAM EQUALIZATION - MAKE THE BRIGHTNESS SAME  IN BOTH IMAGES
    Iblur1 = imgaussfilt(im1eq ,2); %GAUSSIAN FILTER TO REMOVE SALT PEPPER NOISE 


end