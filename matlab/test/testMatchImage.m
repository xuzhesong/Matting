
classdef testMatchImage < matlab.unittest.TestCase
    methods(Test)
        function testChannel(testCase)
            resolution = [...
                100 100; 
                360 360; 
                720 720; 
                1080 1080];
            for i = 1:size(resolution, 1)
                
                r = resolution(i, :);
                
                height = r(1);
                width = r(2);

                [inputRGBImage, inputTrimap, backT, foreT, unkT] = CreateTestImage(r);

                [foreground, background, unknown] = match_img(inputRGBImage, inputTrimap);

                testCase.verifySize(foreground, size(foreT), ...
                    sprintf('Resolution %dx%d failed for foreground channel test', height, width));
                testCase.verifySize(unknown, size(unkT), ...
                    sprintf('Resolution %dx%d failed for unknown channel test', height, width));
                testCase.verifySize(background, size(backT), ...
                    sprintf('Resolution %dx%d failed for background channel test', height, width));
            end
        end
        
        function testImageSplit(testCase)
            resolution = [...
                100 100; 
                360 360; 
                720 720; 
                1080 1080];
            for i = 1:size(resolution, 1)

                r = resolution(i, :);
                
                height = r(1);
                width = r(2);

                [inputRGBImage, inputTrimap, backT, foreT, unkT] = CreateTestImage(r);

                [foreground, background, unknown] = match_img(inputRGBImage, inputTrimap);

                mergeImage = foreground + unknown + background;

                testCase.verifyEqual(mergeImage, inputRGBImage, ...
                    sprintf('Resolution %dx%d failed for image merge test', height, width));
                testCase.verifyEqual(foreground, foreT, ...
                    sprintf('Resolution %dx%d failed for foreground area test', height, width));
                testCase.verifyEqual(unknown, unkT, ...
                    sprintf('Resolution %dx%d failed for unknown area test', height, width));
                testCase.verifyEqual(background, backT, ...
                    sprintf('Resolution %dx%d failed for background area test', height, width));
            end
        end
    end
end
