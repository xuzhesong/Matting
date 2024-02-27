function connectivityError = ConnectivityError(Ip, Ir)

    if ndims(Ip) == 3
        Ip = rgb2gray(Ip);
    end
    if ndims(Ir) == 3
        Ir = rgb2gray(Ir);
    end
    
    %image binarize
    predictedBinary = imbinarize(Ip);
    trueBinary = imbinarize(Ir);
    
    % Calculate connected area
    [labeledPredicted, numPredicted] = bwlabel(predictedBinary);
    [labeledTrue, numTrue] = bwlabel(trueBinary);
    
    % initialize
    errorCount = 0;
    
    for i = 1:numTrue
        trueRegion = (labeledTrue == i);
        
        maxIntersectionArea = 0;
        maxIntersectionIndex = 0;
        
        for j = 1:numPredicted
            predictedRegion = (labeledPredicted == j);
            intersectionArea = sum(sum(trueRegion & predictedRegion));
            
            if intersectionArea > maxIntersectionArea
                maxIntersectionArea = intersectionArea;
                maxIntersectionIndex = j;
            end
        end
        
        if maxIntersectionIndex > 0
            predictedRegion = (labeledPredicted == maxIntersectionIndex);
            unionArea = sum(sum(trueRegion | predictedRegion));
            
            errorCount = errorCount + (unionArea - maxIntersectionArea);
        else
            errorCount = errorCount + sum(sum(trueRegion));
        end
    end
    
    connectivityError = errorCount / numTrue;
end
