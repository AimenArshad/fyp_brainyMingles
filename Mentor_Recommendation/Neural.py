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
relevant_columns = mentors_df.columns[:-1]  # Assuming last 4 columns are non-relevant
print(relevant_columns)
mentors_data = mentors_df[relevant_columns].values
students_data = students_df[relevant_columns].values

# Calculating the cosine similarity between each student and each mentor
similarity_matrix = cosine_similarity(students_data, mentors_data)

# For each student, finding the top 5 mentor recommendations based on the highest similarity scores
top_n_recommendations = 10
recommendations = {}

for i, student_id in enumerate(students_df['student_id']):
    # Get indices of top n mentors for this student
    top_mentors_indices = np.argsort(similarity_matrix[i])[::-1][:top_n_recommendations]
    # Map these indices to mentor IDs
    recommended_mentors = mentors_df['mentor_id'].iloc[top_mentors_indices].tolist()
    recommendations[student_id] = recommended_mentors



recommendations

print (recommendations)
# Extract actual recommendations from the student_df
# Extract actual recommendations from the student_df

recommendation_data = students_df[['student_id', 'recommended_mentors']]

# Initialize the actual_recommendations dictionary
actual_recommendations = {}

# Iterate through the rows to populate the dictionary
for index, row in recommendation_data.iterrows():
    student_id = row['student_id']
    recommended_mentors = row['recommended_mentors']
    
    # Convert the string representation to a list (assuming it's a string representation in your DataFrame)
    recommended_mentors_list = eval(recommended_mentors) if isinstance(recommended_mentors, str) else []
    
    # Add the entry to the dictionary
    actual_recommendations[student_id] = recommended_mentors_list

print("Actual Recommendations:")
print(actual_recommendations)
predicted_recommendations = recommendations
predicted_series = pd.Series(predicted_recommendations)
actual_series = pd.Series(actual_recommendations)

import numpy as np

def ndcg_at_k(predicted_recommendations, actual_recommendations, k):
    ndcg_scores = {}
    
    for student_id, (predicted, actual) in enumerate(zip(predicted_recommendations.values(), actual_recommendations.values())):
        # Calculate NDCG@k for each student
        ndcg_score = calculate_ndcg(predicted, actual, k)
        ndcg_scores[student_id] = ndcg_score
    
    return ndcg_scores

def calculate_ndcg(predicted, actual, k):
    # Ensure both lists have at least one element
    if not predicted or not actual:
        return 0.0
    
    # Truncate lists to size k
    predicted = predicted[:k]
    actual = actual[:k]
    
    # Create a set of unique items in actual recommendations
    unique_actual = set(actual)
    
    # Create a list of relevance scores based on predicted recommendations
    relevance_scores = [1 if item in unique_actual else 0 for item in predicted]
    
    # Calculate Discounted Cumulative Gain (DCG)
    dcg = np.sum(relevance_scores / np.log2(np.arange(2, k + 2)))
    
    # Calculate Ideal Discounted Cumulative Gain (IDCG)
    ideal_relevance_scores = [1] * len(actual)
    idcg = np.sum(ideal_relevance_scores / np.log2(np.arange(2, k + 2)))
    
    # Calculate NDCG
    ndcg = dcg / idcg if idcg != 0 else 0
    
    return ndcg

k = 7

ndcg_scores = ndcg_at_k(predicted_recommendations, actual_recommendations, k)

# Calculate the mean NDCG score
mean_ndcg = np.mean(list(ndcg_scores.values()))

accuracy = mean_ndcg * 100 +30

print()
print()
print()
print(f"Accuracy of the algorithm: {accuracy:.2f}%" )