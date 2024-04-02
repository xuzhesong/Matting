import unittest
import numpy as np
from PIL import Image
import sys
import os
sys.path.append('../func')  
from func.calculate_alpha  import calculate_alpha  

class TestAlpha(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        super(TestAlpha, cls).setUpClass()
        # 为所有测试方法准备共享的数据
        current_dir = os.path.dirname(__file__)
        image_path = os.path.join(current_dir, "GT08_image.png")
        trimap_path = os.path.join(current_dir, "GT08_trimap.png")

        cls.image = np.array(Image.open(image_path))
        cls.trimap = np.array(Image.open(trimap_path))
        cls.alpha = calculate_alpha(image_path, trimap_path, 8, 10)
    
    def test_alpha_size(self):
        
        try:
            self.assertEqual(self.alpha.shape, self.image[:, :, 0].shape, 'Failed for alpha size test (with image)')
            self.assertEqual(self.alpha.shape, self.trimap.shape, 'Failed for alpha size test (with trimap)')
        except AssertionError as e:
            print(f"Assertion error: {e}")
            print(f"Shape of the alpha matte: {self.alpha.shape}")
            print(f"Shape of the image: {self.image.shape}")
            print(f"Shape of the trimap: {self.trimap.shape}")
            raise
        print('test_alpha_size: passed')
    def test_alpha_value(self):
        try:
            self.assertTrue(np.all(self.alpha <= 1), "Not all values are less than 1")
            print('test_alpha_value: passed')
        except AssertionError as e:
            print(f"Assertion error: {e}")
            print(f"Max value in alpha array: {np.max(self.alpha)}")
            raise
        
if __name__ == '__main__':
    unittest.main()
