clc
clear

im1 = imread("D1.jpg");
im2 = imread("D2.jpg");
[im1] = preprocessing(im1);
[im2] = preprocessing(im2);

[MOVINGREG] = registerImages(im2,im1);
%treshold image to detect black part 
I = MOVINGREG.RegisteredImage >0,1;
% make it appropiate file format
I = uint8(I);
% apply filter used by treshold 
im1moved = im1.*I;

block_size = 2;
rate = 0.6;
figure()
change_map = pca_kmeans(im1moved,MOVINGREG.RegisteredImage,block_size,rate);
imshow( change_map);
figure()
imshow(im1);
figure()
imshow(MOVINGREG.RegisteredImage)
im1withchange = im1;
im1withchange(:,:,2) = double(im1(:,:,2))+double(change_map*255);
figure()
imshow(im1withchange);



