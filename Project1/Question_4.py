
# coding: utf-8

# In[38]:

from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import PolynomialFeatures
from sklearn import linear_model
from sklearn.cross_validation import cross_val_predict, cross_val_score
import numpy as np
from sklearn.metrics import mean_squared_error
from math import sqrt
import pandas as pd
import matplotlib.pyplot as plt

import statsmodels.formula.api as sm

data = pd.read_csv("housing_data.csv")

data = data.astype(float)
X = data.ix[:, 0:13].values
y= data.ix[:,13].values

data.columns = ['CRIM', 'ZN', 'INDUS', 'CHAS', 'NOX', 'RM', 'AGE', 'DIS', 'RAD', 'TAX', 'PTRATIO', 'B', 'LSTAT', 'MEDV']

#model = sm.ols('MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + B + LSTAT - 1', data).fit()
#print (model.summary())

reg = linear_model.LinearRegression()

y_predicted = cross_val_predict(reg, X, y, cv=10)
print ('RMSE is: ', sqrt(mean_squared_error(y,y_predicted)))

cv_scores = cross_val_score(reg, X, y,scoring = 'mean_squared_error', cv=10)

print("Linear Regression")

print ('Average RMSE: ', (sum(abs(cv_scores))/10.0)**0.5)
print ('Best RMSE: ', np.min((abs(cv_scores))**0.5))

fig, ax = plt.subplots()
ax.scatter(x=y, y=y_predicted)
ax.plot([y.min(), y.max()], [y.min(), y.max()],  'k--', lw=4)
ax.set_xlabel('Actual')
ax.set_ylabel('Fitted')
plt.show()



y_residual = y - y_predicted
fig, ax = plt.subplots()
ax.scatter(y_predicted, y_residual)
ax.set_xlabel('Fitted')
ax.set_ylabel('Residual')
plt.show()


rmse_degree = []

for deg in range(1,8):
    regr = make_pipeline(PolynomialFeatures(deg),linear_model.LinearRegression())
    y_predicted = cross_val_predict(regr, X, y, cv = 10)
    cv_scores = cross_val_score(regr, X, y,  cv=10)
    print ('---- Polynomial degree ----', deg)
    #print ('RMSE is: ', sqrt(mean_squared_error(y, y_predicted)))
    #print ('Average RMSE: ', (sum(abs(cv_scores))/10.0)**0.5)
    #print ('Best RMSE: ', np.min(abs(cv_scores)**0.5))
    rmse_degree.append((sum(abs(cv_scores))/10.0)**0.5)

    fig, ax = plt.subplots()
    ax.scatter(x=y, y=y_predicted)
    ax.plot([y.min(), y.max()], [y_predicted.min(), y_predicted.max()],  'k--', lw=4)
    ax.set_xlabel('Actual')
    ax.set_ylabel('Fitted')
    
    plt.show()
    
print ('Average RMSE of all degrees: ', rmse_degree)
#plt.figure()
#plt.plot(range(1,len(rmse_degree)+1), rmse_degree,color='blue', linewidth=3)


# In[ ]:




# In[ ]:



