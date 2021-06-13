# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

plt.close('all')

import os.path
#import matplotlib.image as mpimg
import cv2

savedir = 'D:/elena/Google Drive/titech/research/experiments/output/hsi/python'

def show_image(x, figTitle = None, hasGreyScale = False, fpath = ""):
    if hasGreyScale:
        plt.imshow(x, cmap='gray')
    else:
        plt.imshow(x)
    print(fpath + figTitle.replace(' ', '_') + '.jpg')
    if figTitle is not None:
        plt.title(figTitle)
        plt.savefig(fpath + figTitle.replace(' ', '_') + '.jpg')
    plt.show()
    
def load_images(folder):
    images = []
    for filename in os.listdir(folder):
        if '.jpg' in filename: 
            img = cv2.imread(os.path.join(folder, filename))
            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            img = img.astype('float32') / 255.0
            if img is not None:
                images.append(img)
    return images

import scipy.io
import h5py

import mat73
def load_raw_arrays(folder, indexes):
    rawHSI = []
    for i in range(len(indexes)):
        fname = folder + '\\' + str(indexes[i]) + '_target.mat'
        hsi = []
        #with h5py.File(fname, 'r') as f:
            #print(f.keys())
            #mat = scipy.io.loadmat(fname)
            #hsi = f['spectralData']
        mat = mat73.loadmat(fname)
        hsi = mat.spectralData 
        rawHSI.append(hsi)
    return rawHSI

def load_normalized_arrays(folder, indexes):
    rawHSI = []
    for i in range(len(indexes)):
        baseStr = folder + '\\' + str(indexes[i]) + '_'
        
        fname = baseStr + 'target.mat'
        mat = mat73.loadmat(fname)
        hsi = mat.spectralData 
        fname = baseStr + 'white.mat'
        mat = mat73.loadmat(fname)
        white = mat.fullReflectanceByPixel
        fname = baseStr + 'black.mat'
        mat = mat73.loadmat(fname)
        black = mat.blackReflectance
        normhsi = (hsi - black)  / (white - black + 0.0000001)
        rawHSI.append(normhsi)
    return rawHSI

import os

def makedir(fpath):
    try:
        os.mkdir(fpath)
    except OSError as error:
        print('folder exists')
        
def simple_plot(y, figTitle, xLabel, yLabel, fpath):
    plt.plot(np.arange(len(y))+1, y)
    plt.title(figTitle)
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    print(fpath + figTitle.replace(' ', '_') + '.jpg') #
    plt.savefig(fpath + figTitle.replace(' ', '_') + '.jpg')
    plt.show()

import math  

def plot_eigenvalues(pcComp, xVals, pcNum, fpath):
    for i, eigenvector in zip(np.arange(pcNum), pcComp):
        if i < max(math.floor(pcNum/2), 5) :  
            plt.plot(xVals, eigenvector, label='eigv'+str(i+1))
        else:
            plt.plot(xVals, eigenvector, '--', label='eigv'+str(i+1))
            
        plt.legend(loc='upper right')
        plt.title('Eigenvectors')
        plt.xlabel('wavelength')
        plt.ylabel('coefficient')
        plt.xlim([380,780])
        #plt.ylim([-0.1, 0.1]) #
        plt.savefig(fpath + 'eigenvectors' + str(pcNum) +'.jpg')
        plt.show()
    
from sklearn.decomposition import PCA

def prepare_pca_results(hsiList, savefolder="", rangeLimits = [420, 730]):
    w = np.arange(rangeLimits[0], rangeLimits[1]+1)
    if rangeLimits is not [380, 780]:
        hsiList = [x[:,:,w - rangeLimits[0]]for x in hsiList]
    curSavedir =  savedir + '//pca//' + savefolder + '//'
    makedir(curSavedir)
    #for i in range(len(hsiList)):
        #show_image(hsiList[i][:,:,200])   
    X = [np.reshape(x, (x.shape[0] * x.shape[1], x.shape[2])).transpose() for x in hsiList]
    stacked = np.concatenate(X, axis=1).transpose()
    pca = PCA(n_components=10)
    pca.fit(stacked)
    print('Explained variance', pca.explained_variance_ratio_)
    print('Singular values', pca.singular_values_)
    
    plt.figure(0)
    simple_plot(pca.explained_variance_ratio_, 'Explained variance', 'pc number', 'explained percentage', curSavedir)
    plt.figure(1)
    simple_plot(pca.singular_values_, 'Singular Values', 'pc number', 'value', curSavedir)
    
    plt.figure(2)
    trans = [pca.transform(x.transpose()) for x in X]
    for i in range(len(X)):
        for j in range(4):        
            img = trans[i][:,j].reshape((hsiList[i].shape[0], hsiList[i].shape[1]))
            img =  (img - np.min(img)) / (np.max(img) - np.min(img))
            show_image(img, 'pc' + str(j) + '(Im' + str(i) +')', True, curSavedir)
            
    print('Total pixels for pca fitting: ', hsiList[0].shape[0]*hsiList[0].shape[1] + hsiList[1].shape[0]*hsiList[1].shape[1], 'pixels' )
    
    plt.figure(3)
    plot_eigenvalues(pca.components_, w, 10, curSavedir)
    plt.figure(4)
    plot_eigenvalues(pca.components_, w, 3, curSavedir)

    print('finished')

indexes = [67, 94]
fpath = 'D:\elena\mspi\matfiles\hsi\calibTriplets'
hsiList = load_raw_arrays(fpath, indexes)

## Train pca with only these two images
prepare_pca_results(hsiList, savefolder="exp1_raw_full", rangeLimits = [380, 780])

## Pca including hands and after discarding top and bottom of spectrum 
plt.close('all')
prepare_pca_results(hsiList, savefolder="exp2_raw_cropped")

## Pca including hands and after discarding top and bottom of spectrum , after normalization
hsiList = load_normalized_arrays(fpath, indexes)
plt.close('all')
prepare_pca_results(hsiList, savefolder="exp3_norm_cropped")
