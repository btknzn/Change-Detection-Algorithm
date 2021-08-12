function [MOVINGREG] = registerImages(MOVING,FIXED)
% Convert RGB images to grayscale
FIXED = im2gray(FIXED);
MOVINGRGB = MOVING;
MOVING = im2gray(MOVING);

% Default spatial referencing objects
fixedRefObj = imref2d(size(FIXED));
movingRefObj = imref2d(size(MOVING));

% Detect KAZE features
fixedPoints = detectKAZEFeatures(FIXED,'Diffusion','region','Threshold',0.001966,'NumOctaves',3,'NumScaleLevels',5);
movingPoints = detectKAZEFeatures(MOVING,'Diffusion','region','Threshold',0.001966,'NumOctaves',3,'NumScaleLevels',5);

% Extract features
[fixedFeatures,fixedValidPoints] = extractFeatures(FIXED,fixedPoints,'Upright',false);
[movingFeatures,movingValidPoints] = extractFeatures(MOVING,movingPoints,'Upright',false);

% Match features
indexPairs = matchFeatures(fixedFeatures,movingFeatures,'MatchThreshold',50.000000,'MaxRatio',0.500000);
fixedMatchedPoints = fixedValidPoints(indexPairs(:,1));
movingMatchedPoints = movingValidPoints(indexPairs(:,2));
MOVINGREG.FixedMatchedFeatures = fixedMatchedPoints;
MOVINGREG.MovingMatchedFeatures = movingMatchedPoints;

% Apply transformation - Results may not be identical between runs because of the randomized nature of the algorithm
tform = estimateGeometricTransform2D(movingMatchedPoints,fixedMatchedPoints,'similarity');
MOVINGREG.Transformation = tform;
MOVINGREG.RegisteredImage = imwarp(MOVINGRGB, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);

% Store spatial referencing object
MOVINGREG.SpatialRefObj = fixedRefObj;

end