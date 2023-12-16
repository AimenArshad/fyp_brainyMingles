import pandas as pd

# Load the data from the provided files
mentors_file_path = 'Mentors.xlsx'
students_file_path = 'Students.xlsx'

# Reading the mentor and student data
mentors_df = pd.read_excel(mentors_file_path)
students_df = pd.read_excel(students_file_path)


from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

GenderReplacement = {'Female': 1, 'Male':0}
SessionReplacement = {'Throughout Semester': 1, 'Single':0}
AvailabilityReplacement = {'Weekends':1 , 'Weekdays':0}
ModeReplacement = {'Online':1, 'Physical':0}

students_df['Gender'] = students_df['Gender'].replace(GenderReplacement)
students_df['Availability'] = students_df['Availability'].replace(AvailabilityReplacement)
students_df['Mode'] = students_df['Mode'].replace(ModeReplacement)
students_df['Session'] = students_df['Session'].replace(SessionReplacement)

mentors_df['Gender'] = mentors_df['Gender'].replace(GenderReplacement)
mentors_df['Availability'] = mentors_df['Availability'].replace(AvailabilityReplacement)
mentors_df['Mode'] = mentors_df['Mode'].replace(ModeReplacement)
mentors_df['Session'] = mentors_df['Session'].replace(SessionReplacement)

# Extracting the relevant columns for matching (excluding personal and administrative details)
relevant_columns = mentors_df.columns[:-1] 
print(relevant_columns)
mentors_data = mentors_df[relevant_columns].values
students_data = students_df[relevant_columns].values

print("final dfs")
print(students_data)
print(mentors_data)

# Calculating the cosine similarity between each student and each mentor
similarity_matrix = cosine_similarity(students_data, mentors_data)

# For each student, finding the top 5 mentor recommendations based on the highest similarity scores
top_n_recommendations = 6
recommendations = {}

for i, student_id in enumerate(students_df['student_id']):
    # Get indices of top n mentors for this student
    top_mentors_indices = np.argsort(similarity_matrix[i])[::-1][:top_n_recommendations]
    # Map these indices to mentor IDs
    recommended_mentors = mentors_df['mentor_id'].iloc[top_mentors_indices].tolist()
    recommendations[student_id] = recommended_mentors

print(student_id, recommendations)

recommendations




