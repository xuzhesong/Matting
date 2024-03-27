import unittest
import numpy as np
from PIL import Image
import sys
import os
sys.path.append('../func')  
from func.calculate_alpha  import calculate_alpha  

class TestAlpha(unittest.TestCase):
    def test_alpha_size(self):

        current_dir = os.path.dirname(__file__)

        image_path = os.path.join(current_dir, "GT08_image.png")
        trimap_path = os.path.join(current_dir, "GT08_trimap.png")

        image = np.array(Image.open(image_path))
        trimap = np.array(Image.open(trimap_path))
        alpha = calculate_alpha(image_path, trimap_path, 8, 10)

        self.assertEqual(alpha.shape, image[:, :, 0].shape, 'Failed for alpha size test (with image)')
        self.assertEqual(alpha.shape, trimap.shape, 'Failed for alpha size test (with trimap)')

if __name__ == '__main__':
    unittest.main()
