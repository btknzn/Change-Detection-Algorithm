clc
clear
tic
%LOAD IMAGES
im2 = imread("d8.jpg");
im1 = imread("d3.jpg");
%PREPROCESS IMAGES IF ASKED 
%[im1] = preprocessing(im1);
%[im2] = preprocessing(im2);

%REGITER IMAGES
[MOVINGREG] = registerImages(im1,im2);
%REMOVE BLACK CORNERS AFTER REGISTRATION
%treshold image to detect black part 
I = MOVINGREG.RegisteredImage >0,1;
% make it appropiate file format
I = uint8(I);
% apply filter used by treshold 
im2moved = im2.*I;

%FILTER THE IMAGE TO CALIBRATE THE BLUE COLOR OF THE SEA - MAKE BLUE COLOR
%BLACK IN BOTH PICTURES TO ELIMINATE INTENSITY DIFFERENCES IN THE SEA THAT
%DONT QUALIFY AS CHANGES
im2moved = preprocessing_blue(im2moved);
imm = preprocessing_blue(MOVINGREG.RegisteredImage);

diff = (im2moved - imm); %SUBSTRACT IMAGES
%diff = diff.*I;
diff = rgb2gray(diff); %TRANSFORM IMAGE IN GRAYSCALE
threshold = 2;  
new = diff >threshold; %APPLY THRESHOLD
%HIGHLIGHT CHANGES IN GREEN COLOR
im2withchange_new = MOVINGREG.RegisteredImage; 
im2withchange_new(:,:,2) = double(MOVINGREG.RegisteredImage(:,:,2))+double(new*255);
t1 = toc;
%PLOT RESULTS
figure();
imshow(im2withchange_new);
figure();
imshow(im2withchange_new);
imshow([MOVINGREG.RegisteredImage,im2moved]);