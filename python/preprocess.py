""" NOTE: the pyenchant package is required to run this script
"""
import csv
import string
import enchant
import textmining
import datetime

from termDocumentMatrix import TermDocumentMatrix
from enchant.checker import SpellChecker
from enchant.tokenize import get_tokenizer, HTMLChunker, EmailFilter, URLFilter, WikiWordFilter

TEST = ('test_with_solutions.csv', 'test.csv')
TRAIN = ('train.csv', 'train.csv')

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

def preprocessBagOfWords(removeStopWords=True, addTime=True, maxDistance=3, count=None):
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
    timeAndDate = []
    tdm = TermDocumentMatrix()

    #TRAIN must be processed first in order to construct bag-of-words properly
    for dataFile in [TRAIN, TEST]:
        try:
            inputFile = open("../data/" + dataFile[0], 'rb')
            outputFile = open("../data/Y" + dataFile[1], 'wb')
            fileReader = csv.reader(inputFile, delimiter=',')
            fileWriter = csv.writer(outputFile, delimiter=',')
            fileReader.next() #Skip header labels

            if dataFile == TEST:
                tdm.clear_docs()
                addWords = False

            for row in fileReader:
		if addTime:
		    timeAndDate = getTimeAndDate(row[1])

                comment = row[2]
                insult = row[0]
                words = tokenizeAndSpellCheck(comment, removeStopWords=removeStopWords, \
					      maxDistance=maxDistance)
                tdm.add_doc(words, others=timeAndDate, addWordsToDictionary=addWords)
                fileWriter.writerow(insult)
        finally:
            if count and dataFile == TRAIN:
                tdm.remove_words(count)

            tdm.write_csv("../data/X" + dataFile[1], cutoff=1)
            inputFile.close()
            outputFile.close()

def tokenizeAndSpellCheck(comment, removeStopWords=False, maxDistance=3):
    """ Tokenizes the comment into words and spell checks each word with pyenchant.

        NOTE: Some major work may need to be done here to ensure we're getting the
        best features (words)
    """
    l = []
    for word in tokenizer(comment):
        suggestions = dictionary.suggest(word[0].lower())
        #Remove suggestions that have a space (multiple words). Also consider removing hyphenated words.
        #suggestions = filter(lambda x:' ' not in x, suggestions)

        if suggestions:
	    #Trying levenshtein distance instance of filtering
	    distance = levenshtein(word[0].lower(), suggestions[0].lower())
	    if distance <= maxDistance:
	        l.append(suggestions[0].lower())

    if removeStopWords:
        l = textmining.simple_tokenize_remove_stopwords(" ".join(l))
    
    return l

def getTimeAndDate(timeString):
    # binary representation of day of week
    
    if not timeString:
        return [1 for tmp in range(31)]
    
    dayData = [0 for tmp in range(7)]
    day = datetime.date(int(timeString[0:4]), int(timeString[4:6]), int(timeString[6:8]))
    dayData[day.isoweekday() - 1] = 100
    
    # binary representation of hour of day
    timeData = [0 for tmp in range(24)]
    timeData[int(timeString[8:10])] = 100
    
    dayData.extend(timeData)
    
    return dayData
    
def levenshtein(s1, s2):
    if len(s1) < len(s2):
        return levenshtein(s2, s1)
 
    # len(s1) >= len(s2)
    if len(s2) == 0:
        return len(s1)
 
    previous_row = xrange(len(s2) + 1)
    for i, c1 in enumerate(s1):
        current_row = [i + 1]
        for j, c2 in enumerate(s2):
            insertions = previous_row[j + 1] + 1 # j+1 instead of j since previous_row and current_row are one character longer
            deletions = current_row[j] + 1       # than s2
            substitutions = previous_row[j] + (c1 != c2)
            current_row.append(min(insertions, deletions, substitutions))
        previous_row = current_row
 
    return previous_row[-1]
