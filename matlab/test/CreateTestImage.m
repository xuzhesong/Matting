function [image, trimap, back, fore, unk] = CreateTestImage(resolution)
    resolution = [360 360];
    imageSize = [resolution 3];
    trimapSize = resolution;
    
    center = resolution / 2;
    [x, y] = meshgrid(1:imageSize(2), 1:imageSize(1));
    distanceFromCenter = abs(x - center(2)) + abs(y - center(1));
    
    innerRadius = (center(1) / 2) - (center(1) / 10);
    trueRadius = center(1) / 2;
    outerRadius = (center(1) / 2) + (center(1) / 10);
    
    % Generate TRIMAP
    inputTrimap = ones(trimapSize);
    
    back = inputTrimap;
    known = zeros(trimapSize);
    
    back(distanceFromCenter < outerRadius) = 0;
    known(distanceFromCenter < innerRadius) = 1;
    unknown = ones(trimapSize) - back - known;

    TrimapUnknown = unknown .* 0.5;
    Trimapknown = known;
    Trimapback = zeros(trimapSize);
    
    inputTrimap = Trimapback + TrimapUnknown + Trimapknown;
    
    
    % generate RGB IMAGE
    inputImage = zeros(imageSize);
    
    c1 = inputImage(:, :, 1);
    c2 = inputImage(:, :, 2);
    c3 = inputImage(:, :, 3);

    c1(distanceFromCenter >= trueRadius) = 0.4;
    c2(distanceFromCenter >= trueRadius) = 0.3;
    c3(distanceFromCenter >= trueRadius) = 0.7;
    c3(distanceFromCenter < trueRadius) = 0.4;

    inputImage(:,:,1) = c1;
    inputImage(:,:,2) = c2;
    inputImage(:,:,3) = c3;
    
    image = uint8(inputImage*255);
    trimap = uint8(inputTrimap*255);
    back = uint8((back) .* inputImage*255);
    fore = uint8((known) .* inputImage*255);
    unk = uint8((unknown) .* inputImage*255);
    
end

