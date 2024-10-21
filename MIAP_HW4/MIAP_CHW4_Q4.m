% Loading
img1 = imread('Data\q4_data\nevus.jpg');
img1 = im2double(rgb2gray(img1));
img2 = imread('Data\q4_data\melanoma.jpg');
img2 = im2double(rgb2gray(img2));

name1 = 'nevus';
name2 = 'melanoma';
img = img2;
name = name2;

figure('WindowState','fullscreen')
imshow(img)

% Selecing initial coordinates by mouse
[X, Y, ~] = ginput(6);

% Creating polgon mask
mask = roipoly(img, int32(X)', int32(Y)');
imshow(mask)

% Extracting contour bu chan-vese
BW = activecontour(img, mask, 'Chan-vese');
imshow(BW)

figure 
subplot(1, 3, 1)
imshow(img)
title(name)
subplot(1, 3, 2)
imshow(mask)
title("manual mask - " + name)
subplot(1, 3, 3)
imshow(BW.*img)
title("contour " + name)
saveas(gcf, name+" manual.png")

%%
img = img1;
name = name1;

% Input by user 
xin = str2double(input("X:", "s"));
yin = str2double(input("Y:", "s"));

% mask size
window = 9;

% Square mask
mask = zeros(size(img));
mask(yin-floor(window/2):yin+floor(window/2), xin-floor(window/2):xin+floor(window/2)) = ones(window);

% Extracting contour bu chan-vese
BW = activecontour(img, mask, 'Chan-vese');
imshow(BW)

figure 
subplot(1, 3, 1)
imshow(img)
title(name)
subplot(1, 3, 2)
imshow(mask)
title("square mask - " + name)
subplot(1, 3, 3)
imshow(BW.*img)
title("contour " + name)
saveas(gcf, name+" square.png")
%%
img = imread('Data\q4_data\MRI3.png');

figure('WindowState','fullscreen')
imshow(img)

[X, Y, ~] = ginput(8);

mask = roipoly(img, int32(X)', int32(Y)');
imshow(mask)

% Extracting contour bu chan-vese
BW = activecontour(img, mask, 'Chan-vese');
imshow(BW)

%%
img = imread('Data\q4_data\MRI3.png');
img = im2double(img);
name = "MRI";

figure('WindowState','fullscreen')
imshow(img)

% Selecing initial coordinates by mouse
[X, Y, ~] = ginput(8);

% Creating polgon mask
mask = roipoly(img, int32(X)', int32(Y)');
imshow(mask)

% Extracting contour bu chan-vese
BW = activecontour(img, mask, 'Chan-vese');
imshow(BW)

figure 
subplot(1, 3, 1)
imshow(img)
title(name)
subplot(1, 3, 2)
imshow(mask)
title("manual mask - " + name)
subplot(1, 3, 3)
imshow(BW.*img)
title("contour " + name)
saveas(gcf, name+" manual.png")


%%
img = imread('Data\q4_data\MRI3.png');
img = im2double(img);
name = "MRI";

% Input by user 
xin = str2double(input("X:", "s"));
yin = str2double(input("Y:", "s"));

% mask size
window = 9;

% Square mask
mask = zeros(size(img));
mask(yin-floor(window/2):yin+floor(window/2), xin-floor(window/2):xin+floor(window/2)) = ones(window);

% Extracting contour bu chan-vese
BW = activecontour(img, mask, 'Chan-vese');
imshow(BW)

figure 
subplot(1, 3, 1)
imshow(img)
title(name)
subplot(1, 3, 2)
imshow(mask)
title("square mask - " + name)
subplot(1, 3, 3)
imshow(BW.*img)
title("contour " + name)
saveas(gcf, name+" square.png")

%%
img = imread('Data\q4_data\MRI3.png');
img = im2double(img);
name = "MRI";

% Threshold mask
threshold = max(img(:))*0.8;
mask = img > threshold;

% Extracting contour bu chan-vese
BW = activecontour(img, mask, 'Chan-vese');
imshow(BW)

figure 
subplot(1, 3, 1)
imshow(img)
title(name)
subplot(1, 3, 2)
imshow(mask)
title("threshold mask - " + name)
subplot(1, 3, 3)
imshow(BW.*img)
title("contour " + name)
saveas(gcf, name+" threshold.png")