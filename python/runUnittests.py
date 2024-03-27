from func import match_img
from func import calculate_alpha
import test
import unittest

def run_and_display_tests(test_file):
    

    loader = unittest.TestLoader()
    
    suite = loader.discover(start_dir="test", pattern=test_file)
    runner = unittest.TextTestRunner()
    result = runner.run(suite)
    print(result)

 
import os
print("Current Working Directory:", os.getcwd())

run_and_display_tests("testMatchImage.py")
print("%%")  
run_and_display_tests("testAlpha.py")

