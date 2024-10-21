% MIAP HW 1
% Q1
close all
clear 

% Loading data
data = niftiread('sub-0001_space-MNI_T1w.nii');
img = double(data(:, :, 90));

% Normalizing image
img = img/max(img(:));
figure
imshow(img) 

% Saving image
imwrite(img, 'img_q1.png');

% Loading image
img = im2double(imread("img_q1.png"));

% Normalizing image
img = img/max(img(:));

% Resizing image
img_resized = imresize(img, [180, 180]);

% Saving image
imwrite(img_resized, 'mri_reshaped.png');

% Adding salt & pepper noise
noisy_image = add_noise(img_resized, 60, 120, 60, 120);

figure
imshow(noisy_image)
title('Reshaped image with salt and pepper noise')
saveas(gcf, 'sp noise.png')

local_vars = zeros(3, 3);

for i=1:3
    for j=1:3
        % Calculating variance of block in jth row and ith column
        local_vars(j, i) = calculate_var(noisy_image, 1+(i-1)*60, i*60, 1+(j-1)*60, j*60);
    end
end

fprintf('Maximum variance = %d \n', max(local_vars(:)))

% Average filter
denoised_avg = imboxfilt(noisy_image, 7);

% Gaussian filter
denoised_gauss = imgaussfilt(noisy_image, 1.8);

% Median filter
denoised_median = medfilt2(noisy_image, [3, 3]);

figure 
subplot(1, 4, 1)
imshow(img_resized)
title('Original image')
subplot(1, 4, 2)
imshow(denoised_avg)
title('Average')
subplot(1, 4, 3)
imshow(denoised_gauss)
title('Gaussian')
subplot(1, 4, 4)
imshow(denoised_median)
title('Median')
sgtitle('Denoised images')
saveas(gcf, 'Denoised images.png')

% Calculate the global SSIM value and local SSIM map
[ssimval_median, ssimmap] = ssim(denoised_median, img_resized);
[ssimval_gauss, ssimmap] = ssim(denoised_gauss, img_resized);
[ssimval_avg, ssimmap] = ssim(denoised_avg, img_resized);

fprintf('SSIM median = %d, MAE median = %d\n',ssimval_median, median(abs(denoised_median-img_resized), 'all'))
fprintf('SSIM gauss = %d, MAE gauss = %d\n',ssimval_gauss, median(abs(denoised_gauss-img_resized), 'all'))
fprintf('SSIM avg = %d, MAE avg = %d\n',ssimval_avg, median(abs(denoised_avg-img_resized), 'all'))


% A function to add salt and pepper noise
function noisy_image = add_noise(image, y1, y2, x1, x2)
    noisy_image = image;
    noisy_image(y1:y2, x1:x2) = imnoise(image(y1:y2, x1:x2), 'salt & pepper', 0.2);
end


function variance = calculate_var(image, y1, y2, x1, x2)
    variance = var(image(y1:y2, x1:x2), [], 'all');
end
