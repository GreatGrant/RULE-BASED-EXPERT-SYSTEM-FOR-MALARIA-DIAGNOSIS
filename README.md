# Malaria Diagnosis App

This Flutter application allows users to input symptoms and get a diagnosis for malaria based on those symptoms. It uses a rule-based system to determine the likelihood of malaria, displaying both the diagnosis result and a probability score. Additionally, the app shows a chart to visually represent the diagnosis probability. The app also integrates Firebase for user authentication and role-based access control.

## Features

- **Symptom Selection**: Users can select multiple symptoms from a predefined list.
- **Diagnosis Calculation**: Based on selected symptoms, the app calculates the probability of malaria using a rule-based logic.
- **Diagnosis Result**: The app displays the diagnosis and its associated probability as a percentage.
- **Interactive Doughnut Chart**: A chart that visually shows the probability of malaria and other possible diagnoses.
- **User Authentication**: Firebase Authentication is used for user sign-in and sign-up.
- **Role-Based Access**: Firebase Firestore is used to manage user roles (e.g., Attendant, Admin) to control access to different parts of the app.
