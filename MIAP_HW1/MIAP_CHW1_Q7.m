close all;
clear;

Img = im2double(rgb2gray(imread('pca_xray.jpg')));

Img = Img / max(Img(:));

K = [4, 10, 20, 50, 100, 256];

[~, Recounstructed] = SVD_image(Img, [50], "Reconstructed");

figure
subplot(1, 2, 1)
imshow(Img)
title('Original')
subplot(1, 2, 2)
imshow(Recounstructed)
title('Reconstructed')
saveas(gcf,'PCA50.png');

[MSE, ~] = SVD_image(Img, K, "PCA compression");

figure
plot(K, MSE);
title("PCA compression")
xlabel("Number of eigen values")
ylabel("error")
saveas(gcf, 'error_pca.png');

function [MSE, Img_reconstructed]  = SVD_image(Img, K, name)
    % SVD decomposition
    [U, S, V] = svd(Img);

    MSE = zeros(length(K), 1);

    figure;
    h  = [];
    title(name)

    for i=1:length(K)
        k = K(i);
        
        % Reconstructing image using the first k singular values
        Img_reconstructed = U(:, 1:k)* S(1:k, 1:k)* V(:, 1:k)';
        
        % Calculating MSE
        MSE_k = immse(Img, Img_reconstructed);

        disp("mse k = "+ int2str(k))
        disp(MSE_k)
        MSE(i) = MSE_k;
        
        m = sqrt(length(K));
        h(i) = subplot(floor(m),ceil(m),i);
        
        image(Img_reconstructed*256,'Parent',h(i));
        title(["N eigen values = " + string(k)])
        colormap(gray(256));
        
    end
    saveas(gcf,'PCA.png');
    
end
