clear
close all

img = phantom('Modified Shepp-Logan', 500);

% Adding noise
noisy_image = imnoise(img, 'gaussian', 0, 0.05);

figure
subplot(1, 2, 1)
imshow(img);
title('Original')
subplot(1, 2, 2)
imshow(noisy_image);
title('Noisy')
saveas(gcf, "phantom.png")

% Initialize u with the noisy image
v = double(noisy_image);
u = v;

% Set parameters
num_iterations = 10; % Number of iterations
tau = 0.01; % Time step
lambda = 10;

% Iterative time marching
for k = 1:num_iterations
    % Calculate and normalize gradient
    normalized_grad_x = grad_signed(u, 1, 2)./sqrt(grad_signed(u, 1, 2).^2 + ...
        minmod(grad_signed(u, 1, 1), grad_signed(u, -1, 1)).^2 + eps);
    normalized_grad_y = grad_signed(u, 1, 1)./sqrt(grad_signed(u, 1, 1).^2 + ...
        minmod(grad_signed(u, 1, 2), grad_signed(u, -1, 2)).^2 + eps);

    % Compute divergence
    div = grad_signed(normalized_grad_x, -1, 2) + grad_signed(normalized_grad_y, -1, 1);

    % Update u
    u = u + tau * (div + lambda*(u-v));
end

% Display the denoised image
figure
subplot(1, 3, 1)
imshow(img);
title('Original')
subplot(1, 3, 2)
imshow(noisy_image);
title('Noisy')
subplot(1, 3, 3)
imshow(u);
title('Denoised')
sgtitle("Iterations = " + num2str(num_iterations))
saveas(gcf, "Iterations = " + num2str(num_iterations) + ".png")

% Calculating SNR
SNR = 10*log10(var(img(:))/var(img(:)-u(:)));
fprintf("SNR for %d iterations = %d \n", num_iterations, SNR);


% Gradient calculation
function g = grad_signed(X, sign, dim)
    g = sign * (circshift(X, sign, dim) - X);
    
    if dim==1
            g(1, :)=0;
            g(end, :)=0;
    else
            g(:, 1)=0;
            g(:, end)=0;
    end
end

function m = minmod(a, b)
    m = min(abs(a), abs(b)) .* (sign(a)+sign(b))/2;
end
