import numpy as np
from PIL import Image

def CreateTestImage(resolution=(360, 360)):
    imageSize = (*resolution, 3)
    trimapSize = resolution
    
    center = np.array(resolution) // 2
    x, y = np.meshgrid(range(1, imageSize[1]+1), range(1, imageSize[0]+1))
    distanceFromCenter = np.abs(x - center[1]) + np.abs(y - center[0])
    
    innerRadius = center[0] // 2 - center[0] // 10
    trueRadius = center[0] // 2
    outerRadius = center[0] // 2 + center[0] // 10
    
    # 生成 TRIMAP
    inputTrimap = np.ones(trimapSize)
    back = np.copy(inputTrimap)
    known = np.zeros(trimapSize)
    
    back[distanceFromCenter < outerRadius] = 0
    known[distanceFromCenter < innerRadius] = 1
    unknown = np.ones(trimapSize) - back - known
    
    TrimapUnknown = unknown * 0.5
    TrimapKnown = known
    TrimapBack = np.zeros(trimapSize)
    
    inputTrimap = TrimapBack + TrimapUnknown + TrimapKnown
    
    # 生成 RGB 图像
    inputImage = np.zeros(imageSize)
    
    inputImage[distanceFromCenter >= trueRadius, 0] = 0.4
    inputImage[distanceFromCenter >= trueRadius, 1] = 0.3
    inputImage[distanceFromCenter >= trueRadius, 2] = 0.7
    inputImage[distanceFromCenter < trueRadius, 2] = 0.4
    
    # 修改 back, fore, unk 以兼容 inputImage 的形状
    back = np.expand_dims(back, axis=-1) * inputImage * 255
    fore = np.expand_dims(known, axis=-1) * inputImage * 255
    unk = np.expand_dims(unknown, axis=-1) * inputImage * 255

    image = (inputImage * 255).astype(np.uint8)
    trimap = (inputTrimap * 255).astype(np.uint8)
    back = back.astype(np.uint8)
    fore = fore.astype(np.uint8)
    unk = unk.astype(np.uint8)
    
    Image.fromarray(image).save('TestImage.png')
    Image.fromarray(trimap).save('TestTrimap.png')
    Image.fromarray(fore).save('Testfore.png')
    Image.fromarray(back).save('Testback.png')
    Image.fromarray(unk).save('Testunk.png')
    Image.fromarray(unk+back).save('TestImageEqual.png')

    return image, trimap, back, fore, unk
