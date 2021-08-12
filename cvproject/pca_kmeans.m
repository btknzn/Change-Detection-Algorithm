function [change_map] = pca_kmeans(im1,im2,block_size,rate)

%% CHECK THE NUMBER OF INPUTS;
if nargin <= 3
    rate=0.9;
end

%% calculate the image_size and padding_size;
image_size = size(im1);
padding_size = image_size + block_size;
padding_size(3) = padding_size(3) - block_size;

%% calculate the difference image;
delta = abs(double(im1)-double(im2));

%% padding
%INTRODUCE NEW PIXELS AROUND THE EDGES OF THE IMAGE 
padding_img = zeros(padding_size);
lb = ceil(block_size/2); %ROUND TO THE NEAREST INTEGER VALUE
ub_col = lb+image_size(1)-1;
ub_row = lb+image_size(2)-1;
padding_img(lb:ub_col,lb:ub_row,:)=delta;

%% generate feature vector for blocks;
vk = zeros(prod(image_size(1:2)),image_size(3)*block_size*block_size);
cnt=1;
%CREATE (BLOCK SIZE)*(BLOCK SIZE) OVERLAPPING BLOCKS FOR THE FEATURE VECTOR
for k1=1:image_size(1)
    for k2=1:image_size(2)
        vk_temp = padding_img(k1:k1+block_size-1,k2:k2+block_size-1,:);
        vk(cnt,:)=reshape(vk_temp,[],1);
        cnt=cnt+1;
    end
end
clear cnt;

%% NORMALIZATION WITH THE MEAN VALUE
mean_val = mean(vk);
std_val = std(vk)+1e-12;
num = size(vk,1);
vk = (vk-repmat(mean_val,num,1))./repmat(std_val,num,1);

%% PCA
cov = vk' * vk; %CALCULATE COVARIANCE MATRIX
[V,D]=eig(cov); %CALCULATE EIGENVALUES OF COVARIANCE MATRIX
val=diag(D); %GET DIAGONAL
%GET PCA VALUES
for k1=length(val):-1:1
    if(sum(val(k1:length(val)))>=rate*sum(val))
        break;
    end
end
vec=V(:,k1:length(val));
feature=vk * vec;

%% kmeans
[label,~]=kmeans(feature,2); %APPLY 2-K MEANS CLUSTERING (CHANGE-NON CHANGE)
change_map=reshape(label,image_size([2,1]));
change_map=change_map'-1; %CHANGE MAP THAT CONTAINS THE POINTS OF CHANGE
end