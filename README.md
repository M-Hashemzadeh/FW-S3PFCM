# FW-S3PFCM: Feature-weighted Safe-Semi-Supervised Possibilistic Fuzzy C-Means Clustering


The safe Semi-Supervised Fuzzy C-Means Clustering (S3FCM) method is a well-known clustering method that can produce successful results by incorporating prior knowledge of the class distribution. Its process is fast and simple but still has two limitations. The first issue is that it gives equal weight to all data features, while in real-world applications, different features usually have different importance. Secondly, S3FCM is very sensitive to noise and outliers. This paper proposes an extension of the S3FCM, entitled FW-S3PFCM, to mitigate these shortcomings. The proposed method uses a local feature weighting scheme to consider the different feature weights in the clustering process. Additionally, a possibilistic version of the S3FCM is designed to reduce the sensitivity to noise and outliers. The effectiveness of the proposed method is comprehensively evaluated on various benchmark datasets, and its performance is compared with the state-of-the-arts methods. To practically asses the FW-S3FCM, a real-world dataset of brain MRI images and its segmentation performance are analyzed as well. The average Accuracy, F1-score, Sensitivity, and Precision measures obtained by FW-S3FCM are 0.9682, 0.9826, 0.9743, and 0.9925, respectively, which are better than the competitors' performance. 

# Overview of the FW-S3PFCM:
![Untitled](https://github.com/user-attachments/assets/7a1d927d-1242-43f4-b05f-296233e6e483)



# Case study: Brain MRI segmentation 
![image](https://github.com/user-attachments/assets/bf34dd18-5769-4ed4-af37-203ae124f537)

# Comment:
The repository file includes the MATLAB implementation of the FW-S3PFCM algorithm.

Comments are written for all steps of the algorithm for better understanding the code. Also, a demo is implemented for ease of running, which runs by importing the data and other necessary algorithm parameters.

To evaluate the proposed method, the UCI benchmark datasets (https://archive.ics.uci.edu/datasets) and brain MRI segmentation dataset (https://www.kaggle.com/datasets/mateuszbuda/lgg-mri-segmentation) have been used. 


## Condition and terms to use any sources of this project (Codes, Datasets, etc.):

1) Please cite the following papers:

[1] M. Hashemzadeh, A. Golzari Oskouei, and N. Farajzadeh, "New fuzzy C-means clustering method based on feature-weight and cluster-weight learning," Applied Soft Computing, vol. 78, pp. 324-345, 2019/05/01/ 2019, doi: https://doi.org/10.1016/j.asoc.2019.02.038.

[2] A. Golzari Oskouei, M. Hashemzadeh, B. Asheghi, and M. A. Balafar, "CGFFCM: Cluster-weight and Group-local Feature-weight learning in Fuzzy C-Means clustering algorithm for color image segmentation," Applied Soft Computing, vol. 113, p. 108005, 2021/12/01/ 2021, doi: https://doi.org/10.1016/j.asoc.2021.108005.

[3] A. Golzari Oskouei and M. Hashemzadeh, "CGFFCM: A color image segmentation method based on cluster-weight and feature-weight learning," Software Impacts, vol. 11, p. 100228, 2022/02/01/ 2022, doi: https://doi.org/10.1016/j.simpa.2022.100228.

2) Please do not distribute the database or source codes to others without the authorization from Dr. Mahdi Hashemzadeh.

Authors’ Emails: shirinkhezri[at]azaruniv.ac.ir (Sh. Khezri), nasseraghazadeh[at]iyte.edu.tr (N. Aghazadeh), hashemzadeh[at]azaruniv.ac.ir (M. Hashemzadeh), and a.golzari[at]tabrizu.ac.ir (A. G. Oskouei)




