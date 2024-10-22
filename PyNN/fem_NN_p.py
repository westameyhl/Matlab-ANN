import  tensorflow as tf
from    tensorflow.keras import optimizers
import csv
import os
import numpy as np

from matfileport import MatPort
from dense_library import create_dense


def clear_all():
    #Clears all the variables from the workspace of the spyder application.
    gl = globals().copy()
    for var in gl:
        if var[0] == '_': continue
        if 'func' in str(globals()[var]): continue
        if 'module' in str(globals()[var]): continue
        del globals()[var]
        

def create_directory(d_route):
    isexist = os.path.exists(d_route)
    if not isexist:
        os.makedirs(d_route)
        

def create_log(out, corr, y):
    logf = []
    for i in range(len(corr)):
        if not corr[i]:
            logline = []
            for j in out[i]:
                logline.append(j)
            logline.append(y[i])
            logf.append(logline)
    return(logf)
    

def create_dataset(x, type_x, depth_type, n_batch, x_max):
    #x = tf.convert_to_tensor(x, dtype=tf.float32) / 255.
    #y = tf.convert_to_tensor(y, dtype=tf.int32)
    #y = tf.one_hot(y, depth=10)
    x = tf.convert_to_tensor(x, dtype=tf.float32) / x_max
    type_x = tf.convert_to_tensor(type_x, dtype=tf.int32)
    type_x = tf.one_hot(type_x, depth=depth_type)
    print(x.shape, type_x.shape)
    xy_dataset = tf.data.Dataset.from_tensor_slices((x, type_x))
    xy_dataset = xy_dataset.batch(n_batch)
    return(x, type_x, xy_dataset)

r_date = '0715'

get_epoch = 27
#file_r = '0011'
#file_r = '0101'
file_r = '1110'


# main_route = 'E:\\Project_ExpNNFEM\\P1\\'
main_route = 'C:\\westame\\Project_ExpNNFEM\\P3\\'

#(x, y), (x_val, y_val) = datasets.mnist.load_data() 
train_route = main_route + 'Matlab\\DataNeuNet\\' + r_date + '\\train_10000_test_1000\\'
MatPort_NN = MatPort(train_route)
(x, x_val, y, y_val, info_xy) = MatPort_NN.auto_call_fem()


test_route = main_route + 'Matlab\\DataNeuNet\\' + r_date + '\\exp_' + file_r + '\\'
MatPort_EXP = MatPort(test_route)
(x_go, x_back, t_go, t_back, info_xy_v) = MatPort_EXP.auto_call_exp()


class Params:
    activate_function = 'relu'
    learning_r = 0.001
    t_i = 1
    all_epoch = 50
    n_train = x.shape[0]
    n_test_fem = x_val.shape[0]
    n_test_v = x_go.shape[0]
    mat_row = x.shape[1]
    mat_col = x.shape[2]
    n_batch = 200
    x_max = 5
    layer_list = [512, 128, 32, 5]
    hid_layers = len(layer_list) - 1
    list_end = layer_list[hid_layers]


(x, y, train_dataset) = create_dataset(x, y, Params.list_end, Params.n_batch, Params.x_max)
(x_val, y_val, test_dataset) = create_dataset(x_val, y_val, Params.list_end, Params.n_batch, Params.x_max)
(x_go, t_go, go_dataset) = create_dataset(x_go, t_go, Params.list_end, Params.n_batch, Params.x_max)
(x_back, t_back, back_dataset) = create_dataset(x_back, t_back, Params.list_end, Params.n_batch, Params.x_max)


# model = create_dense('relu')
model = create_dense(Params.activate_function, Params.layer_list)
# 学习率
optimizer = optimizers.SGD(learning_rate = Params.learning_r)


def train_epoch(train_data, epoch, log_csv):

    # Step4.loop
    for step, (x, y) in enumerate(train_data):

        with tf.GradientTape() as tape:
            # [b, 28, 28] => [b, 784]
            x = tf.reshape(x, (-1, Params.mat_row * Params.mat_col))
            # Step1. compute output
            # [b, 784] => [b, 10]
            out = model(x)
            # Step2. compute loss
            loss = tf.reduce_sum(tf.square(out - y)) / x.shape[0]
            #softmax_out=tf.nn.softmax(out) 
            #loss = -tf.reduce_sum(y*tf.math.log(tf.clip_by_value(softmax_out,1e-10,1.0)))

        # Step3. optimize and update w1, w2, w3, b1, b2, b3
        grads = tape.gradient(loss, model.trainable_variables)
        # w' = w - lr * grad
        optimizer.apply_gradients(zip(grads, model.trainable_variables))

        if step % 200 == 0:
            (total_test, out_fem, corr_fem, y_fem) = test_nn_mid(test_dataset)
            (total_go, out_go, corr_go, y_go) = test_nn_mid(go_dataset)
            (total_back, out_back, corr_back, y_back) = test_nn_mid(back_dataset)

            # print(epoch, step, 'loss:', loss.numpy())
            rows = [epoch + 1, step, loss.numpy(), total_test, total_go, total_back, Params.t_i, 
                    total_test/Params.n_test_fem, total_go/Params.n_test_v , total_back/Params.n_test_v] 
            Params.t_i = Params.t_i + 0.1
            #rows = [{'epoch':1, 'batch':22, 'loss':333}]
            log_csv.append(rows)
    if epoch == get_epoch:
        log_go = create_log(out_go, corr_go, y_go)
        log_back = create_log(out_back, corr_back, y_back)
        return(log_go, log_back, log_csv, True)
    else:
        return(0, 0, log_csv, False)
            

def test_nn_mid(test_data):
    total_correct = 0
    # Step4.loop
    for step, (x, y) in enumerate(test_data):

        with tf.GradientTape() as tape:
            # [b, 28, 28] => [b, 784]
            x = tf.reshape(x, (-1, Params.mat_row * Params.mat_col))
            # Step1. compute output
            # [b, 784] => [b, 10]
            out = model(x)
            pred = tf.argmax(out, axis=1) # 选取概率最大的类别
            y = tf.argmax(y, axis=1) # one-hot 编码逆过程
            correct = tf.equal(pred, y) # 比较预测值与真实值
            # 求和比较结果中所有True(转换为1)的数量，即为预测正确的数量：
            total_correct += tf.reduce_sum(tf.cast(correct, dtype=tf.int32)).numpy() # 统计预测正确的样本个数
    return (total_correct, out.numpy(), correct.numpy(), y.numpy())

        
def train(train_data):
    log_go = []
    log_back = []
    log_csv = []

    # train_epoch 函数负责训练网络，在该函数内部不断调用 test_nn_mid 函数检测准确率，并输出每一步的结果
    # 输出整体训练成果，以及在某个epoch (由参数get_epoch决定) 下的错误预测值
    for epoch in range(Params.all_epoch):
        (log_go_temp, log_back_temp, log_csv, bool_log) = train_epoch(train_data, epoch, log_csv)
        if bool_log:
            log_go = log_go_temp
            log_back = log_back_temp

    file_name ='Ep'+ str(Params.all_epoch) + '_' + Params.activate_function + '_Lr'+ str(Params.learning_r) + '_Hid' + str(Params.hid_layers)
    data_route = main_route + 'PyNN\\DataFile\\' + r_date + '\\' + file_name + '\\' + file_r
    create_directory(data_route)
    
    logfile_csv = data_route + '\\' + 'acc.csv'
    headers = ['epoch', 'batch', 'loss', 'accuracy', 'go', 'back', 't', 'acc_fem', 'acc_go', 'acc_back']
    with open(logfile_csv, 'w', newline = '')as f:
        f_csv = csv.writer(f, headers)
        for i in log_csv:
            f_csv.writerow(i)
        f.close()
        
    logfile_go = data_route + '\\' + 'go.csv'
    with open(logfile_go, 'w', newline = '')as f:
        f_csv = csv.writer(f)
        for i in log_go:
            f_csv.writerow(i)
        f.close()
        
    logfile_back = data_route + '\\' + 'back.csv'
    with open(logfile_back, 'w', newline = '')as f:
        f_csv = csv.writer(f)
        for i in log_back:
            f_csv.writerow(i)
        f.close()


if __name__ == '__main__':
    train(train_dataset)
 #   test_nn(test_dataset)
 #   test_nn(go_dataset)
 #   test_nn(back_dataset)
 