# Tutorial

**Follow the tutorial:**
[TUTORIAL](https://www.iorad.com/player/2452404/127-0-0---How-to-untitled-task-name?iframeHash=trysteps-1)

# Data Mining in Motoko

This project is built in Motoko and is aimed at processing student data, calculating distances between data points based on specific student attributes, and making predictions using the KNN (k-Nearest Neighbors) algorithm.

## KNN

K-Nearest Neighbors (KNN) is a simple, yet powerful, machine learning algorithm used for classification and regression tasks. It works by finding the 'k' nearest data points (neighbors) to a new data point and classifying it based on the majority label of its neighbors or predicting its value using the average of nearby points. KNN is a non-parametric method, meaning it makes no assumptions about the underlying data distribution. However, it can be computationally expensive, especially with large datasets, since it requires calculating the distance between data points during the prediction phase.

[wikipedia KNN](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm)

## Features

- **Calculate Distances**: Calculate the distance between a set of student records and input records using attributes such as absences, study time, failures, and higher education status.
- **Fetch Raw Data**: Retrieve raw JSON data for analysis.
- **KNN Prediction**: Make predictions based on input data and pre-existing student records using KNN.

## Setup

1. **Clone the repository**:

2. **Deploy the Canisters**:
   Use the command below to deploy the backend:
   ```bash
   make deploy
   ```
   
3. **Test the Application**:
   You can run the provided tests with:
   ```bash
   ./dm_core_test.sh
   ```
   
## Usage

### 1. Fetch Raw Data
To fetch raw data, navigate to the **Candid UI**. You can select a JSON file (like the one available in the `data/` folder) and load its contents:

- Go to the `fetch_raw_data` function.
- Choose a JSON ia Data Directory, file (e.g., `kirito.json`).
- Select the **Raw** view, copy the link.
- Click **Call** to fetch the data.

### 2. Calculate Distances
Use `calculateAllDistancesMock` to compute the distances between student records. Enter values for `absences`, `failures`, `higher`, and `studytime` and click **Call**.

### 3. Predict Higher Education Chances
Use the `predictHigher` function to predict the chances of a student pursuing higher education based on their study habits and failures.

## Available JSON Files
The `data/` directory contains multiple example student records in JSON format that you can use to fetch raw data and test the algorithms.

Example of `kirito.json`:
```json
{
  "studytime": 1,
  "higher": "yes",
  "absences": 2,
  "failures": "no"
}
```
