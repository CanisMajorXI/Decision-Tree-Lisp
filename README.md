题目要求

Implement the ID3 algorithm (see Decision Tree in Lecture notes) in lisp. Your code is to read from a local data file called “data.txt”, then creates a nested list that corresponds to the Decision Tree for the data in data.txt. Assume that the data file contains N entries and M columns. The columns are separated by a single space, and the rows are terminated by a single newline ‘\n’ (unix text format). The last column shall contain the target value or class label. The first row contains the name of the attributes. You can assume that all attribute values and the targets are symbolic (ie. Not numeric). A sample data file is provided with this assignment. Your code produces a list as output which corresponds to the DT generated. The list must follow the following syntax: LIST = (Attribute Value LIST) | CLASS,
Where CLASS is a terminal (the leaf node) containing one of the permissible class labels (as defined in the data file).
Thus, the correct output for the sample file provided would be as follows:

((Dividend AboveAverage (Turnover High (NO))(Turnover Medium (Reissued Yes (YES))(Reissued No (NO)))(Turnover Low (YES)))(Dividend Average (YES))(Dividend BelowAverage (Reissued No (YES))(Reissued Yes (NO)))) Note that your code will be tested on data files that differ in content from the provided sample. Thus, you need to ensure that your code works correctly for any data file. Use comment lines in your code to document key points of your code. Your code should have a comment header which contains your full name and student
number.
