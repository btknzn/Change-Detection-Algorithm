clc
clear
%LOAD IMAGES
im1 = imread("w6.jpg");
im2 = imread("w2.jpg");
%IMAGE PREPROCESSING
%[im1] = preprocessing(im1);
%[im2] = preprocessing(im2);

%IMAGE REGISTRATION
[MOVINGREG] = registerImages(im1,im2);
%treshold image to detect black part 
%REMOVE BLACK CORNERS AFTER REGISTRATION
I = MOVINGREG.RegisteredImage >0,1;
% make it appropiate file format
I = uint8(I);
% apply filter used by treshold 
im2moved = im2.*I;

diff = (im2moved - MOVINGREG.RegisteredImage); %SUBSTRACT IMAGES
diff = rgb2gray(diff); %CONVERT DIFFERENCE IN GRAYSCALE IMAGE
threshold = 20;    %APPLY THRESHOLD
new = diff >threshold; %THRESHOLD FILTER TO THE DIFFERENCE
im2withchange_new = im2;
im2withchange_new(:,:,2) = double(im2(:,:,2))+double(new*255);  % VISUALIZE CHANGES AS GREEN HIGHLIGHTS
%PLOT RESULTS
figure();
imshow(im2withchange_new); 
figure();
imshow(im2withchange_new);
imshow([MOVINGREG.RegisteredImage,im2moved]);