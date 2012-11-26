""" NOTE: the pyenchant package is required to run this script
"""
import csv
import string
import enchant
import textmining

from termDocumentMatrix import TermDocumentMatrix
from enchant.checker import SpellChecker
from enchant.tokenize import get_tokenizer, HTMLChunker, EmailFilter, URLFilter, WikiWordFilter

TEST = 'test_with_solutions.csv'
TRAIN = 'train.csv'

dictionary = enchant.Dict("en_US")
tokenizer = get_tokenizer(tag="en_US", chunkers=[HTMLChunker], filters=[EmailFilter, URLFilter, WikiWordFilter])

def preprocessSpellCheck():
    """ Parses the comments from each csv file in DATA_FILES and creates a new
        correpsonding file with comments that have been delimited into words
        that have been spell checked.
    """
    for dataFile in DATA_FILES:
        try:
            inputFile = open("../data/" + dataFile, 'rb')
            outputFile = open("../data/spellChecked_" + dataFile, 'wb')
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

def preprocessBagOfWords():
    """ Creates a new bag-of-words csv for each csv in DATA_FILES. Each entry in the
        bag-of-words csv represents the number of times the corresponding word occurs
        in the comment.

        NOTE: The list of words each comment is compared against is compiled from every
        word in the test set. From what I've read so far, selecting useful features,
        or words in our case, can be tricky. Some things to consider are:

            - Ignore stop words (you, a, if, etc...)
            - Don't include words that occur rarely -- for example, a word only seen
              in a single comment
            - Consider different methods of tokenizing words -- for example, should we also
              include numbers, grammar, internet words (memes), etc...
            - How to accurately replace words that are mispelled. Should we always take the
              first suggestion or should we have some sort of heuristic?
            - May want to replace multiple variants of one word (fucker, fucking, fuck)
              with one common word (fuck) to reduce features
    """
    addWords = True
    tdm = TermDocumentMatrix()

    #TRAIN must be processed first in order to construct bag-of-words properly
    for dataFile in [TRAIN, TEST]:
        try:
            inputFile = open("../data/" + dataFile, 'rb')
            outputFile = open("../data/Y_" + dataFile, 'wb')
            fileReader = csv.reader(inputFile, delimiter=',')
            fileWriter = csv.writer(outputFile, delimiter=',')
            fileReader.next() #Skip header labels

            if dataFile == TEST:
                tdm.clear_docs()
                addWords = False

            for row in fileReader:
                comment = row[2]
                insult = row[0]
                words = tokenizeAndSpellCheck(comment, removeStopWords=True)
                tdm.add_doc(words, addWordsToDictionary=addWords)
                fileWriter.writerow(insult)
        finally:
            tdm.write_csv("../data/X_bagOfWords_" + dataFile, cutoff=1)
            inputFile.close()
            outputFile.close()

def tokenizeAndSpellCheck(comment, removeStopWords=False):
    """ Tokenizes the comment into words and spell checks each word with pyenchant.

        NOTE: Some major work may need to be done here to insure we're getting the
        best features (words)
    """
    l = []
    for word in tokenizer(comment):
        suggestions = dictionary.suggest(word[0])
        #Remove suggestions that have a space (multiple words). Also consider removing hyphenated words.
        suggestions = filter(lambda x:' ' not in x, suggestions)
        if suggestions:
            l.append(suggestions[0])

    if removeStopWords:
        l = textmining.simple_tokenize_remove_stopwords(" ".join(l))
    
    return l
