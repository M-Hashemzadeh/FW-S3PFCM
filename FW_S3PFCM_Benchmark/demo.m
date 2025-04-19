
clc
clear all
close all

%Load the dataset. The last column of dataset is true labels.
X=load('iris.mat');
X=X.iris;

class=X(:,end);
X(:,end)=[];    %delete last column (true labels) in clustering process

[N,d]=size(X);
X=(X(:,:)-min(X(:)))./(max(X(:)-min(X(:)))); %Normalize data between 0 and 1 (optinal)

%Algorithm parameters.
%---------------------
k=size(unique(class),1);  %number of clusters.
q=2;                      %the value for the feature weight updates.
t_max=100;                 %maximum number of iterations.
beta_memory=0.3;            %amount of memory for the cluster weight updates.
fuzzy_degree=2;           %fuzzy membership degree
I=1;                      %The value of this parameter is in the range of (0 and 1]
Restarts=10;              %number of algorithm restarts.
balance_parm = 2;         %balance parameter among to terms of loss function
T_pow = 2;                %power of T
a_coefficient = 1;        %coefficient of u
b_coefficient = 1;        %coefficient of t
alpha_1 = 2;
alpha_2 = 2;

landa=I./var(X);
landa(landa==inf)=1;

f = double(class == 1:max(class));% convert class to onehot encoding
f(:,sum(f)==0)=[];
labeled_rate = 20;               % rate of labeled data (0-100)

%---------------------
%Cluster the instances using the propsed procedure.
%---------------------------------------------------------
for repeat=1:Restarts
    fprintf('========================================================\n')
    fprintf('proposed clustering algorithm: Restart %d\n',repeat);
    
    % label indicator vector
    rand('state',repeat)
    b = zeros(N,1);
    tmp1=randperm(N);
    b(tmp1(1:N*labeled_rate/100))=1;
    
    %initialize with labeled data.
    if labeled_rate==0
        %Randomly initialize the cluster centers.
        tmp2=randperm(N);
        M=X(tmp2(1:k),:);
    else
        M = ((b.*f)'*X)./repmat(sum(b.*f)',1,d);
        if sum(isnan(M))>=1
            tmp2=randperm(N);
            tem3= X(tmp2(1:k),:);
            M(isnan(M))=tem3(isnan(M));
        end
    end
    
    %Execute proposed clustering algorithm.
    %Get the cluster assignments, the cluster centers and the feature weight.
    tic
    [pre_Cluster_elem,~,~]=FW_FCM(X,M,k,t_max,beta_memory,N,fuzzy_degree,d,q,landa, balance_parm,a_coefficient,b_coefficient,T_pow);
    [Cluster_elem,M,Z]=FW_S3PFCM(X,M,k,t_max,beta_memory,N,fuzzy_degree,d,q,landa,f,b,balance_parm,a_coefficient,b_coefficient,T_pow, alpha_1, alpha_2, pre_Cluster_elem');
    Runtime = toc;
    feature_weights = Z;
    [~,unsupervised_Cluster]=max(Cluster_elem,[],1); %Hard clusters. Select the largest value for each sample among the clusters, and assign that sample to that cluster.
    semisupervised_Cluster  = unsupervised_Cluster;
    
    semisupervised_Cluster(tmp1(1:N*labeled_rate/100))=class(tmp1(1:N*labeled_rate/100));
    % Evaluation metrics
    EVAL = Evaluate(class,semisupervised_Cluster');
    Accurcy_semisupervised(repeat)=EVAL(1);
    NMI_semisupervised(repeat)=EVAL(3);
    
    fprintf('End of Restart %d\n',repeat);
    fprintf('========================================================\n\n')
end

fprintf('Average semisupervised accurcy over %d restarts: %f.\n',Restarts,mean(Accurcy_semisupervised));
fprintf('Average semisupervised NMI over %d restarts: %f.\n',Restarts,mean(NMI_semisupervised));

