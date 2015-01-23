# Automated Insult Detection

Insults and abuse on the Internet are becoming a growing problem as we become
 increasingly connected. Anonymity and a lack of supervision has led to an increasing number of
 insults in forums that try to promote communication.
 An accurate, single-class classifier operating in real-time could automate
 or facilitate the removal of a large number of these insults.
 We would no longer have to completely rely on moderators or the user-base
 to expunge every insult which will hopefully lead the way to more abuse-free
 discourse on the Internet.
 
The goal is to create a single-class classifier that can determine if a
 comment that has been addressed to another person in a blog/forum conversation
 is insulting.
 The predictions are in the range [0,1] where 1 indicates 100% confidence that the comment was insulting.
 We will only be looking at comments that are addressing other participants
 in the conversation.
 We will consider insults that have been addressed to non-participants (such
 as celebrities, politicians, or other well known public figures) to be
 non insulting for the purposes of this problem.
 We will also have to account for a wide range of possible insults which
 may or may not contain profanity, racial slurs, or other offensive language.
 In addition, a comment that contains offensive language, but is not insulting
 to another participant in the conversation will not be considered insulting.
 Also, the insults that we are attempting to classify will not be subtle
 (such as insults using sarcasm, or Internet memes).

The data set that we are using comes from a machine learning competition
 on Kaggle, a website that hosts predictive modeling competitions.
 The data set consists of a training set containing 3948 entries and testing
 set containing 2648 entries.
 Each entry in the training and testing set has a time attribute in the
 form YYYYMMDDhhmmss, and the corresponding comment.
 The time is on a 24 hour clock corresponding to when the comment was made.
 The comments are mostly English language comments, compiled from various
 forums with very little formatting.
 Spelling and grammatical errors are very common, and sometimes may even
 contain HTML markup.
 Preprocessing this data to get useful features will be a very important
 step towards accurately classifying insults.

Please refer to our documentation for a more detailed analysis of our implimentation and results.

