# -*- coding: utf-8 -*-
"""
Created on Thu Jun 10 23:11:16 2021

@author: foxel
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import tensorflow as tf

from sklearn.metrics import accuracy_score, precision_score, recall_score
from sklearn.model_selection import train_test_split
from tensorflow.keras import layers, losses
from tensorflow.keras.datasets import fashion_mnist
from tensorflow.keras.models import Model

import os.path
#import matplotlib.image as mpimg
import cv2

def show_image(x):
    plt.imshow(x)
    
def load_images(folder, x = 50, y = 50, w = 800, h = 800):
    images = []
    origListdir = os.listdir(folder)
    for filename in origListdir:
        if '.jpg' in filename: 
            img = cv2.imread(os.path.join(folder, filename))
            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            #img = mpimg.imread(os.path.join(folder, filename))
            #print(img.min(), img.max())
            crop_img = img[y:y+h, x:x+w]
            #plt.imshow(crop_img)
            crop_img = crop_img.astype('float32') / 255.0
            if crop_img is not None:
                images.append(crop_img)
    images = images[1:]
    return images


fpath = "D:/elena/Google Drive/titech/research/experiments/output/hsi/handsOnly/normalized"
allImage = load_images(fpath) 
allImage = np.array(allImage) #, dtype=object
plt.imshow(allImage[0])

from sklearn.model_selection import train_test_split
X_train, X_test = train_test_split(allImage, test_size=0.1, random_state=42)
print(X_train.shape, X_test.shape)

from keras.layers import Dense, Flatten, Reshape, Input, InputLayer
from keras.models import Sequential, Model

def build_autoencoder(img_shape, code_size):
    # The encoder
    encoder = Sequential()
    encoder.add(InputLayer(img_shape))
    encoder.add(Flatten())
    encoder.add(Dense(code_size, activation='relu'))

    # The decoder
    decoder = Sequential()
    decoder.add(InputLayer((code_size,)))
    decoder.add(Dense(np.prod(img_shape), activation='sigmoid')) # np.prod(img_shape) is the same as 32*32*3, it's more generic than saying 3072
    decoder.add(Reshape(img_shape))

    return encoder, decoder


input_shape = allImage.shape[1:]
print(input_shape)
encoder, decoder = build_autoencoder(input_shape, 1024)

inp = Input(input_shape)
code = encoder(inp)
reconstruction = decoder(code)

autoencoder = Model(inp,reconstruction)
#autoencoder.compile(optimizer='adamax', loss='mse')
autoencoder.compile(optimizer='adam', loss=losses.MeanSquaredError())

print(autoencoder.summary())

history = autoencoder.fit(x=X_train, y=X_train, epochs=20, validation_data=(X_test, X_test))
                          
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')
plt.show()

def reconstruct(img, encoder, decoder):
    # img[None] will have shape of (1, 32, 32, 3) which is the same as the model input
    code = encoder.predict(img[None])[0]
    reco = decoder.predict(code[None])[0]   
    return reco

def visualize(img,encoder,decoder):
    """Draws original, encoded and decoded images"""
    code = encoder.predict(img[None])[0]
    reco = decoder.predict(code[None])[0]

    plt.subplot(1,3,1)
    plt.title("Original")
    show_image(img)

    plt.subplot(1,3,2)
    plt.title("Code")
    plt.imshow(code.reshape([code.shape[-1]//2,-1]))

    plt.subplot(1,3,3)
    plt.title("Reconstructed")
    show_image(reco)
    plt.show()

for i in range(len(X_test)):
    img = X_test[i]
    visualize(img,encoder,decoder)
    

reconstructed = []
n = len(X_train)+1
plt.figure(figsize=(20, 4))
for i in range(n):
    if i == (n-1):
        img = X_test[0]
    else:
        img = X_train[i]
    reconstructed.append(reconstruct(img, encoder, decoder))
# display original
    ax = plt.subplot(2, n, i + 1)
    show_image(img)
    plt.title("original")
#      plt.gray()
    ax.get_xaxis().set_visible(False)
    ax.get_yaxis().set_visible(False)
# display reconstruction
    ax = plt.subplot(2, n, i + 1 + n)
    show_image(reconstructed[i])
    plt.title("reconstructed")
#      plt.gray()
    ax.get_xaxis().set_visible(False)
    ax.get_yaxis().set_visible(False)
plt.show()