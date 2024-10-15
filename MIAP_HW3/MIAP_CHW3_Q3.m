% Loading image
img = im2double(imread('retina.png'));

% Adding salt and pepper noise
img_noisy = imnoise(img, 'salt & pepper', 0.5);

Z = zeros(size(img)); % denoised image\
Y = img_noisy;

Wmax = 39;
% Iterate through pixels
for i=1:size(Y, 1)
    for j=1:size(Y, 2)
        w = 1;
        h = 1;
        while(true)
            wmax = min([Wmax, i-1, j-1, size(Y, 1)-i, size(Y, 2)-j]);
            w = min([w, i-1, j-1, size(Y, 1)-i, size(Y, 2)-j]);
            Smed = median(Y(i-w:i+w, j-w:j+w), 'all');
            Smax = max(Y(i-w:i+w, j-w:j+w), [], 'all');
            Smin = min(Y(i-w:i+w, j-w:j+w), [], 'all');
            if Smin < Smed && Smed < Smax
                if Smin < Y(i, j) && Y(i, j) < Smax
                    Z(i,j) = Y(i,j);
                else
                    Z(i,j) = Smed;
                end
                break
            else
                w = w+h;
            end

            if w > wmax
                Z(i, j) = Smed;
                break
            end
        end
    end
end

% Plotting results
figure
subplot(1, 2, 1)
imshow(Y)
title('noisy')
subplot(1, 2, 2)
imshow(Z)
title('denoised')
saveas(gcf, 'amf.png')

Z_amf = Z;
%%

Z = zeros(size(img)); % denoised image
Y = img_noisy;

Wmax = 39;
h = 1;
% Iterate through pixels
for i=2+h:size(Y, 1)-h-1
    for j=2+h:size(Y, 2)-h-1
        w = 1;
        while(true)
            wmax = min([Wmax, i-1-h, j-1-h, size(Y, 1)-i-h, size(Y, 2)-j-h]);
            w = min([w, i-1-h, j-1-h, size(Y, 1)-i-h, size(Y, 2)-j-h]);

            y_patch = Y(i-w:i+w, j-w:j+w);
            Smax = max(y_patch, [], 'all');
            Smin = min(y_patch, [], 'all');
            Smaxh = max(Y(i-w-h:i+w+h, j-w-h:j+w+h), [], 'all');
            Sminh = min(Y(i-w-h:i+w+h, j-w-h:j+w+h), [], 'all');
            % Calculating a(k,l)
            A = (y_patch > Smin) & (y_patch < Smax);
            % Calculating Smean
            Smean = -1;
            if sum(A(:)) ~= 0
                Smean = sum(A.*y_patch, "all")/sum(A(:));
            end


            if Smin == Smin && Smax == Smaxh && Smean ~= -1
                if Smin < Y(i, j) && Y(i, j) < Smax
                    Z(i,j) = Y(i,j);
                else
                    Z(i,j) = Smean;
                end
                break

            else
                w = w+h;
            end

            if w > wmax
                Z(i, j) = Smean;
                break
            end
        end
    end
end

% Plotting results
figure
subplot(1, 2, 1)
imshow(Y)
title('noisy')
subplot(1, 2, 2)
imshow(Z)
title('denoised')
saveas(gcf, 'alg.png')

%%
% Calculating errors
psnr_amf = psnr(img, Z_amf);
psnr_alg = psnr(img, Z);
mse_amf = immse(img, Z_amf);
mse_alg = immse(img, Z);

fprintf('psnr amf: %d \n', psnr_amf)
fprintf('psnr alg: %d \n', psnr_alg)
fprintf('mse amf: %d \n', mse_amf)
fprintf('mse alg: %d \n', mse_alg)
