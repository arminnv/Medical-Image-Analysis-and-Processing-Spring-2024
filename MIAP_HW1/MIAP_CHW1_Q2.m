close all
% Loading image
img = im2double(imread('retina.png'));
img = img/max(img, [], 'all');

% Logarithmic transform
c = 2;
img_log = c*log(1+abs(img));
%img_log = img_log/max(img_log, [], 'all');

% Law-Power transform
gamma = 2;
a = 2.6;
img_pow = a*img.^gamma;
%img_pow = img_pow/max(img_pow, [], 'all');

% Displaying results
figure
subplot(1, 3, 1)
imshow(img)
title('Original')
subplot(1, 3, 2)
imshow(img_log)
title('Logarithmic')
subplot(1, 3, 3)
imshow(img_pow)
title('Power-law')

saveas(gcf, 'retina_enhanced.png')

