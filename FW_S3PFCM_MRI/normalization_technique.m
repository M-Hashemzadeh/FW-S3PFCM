% This function enhanced the contrast of medical images by employing a novel image size dependent normalization technique
function enhanced_image = normalization_technique(Img,m,n)
x = im2double(Img);
% figure; subplot(1,2,1); imshow(x); title('original') 
%% Equation 1 
xx=sum(x(:))/(m*n); 
%% Equation 2
xx0 = (x - min(x(:)))*exp(xx);
xx1 = max(x(:))- min(x(:)); 
enhanced_image=xx0/xx1;
%% Display the results
% subplot(1,2,2); imshow(enhanced_image); title('enhanced')
end
% imwrite(xx2,'CT_enhanced.jpg')