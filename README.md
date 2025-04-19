# FW-S3PFCM: Feature-weighted Safe-Semi-Supervised Possibilistic Fuzzy C-Means Clustering


The safe Semi-Supervised Fuzzy C-Means Clustering (S3FCM) method is a well-known clustering method that can produce successful results by incorporating prior knowledge of the class distribution. Its process is fast and simple but still has two limitations. The first issue is that it gives equal weight to all data features, while in real-world applications, different features usually have different importance. Secondly, S3FCM is very sensitive to noise and outliers. This paper proposes an extension of the S3FCM, entitled FW-S3PFCM, to mitigate these shortcomings. The proposed method uses a local feature weighting scheme to consider the different feature weights in the clustering process. Additionally, a possible version of the S3FCM is designed to reduce the sensitivity to noise and outliers. The effectiveness of the proposed method is comprehensively evaluated on various benchmark datasets, and its performance is compared with the state-of-the-art methods. To practical asses the FW-S3FCM, a real-world dataset of brain MRI images and its segmentation performance is analyzed as well. The average Accuracy, F1-score, Sensitivity, and Precision measures obtained by FW-S3FCM are 0.9682, 0.9826, 0.9743, and 0.9925, respectively, which are better than the competitors' performance.

# Overview of the FW-S3PFCM:
![Untitled](https://github.com/user-attachments/assets/7a1d927d-1242-43f4-b05f-296233e6e483)



# Case study: Brain MRI segmentation 
![image](https://github.com/user-attachments/assets/bf34dd18-5769-4ed4-af37-203ae124f537)

# Comment:
The repository file includes the MATLAB implementation of the FW-S3PFCM algorithm.

Comments are written for all steps of the algorithm for better understanding the code. Also, a demo is implemented for ease of running, which runs by importing the data and other necessary algorithm parameters.

To evaluate the proposed method, the UCI benchmark datasets (https://archive.ics.uci.edu/datasets) and brain MRI segmentation dataset (https://www.kaggle.com/datasets/mateuszbuda/lgg-mri-segmentation) have been used. 




