# Bayesian Matting Project in MATLAB

## Introduction

Bayesian keying is an image processing technique based on Bayes' theorem, which achieves highly accurate foreground object extraction by combining the approximate foreground and background information provided by the user (usually in the form of trimap), and using a probabilistic model to accurately analyse and estimate the colour of each pixel point. This method is particularly suitable for complex scenes with similar foreground and background colours or blurred edges, and can provide excellent keying accuracy and flexibility, which is widely used in image editing, visual effects production and other fields.


## Installation

This project does not require installation beyond having a working MATLAB environment. Ensure you have MATLAB installed on your system (Build by version R2021b).

## Requirements

- MATLAB R2021a or newer

## Dataset

public dataset on http://www.alphamatting.com/

## Usage

1. Clone or download the repository to your local machine.
2. Open MATLAB and navigate to the project directory.
3. Run the `main.m` of `image_input.mlapp` script, select the input picture and trimap and click the matting button.
![Logo](./matlab/gui.png)

## Main function
- read_image: read image and trimap from the input path. 
- match_image: Divide image to F, B, C, according to the image and trimap, and output the mean value and variance of F and B. 
- calculate_alpha: Calculate the alpha matte according to the input mean value and variance which would be generated by match_image function. 

## Evaluation
- MSE (mean square error) 
- SAD (sum of absolute difference) 
- Gradient Error 
- Connectivity Error 

## Implement in Python
Loading, writing, and performing mathematical operations on images in Python is usually done using OpenCV or PIL (the Python Image Processing Library, usually accessed through its branch Pillow).
Here are some exmple to process image in Python.
```bash
import cv2
# load image
image = cv2.imread('image.png')

# write image
cv2.imwrite('alpha.png', image)
```
After that, mathematical operations can be performed directly on the NumPy arrays used by OpenCV.




```matlab

