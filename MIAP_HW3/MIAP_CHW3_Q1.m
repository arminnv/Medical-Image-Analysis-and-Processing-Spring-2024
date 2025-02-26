% Reading image
img = im2double(imread('image_anisotropic.png'));

% Adding noise
noisy_img = imnoise(img, 'gaussian', 0, 0.1);

figure
subplot(1, 2, 1)
imshow(img)
title('original')
subplot(1, 2, 2)
imshow(noisy_img)
title('noisy')
saveas(gcf, 'q1 noisy.png')

% Calculating gradients of smoothed image
[gn, gs, ge, gw] = calc_grad(imgaussfilt(noisy_img));

%%
% Denoising image using anisotropic diffusion
denoised_image = anisodiff(noisy_img, 20, 0.5, 0.1, 1);
subplot(1, 2, 1)
imshow(noisy_img)
subplot(1, 2, 2)
imshow(denoised_image)


% Evaluating results using NIQE and SSIM measures
niqe_min = 10000;
ssim_max = 0;

for niter=[10, 20, 30]
    for option=[1, 2]
        for k=[0.2, 0.5, 0.8, 1]
            for l=[0.05, 0.1, 0.2, 0.3]
                   denoised_image = anisodiff(noisy_img, niter, k, l, option);
          
                   SSIM = ssim(im2uint8(denoised_image), im2uint8(img));
                   if SSIM > ssim_max
                        ssim_max = SSIM;
                        imwrite(denoised_image, 'best ssim.png')
                        params_ssim = [niter, k, l, option];
                   end
                    
                   NIQE = niqe(im2uint8(denoised_image));
                   if NIQE < niqe_min
                        niqe_min = NIQE;
                        imwrite(denoised_image, 'best niqe.png')
                        params_niqe = [niter, k, l, option];
                   end
            end
        end
    end
end

function [gn, gs, ge, gw] = calc_grad(I)
    H = size(I, 1);
    W = size(I, 2);
    gn = zeros(size(I));
    gs = zeros(size(I));
    ge = zeros(size(I));
    gw = zeros(size(I));

    for i=1:size(I, 1)
        for j=1:size(I, 2)
            gs(i, j) = I(min(i+1,H), j)-I(i, j);
            gn(i, j) = I(max(i-1,1), j)-I(i, j);
            ge(i, j) = I(i, min(W,j+1))-I(i, j);
            gw(i, j) = I(i, max(1,j-1))-I(i, j);
        end
    end
end

function [D, V] = eigv(A)
    [V,D] = eig(A);
    [D,I] = sort(diag(D), 'descend');
    V = V(:, I);
end