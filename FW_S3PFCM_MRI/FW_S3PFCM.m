function [Cluster_elem,M,Z]=FW_S3PFCM(X,M,k,t_max,beta_memory,N,fuzzy_degree,d,q,landa,f,b,balance_parm,a_coefficient,b_coefficient,T_pow, alpha_1, alpha_2,pre_Cluster_elem)
%
%[Cluster_elem,M,Z]=FW_S3PFCM(X,M,k,t_max,beta_memory,N,fuzzy_degree,d,q,landa,f,b,balance_parm,a_coefficient,b_coefficient,T_pow, alpha_1, alpha_2,pre_Cluster_elem)
%
%
%Function Inputs
%===============
%
%X is an Nxd data matrix, where each row corresponds to an instance.
%
%M is a kxd matrix of the initial cluster centers. Each row corresponds to a center.
%
%k is the number of clusters.
%
%t_max is the maximum number of iterations.
%
%beta_memory controls the amount of memory for the weight updates (0<=beta<=1).
%
%N is the number of saamples in dataset.
%
%fuzzy_degree is the fuzzy membership degree.
%
%d is the number of features.
%
%q is the value for the feature weight updates.
%
%balance_perm is the balance parameter among to terms of loss function.
%
%a_cofficient is the cofficient of u.
%
%b_cofficient is the cofficient of T.
%
%T_pow is the power of T.
%
%alpha_1 and alpha_2 are regularization parameters.
%
%Function Outputs
%================
%
%Cluster_elem is a kxd matrix containing the final cluster assignments.
%
%M is a kxd matrix of the final cluster centers. Each row corresponds to a center.
%
%z is a kxd matrix of the final weights of each fatuter in each cluster.
%
%Courtesy of A. Golzari Oskouei

if beta_memory<0 || beta_memory>1
    error('beta must take a value in [0,1]');
end

if q==0
    error('beta must be a non-zero number');
end

%--------------------------------------------------------------------------
%Weights are uniformly initialized.
Z=ones(k,d)/d;  %initial faeture weights

%Other initializations.
Iter=1; %Number of iterations.
O_F_old=inf; %Previous iteration objective (used to check convergence).
%--------------------------------------------------------------------------

fprintf('\nStart of fuzzy C-means clustering method based on feature-weight and cluster-weight learning iterations\n');
fprintf('----------------------------------\n\n');

%The proposed iterative procedure.
while 1
    %Update the cluster assignments.
    for j=1:k
        distance(j,:,:) = (1-exp((-1.*repmat(landa,N,1)).*((X-repmat(M(j,:),N,1)).^2)));
        WBETA = transpose(Z(j,:).^q);
        WBETA(WBETA==inf)=0;
        dNK(:,j) = reshape(distance(j,:,:),[N,d]) * WBETA   ;
    end
    
    tmp1 = zeros(N,k);
    for j=1:k
        tmp2 = (dNK./repmat(dNK(:,j),1,k)).^(1/(fuzzy_degree-1));
        tmp2(tmp2==inf)=0;
        tmp2(isnan(tmp2))=0;
        tmp1=tmp1+tmp2;
    end
    Cluster_elem = transpose( (1/(a_coefficient+alpha_1+alpha_2)) * (((a_coefficient + alpha_1 + alpha_2 - sum((alpha_1*b.*f)+(alpha_2*b.*pre_Cluster_elem),2))./tmp1) + ((alpha_1*b.*f)+(alpha_2*b.*pre_Cluster_elem)) ) );
    
    Cluster_elem(isnan(Cluster_elem))=1;
    Cluster_elem(Cluster_elem==inf)=1;
    
    if nnz(dNK==0)>0
        for j=1:N
            if nnz(dNK(j,:)==0)>0
                Cluster_elem(find(dNK(j,:)==0),j) = 1/nnz(dNK(j,:)==0);
                Cluster_elem(find(dNK(j,:)~=0),j) = 0;
            end
        end
    end
    
    %Update gama.
    for j=1:k
        distance(j,:,:) = (1-exp((-1.*repmat(landa,N,1)).*((X-repmat(M(j,:),N,1)).^2)));
        WBETA = transpose(Z(j,:).^q);
        WBETA(WBETA==inf)=0;
        dNK(:,j) = reshape(distance(j,:,:),[N,d]) * WBETA ;
    end
    
    if balance_parm==0
        gama = (balance_parm * 2 * sum(dNK .* transpose(Cluster_elem.^fuzzy_degree)) ./ sum(Cluster_elem.^fuzzy_degree,2)') + 1;
    else
        gama = balance_parm * 2 * sum(dNK .* transpose(Cluster_elem.^fuzzy_degree)) ./ sum(Cluster_elem.^fuzzy_degree,2)';
    end
    
    %Update the T.
    T = (1+(repmat(2*b_coefficient./gama, N,1) .* dNK).^(1/(T_pow-1))).^-1;
    
    %Calculate the fuzzy C-means clustering method based on feature-weight and cluster-weight learning objective.
    O_F=object_fun_FW_S3PFCM(N,d,k,Cluster_elem,landa,M,fuzzy_degree,Z,q,X,gama,T,a_coefficient,b_coefficient,T_pow,alpha_1, alpha_2, pre_Cluster_elem,b,f);
    
    
    if ~isnan(O_F)
        fprintf('The clustering objective function is %f\n\n',O_F);
    end
    
    %Check for convergence. Never converge if in the current (or previous)
    %iteration empty or singleton clusters were detected.
    if Iter>=t_max || ~isnan(O_F) && ~isnan(O_F_old) && (abs(1-O_F/O_F_old) < 1e-6 )
        
        fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        fprintf('The final objective function is =%f.\n',O_F);
        fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        
        break;
        
    end
    
    O_F_old=O_F;
    
    %Update the cluster centers.
    mf1 = Cluster_elem.^fuzzy_degree;       % MF matrix after exponential modification
    tf = T'.^T_pow;
    
    mf2 = (Cluster_elem-(b.*f)').^fuzzy_degree;
    mf3 = (Cluster_elem-(b.*pre_Cluster_elem)').^fuzzy_degree;
    
    mf = (a_coefficient.*mf1) + (b_coefficient.*tf) + (alpha_1 * mf2)+ (alpha_2 * mf3);
    
    
    for j=1:k
        M(j,:) = (mf(j,:) * (X .* (exp((-1.*repmat(landa,N,1)).*((X-repmat(M(j,:),N,1)).^2)))))./(((mf(j,:)*(exp((-1.*repmat(landa,N,1)).*((X-repmat(M(j,:),N,1)).^2)))))); %new center
    end
    
    z_old=Z;
    
    %Update the feature weights.
    for j=1:k
        distance(j,:,:) = (1-exp((-1.*repmat(landa,N,1)).*((X-repmat(M(j,:),N,1)).^2)));
        dWkm(j,:) = (((a_coefficient.*(Cluster_elem(j,:).^fuzzy_degree)) + (b_coefficient.*(T(:,j).^T_pow))') + (alpha_1 * ((Cluster_elem(j,:)-(b.*f(:,j))').^fuzzy_degree)) + (alpha_2 * ((Cluster_elem(j,:)-(b.*pre_Cluster_elem(:,j))').^fuzzy_degree)))* reshape(distance(j,:,:),[N,d]);
    end
    
    tmp1 = zeros(k,d);
    for j=1:d
        tmp2 = (dWkm./repmat(dWkm(:,j),1,d)).^(1/(q-1));
        tmp2(tmp2==inf)=0;
        tmp2(isnan(tmp2))=0;
        tmp1=tmp1+tmp2;
    end
    Z = 1./tmp1;
    Z(isnan(Z))=1;
    Z(Z==inf)=1;
    
    if nnz(dWkm==0)>0
        for j=1:k
            if nnz(dWkm(j,:)==0)>0
                Z(j,find(dWkm(j,:)==0)) = 1/nnz(dWkm(j,:)==0);
                Z(j,find(dWkm(j,:)~=0)) = 0;
            end
        end
    end
    %
    
    %Memory effect.
    Z=(1-beta_memory)*Z+beta_memory*z_old;
    
    Iter=Iter+1;
end
end



