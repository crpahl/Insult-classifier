""" 
A slighty modified version of the TermDocumentMatrix from the textmining package.
"""
import operator
import csv

class TermDocumentMatrix:

    """
    Class to efficiently create a term-document matrix.

    The only initialization parameter is a tokenizer function, which should
    take in a single string representing a document and return a list of
    strings representing the tokens in the document. If the tokenizer
    parameter is omitted it defaults to using textmining.simple_tokenize

    Use the add_doc method to add a document (document is a string). Use the
    write_csv method to output the current term-document matrix to a csv
    file. You can use the rows method to return the rows of the matrix if
    you wish to access the individual elements without writing directly to a
    file.

    """

    def __init__(self):
        # The term document matrix is a sparse matrix represented as a
        # list of dictionaries. Each dictionary contains the word
        # counts for a document.
        self.sparse = []
        # a parallel list for additional features to be appended to the
        # end of the bow vector.
        self.otherFeatures = []
        # Keep track of the number of documents containing the word.
        self.doc_count = {}

    def add_doc(self, words, others=[], addWordsToDictionary=True):
        """Add document to the term-document matrix."""
        # Count word frequencies in this document
        word_counts = {}
        for word in words:
            word_counts[word] = word_counts.get(word, 0) + 1
        # Add word counts as new row to sparse matrix
        self.sparse.append(word_counts)
        self.otherFeatures.append(others)
        
        if addWordsToDictionary:
            # Add to total document count for each word
            for word in word_counts:
                self.doc_count[word] = self.doc_count.get(word, 0) + 1

    def clear_docs(self):
        """Clear all currently added docs but retain the dictionary"""
        self.sparse = []

    def remove_words(self, count):
        """Keep the 'count' most frequently used words"""
        doc_count_sorted = sorted(self.doc_count.iteritems(), key=operator.itemgetter(1), reverse=True)
        self.doc_count = {}
        for entry in doc_count_sorted[:count]:
            self.doc_count[entry[0]] = entry[1]

    def rows(self, cutoff=2):
        """Helper function that returns rows of term-document matrix."""
        # Get master list of words that meet or exceed the cutoff frequency
        words = [word for word in self.doc_count \
          if self.doc_count[word] >= cutoff]
        # Return header
        yield words
        # Loop over rows
        for row, other in zip(self.sparse, self.otherFeatures):
            # Get word counts for all words in master list. If a word does
            # not appear in this document it gets a count of 0.
            data = [row.get(word, 0) for word in words]
            data.extend(other)
            yield data

    def write_csv(self, filename, cutoff=2):
        """
        Write term-document matrix to a CSV file.

        filename is the name of the output file (e.g. 'mymatrix.csv').
        cutoff is an integer that specifies only words which appear in
        'cutoff' or more documents should be written out as columns in
        the matrix.

        """
        f = csv.writer(open(filename, 'wb'))
        for row in self.rows(cutoff=cutoff):
            f.writerow(row)
