from keras.models import Sequential
from keras.layers import Dense
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from keras.utils import np_utils
import numpy
import os

# fix random seed for reproducibility

seed = 7
numpy.random.seed(seed)

cwd = os.getcwd()
print(cwd)
currentPath = cwd+"/output/NN/"
nnOutputPath = cwd+"/output/output_NN/" 

if not os.path.exists(nnOutputPath):
	os.makedirs(nnOutputPath)
os.chdir(currentPath)

# load indians dataset
trainData = numpy.loadtxt("train_NN.csv", delimiter=",")
testData = numpy.loadtxt("test_NN.csv", delimiter=",")
# split into input (X) 2 output (Y) variables
X = trainData[:,0:9]
Y = trainData[:,9]
X_train, X_val, y_train, y_val = train_test_split(X, Y, test_size=0.33, random_state=seed)

X_test = testData[:,0:9]
y_test = testData[:,9]

# convert integers to dummy variables (i.e. one hot encoding)
encoder = LabelEncoder()
encoder.fit(y_train)
encoded_Y = encoder.transform(y_train)
y_train = np_utils.to_categorical(encoded_Y)

encoder.fit(y_val)
encoded_Y = encoder.transform(y_val)
y_val = np_utils.to_categorical(encoded_Y)

encoder.fit(y_test)
encoded_Y = encoder.transform(y_test)
y_test = np_utils.to_categorical(encoded_Y)

# create model
model = Sequential()
model.add(Dense(8, input_dim=9, activation='tanh'))
model.add(Dense(128, activation='tanh'))
model.add(Dense(64, activation='tanh'))
model.add(Dense(10, activation='softmax'))
# Compile model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
# Fit the model
model.fit(X_train, y_train, validation_data=(X_val,y_val), epochs=150, batch_size=128)

score = model.evaluate(X_test, y_test, batch_size = 128, verbose=2)
 
print "Test Loss: ", score[0],"test Accuracy: ", score[1]

os.chdir(nnOutputPath)
model.save('a4model.h5')