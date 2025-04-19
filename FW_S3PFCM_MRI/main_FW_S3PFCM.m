% The code was written by Amin Golzari Oskouei in 2023.
function [accurcy,fm,nmi, Runtime, Sensitivity, Precision] = main_FW_S3PFCM(FileName,MaskName, PathName)
%%
f_ori=imread(strcat(PathName,'\original','\',FileName));
GT = imread(strcat(PathName,'\GT','\',MaskName));

%% skull border remove
binarymak = skull_remove(f_ori);
f2 = f_ori(3:end-3, 4:end-4, :);
GT = GT (3:end-3, 4:end-4);
f2 = bsxfun(@times, f2, cast(binarymak, 'like', f_ori));

%% Feathre Extract step
fprintf('The feature extraction phase has started ...\n')
X = FeatureExtractor(f2);
[N,d]=size(X);

%Algorithm parameters.
%---------------------
k=3;                       %number of clusters.
q=-3;                      %the value for the feature weight updates.
t_max=100;                 %maximum number of iterations.
beta_memory=0.3;           %amount of memory for the cluster weight updates.
fuzzy_degree=2;            %fuzzy membership degree
I=1;                       %The value of this parameter is in the range of (0 and 1]

balance_parm = 1;          %balance parameter among to terms of loss function
T_pow = 2;                 %power of T
a_coefficient = 5;         %coefficient of u
b_coefficient = 5;         %coefficient of t
alpha_1 = 2;
alpha_2 = 1;

landa=I./var(X);
landa(landa==inf)=1;

f = double(double(reshape(GT, [1, size(GT,1) * size(GT,2)]))' == 0:max(double(reshape(GT, [1, size(GT,1) * size(GT,2)]))'));% convert class to onehot encoding
f(:,sum(f)==0)=[];
if size(unique(GT),1)~=k
    f(:,size(unique(GT),1)+1:k)=0;
end
labeled_rate = 20;               % rate of labeled data (0-100)


% label indicator vector
rand('state',1)
b = zeros(N,1);
for i =1:k
    ansr = find(f(:,i)==1);
    tmp1=ansr(randperm(size(ansr,1)));
    b(tmp1(1:size(ansr,1)*labeled_rate/100))=1;
end

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
%Get the cluster assignments, the cluster centers and the feature weights.
tic
[pre_Cluster_elem,~,~]=FW_FCM(X,M,k,t_max,beta_memory,N,fuzzy_degree,d,q,landa, balance_parm,a_coefficient,b_coefficient,T_pow);
[Cluster_elem,M,Z]=FW_S3PFCM(X,M,k,t_max,beta_memory,N,fuzzy_degree,d,q,landa,f,b,balance_parm,a_coefficient,b_coefficient,T_pow, alpha_1, alpha_2, pre_Cluster_elem');
Runtime = toc;

%% Lables (imagesize by imagesize)
[~,Lr2]=max(Cluster_elem);
m = size(f2,1);
n = size(f2,2);
Lr2 = reshape(Lr2,[m n]);

%% result
a = double(reshape(GT, [1, size(GT,1) * size(GT,2)]));
b = double(reshape(Lr2, [1, size(GT,1) * size(GT,2)]));
EVAL = Evaluate(a',b');
accurcy=EVAL(1);
fm=EVAL(2);
nmi=EVAL(3);
Sensitivity = EVAL(4);
Precision = EVAL(5);
Lseg=Label_image(f2,Lr2);
Lseg=Lseg*2;

%% figure
figure,imshow(Lseg);
imwrite(Lseg, strcat('Results','\',FileName))
end
