
classdef TestReadImage < matlab.unittest.TestCase
    methods(Test)
        function testReadImageSize(testCase)
            [exp_image, exp_trimap] = CreateTestImage([360 360]);
            
            trimap = read_img("TestTrimap.png");
            image = read_img("TestImage.png");

            testCase.verifySize(image, size(exp_image), ...
                sprintf('Failed for image size test: size: %d, expect size: %d', size(image), size(exp_image)));
            testCase.verifySize(trimap, size(exp_trimap), ...
                sprintf('Failed for trimap size test: size: %d, expect size: %d', size(trimap), size(exp_trimap)));
            
        end
        
        function testReadImageValue(testCase)
            [exp_image, exp_trimap] = CreateTestImage([360 360]);
            trimap = read_img("TestTrimap.png");
            image = read_img("TestImage.png");

            testCase.verifyEqual(image, exp_image, ...
                sprintf('Failed for image size test: error: %f', mean(image - exp_image, "all")));
            testCase.verifyEqual(trimap, exp_trimap, ...
                sprintf('Failed for trimap size test: error: %f', mean(trimap - exp_trimap, "all")));
            
        end

        function testReadImageMatch(testCase)
            trimap = read_img("TestTrimap.png");
            image = read_img("TestImage.png");

            testCase.verifySize(image(:,:,1), size(trimap), ...
                sprintf('Failed for image size test: size: %d, expect size: %d', size(image), size(trimap)));
            testCase.verifySize(trimap, size(image(:,:,1)), ...
                sprintf('Failed for trimap size test: size: %d, expect size: %d', size(trimap), size(image)));
            
        end
    end
end
