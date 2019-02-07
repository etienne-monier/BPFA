#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# OS
import os
from os.path import join, dirname

# Numpy
import numpy as np

# Scipy
import scipy.io as sio

# Others
import time
import warnings


def BPFA_matlab(Y, mask, **kwargs):
    """
    Implements the BPFA code for Python.

    Args:
        Y (2D or 3D Numpy array): The input data.
        mask (2D Numpy array): The acquisition mask.

    Keyword Args:
        PatchSize (int): The patch size. Default is 5.
        Omega (int): The Omega parameter. Default is 1.
        K (int): The dictionary dimension. Default is 128.
        iter (int): The number of iterations. Default is 100.
        step (int): The distance between two consecutive patches. Default is 1 for full overlap.
        verbose (bool): The verbose parameter. Default is True.

    Returns:
        Xhat (2D or 3D Numpy array): The reconstructed image.
        InfoOut (dictionary): Dictionary containing the following informations: 'dt' which is the elapsed time.
    """

    ##
    ## Catch keyword parameters.
    ##

    # Default values
    PatchSize = 5
    Omega = 1
    K = 128
    Niter = 100
    step = 1
    verbose = True

    # Catch input
    for key, value in kwargs.items():

        if key.upper() == 'PATCHSIZE':
            if type(value) is not int:
                raise ValueError('The patch size parameter is not an integer.')
            if value <= 0 or value > np.min(Y.shape[:2]):
                raise ValueError('The patch size should lay between 1 and {}.'.format(np.min(Y.shape[:2])))
            PatchSize = value

        elif key.upper() == 'OMEGA':
            if type(value) is not int and type(value) is not float:
                raise ValueError('The Omega parameter is not an integer nor a float.')
            if value <= 0:
                raise ValueError('The Omega should be positive.')
            Omega = value

        elif key.upper() == 'K':
            if type(value) is not int:
                raise ValueError('The K parameter is not an integer.')
            if value <= 0:
                raise ValueError('The K should be positive.')
            K = value

        elif key.upper() == 'ITER':
            if type(value) is not int:
                raise ValueError('The iter parameter is not an integer.')
            if value <= 0:
                raise ValueError('The iter should be positive.')
            Niter = value

        elif key.upper() == 'STEP':
            if type(value) is not int:
                raise ValueError('The step parameter is not an integer.')
            if value <= 0:
                raise ValueError('The step should be positive.')
            step = value

        elif key.upper() == 'VERBOSE':
            if type(value) is not bool:
                raise ValueError('The verbose parameter is not boolean.')
            verbose = value

        else:
            warnings.warn('Unknown keyword argument: {}.'.format(key))

    ##
    ## Sets the data name files.
    ##
    dateStr = time.strftime('%A-%d-%B-%Y-%Hh%Mm%Ss', time.localtime())

    inName = join(dirname(__file__), '../BPFA/InOut/BPFA_in_{}.mat'.format(id(dateStr)))
    outName = join(dirname(__file__), '../BPFA/InOut/BPFA_out_{}.mat'.format(id(dateStr)))

    ##
    ## Execute program.
    ##

    # Arguments.
    Dico = {'Y': Y,
            'mask': mask,
            'PatchSize': PatchSize,
            'Omega': Omega,
            'K': K,
            'iter': Niter,
            'Step': step,
            'outName': outName,
            'verbose': verbose}

    # Save temp data
    sio.savemat(inName, Dico)

    # Execute program.
    cwd = join(dirname(__file__), '../BPFA/')
    os.system("matlab -nodesktop -nosplash -nodisplay -sd '{}' -r ' disp(\"Matlab Code ------------\"); disp(\"Loading data ...\"); load(\"{}\"); run BPFA_for_python.m; quit;' | tail -n +11".format(cwd, inName))

    # Get output data
    data = sio.loadmat(outName)
    Xhat = data['Xhat']
    dt = data['time']

    # rm out and in
    os.remove(inName)
    os.remove(outName)

    InfoOut = {'time': dt}

    return (Xhat, InfoOut)
