import csv
import string
import enchant

from enchant.checker import SpellChecker
from enchant.tokenize import get_tokenizer, HTMLChunker, EmailFilter, URLFilter, WikiWordFilter

DATA_FILES = ['test_with_solutions.csv',
              'train.csv']

dictionary = enchant.Dict("en_US")
tokenizer = get_tokenizer(tag="en_US", chunkers=[HTMLChunker], filters=[EmailFilter, URLFilter, WikiWordFilter])

def preprocess():
    """ Parses the comments from each csv file in DATA_FILES and creates a new
        correpsonding file with comments that have been delimited into words
        that have been spell checked.
    """
    for dataFile in DATA_FILES:
        inputFile = None
        try:
            inputFile = open("../data/" + dataFile, 'rb')
            outputFile = open("../data/processed_" + dataFile, 'wb')
            fileReader = csv.reader(inputFile, delimiter=',')
            fileWriter = csv.writer(outputFile, delimiter=',')
            fileReader.next() #Skip header labels

            for row in fileReader:
                comment = row[2]
                words = tokenizeAndSpellCheck(comment)
                fileWriter.writerow(row[0:2] + words)
        finally:
            inputFile.close()
            outputFile.close()

def tokenizeAndSpellCheck(comment):
    """ Tokenizes the comment into words and spell checks each word with pyenchant.
    """
    l = []
    for word in tokenizer(comment):
        suggestions = dictionary.suggest(word[0])
        if suggestions:
            l.append(suggestions[0])
    
    return l
