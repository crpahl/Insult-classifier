import csv
import string

DATA_FILES = ['test_with_solutions.csv',
              'train.csv']

def preprocess():
    for file in DATA_FILES:
        #spellCheck()
        #createCSV()
        f = None
        p = True
        try:
            f = open("../data/" + file, 'rb')
            f2 = open("../data/processed_" + file, 'wb')
            fileWriter = csv.writer(f2, delimiter=',')
            fileReader = csv.reader(f, delimiter=',')
            fileReader.next()                           #Skip labels
            for row in fileReader:
                if p == True:
                    p = False;
                    comment = row[2]
                    words = stringToWords(comment)
                    print words
                    fileWriter.writerow(row[0:2] + words)
        finally:
            f.close()
            f2.close()

def stringToWords(comment):
    return ''.join([c for c in comment if c not in string.punctuation]).split()

def createCSV():
    pass

def spellCheck():
    pass
