function j_fun = object_fun_FW_S3PFCM(N,d,k,Cluster_elem,landa,M,fuzzy_degree,z,beta_z,X,gama,T,a_coefficient,b_coefficient,T_pow,alpha_1, alpha_2, pre_Cluster_elem,b,f)
    for j=1:k
        distance(j,:,:) = (1-exp((-1.*repmat(landa,N,1)).*((X-repmat(M(j,:),N,1)).^2)));
        WBETA = transpose(z(j,:).^beta_z);
        WBETA(WBETA==inf)=0;
        dNK(:,j) = reshape(distance(j,:,:),[N,d]) * WBETA ;
    end
    j_fun1 = 2 * sum(sum(dNK .* ((a_coefficient.*transpose(Cluster_elem.^fuzzy_degree)) + (b_coefficient.*(T.^T_pow)))));
    j_fun2 = sum(sum(dNK .* transpose((Cluster_elem-(b.*f)').^fuzzy_degree)));
    j_fun3 = sum(sum(dNK .* transpose((Cluster_elem-(b.*pre_Cluster_elem)').^fuzzy_degree)));
    j_fun4 = sum(sum((1-T).^T_pow).* gama);
    j_fun = j_fun1 + (alpha_1 * j_fun2) + (alpha_2 * j_fun3) + j_fun4 ;
end

