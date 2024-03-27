import numpy as np
import unittest
from func.match_img  import match_img  

class TestMatchImg(unittest.TestCase):
    def test_match_img(self):
        
        rgb = np.array([[[255, 0, 0], [0, 255, 0], [0, 0, 255]]], dtype=np.uint8)
        trimap = np.array([[255, 0, 128]], dtype=np.uint8)
        
        F_mean, B_mean, F_cov, B_cov = match_img(rgb, trimap)
        
        print("Shape of rgb:", rgb.shape)
        print("Shape of trimap:", trimap.shape)
        print("Shape of F_cov:", F_cov.shape)
        print("Shape of B_cov:", B_cov.shape)

        

        print("Value of rgb:", rgb)
        print("Value of trimap:", trimap)
        print("F_mean = ", F_mean)
        print("B_mean = ", B_mean)

        self.assertAlmostEqual(F_mean[0, 0], 255) 
        self.assertAlmostEqual(B_mean[0, 1], 255) 
        
        self.assertEqual(F_cov.shape, (3, 3))
        self.assertEqual(B_cov.shape, (3, 3))
        

if __name__ == '__main__':
    unittest.main()












# import unittest
# import numpy as np 
# import sys
# import os

# from test.CreateTestImage import CreateTestImage
# from test.MatchImage import match_img_test
# from func.match_img  import match_img  

# class TestMatchImage(unittest.TestCase):
#     def test_value(self):
#         resolutions = [
#             (100, 100),
#             (360, 360),
#             (720, 720),
#             (1080, 1080)
#         ]
#         for height, width in resolutions:
#             r = (height, width)

#             inputRGBImage, inputTrimap, backT, foreT, unkT = CreateTestImage(r)

#             # backT = backT[:,:,2]
#             # foreT = foreT[:,:,2]
#             # backT, foreT = backT[:,:,0], foreT[:,:,0]
#             # print(np.max(backT, axis=(0,1)))
#             back = backT + unkT
#             expectFmean = np.mean(foreT, axis=(0,1)).reshape(1, -1)
#             expectBmean = np.mean(back, axis=(0,1)).reshape(1, -1)

#             print('expect value:', expectFmean, expectBmean)

#             pixelsF = foreT.reshape(-1, foreT.shape[-1])  # 重塑为 [像素数, 通道数]
#             pixelsB = back.reshape(-1, back.shape[-1])  # 重塑为 [像素数, 通道数]
#             print("shape of pexelsF", pixelsF.shape)
#             # 计算协方差矩阵
#             expectFcov = np.cov(pixelsF, rowvar=False)  
#             expectBcov = np.cov(pixelsB, rowvar=False)  
#             # expectFcov = np.cov(foreT)  
#             # expectBcov = np.cov(foreT)  
#             print('expect value:', expectFcov, expectBcov)

#             F_mean, B_mean, F_cov, B_cov = match_img_test(inputRGBImage, inputTrimap)

#             print('result value:', F_mean, B_mean)
#             print('result value:', F_cov, B_cov)

#             self.assertTrue(np.array_equal(backT+foreT+unkT, inputRGBImage), f'Resolution {height}x{width} failed for RGB test')
#             self.assertTrue(np.array_equal(F_mean, expectFmean), f'Resolution {height}x{width} failed for F_mean test')
#             self.assertTrue(np.array_equal(B_mean, expectBmean), f'Resolution {height}x{width} failed for B_mean test')
#             self.assertTrue(np.array_equal(F_cov, expectFcov), f'Resolution {height}x{width} failed for F_cov test')
#             self.assertTrue(np.array_equal(B_cov, expectBcov), f'Resolution {height}x{width} failed for B_cov test')


# if __name__ == '__main__':
#     unittest.main()
