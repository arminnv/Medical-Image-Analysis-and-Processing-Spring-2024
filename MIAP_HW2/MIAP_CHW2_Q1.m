clear
close all
% Loading image
img = imread('q1.png');

% Setting threshold on green channel
mask = img(:, :, 2)>200;
mask(img(:, :, 1)>30) = 0;
disp(size(mask(:, :, 1)<100))

% Plotting the mask
figure
imshow(mask)
saveas(gcf, 'q1res01.jpg')

% Filling the holes
se = strel('disk', 10);
mask = imdilate(mask, se);
mask = imerode(mask, se);

% Plotting filled mask
figure
imshow(mask)
saveas(gcf, 'q1res02.jpg')

% Coloring the shirt
idx = mask(:, :)>0;
red = img(:, :, 1);
green = img(:, :, 2);
green(idx) = 0;
red(idx) = 255;
img(:, :, 1) = red;
img(:, :, 2) = green;

figure
imshow(img)
saveas(gcf, 'q1res03.jpg')