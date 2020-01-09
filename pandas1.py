#panda write
import pandas as pd
import xlsxwriter
from pandas import *

informations = {'stt':[1,2,3,4,5,6,7,8,9],
                'name': ['nhan1', 'nhan2','nhan3','nhan4','nhan5','nhan6','nhan7','nhan8','nhan9'],
                'classes':['43k22','43k23','43k24','43k25','43k26','43k27','43k31','43k234','43k01']}
df = pd.DataFrame(informations)



print(df.head(2))
print("==========================================")
print(df.tail())
print('==========================================')
print(df.set_index("stt"))
print('==========================================')
print(df.reset_index)
print('==========================================')
print(df['name'])
print('==========================================')
print(df['classes'])


'''#write to excel
writer = pd.ExcelWriter('sample.xlsx' ,engine = 'xlsxwriter')
df.to_excel(writer, sheet_name = 'sheet1')
writer.save()

#padas read
import xlrd
df1 = pd.read_excel('worldbank.xlsx', sheet_name='GDP')

b = df1.set_index('date', inplace = False)

print (b)
print('==================')'''








