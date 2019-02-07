# BPFA algorithm

### Description

Beta Process Factor Analysis algorithm. The paper could be found [here](http://people.ee.duke.edu/~lcarin/BPFA_HSI_6.pdf).

The code is a MATLAB implementation of BPFA with a Python function to call the MATLAB code. 

The Python extensions saves the MATLAB code input data, then executes the MATLAB code, then gets the output data for Python post-processing.

### MATLAB code usage

Function file: BPFA/BPFA.m

#### Arguments

| Name      | Type                  | Description                                                                                                    |
| :------   | :-------              | :-------------                                                                                                 |
| Y         | 2D or 3D double array | The (possibly multi-band) image. Note that in the case of a 3D image, the last dimension is the spectrum axis. |
| mask      | 2D logical array      | The sampling mask. true means the pixel has been acquired. false means it did not.                             |
| PatchSize | int                   | The patch width (and height).                                                                                  |
  
#### Keyword Arguments

| Name    | Type     | Description                                 |
| :------ | :------- | :-------------                              |
| iter    | int      | The number of iterations. Default is 100.   |
| K       | int      | The number of dictionaries. Default is 128. |
| step    | int      | The step number (see note). Default is 1.   |

#### Returns

Xhat (2D or 3D double array): The reconstructed array.

#### Note
 In the case of really big images, one has to reduce computational costs (at least when the processing exceeds 1h15m). Two methods are possible:
1. Reduce the Patch size.
2. Reduce the number of patches.

 The second point is made possible by not taking all the possible patches, i.e. by reducing overlaping. The step optional parameter set the number of pixels between two patches in both x and y dimensions. Setting a higher value of step will reduce computational cost but it will also degrade the reconstruction.

#### Example

```
     Xhat = BPFA(Y, mask, 15)
     Xhat = BPFA(Y, mask, 15, 'iter', 50)
     Xhat = BPFA(Y, mask, 15, 'iter', 50, 'step', 3)
```

### Python code usage

Function file: BPFA_for_Python/BPFA.py

#### First note

To have access to the BPFA code and to be able to import it, add its path to the PYTHONPATH.

As an example, in Linux, you can add the following lines to your .bashrc:

```
export PYTHONPATH="$PYTHONPATH:/home/path_to_module/BPFA_for_Python/"
``` 

#### Arguments

| Name    | Type                 | Description           |
| :------ | :-------             | :-------------        |
| Y       | 2D or 3D Numpy array | The input data.       |
| mask    | 2D Numpy array       | The acquisition mask. |

#### Keyword Arguments

| Name      | Type     | Description                                                                  |
| :------   | :------- | :-------------                                                               |
| PatchSize | int      | The patch size. Default is 5.                                                |
| Omega     | int      | The Omega parameter. Default is 1.                                           |
| K         | int      | The dictionary dimension. Default is 128.                                    |
| iter      | int      | The number of iterations. Default is 100.                                    |
| step      | int      | The distance between two consecutive patches. Default is 1 for full overlap. |
| verbose   | bool     | The verbose parameter. Default is True.                                      |

#### Returns

| Name    | Type                 | Description                                                                       |
| :------ | :-------             | :-------------                                                                    |
| Xhat    | 2D or 3D Numpy array | The reconstructed image.                                                          |
| InfoOut | dictionary           | Dictionary containing the following informations: 'dt' which is the elapsed time. |

#### Example

```
     import BPFA
     Xhat, infoOut = BPFA.BPFA(Y, mask, PathchSize=15)
     Xhat, infoOut = BPFA.BPFA(Y, mask, PathchSize=15, iter=50)
     Xhat, infoOut = BPFA.BPFA(Y, mask, PathchSize=15, iter=50, step=3)
```


### MATLAB and Python versions

The repository code has been developped on MATLAB 2017 and Python 3.5.

### Author and License:

This code was improved by Etienne Monier (https://github.com/etienne-monier) based on a code developed by Zhengming Xing, Duke University (https://zmxing.github.io/).

The previous code did not have any license. Then, this repository is shared under MIT License.