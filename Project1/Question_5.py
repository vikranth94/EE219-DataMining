
# coding: utf-8

# In[ ]:




# In[17]:

import pandas as pd
from sklearn.linear_model import RidgeCV,LassoCV
from math import sqrt
from sklearn.metrics import mean_squared_error

data = pd.read_csv("housing_data.csv")
X = data.ix[:, 0:13].values
Y= data.ix[:,13].values

#partARidge

alphaValues =  [1,0.1,0.01,0.001]
ridge = RidgeCV(normalize=True,alphas=alphaValues, cv=10)
ridge.fit(X, Y)
prediction = ridge.predict(X)

print("RIDGE REGRESSION")
print ("Best Alpha value :" + str(ridge.alpha_))
print ("Coefficient values:\n" + str(ridge.coef_))
print ('Best RMSE :', sqrt(mean_squared_error(Y, prediction)),'\n')


#partBLasso

alphaValues =  [1,0.1,0.01,0.001]
lasso = LassoCV(normalize=True,alphas=alphaValues, cv=10)
lasso.fit(X, Y)
prediction = lasso.predict(X)

print("LASSO REGRESSION")
print ("Best Alpha value :" + str(ridge.alpha_))
print ("Coefficient values:\n" + str(lasso.coef_))
print ('Best RMSE :', sqrt(mean_squared_error(Y, prediction)))


# In[ ]:



