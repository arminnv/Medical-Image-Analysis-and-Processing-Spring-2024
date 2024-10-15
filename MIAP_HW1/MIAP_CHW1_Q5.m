close all
clear

% Load your grayscale image (replace 'blurred_noisy.png' with the actual image file)
image = im2double(imread('retina.png'));

% Apply 5x5 averaging filter (box filter)
kernel_size = 5;
kernel = ones(kernel_size) / kernel_size^2;
blurred_image = conv2(image, kernel, 'same');

% Add Gaussian noise to the blurred image
noise_stddev = 0.07;
noise = noise_stddev * randn(size(image));
blurred_gauss = blurred_image + noise;
gauss_image = image + noise;

% Denoising images
blurred_denoised = wiener_filter(blurred_image, true);
gauss_denoised = wiener_filter(gauss_image, false);
blurred_gauss_denoised = wiener_filter(blurred_gauss, true);

% Display results
subplot(3, 3, 1); imshow(image); title('Original Image');
subplot(3, 3, 2); imshow(blurred_image); title('Blurred');
subplot(3, 3, 3); imshow(blurred_denoised); title('Restored Image');

subplot(3, 3, 4); imshow(image); title('Original Image');
subplot(3, 3, 5); imshow(gauss_image); title('Gaussian noise');
subplot(3, 3, 6); imshow(gauss_denoised); title('Restored Image');

subplot(3, 3, 7); imshow(image); title('Original Image');
subplot(3, 3, 8); imshow(blurred_gauss); title('Blurred and gaussian noise');
subplot(3, 3, 9); imshow(blurred_gauss_denoised); title('Restored Image');

saveas(gcf, 'retina_denoised.png')

% Calculating PSNR values
fprintf('PSNR blurred = %d \n', calculate_psnr(image, blurred_denoised));
fprintf('PSNR gauss = %d \n', calculate_psnr(image, gauss_denoised));
fprintf('PSNR blurred and gauss = %d \n', calculate_psnr(image, blurred_gauss_denoised));

function restored_image = wiener_filter(noisy_image, degrade)
    average = mean(noisy_image, "all");

    kernel_size = 5;
    kernel = ones(kernel_size) / kernel_size^2;
    
    % Wiener deconvolution parameters
    Pgg = abs(fft2(noisy_image)).^2 / (size(noisy_image, 1) * size(noisy_image, 2));
    Pnn = var(noisy_image(1:50, 1:50), [], "all");
    Pff = max(Pgg - Pnn, 0);
    
    % Compute the Wiener filter
    if degrade
        H = fft2(kernel, size(noisy_image, 1), size(noisy_image, 2));
        G = fft2(noisy_image - average);
        W = Pff .* conj(H) ./ (Pff .* abs(H).^2 + Pnn);
        restored_image = ifft2(W .* G);
    else
        G = fft2(noisy_image - average);
        W = Pff ./ (Pff + Pnn);
        restored_image = ifft2(W .* G);
    end
    restored_image = abs(restored_image + average);
end


function psnr = calculate_psnr(original_image, denoised_image)
    % Calculate the mean squared error (MSE)
    mse = mean((original_image - denoised_image) .^ 2, "all");

    % Calculate the maximum pixel value
    max_pixel_value = max(original_image(:));

    % Calculate PSNR
    psnr = 10 * log10(max_pixel_value^2 / mse);
end
