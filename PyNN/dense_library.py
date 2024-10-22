# -*- coding: utf-8 -*-
"""
Created on Fri May 27 13:07:17 2022

@author: westame
"""
from tensorflow import keras
from tensorflow.keras import layers


def create_dense(activate_function, layer_list):
    
    keras_list =[0] * len(layer_list)
    for i in range(len(layer_list) - 1):
        keras_list[i] = layers.Dense(layer_list[i], activation = activate_function)
    keras_list[i+1] = layers.Dense(layer_list.pop())
    
    model_dense = keras.Sequential(keras_list)
    return model_dense 