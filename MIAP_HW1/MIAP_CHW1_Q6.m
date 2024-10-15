close all;

% Load the image
original_image = rgb2gray(imread('brain_ct.jpeg'));

% Manually set the threshold value (adjust as needed)
threshold_value = 80; % Example threshold value

% Create a binary mask based on the threshold
binary_mask = original_image > threshold_value;

% Apply morphological operations (dilation and erosion) to the binary mask
se = strel('disk', 6); % Define a structuring element (you can adjust the size)
dilated_mask = imdilate(binary_mask, se);
eroded_mask = imerode(dilated_mask, se);

% Compare the original image with the final mask
figure;
subplot(1, 4, 1); imshow(binary_mask); title('Binary Image');
subplot(1, 4, 2); imshow(dilated_mask); title('Dilated Mask');
subplot(1, 4, 3); imshow(eroded_mask); title('Eroded Mask');
subplot(1, 4, 4); imshow(original_image); title('Original');
saveas(gcf, 'mask ct.png')

% Add Gaussian noise to the original image
noisy_image = imnoise(original_image, 'gaussian', 0, 0.02); % Adjust noise parameters

% Repeat the thresholding and morphological operations on the noisy image
noisy_binary_mask = noisy_image > threshold_value;
noisy_dilated_mask = imdilate(noisy_binary_mask, se);
noisy_eroded_mask = imerode(noisy_dilated_mask, se);

% Compare the noisy original image with the final noisy mask
figure;
subplot(1, 4, 1); imshow(noisy_binary_mask); title('Binary Noisy Image');
subplot(1, 4, 2); imshow(noisy_dilated_mask); title('Noisy Dilated Mask');
subplot(1, 4, 3); imshow(noisy_eroded_mask); title('Noisy Eroded Mask');
subplot(1, 4, 4); imshow(original_image); title('Original');
saveas(gcf, 'mask ct noisy.png')
