import numpy
import pandas
from keras.models import Sequential
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasClassifier
from keras.utils import np_utils
from keras.models import load_model
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.preprocessing import LabelEncoder
from sklearn.pipeline import Pipeline
import os

# fix random seed for reproducibility
seed = 7
numpy.random.seed(seed)

# load dataset
cwd = os.getcwd()
print(cwd)
currentPath = cwd+"/output/NN/"
nnOutputPath = cwd+"/output/output_NN/" 

if not os.path.exists(nnOutputPath):
	os.makedirs(nnOutputPath)

if os.path.exists(nnOutputPath+"modelAccuracy.txt"):
			os.remove(nnOutputPath+"modelAccuracy.txt")

filesList = os.listdir(currentPath) 
for file in filesList:
	if file.endswith(".csv"):
		filePath = os.path.join(currentPath, file)
		dataframe = pandas.read_csv(filePath, header=None)
		dataset = dataframe.values
		X = dataset[:,0:9].astype(float)
		Y = dataset[:,9]

		# encode class values as integers
		encoder = LabelEncoder()
		encoder.fit(Y)
		encoded_Y = encoder.transform(Y)
		# convert integers to dummy variables (i.e. one hot encoded)
		dummy_y = np_utils.to_categorical(encoded_Y)

		# define baseline models
		def baseline_model():
			# create model
			model = Sequential()
			model.add(Dense(8, input_dim=9, activation='relu'))
			model.add(Dense(128, activation='sigmoid'))
			model.add(Dense(32, activation='sigmoid'))
			# model.add(Dense(64, activation='tanh'))
			# model.add(Dense(512, activation='sigmoid'))
			model.add(Dense(10, activation='softmax'))
			# # Compile model
			model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
			model.save(nnOutputPath+str(file)[:-4]+'_model.h5')
			return model

		estimator = KerasClassifier(build_fn=baseline_model, epochs=200, batch_size=32, verbose=1)
		kfold = KFold(n_splits=10, shuffle=True, random_state=seed)
		results = cross_val_score(estimator, X, dummy_y, cv=kfold)
		print("Baseline: %.2f%% (%.2f%%)" % (results.mean()*100, results.std()*100))

		with open(nnOutputPath+"modelAccuracy.txt", "a") as current_model:
			current_model.write("User"+str(file)[2:4]+"\t"+str(results.mean()*100)+"\n")