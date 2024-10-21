% Loading images
monkey_image = imread('monkey.jpg');
lion_image = imread('lion.jpg');

% Converting to gray-scale
monkey = im2double(rgb2gray(monkey_image));
lion = im2double(rgb2gray(lion_image));

% 2D DFT
monkey_fft = fft2(monkey);
lion_fft = fft2(lion);

% Swapping phases
combined_image_monkey = ifft2(abs(monkey_fft) .* exp(1i * angle(lion_fft)));
combined_image_lion = ifft2(abs(lion_fft) .* exp(1i * angle(monkey_fft)));

figure
subplot(2, 2, 1)
imshow(monkey)
title('Monkey')
subplot(2, 2, 2)
imshow(lion)
title('Lion')
subplot(2, 2, 3)
imshow(abs(combined_image_monkey))
title('Monkey with lion phase')
subplot(2, 2, 4)
imshow(abs(combined_image_lion))
title('Lion with monkey phase')

saveas(gcf, 'phase swap.png')