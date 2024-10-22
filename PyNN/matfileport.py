# -*- coding: utf-8 -*-
"""
Created on Wed May 11 15:37:33 2022

@author: westame
"""

from scipy.io import loadmat


class MatPort(object):
# matlab侧的接口
    def __init__(self, main_route):
        self.main_route = main_route
    
    def one_call(self, file_name):
        # 读取一个mat文件，输入文件名不带 '.mat'， 文件名和数据变量名需要一致
        call_file = self.main_route + file_name + '.mat'
        orig_mat = loadmat(call_file)
        data_mat = orig_mat[file_name]
        return data_mat
    
    def auto_call_fem(self):
        # 读取该文件夹下全部数据
        sample_train = self.one_call('sample_train')
        sample_test = self.one_call('sample_test')
        type_train = self.one_call('type_train')
        type_train = type_train[:,0]
        type_test = self.one_call('type_test')
        type_test = type_test[:,0]
        sample_info = self.one_call('sample_info')
        return (sample_train, sample_test, type_train, type_test, sample_info)
    
    def auto_call_exp(self):
        # 读取该文件夹下全部数据
        sample_go = self.one_call('sample_go')
        sample_back = self.one_call('sample_back')
        type_go = self.one_call('type_go')
        type_go = type_go[:,0]
        type_back = self.one_call('type_back')
        type_back = type_back[:,0]
        sample_info = self.one_call('sample_info')
        return (sample_go, sample_back, type_go, type_back, sample_info)
