close all;
% loading image
img_raw = rgb2gray(imread("Low Matrix Approximation question.jpg"));
img = im2double(img_raw);

% Adding noise
%var_noise = 1 * max(img(:))/max(double(img_raw(:)));
var_noise = 0.01;
img_noisy = imnoise(img, "gaussian", 0, var_noise);

% Initializing hyperparameters
delta = 0.1;
c = 2.8;
patch_size = 40;
K = 8;

y = img_noisy;
x = y;
yk = y;

for k=1:K
    yk = x + delta * (y - yk);
    for i=1:floor(size(y, 1)/patch_size)
        for j=1:floor(size(y, 2)/patch_size)
            % Extracting patrches
            yj = y(1+(i-1)*patch_size:i*patch_size, 1+(j-1)*patch_size:j*patch_size);

            % Finding similar Patches
            Yj = find_similar(yj, y);

            % Singular value decomposition
            [U, S, V] = svd(Yj);
            Sw = calc_sw(S, 1, c); % optimal singular values
            Xj = U * Sw * V'; % reconstructed matrix
            % Aggregating patches
            x(1+(i-1)*patch_size:i*patch_size, 1+(j-1)*patch_size:j*patch_size) = ...
            reshape(Xj(:, 1), [patch_size, patch_size]);
            disp([i,j])
        end
    end
end

%%
figure
subplot(1, 3, 1)
imshow(img)
title('original')
subplot(1, 3, 2)
imshow(y)
title('noisy')
subplot(1, 3, 3)
%imshow(reshape(Xj(:,8), [patch_size,patch_size]))
imshow(yk)
title('denoised')
saveas(gcf, 'q4.png')

% Calculating new singular values (Sw)
function Sw = calc_sw(S, var_noise, c)
    n = size(S, 2);
    sigma_hat = sqrt(max(diag(S).^2 - n*var_noise, 0));
    w = c * sqrt(n) ./ (sigma_hat + 10^-16);
    Sw = zeros(size(S));
    r = min(size(S, 1), size(S, 2));
    Sw(1:r, 1:r) = diag(max(sigma_hat-w, 0));
end

% Block matching
function Yj = find_similar(yj, y)
    Yj = [];
    S = [];
    loc = [];
    w1 = size(yj,1);
    w2 = size(yj,2);
    for i=1:size(y, 1)-w1+1
        for j=1:size(y,2)-w2+1
           patch = y(i:i+w1-1, j:j+w2-1);
           similarity = norm(patch-yj, 'fro');
           S = [S, similarity];
           loc = [loc, [i;j]];
           
           %if similarity > 6
           %     Yj = [Yj, patch(:)];
           %end
        end
    end
    [minvalues, ind] = mink(S, 10);

    for m=1:length(ind)
        i = loc(1, ind(m));
        j = loc(2, ind(m));
        patch = y(i:i+w1-1, j:j+w2-1);
        Yj = [Yj, patch(:)];
    end
end