close all
clear

% Define the structuring element (square mask)
se_square = strel('square', 30); % Change the size as needed

% Define the structuring element (disk mask)
se_disk = strel('disk', 15); % Change the radius as needed

% Read the input image (replace 'input_image.png' with your image)
original_image = rgb2gray(imread('mri_low_contrast.png'));

input_image = original_image > 100;

% Apply top-hat transform using square mask
tophat_square = input_image - imopen(input_image, se_square);

% Apply bottom-hat transform using square mask
bottomhat_square = imclose(input_image, se_square) - input_image;

% Apply top-hat transform using disk mask
tophat_disk = input_image - imopen(input_image, se_disk);

% Apply bottom-hat transform using disk mask
bottomhat_disk = imclose(input_image, se_disk) - input_image;

image = im2double(original_image);
% Display the results (you can customize this part)
figure;
subplot(2, 2, 1); imshow(tophat_square); title('Top-Hat (Square Mask)');
subplot(2, 2, 2); imshow(tophat_disk); title('Top-Hat (Disk Mask)');
subplot(2, 2, 3); imshow(bottomhat_square); title('Bottom-Hat (Square Mask)');
subplot(2, 2, 4); imshow(bottomhat_disk); title('Bottom-Hat (Disk Mask)');
saveas(gcf, 'tophat.png')

figure
subplot(2, 2, 1); imshow(image.*tophat_square); title('Top-Hat Transform (Square Mask)');
subplot(2, 2, 2); imshow(image.*tophat_disk); title('Top-Hat Transform (Disk Mask)');
subplot(2, 2, 3); imshow(image.*bottomhat_square); title('Bottom-Hat Transform (Square Mask)');
subplot(2, 2, 4); imshow(image.*bottomhat_disk); title('Bottom-Hat Transform (Disk Mask)');
saveas(gcf, 'tophat transform.png')

a1 = 1;
a2 = 1;

% Define the structuring element (square mask)
se_square = strel('square', 3); % Change the size as needed

% Define the structuring element (disk mask)
se_disk = strel('disk', 2); % Change the radius as needed

image_enhanced_square = image + a1*image.*imopen(input_image, se_square) -a2* image.*(1-imclose(input_image, se_square));
image_enhanced_square = image_enhanced_square / max(image_enhanced_square(:));
image_enhanced_disk = image + a1*image.*imopen(input_image, se_disk) - a2*image.*(1-imclose(input_image, se_disk));
image_enhanced_disk = image_enhanced_disk / max(image_enhanced_disk(:));


CIRs_disk = [];
CIRs_square = [];

% Define the structuring element (square mask)
se_square = strel('square', 2); % Change the size as needed

% Define the structuring element (disk mask)
se_disk = strel('disk', 2); % Change the radius as needed 

se = strel('square', 2);

for i=1:6
    image_enhanced_square = image + a1*image.*imopen(input_image, se_square) -a2* image.*(1-imclose(input_image, se_square));
    image_enhanced_square = image_enhanced_square / max(image_enhanced_square(:));
    image_enhanced_disk = image + a1*image.*imopen(input_image, se_disk) - a2*image.*(1-imclose(input_image, se_disk));
    image_enhanced_disk = image_enhanced_disk / max(image_enhanced_disk(:));   
    
    CIRs_square = [CIRs_square calculate_CIR(image, image_enhanced_square)];
    CIRs_disk = [CIRs_disk calculate_CIR(image, image_enhanced_disk)];

    figure
    subplot(1, 3, 1);
    imshow(original_image)
    title('original image')
    subplot(1, 3, 2);
    imshow(image_enhanced_square)
    title('square')
    subplot(1, 3, 3);
    imshow(image_enhanced_disk)
    title('disk')

    sgtitle("size = " + num2str(i))
    saveas(gcf, "size = " + num2str(i) + ".png")

    se_square = strel('square', i);
    se_disk = strel('disk', i);

end

disp(['Contrast Improvement Ratio (CIR) within ROI square: ', num2str(CIRs_square)]);
disp(['Contrast Improvement Ratio (CIR) within ROI disk: ', num2str(CIRs_disk)]);


function CIR = calculate_CIR(unenhanced_image, enhanced_image)
    % Define window sizes
    windowSize3 = 3;
    windowSize7 = 7;
    
    % Create kernels for convolution
    kernel3 = ones(windowSize3) / windowSize3^2;
    kernel7 = ones(windowSize7) / windowSize7^2;
    
    % Compute C1 for unenhanced image
    p = conv2(double(unenhanced_image), kernel3, 'same');
    a = conv2(double(unenhanced_image), kernel7, 'same');
    C = abs(p - a) ./ abs(p + a);
    
    % Compute Cbar for enhanced image
    p = conv2(double(enhanced_image), kernel3, 'same');
    a = conv2(double(enhanced_image), kernel7, 'same');
    C_hat = abs(p - a) ./ max(abs(p + a),  0.001);
    
    % Calculate CIR within a region of interest (ROI)
    numerator = (C - C_hat).^2;
    denominator = C.^2;
    CIR = sum(numerator(30:190, 20:220), "all") / sum(denominator(30:190, 20:220), "all");
end



