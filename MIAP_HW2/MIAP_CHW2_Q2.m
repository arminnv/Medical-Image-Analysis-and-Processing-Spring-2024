clear
close all
% Loading image
img = im2double(imread('hand.jpg'));

% Adding noise
var_noise = 0.05;
img_noisy = rgb2gray(imnoise(img, 'gaussian', 0.01, var_noise));
img = rgb2gray(img);

figure
montage({img, img_noisy})
saveas(gcf, 'montage.png')

% Filter parameters
hg = 1.95*var_noise;
hx = 0.02* norm(size(img));

% Applying classic filter
filtered_image_classic = classical_filter(img_noisy, hx);

figure
montage({img, img_noisy, filtered_image_classic}, 'size', [1 3])
title('Classic Regression')
saveas(gcf, 'hand denoised classic.png')

% Applying bilateral filter
filtered_image_bi = bilateral_filter(img_noisy, hx, hg);

figure
montage({img, img_noisy, filtered_image_bi}, 'size', [1 3])
title('Bilateral')
saveas(gcf, 'hand denoised bi.png')


function filtered_image = classical_filter(input_image, spatial_sigma)
    [rows, columns] = size(input_image);

    % Create spatial Gaussian kernel
    kernel_size = 5;  % Example: 5x5 kernel
    x = linspace(-kernel_size/2, kernel_size/2, kernel_size);
    spatial_kernel = gaussian_kernel(x, spatial_sigma);

    filtered_image = conv2(input_image, spatial_kernel, 'same');
end

function filtered_image = bilateral_filter(input_image, spatial_sigma, range_sigma)
    [rows, columns] = size(input_image);
    filtered_image = zeros(rows, columns);

    % Create spatial Gaussian kernel
    kernel_size = 5;  % Example: 5x5 kernel
    x = linspace(-kernel_size/2, kernel_size/2, kernel_size);
    spatial_kernel = gaussian_kernel(x, spatial_sigma);

    for i = 1+(kernel_size-1)/2:rows-(kernel_size-1)/2
        for j = 1+(kernel_size-1)/2:columns-(kernel_size-1)/2
            % Compute range kernel (based on pixel intensity/color similarity)

            range_kernel = gaussian_kernel(abs(input_image(i, j) - ...
                input_image(i-(kernel_size-1)/2:i+(kernel_size-1)/2, j-(kernel_size-1)/2:j+(kernel_size-1)/2)), range_sigma);

            % Compute weights for neighboring pixels
            weights = spatial_kernel .* range_kernel;
            %disp(size(input_image(i-(kernel_size-1)/2:i+(kernel_size-1)/2, j-(kernel_size-1)/2:j+(kernel_size-1)/2)))
            %disp(size(weights))
            % Apply the filter
            filtered_value = sum(weights ...
                .* input_image(i-(kernel_size-1)/2:i+(kernel_size-1)/2, j-(kernel_size-1)/2:j+(kernel_size-1)/2), 'all');
            filtered_image(i, j) = filtered_value;
        end
    end
end

function kernel = gaussian_kernel(x, sigma)
    % Create a 1D Gaussian kernel
    %disp(size(sigma))
    kernel = exp(-x.^2 ./ (2 * sigma.^2));
    kernel = kernel / sum(kernel);  % Normalize the kernel
end
