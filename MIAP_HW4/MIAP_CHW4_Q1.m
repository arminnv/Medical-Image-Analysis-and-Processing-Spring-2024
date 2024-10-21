% Loading data
data = load('Data\q1_data\data\data.mat');
img = double(data.imageData);
mask = double(data.imageMask);

% Save as JPEG
imwrite(img, 'Image q1.jpg', 'JPG');
imwrite(mask, 'mask q1.jpg', 'JPG');

% Initializing params
k = 3;
q = 5;
b0 = 1;
bc = (b0 .* ones(size(img))) .* mask;
eps = 10^-5;
Nmax = 200;

% Defining Gaussian kernel
f = 9;
sigma = 2.5;
kernel = fspecial('gaussian', [f, f], sigma);

% Applying kmeans
[seg, mu, sigma] = KMeans(img, mask, k, eps);

for i=1:k
    subplot(1, 3, i)
    imshow(seg==i)
end
%%

[u, b, c, J] = iterate(img, mask, seg, b0, mu, q, kernel, 100, eps, Nmax);
b2=b;
b2(b==0) = 1;

figure
plot(J)
title('objective')
saveas(gcf, 'obj.png')

figure
imshow(b)
title('Bias Field')
saveas(gcf, 'bias field.png')

figure
subplot(1, 3, 1)
imshow(img)
title('Corrupted')
subplot(1, 3, 2)
imshow((img.*mask)./b2)
title('Bias Removed')
subplot(1, 3, 3)
imshow(b)
title('Bias Field')
saveas(gcf, 'field.png')

figure
showSegmented(seg, k, 'Iinitial: K-Means', 'q1 kmeans.png')
figure
showSegmented(u*3, k, 'Segmented Image', 'q1 seg.png')