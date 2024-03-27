import pandas as pd
from sklearn.cluster import KMeans
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np
import json
import sys
import json
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

# Read data from Node.js
student_data_json = sys.argv[1]

# Parse JSON data
data = json.loads(student_data_json)
df = pd.DataFrame(data)

# Feature Engineering
# Convert ideas text into TF-IDF vectors
vectorizer = TfidfVectorizer(stop_words='english')
ideas_vectors = vectorizer.fit_transform(df['idea'])

combined_features = ideas_vectors

# Clustering using K-Means
kmeans = KMeans(n_clusters=2)  # You can choose the number of clusters based on requirements
clusters = kmeans.fit_predict(combined_features)

df['cluster'] = clusters
#print(clusters)


#function
def recommend_users(email):
    user_row = df[df['email'] == email]
    if user_row.empty:
        print("User not found.")
        return None

    user_cluster = user_row['cluster'].iloc[0]
    
    similar_users = df[df['cluster'] == user_cluster]
    similar_users = similar_users[similar_users['email'] != email]  # Exclude the user itself
    
    if similar_users.empty:
        return None
    
    # Compute cosine similarity based on idea text
    similarity_scores = cosine_similarity(ideas_vectors[user_row.index], ideas_vectors[similar_users.index])
    similar_users['similarity'] = similarity_scores.flatten()
    
    # Sort similar users by idea similarity
    similar_users = similar_users.sort_values(by='similarity', ascending=False)
    
    recommended_users = similar_users
    recommended_users['skills_match_count'] = recommended_users.apply(lambda row: sum([1 for skill in row['skills'] if skill in row['requirements']]), axis=1)
    recommended_users = recommended_users.sort_values(by=['skills_match_count', 'similarity'], ascending=[False, False])
    recommended_users_dict = recommended_users[['email', 'idea', 'skills', 'requirements']].to_dict(orient='records')
    return recommended_users_dict

unique_emails = df['email'].unique()

# Dictionary to store recommendations for each user
all_recommendations = {}

# Iterate over each email
for email in unique_emails:
    # Get recommendations for the current email
    recommended_users = recommend_users(email)
    
    # Store recommendations in the dictionary
    all_recommendations[email] = recommended_users



# Print the JSON output
print(json.dumps(all_recommendations))