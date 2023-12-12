import sys
import json
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

# Read data from Node.js
student_data_json = sys.argv[1]
mentors_data_json = sys.argv[2]

# Parse JSON data
all_students = json.loads(student_data_json)
all_mentors = json.loads(mentors_data_json)

languages = ['C/C++','C#','Java','HTML','CSS','JavaScript','NodeJs','Python','Ruby','PHP','Angular','React','ReactNative','Flutter','Kotlin','SQL','Selenium','Junit','Pytest','AWSCLI','Azure','UML','UnrealEngine','Unity','Solidity','Go','GCPCLI','Kubernetes']
domains = ['Web_Development','MobileApp_Development','DesktopAppDevelopment','GameDev','DataScience','DatabaseManagement','SoftwareTesting','CloudComputing','ArtificialIntelligence','UI/UX','CyberSecurity','SoftwareDesignAndArchitecture','BlockchainDev']
# print(all_students)
# print(all_mentors)

def mapDomains(domain_dataFrame, user_dataframe ):
    for domain in domains:
        if domain in domain_dataFrame['name'].values:
            value = domain_dataFrame.loc[domain_dataFrame['name'] == domain, 'difficultyLevel'].values[0]
            user_dataframe.loc[:, domain] = value
        else:
            user_dataframe.loc[:, domain] = 0
    return user_dataframe


def mapLanguages(language_dataFrame, user_dataframe ):
    for language in languages:
        if language in language_dataFrame['name'].values:
            value = language_dataFrame.loc[language_dataFrame['name'] == language, 'difficultyLevel'].values[0]
            user_dataframe.loc[:, language] = value
        else:
            user_dataframe.loc[:, language] = 0
    return user_dataframe

columns = ['_id', 'gender', 'mode', 'session', 'availability']

def mapMDomains(domain_dataFrame, user_dataframe ):
    for domain in domains:
        if domain in domain_dataFrame['name'].values:
            value = domain_dataFrame.loc[domain_dataFrame['name'] == domain, 'score'].values[0]
            user_dataframe.loc[:, domain] = value
        else:
            user_dataframe.loc[:, domain] = 0
    return user_dataframe


def mapMLanguages(language_dataFrame, user_dataframe ):
    for language in languages:
        if language in language_dataFrame['name'].values:
            value = language_dataFrame.loc[language_dataFrame['name'] == language, 'score'].values[0]
            user_dataframe.loc[:, language] = value
        else:
            user_dataframe.loc[:, language] = 0
    return user_dataframe

mentors_language_df = pd.DataFrame()
mentors_domain_df = pd.DataFrame()

for mentor in all_mentors:
    mentor_domains = pd.json_normalize(mentor, record_path='domains', sep='_', errors='ignore')
    mentor_languages = pd.json_normalize(mentor, record_path='languages', sep='_', errors='ignore')
    mentor_id = mentor.get('_id')
    mentor_domain_df = pd.DataFrame(index=[mentor_id])
    mentor_language_df = pd.DataFrame(index=[mentor_id])

    mentor_domain_df = mapMDomains(mentor_domains, mentor_domain_df )
    mentor_language_df = mapMLanguages(mentor_languages, mentor_language_df )

    mentors_domain_df = pd.concat([mentors_domain_df, mentor_domain_df], sort=False)
    mentors_language_df = pd.concat([mentors_language_df, mentor_language_df],sort=False)

mentors_domain_df.index = mentors_domain_df.index.astype(str)
# print(all_mentors)
# print("Dataframe")
# print(pd.DataFrame(all_mentors)[columns])
mentor_df = pd.merge(pd.DataFrame(all_mentors)[columns], mentors_domain_df, left_on='_id', right_index=True)
mentor_df = pd.merge(mentor_df, mentors_language_df, left_on='_id', right_index=True)

mentor_df = mentor_df.drop_duplicates()


# students_language_df = pd.DataFrame()
# students_domain_df = pd.DataFrame()

students_language_df = pd.DataFrame()
students_domain_df = pd.DataFrame()

for student in all_students:
    student_domains = pd.json_normalize(student, record_path='domains', sep='_', errors='ignore')
    student_languages = pd.json_normalize(student, record_path='languages', sep='_', errors='ignore')
    student_id = student.get('_id')
    student_domain_df = pd.DataFrame(index=[student_id])
    student_language_df = pd.DataFrame(index=[student_id])

    student_domain_df = mapDomains(student_domains, student_domain_df )
    student_language_df = mapLanguages(student_languages, student_language_df )

    students_domain_df = pd.concat([students_domain_df, student_domain_df], sort=False)
    students_language_df = pd.concat([students_language_df, student_language_df],sort=False)

students_domain_df.index = students_domain_df.index.astype(str)
# print(all_mentors)
# # print("Dataframe")
# print(pd.DataFrame(all_students)[columns])
student_df = pd.merge(pd.DataFrame(all_students)[columns], students_domain_df, left_on='_id', right_index=True)
student_df = pd.merge(student_df, students_language_df, left_on='_id', right_index=True)

student_df = student_df.drop_duplicates()
# print("std")
# print(student_df)


GenderReplacement = {'Female': 1, 'Male':0}
SessionReplacement = {'Throughout Semester': 1, 'Single':0}
AvailabilityReplacement = {'Weekends':1 , 'Weekdays':0}
ModeReplacement = {'Online':1, 'Physical':0}

student_df['gender'] = student_df['gender'].replace(GenderReplacement)
student_df['availability'] = student_df['availability'].replace(AvailabilityReplacement)
student_df['mode'] = student_df['mode'].replace(ModeReplacement)
student_df['session'] = student_df['session'].replace(SessionReplacement)

mentor_df['gender'] = mentor_df['gender'].replace(GenderReplacement)
mentor_df['availability'] = mentor_df['availability'].replace(AvailabilityReplacement)
mentor_df['mode'] = mentor_df['mode'].replace(ModeReplacement)
mentor_df['session'] = mentor_df['session'].replace(SessionReplacement)

# print(student_df)
# print(mentor_df)

student_df = student_df.drop_duplicates()
mentor_df = mentor_df.drop_duplicates()

student_df_final = student_df.drop('_id', axis=1)
mentor_df_final = mentor_df.drop('_id', axis=1)

# print(student_df_final)
# print(mentor_df_final)

student_df_final = student_df_final.values
mentor_df_final = mentor_df_final.values
# print("printing student dataframe")
# print(student_df_final)
# print("printing mentor dataframe")
# print(mentor_df_final)

# final_all_mentors = mentor_df.drop('_id', axis=1)
# final_student = student_df.drop('_id', axis=1)
# final_student = final_student.drop_duplicates()
# final_all_mentors = final_all_mentors.drop_duplicates()
# print(final_student)
# print(final_all_mentors)
# print("hello0")
# Calculating the cosine similarity between each student and each mentor
similarity_matrix = cosine_similarity(student_df_final, mentor_df_final)
# print("First 5 rows and columns of Similarity Matrix:")
# print("printing matrix")
# print(similarity_matrix)
# print("hello")
# # For each student, finding the top 5 mentor recommendations based on the highest similarity scores
top_n_recommendations = 5
recommendations = {}
# print("hello2")
for i, student_id in enumerate(student_df['_id']):
    # print("hello",i)
    # Get indices of top n mentors for this student
    top_mentors_indices = np.argsort(similarity_matrix[i])[::-1][:top_n_recommendations]
    # Map these indices to mentor IDs
    recommended_mentors = mentor_df['_id'].iloc[top_mentors_indices].tolist()
    recommendations[student_id] = recommended_mentors
     # Print or use recommendations for the current student
    # print(f"Recommendations for {student_id}: {recommended_mentors}")

# # Print or use recommendations as needed
# print("All Recommendations:", recommendations)
# recommendations

print(json.dumps(recommendations))