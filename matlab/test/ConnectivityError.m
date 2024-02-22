function connectivityError = ConnectivityError(predictedImage, trueImage)

    if ndims(predictedImage) == 3
        predictedImage = rgb2gray(predictedImage);
    end
    if ndims(trueImage) == 3
        trueImage = rgb2gray(trueImage);
    end
    
    %image binarize
    predictedBinary = imbinarize(predictedImage);
    trueBinary = imbinarize(trueImage);
    
    % Calculate connected area
    [labeledPredicted, numPredicted] = bwlabel(predictedBinary);
    [labeledTrue, numTrue] = bwlabel(trueBinary);
    
    % 初始化错误计数initialize
    errorCount = 0;
    
    % 对于每个真实的连通区域，找到与之最匹配的预测连通区域
    for i = 1:numTrue
        trueRegion = (labeledTrue == i);
        
        % 初始化最大交集区域面积和索引
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
        
        % 如果找到最大交集区域，计算错误
        if maxIntersectionIndex > 0
            % 计算并集面积
            predictedRegion = (labeledPredicted == maxIntersectionIndex);
            unionArea = sum(sum(trueRegion | predictedRegion));
            
            % 计算错误：并集 - 交集
            errorCount = errorCount + (unionArea - maxIntersectionArea);
        else
            % 如果没有找到匹配的预测区域，错误计数增加真实区域的像素数
            errorCount = errorCount + sum(sum(trueRegion));
        end
    end
    
    % 计算平均连通性错误
    connectivityError = errorCount / numTrue;
end
