import numpy
import pandas
from keras.models import Sequential
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasClassifier
from keras.utils import np_utils
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.preprocessing import LabelEncoder
from sklearn.pipeline import Pipeline

# fix random seed for reproducibility
seed = 7
numpy.random.seed(seed)

# load dataset
dataframe = pandas.read_csv("neuraldata.csv", header=None)
dataset = dataframe.values
X = dataset[:,0:9].astype(float)
Y = dataset[:,9]

# encode class values as integers
encoder = LabelEncoder()
encoder.fit(Y)
encoded_Y = encoder.transform(Y)
# convert integers to dummy variables (i.e. one hot encoded)
dummy_y = np_utils.to_categorical(encoded_Y)


# define baseline model
def baseline_model():
	# create model
	model = Sequential()
	model.add(Dense(128, input_dim=9, activation='relu'))
	model.add(Dense(32, activation='sigmoid'))
	model.add(Dense(10, activation='softmax'))
	# Compile model
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	model.save('my_model.h5')
	return model

estimator = KerasClassifier(build_fn=baseline_model, epochs=100, batch_size=32, verbose=1)

kfold = KFold(n_splits=10, shuffle=True, random_state=seed)

results = cross_val_score(estimator, X, dummy_y, cv=kfold)
print("Baseline: %.2f%% (%.2f%%)" % (results.mean()*100, results.std()*100))

# model.save('my_model.h5')  categorical_crossentropy
