# Author :- Ashish Kumar

import numpy as np
import matplotlib.pyplot as plt
import csv

# Read data from main.csv
with open('main.csv', mode='r') as file:
    reader = csv.DictReader(file)
    data = [row for row in reader]

# Get roll number from user
roll_number = input("Enter Roll Number: ")

# Filter data for student with the given roll number
student_data = [row for row in data if row['Roll_Number'] == roll_number]
if not student_data:
    print("Student not found.")
    exit()

student_data = student_data[0]

# Extract exam marks, interpreting 'a' as 0
exam_marks = []
labels = []
for key, value in student_data.items():
    if key != "Roll_Number" and key != "Name" and key != "Total":
        labels.append(key)
        exam_marks.append(0 if value == 'a' else int(value))

# Calculate highest marks for each subject
highest_marks = []
for key in labels:
    if key != "Total":
        marks = [0 if row[key] == 'a' else int(row[key]) for row in data]
        highest_marks.append(max(marks))

# Plotting the double bar graph
num_exams = len(exam_marks)
x = np.arange(num_exams)
bar_width = 0.35

plt.bar(x, exam_marks, width=bar_width, label='Student Marks')
plt.bar(x + bar_width, highest_marks, width=bar_width, label='Highest Marks')
plt.xticks(x + bar_width / 2, labels)
plt.ylabel('Marks')
plt.title(f'Marks for Student {roll_number} vs Highest Marks')
plt.legend()
plt.show()

    #  num_exams = len(exam_marks): This line calculates the number of exams, which is the length of the exam_marks list. Each element in this list represents the marks obtained by a student in a particular exam.

    # x = np.arange(num_exams): This line creates an array x containing values from 0 to num_exams - 1. These values will be used as the x-coordinates for the bars in the bar graph.

    # bar_width = 0.35: This line sets the width of each bar in the bar graph.

    # plt.bar(x, exam_marks, width=bar_width, label='Student Marks'): This line creates a bar graph for the student's marks. It uses the bar function from Matplotlib, specifying the x-coordinates (x), the y-coordinates (student marks), the bar width, and a label for the legend.

    # plt.bar(x + bar_width, highest_marks, width=bar_width, label='Highest Marks'): This line creates a second set of bars for the highest marks. It uses the same bar function but shifts the x-coordinates to the right by bar_width so that these bars are displayed beside the student marks bars.

    # plt.xticks(x + bar_width / 2, labels): This line sets the x-axis tick labels to the exam labels (labels). It positions the ticks at the center of each pair of bars by adding bar_width / 2 to the x-coordinates.

    # plt.ylabel('Marks'): This line sets the label for the y-axis.

    # plt.title(f'Marks for Student {roll_number} vs Highest Marks'): This line sets the title of the plot, including the student's roll number.

    # plt.legend(): This line displays the legend, which shows the labels ('Student Marks' and 'Highest Marks') associated with each set of bars.

    # plt.show(): This line displays the plot.


# Read data from stats.csv
with open('stats.csv', mode='r') as file:
    reader = csv.DictReader(file)
    data = [row for row in reader]

# Select exam to plot
exam = input("Enter Exam: ")

# Filter data for the selected exam
exam_data = [row for row in data if row['Exam'] == exam][0]

# Extract mean, median, and standard deviation
mean = float(exam_data['Mean'])
median = float(exam_data['Median'])
std_dev = float(exam_data['Standard Deviation'])

# Plotting the bar graph
labels = ['Mean', 'Median', 'Standard Deviation']
values = [mean, median, std_dev]
x = np.arange(len(labels))

plt.bar(x, values)
plt.xticks(x, labels)
plt.ylabel('Marks')
plt.title(f'Stats for {exam}')
plt.show()
