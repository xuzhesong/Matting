
classdef TestAlpha < matlab.unittest.TestCase
    methods(Test)
        function testAlphaSize(testCase)
            [image, trimap] = CreateTestImage([360 360]);
            alpha = calculate_alpha(image, trimap, 8, 10);
            
            testCase.verifySize(alpha, size(image(:,:,1)), ...
                sprintf('Failed for alpha size test(with image): size: %d, expect size: %d', size(alpha), size(image(:,:,1))));
            testCase.verifySize(alpha, size(trimap), ...
                sprintf('Failed for alpha size test(with trimap): size: %d, expect size: %d', size(alpha), size(trimap)));
            
        end
        
    end
end
