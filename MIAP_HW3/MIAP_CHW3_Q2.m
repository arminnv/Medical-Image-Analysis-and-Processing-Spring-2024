close all;
clear;

% Loading image
img = im2double(imread('image2.png'));

% Adding noise
noisy = imnoise(img, 'gaussian', 0, 0.05);

% Denoising image with isodiff
denoised_iso = isodiff(noisy, 0.02, 10);

% Denoising image with anisodiff
denoised_aniso = anisodiff(noisy, 40, 200, 0.02, 2);

% Plotting results
figure
subplot(2, 2, 1)
imshow(img)
title('original')
subplot(2, 2, 2)
imshow(noisy)
title('noisy')
subplot(2, 2, 3)
imshow(denoised_iso)
title('denoised iso')
subplot(2, 2, 4)
imshow(denoised_aniso)
title('denoised aniso')
saveas(gcf, 'q2.png')

% Calculating meaures
niqe_iso = niqe(denoised_iso);
niqe_aniso = niqe(denoised_aniso);

ssim_iso = ssim(denoised_iso, img);
ssim_aniso = ssim(denoised_aniso, img);

fprintf('niqe iso: %d \n', niqe_iso)
fprintf('niqe aniso: %d \n', niqe_aniso)
fprintf('ssim iso: %d \n', ssim_iso)
fprintf('ssim aniso: %d \n', ssim_aniso)


