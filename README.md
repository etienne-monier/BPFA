# BPFA algorithm

### Description

Beta Process Factor Analysis algorithm. The paper could be found [here](http://people.ee.duke.edu/~lcarin/BPFA_HSI_6.pdf).

### Usage

#### Arguments

1. Y (2D or 3D double array): The (possibly multi-band) image. Note that in the case of a 3D image, the last dimension is the spectrum axis.
2. mask (2D logical array): The sampling mask. true means the pixel has been acquired. false means it did not.
3. PatchSize (int): The patch width (and height).
  
#### Keyword Arguments

1. iter (int): The number of iterations. Default is 100.
2. K (int): The number of dictionaries. Default is 128.
3. step (int): The step number (see note). Default is 1.

#### Returns

Xhat (2D or 3D double array): The reconstructed array.

#### Note
 In the case of really big images, one has to reduce computational costs (at least when the processing exceeds 1h15m). Two methods are possible:
1. Reduce the Patch size.
2. Reduce the number of patches.

 The second point is made possible by not taking all the possible patches, i.e. by reducing overlaping. The step optional parameter set the number of pixels between two patches in both x and y dimensions. Setting a higher value of step will reduce computational cost but it will also degrade the reconstruction.

### Example

```
     Xhat = BPFA(Y, mask, 15)
     Xhat = BPFA(Y, mask, 15, 'iter', 50)
     Xhat = BPFA(Y, mask, 15, 'iter', 50, 'step', 3)
```

### Author and License:

This code was improved by Etienne Monier (https://github.com/etienne-monier) based on a code developed by Zhengming Xing, Duke University (https://zmxing.github.io/).

The previous code did not have any license. Then, this repository is shared under MIT License.