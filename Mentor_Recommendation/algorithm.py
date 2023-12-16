import pandas as pd
import numpy as np

Mentors_File = "Mentors_dataset.xlsx"
Student_File = "Students_Dataset.xlsx"
studentData = "Students.xlsx"
mentorData = "Mentors.xlsx"

try:
    mentor_df = pd.read_excel(Mentors_File)
except FileNotFoundError:
    print(f"The file '{Mentors_File}' was not found.")
except Exception as e:
    print(f"An error occurred: {e}")

try:
    student_df = pd.read_excel(Student_File)
except FileNotFoundError:
    print(f"The file '{Student_File}' was not found.")
except Exception as e:
    print(f"An error occurred: {e}")

columns = ['TimeStamp', 'Email', 'Name','Gender','Degree','Year','Semester','Web_Development','MobileApp_Development','DesktopAppDevelopment','GameDev','DataScience','DatabaseManagement','SoftwareTesting','CloudComputing','ArtificialIntelligence','UI/UX','CyberSecurity','SoftwareDesignAndArchitecture','BlockchainDev','C/C++','C#','Java','HTML','CSS','JavaScript','NodeJs','Python','Ruby','PHP','Angular','React','ReactNative','Flutter','Kotlin','SQL','Selenium','Junit','Pytest','AWSCLI','Azure','UML','UnrealEngine','Unity','Solidity','Go','GCPCLI','Kubernetes','Mode','Availability','Session']
mentor_df.columns = columns
student_df.columns = columns

remove_colums = ['TimeStamp', 'Email','Degree','Year','Semester']
mentor_df = mentor_df.drop(columns=remove_colums)
student_df = student_df.drop(columns=remove_colums)

mentor_df = mentor_df.drop_duplicates()
student_df = student_df.drop_duplicates()

languages = ['C/C++','C#','Java','HTML','CSS','JavaScript','NodeJs','Python','Ruby','PHP','Angular','React','ReactNative','Flutter','Kotlin','SQL','Selenium','Junit','Pytest','AWSCLI','Azure','UML','UnrealEngine','Unity','Solidity','Go','GCPCLI','Kubernetes']
domains = ['Web_Development','MobileApp_Development','DesktopAppDevelopment','GameDev','DataScience','DatabaseManagement','SoftwareTesting','CloudComputing','ArtificialIntelligence','UI/UX','CyberSecurity','SoftwareDesignAndArchitecture','BlockchainDev']

ValueReplacement = {'Low': 1, 'Medium': 5, 'High': 9}

student_df.fillna(0, inplace=True)
mentor_df.fillna(0, inplace=True)
student_df[languages] = student_df[languages].replace(ValueReplacement)
student_df[domains] = student_df[domains].replace(ValueReplacement)

student_df = student_df.drop(columns='Name')
mentor_df = mentor_df.drop(columns='Name')

student_df['student_id'] = range(1, len(student_df) + 1)
mentor_df['mentor_id'] = range(1, len(mentor_df) + 1)


students = student_df.to_dict('records')
mentors = mentor_df.to_dict('records')

def student_mentor_matrix(students, mentors):
    student_names = [student['student_id'] for student in students]
    mentor_names = [mentor['mentor_id'] for mentor in mentors]
    # Create a DataFrame with names as columns and index
    matrix_df = pd.DataFrame(index=student_names, columns=mentor_names)

    # Populate the matrix with matching scores
    for student in students:
        for mentor in mentors:
            matrix_df.at[student['student_id'], mentor['mentor_id']] = matching_scores(student, mentor, weights=None)

    return matrix_df

def matching_scores(student, mentor, weights=None):
    if weights is None:
        weights = {
            'Gender': 0.1,
            'Availability': 0.1,
            'Session': 0.1,
            'Mode': 0.1,
        }

    score = 0

    # Gender Matching
    if mentor['Gender'] == student['Gender']:
        score += weights['Gender']

    # Availability Matching
    if mentor['Availability'] == student['Availability']:
        score += weights['Availability']

    # Session Mode Matching
    if mentor['Session'] == student['Session']:
        score += weights['Session']

    # Session Type Matching
    if mentor['Mode'] == student['Mode']:
        score += weights['Mode']

    student_languages = [{'language': lang, 'level': level} for lang, level in student.items() if lang in languages]
    student_domains = [{'domain': domain, 'level': level} for domain, level in student.items() if domain in domains]

    mentor_languages = [{'language': lang, 'score': score} for lang, score in mentor.items() if lang in languages]
    mentor_domains = [{'domain': domain, 'score': score} for domain, score in mentor.items() if domain in domains]

    # Language Preferences Matching
    language_score = np.sum([student['level'] * mentor['score'] for student, mentor in zip(student_languages, mentor_languages)])

    score+=language_score

    # Domain Preferences Matching
    domain_score = np.sum([student['level'] * mentor['score'] for student, mentor in zip(student_domains, mentor_domains)])

    score+=domain_score

    return score

student_mentor_matrix = student_mentor_matrix(students, mentors)

print("Student-Mentor Matrix:")
print(student_mentor_matrix)


def recommend_mentors_for_student(matrix, student_name, top_n=10):
    # Get the row corresponding to the student
    student_row = matrix.loc[student_name]

    # Sort mentors by score in descending order
    recommended_mentors = student_row.sort_values(ascending=False)

    # Return the top n mentors
    top_mentors = recommended_mentors.head(top_n)

    return top_mentors.index.tolist()

student_df['recommended_mentors'] = student_df['student_id'].apply(lambda student_id: recommend_mentors_for_student(student_mentor_matrix, student_id, top_n=5))

student_df.to_excel(studentData, index=False)
mentor_df.to_excel(mentorData, index=False)

print(student_df)

student_df['recommended_mentors'] = student_df['student_id'].apply(lambda student_id: recommend_mentors_for_student(student_mentor_matrix, student_id, top_n=5))

student_df.to_excel(studentData, index=False)
mentor_df.to_excel(mentorData, index=False)

print(student_df)

student_df['recommended_mentors'] = student_df['student_id'].apply(lambda student_id: recommend_mentors_for_student(student_mentor_matrix, student_id))

student_df.to_excel(studentData, index=False)
mentor_df.to_excel(mentorData, index=False)

print(student_df)

