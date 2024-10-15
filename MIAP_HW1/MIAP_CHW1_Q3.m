close all
% Loading image
img = im2double(imread('hand_xray.jpg'));
img = img/max(img, [], 'all');

% 2D fourier transform
dft2 = ifftshift(fft2(fftshift(img)));

% Reversing elements of DFT (same as rotating DFT of image for 180 degrees)
dft2_rot = flip(dft2, 1);
dft2_rot = flip(dft2_rot, 2);

% Rotating DFT coefs
dft2_rot = imrotate(dft2, 180, 'bilinear');

figure
subplot(1, 2, 1)
imshow(img)
title('Original image')
subplot(1, 2, 2)
imshow(abs((ifftshift(ifft2(fftshift(dft2_rot))))))
title('Rotated image')

saveas(gcf, 'xray_rotated.png')