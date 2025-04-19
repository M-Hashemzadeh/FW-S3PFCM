function j_fun = object_fun(N,d,k,Cluster_elem,landa,M,fuzzy_degree,z,beta_z,X,gama,T,a_coefficient,b_coefficient,T_pow)
    for j=1:k
        distance(j,:,:) = (1-exp((-1.*repmat(landa,N,1)).*((X-repmat(M(j,:),N,1)).^2)));
        WBETA = transpose(z(j,:).^beta_z);
        WBETA(WBETA==inf)=0;
        dNK(:,j) = reshape(distance(j,:,:),[N,d]) * WBETA ;
    end
    term_1 = 2 * sum(sum(dNK .* ((a_coefficient.*transpose(Cluster_elem.^fuzzy_degree)) + (b_coefficient.*(T.^T_pow)))));
    term_2 = sum(sum((1-T).^T_pow).* gama);
    j_fun = term_1+term_2;
end

