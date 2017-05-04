
# coding: utf-8

# In[3]:

import pandas as pd
import calendar
from sklearn.ensemble import RandomForestRegressor
from math import sqrt
from sklearn.metrics import mean_squared_error
from sklearn import tree

def encode_day_names(days):
    day_to_num = dict(zip(list(calendar.day_name), range(1, 8)))
    return [day_to_num[day] for day in days]

def encode_files(files):
    for i in range(len(files)):
        files[i]=int (files[i].split('_')[-1])
    return files

def encode_work_flows(work_flows):
    for i in range(len(work_flows)):
        work_flows[i]=int (work_flows[i].split('_')[-1])
    return work_flows

data = pd.read_csv("network_backup_dataset.csv")

X = data.ix[:, [0, 1, 2, 3, 4]].values
X[:, 1] = encode_day_names(X[:, 1])
X[:, 3] = encode_work_flows(X[:, 3])
X[:, 4] = encode_files(X[:, 4])

y = data.ix[:, 5].values



rfr = RandomForestRegressor(
        n_estimators = 20,
        max_depth = 4,
        max_features = 5
        )

rfr.fit(X, y)
y_predicted = rfr.predict(X)

rmse = sqrt(mean_squared_error(y, y_predicted))
print("RMSE: " , rmse)

print("IMPORTANCE of features: " , rfr.feature_importances_)



# In[ ]:



