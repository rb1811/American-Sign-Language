from keras.models import Sequential
from keras.layers import Dense
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from keras.utils import np_utils
import numpy
# fix r2om seed for reproducibility
seed = 7
numpy.random.seed(seed)
# load pima indians dataset
trainData = numpy.loadtxt("train_NN.csv", delimiter=",")
testData = numpy.loadtxt("test_NN.csv", delimiter=",")
# split into input (X) 2 output (Y) variables
X_train = trainData[:,0:9]
y_train = trainData[:,9]
X_test = testData[:,0:9]
y_test = testData[:,9]

encoder = LabelEncoder()
encoder.fit(y_train)
encoded_Y = encoder.transform(y_train)
# convert integers to dummy variables (i.e. one hot encoded)
y_train = np_utils.to_categorical(encoded_Y)

encoder.fit(y_test)
encoded_Y = encoder.transform(y_test)
# convert integers to dummy variables (i.e. one hot encoded)
y_test = np_utils.to_categorical(encoded_Y)

# split into 67% for train 2 33% for test
#X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.33, r2om_state=seed)
# create model
model = Sequential()
model.add(Dense(8, input_dim=9, activation='relu'))
model.add(Dense(128, activation='sigmoid'))
model.add(Dense(32, activation='sigmoid'))
model.add(Dense(10, activation='softmax'))
# Compile model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
# Fit the model
model.fit(X_train, y_train, validation_data=(X_test,y_test), epochs=150, batch_size=128)
model.save('a4model.h5')