# import sys
# import json
# import pandas as pd
# from sklearn.metrics.pairwise import cosine_similarity
# import numpy as np

# # Read data from Node.js
# student_data_json = sys.argv[1]
# mentors_data_json = sys.argv[2]

# # Parse JSON data
# student_data = json.loads(student_data_json)
# all_mentors = json.loads(mentors_data_json)

# languages = ['C/C++','C#','Java','HTML','CSS','JavaScript','NodeJs','Python','Ruby','PHP','Angular','React','ReactNative','Flutter','Kotlin','SQL','Selenium','Junit','Pytest','AWSCLI','Azure','UML','UnrealEngine','Unity','Solidity','Go','GCPCLI','Kubernetes']
# domains = ['Web_Development','MobileApp_Development','DesktopAppDevelopment','GameDev','DataScience','DatabaseManagement','SoftwareTesting','CloudComputing','ArtificialIntelligence','UI/UX','CyberSecurity','SoftwareDesignAndArchitecture','BlockchainDev']

# student_domains = pd.json_normalize(student_data, record_path='domains', sep='_', errors='ignore')
# student_languages = pd.json_normalize(student_data, record_path='languages', sep='_', errors='ignore')

# student_id = student_data.get('_id')

# student_domain_df = pd.DataFrame(index=[student_id])
# student_language_df = pd.DataFrame(index=[student_id])

# def mapDomains(domain_dataFrame, user_dataframe ):
#     for domain in domains:
#         if domain in domain_dataFrame['name'].values:
#             value = domain_dataFrame.loc[domain_dataFrame['name'] == domain, 'difficultyLevel'].values[0]
#             user_dataframe.loc[:, domain] = value
#             print(f"Domain: {domain}, Value: {value}")
#         else:
#             user_dataframe.loc[:, domain] = 0
#             print(f"Domain: {domain}, Value: 0")
#     return user_dataframe


# def mapLanguages(language_dataFrame, user_dataframe ):
#     for language in languages:
#         if language in language_dataFrame['name'].values:
#             value = language_dataFrame.loc[language_dataFrame['name'] == language, 'difficultyLevel'].values[0]
#             user_dataframe.loc[:, language] = value
#             print(f"Language: {language}, Value: {value}")
#         else:
#             user_dataframe.loc[:, language] = 0
#             print(f"Language: {language}, Value: 0")
#     return user_dataframe
# # for domain in domains:
# #     if domain in student_domains['name'].values:
# #         value = student_domains.loc[student_domains['name'] == domain, 'difficultyLevel'].values[0]
# #         student_domain_df.loc[:, domain] = value
# #         print(f"Domain: {domain}, Value: {value}")
# #     else:
# #         student_domain_df.loc[:, domain] = 0
# #         print(f"Domain: {domain}, Value: 0")

# student_domain_df = mapDomains(student_domains, student_domain_df )
# student_language_df = mapLanguages(student_languages, student_language_df )
# # Print received data
# print("Received Student Data In python:")
# print(student_data)


# print("\nReceived Mentors Data in python:")
# print(all_mentors)


# columns = ['_id', 'gender', 'mode', 'session', 'availability']
# print(len(student_domain_df))
# print(student_domain_df)

# student_dataFrame =  pd.DataFrame(student_data)[columns]
# print(len(student_dataFrame))
# student_dataFrame = student_dataFrame.drop_duplicates()
# student_df = pd.merge(student_dataFrame, student_domain_df, left_on='_id', right_index=True)
# student_df = pd.merge(student_df, student_language_df, left_on='_id', right_index=True)

# student_df = student_df.drop_duplicates()

# print(student_df)

# def mapMDomains(domain_dataFrame, user_dataframe ):
#     for domain in domains:
#         if domain in domain_dataFrame['name'].values:
#             value = domain_dataFrame.loc[domain_dataFrame['name'] == domain, 'score'].values[0]
#             user_dataframe.loc[:, domain] = value
#             print(f"Domain: {domain}, Value: {value}")
#         else:
#             user_dataframe.loc[:, domain] = 0
#             print(f"Domain: {domain}, Value: 0")
#     return user_dataframe


# def mapMLanguages(language_dataFrame, user_dataframe ):
#     for language in languages:
#         if language in language_dataFrame['name'].values:
#             value = language_dataFrame.loc[language_dataFrame['name'] == language, 'score'].values[0]
#             user_dataframe.loc[:, language] = value
#             print(f"Language: {language}, Value: {value}")
#         else:
#             user_dataframe.loc[:, language] = 0
#             print(f"Language: {language}, Value: 0")
#     return user_dataframe

# mentors_language_df = pd.DataFrame()
# mentors_domain_df = pd.DataFrame()

# for mentor in all_mentors:
#     mentor_domains = pd.json_normalize(mentor, record_path='domains', sep='_', errors='ignore')
#     mentor_languages = pd.json_normalize(mentor, record_path='languages', sep='_', errors='ignore')
#     mentor_id = mentor.get('_id')
#     mentor_domain_df = pd.DataFrame(index=[mentor_id])
#     mentor_language_df = pd.DataFrame(index=[mentor_id])

#     mentor_domain_df = mapMDomains(mentor_domains, mentor_domain_df )
#     mentor_language_df = mapMLanguages(mentor_languages, mentor_language_df )

#     mentors_domain_df = pd.concat([mentors_domain_df, mentor_domain_df], sort=False)
#     mentors_language_df = pd.concat([mentors_language_df, mentor_language_df],sort=False)


# print(mentors_domain_df)
# mentors_domain_df.index = mentors_domain_df.index.astype(str)
# mentor_df = pd.merge(pd.DataFrame(all_mentors)[columns], mentors_domain_df, left_on='_id', right_index=True)
# mentor_df = pd.merge(mentor_df, mentors_language_df, left_on='_id', right_index=True)

# mentor_df = mentor_df.drop_duplicates()

# print(mentor_df)


# GenderReplacement = {'Female': 1, 'Male':0}
# SessionReplacement = {'Throughout Semester': 1, 'Single':0}
# AvailabilityReplacement = {'Weekends':1 , 'Weekdays':0}
# ModeReplacement = {'Online':1, 'Physical':0}

# student_df['gender'] = student_df['gender'].replace(GenderReplacement)
# student_df['availability'] = student_df['availability'].replace(AvailabilityReplacement)
# student_df['mode'] = student_df['mode'].replace(ModeReplacement)
# student_df['session'] = student_df['session'].replace(SessionReplacement)

# mentor_df['gender'] = mentor_df['gender'].replace(GenderReplacement)
# mentor_df['availability'] = mentor_df['availability'].replace(AvailabilityReplacement)
# mentor_df['mode'] = mentor_df['mode'].replace(ModeReplacement)
# mentor_df['session'] = mentor_df['session'].replace(SessionReplacement)

# print(student_df[['gender','mode','availability','session']])
# print(mentor_df[['gender','mode','availability','session']])

# all_mentors = mentor_df.drop('_id', axis=1)
# student = student_df.drop('_id', axis=1)

# print(all_mentors)
# print(student)
# # Calculating the cosine similarity between each student and each mentor
# similarity_matrix = cosine_similarity(student, all_mentors)

# # For each student, finding the top 5 mentor recommendations based on the highest similarity scores
# top_n_recommendations = 5
# recommendations = {}

# for i, student_id in enumerate(student_df['_id']):
#     # Get indices of top n mentors for this student
#     top_mentors_indices = np.argsort(similarity_matrix[i])[::-1][:top_n_recommendations]
#     # Map these indices to mentor IDs
#     recommended_mentors = mentor_df['_id'].iloc[top_mentors_indices].tolist()
#     recommendations[student_id] = recommended_mentors

# print(student_id, recommendations)

# recommendations
