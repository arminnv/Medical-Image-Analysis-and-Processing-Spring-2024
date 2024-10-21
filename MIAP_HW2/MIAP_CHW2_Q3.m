clear
close all
% Loading image
img1 = im2double(rgb2gray(imread('Image1.png')));
img2 = im2double(rgb2gray(imread('Image2.png')));

% Adding noise
img1_noisy = imnoise(img1, 'gaussian', 0.5, 0.1);
img2_noisy = imnoise(img2, 'salt & pepper', 0.01);

img = img2_noisy;

% Set parameters
Wsim = 3;
W = 5;
h = 0.5; % Smoothing parameter
patch_size = 2*Wsim+1; % Patch size

% Initialize filtered image
filtered_img = zeros(size(img));

% Padding for boundary pixels
len_pad = W+Wsim;
padded_img = padarray(img, [len_pad, len_pad], 'symmetric');


PSNR = [];
H = [0.1, 0.2, 0.3, 0.4, 0.5];
figure
nplot = 1;
for h=H
    % Iterate over each pixel
    for i = 1:size(img, 1)
        for j = 1:size(img, 2)
            patch_center = padded_img(i-Wsim+len_pad:i+Wsim+len_pad, j-Wsim+len_pad:j+Wsim+len_pad);
            
            % Compute weighted average
            total_weight = 0;
            weighted_sum = 0;
            
            for m = -W:W
                for n = -W:W
                    patch = padded_img(i-Wsim+m++len_pad:i+Wsim+m++len_pad, j-Wsim+n++len_pad:j+Wsim+n++len_pad);
    
                    % Calculating weights based on similarity 
                    weight = exp(-norm(patch - patch_center)^2 / h^2);
                    weighted_sum = weighted_sum + weight * padded_img(i+m+len_pad, j+n+len_pad);
                    total_weight = total_weight + weight;
                end
            end
             
            % Update filtered pixel
            filtered_img(i, j) = weighted_sum / total_weight;
        end
    end

    PSNR = [PSNR, calculate_psnr(img2, filtered_img)];
    subplot(1, 5, nplot)
    nplot = nplot+1;
    imshow(filtered_img)
    title("sigma = "+num2str(h))
    disp(h)
end
saveas(gcf, "img2 NLM all W = " + num2str(W) + ".png")

figure 
plot(H, PSNR)
title("img2 nlm psnr W = " + num2str(W))
saveas(gcf, "img2 nlm psnr W = " + num2str(W) + ".png")

% Display the original and filtered images
figure
subplot(1, 2, 1);
imshow(img);
title('Original Image');
subplot(1, 2, 2);
imshow(abs(filtered_img)); % Convert back to uint8
title('Filtered Image');

% Save the filtered image
saveas(gcf, "img1 NLM W = " + num2str(W) + ".png")

%%

img1 = im2double(rgb2gray(imread('Image1.png')));
img2 = im2double(rgb2gray(imread('Image2.png')));

% Adding noise
img1_noisy = imnoise(img1, 'gaussian', 0.5, 0.1);
img2_noisy = imnoise(img2, 'salt & pepper', 0.01);

PSNR = [];
S = [0.1, 0.2, 0.3, 0.4, 0.5];
for sigma = S
    % Apply Gaussian filtering to denoise the image
    denoised_gauss = classical_filter(img2_noisy, sigma);
    PSNR = [PSNR, calculate_psnr(img2, denoised_gauss)];

end

figure 
plot(S, PSNR)
title("img2 gauss psnr")
saveas(gcf, "img2 gauss psnr.png")


function psnr = calculate_psnr(original_image, denoised_image)
    % Calculate the mean squared error (MSE)
    mse = mean((original_image - denoised_image) .^ 2, "all");

    % Calculate the maximum pixel value
    max_pixel_value = max(original_image(:));

    % Calculate PSNR
    psnr = 10 * log10(max_pixel_value^2 / mse);
end

function filtered_image = classical_filter(input_image, spatial_sigma)
    [rows, columns] = size(input_image);

    % Create spatial Gaussian kernel
    kernel_size = 77;  % Example: 5x5 kernel
    x = linspace(-kernel_size/2, kernel_size/2, kernel_size);
    spatial_kernel = gaussian_kernel(x, spatial_sigma);

    filtered_image = conv2(input_image, spatial_kernel, 'same');
end

function kernel = gaussian_kernel(x, sigma)
    % Create a 1D Gaussian kernel
    %disp(size(sigma))
    kernel = exp(-x.^2 ./ (2 * sigma.^2));
    kernel = kernel / sum(kernel);  % Normalize the kernel
end


