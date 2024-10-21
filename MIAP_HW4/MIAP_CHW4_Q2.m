close all;

% Loading
img = rgb2gray(im2double(imread('data/q2_data/melanoma.jpg')));

figure
imshow(img)

n_points = 40;
niter = 50;
X = zeros(n_points, 2);

% Initial rect contour
theta = 2*pi/n_points;
r = 100;
for i=1:n_points
    X(i, 1) = max(min(floor(size(img,2)/2 + 1.3*r*cos(i*theta)), 190), 10);
    X(i, 2) = max(min(floor(size(img,1)/2 + r*sin(i*theta)), 145), 10);
end

% Show initial contour
figure
I = insertMarker(img, X, 'o', 'Size', 2);
imshow(I)
title('initial')
saveas(gcf, 'rect.png')

% Calculate gradient of smoothed image
[Gx, Gy] = imgradientxy(imgaussfilt(img, 1));

% Video writer
outputVideo = VideoWriter(fullfile('output_video.avi'));
outputVideo.FrameRate = 8; % Set the desired frame rate
open(outputVideo);

% Main loop
for t=1:niter
    disp(t)
    
    % iterate for each point
    for n=1:n_points
        % Calculate d
        d = calculate_average_distance(X);
        w = 2;
        kernel_size = 2*w+1;
        K = zeros(kernel_size, kernel_size);
        
        % Find energy difference of neighbours 
        for k1=1:kernel_size
            for k2=1:kernel_size
                nstep = 1;
                K(k1, k2) = calc_deltaE(X, n, [X(n,1)+k1-w-1, X(n,2)+k2-w-1], d, Gx, Gy);
                
            end
        end

        % Find minimum energy
        [Min, idx] = min(K, [], 'all');
        [i1, i2] = find(K == Min, 1);
        
        % Move the point
        X(n, 1) = X(n,1)+i1-w-1;
        X(n, 2) = X(n,2)+i2-w-1;

    end    
    % Write frame
    writeVideo(outputVideo, insertMarker(img, X, 'o', 'Size', 2));
end

close(outputVideo);

% Show result
I = insertMarker(img, X, 'o', 'Size', 2);
figure
imshow(I)
saveas(gcf, 'snake.png')

% Calculate energy difference
function deltaE = calc_deltaE(X, n, xnew, d, Gx, Gy)
    lamda = 50000;
    n_points = size(X, 1);
    n1 = n-1;
    n2 = n+1;
    if n1<=0
        n1=n1+n_points;
    end
    if n2>n_points
        n2=n2-n_points;
    end
    d=1;
    
    % Potential difference
    deltaE_int = ((X(n2,1)-xnew(1))^2 + (X(n2,2)-xnew(2))^2 - d^2)^2 + ...
             ((X(n1,1)-xnew(1))^2 + (X(n1,2)-xnew(2))^2 - d^2)^2 - ...
             ((X(n2,1)-X(n,1))^2 + (X(n2,2)-X(n,2))^2 - d^2)^2 - ...
             ((X(n1,1)-X(n,1))^2 + (X(n1,2)-X(n,2))^2 - d^2)^2;
    
    % External difference
    deltaE_ext = -Gx(xnew(2),xnew(1))^2 -Gy(xnew(2),xnew(1))^2 ...
                +Gx(X(n,2),X(n,1))^2 +Gy(X(n,2),X(n,1))^2;
    
    % Total difference
    deltaE = deltaE_int + lamda * deltaE_ext;
end


function d = calculate_average_distance(X)
    sum_dist = norm(X(end)-X(1));
    n = length(X);
    
    for i=1:n-1
        sum_dist = sum_dist + norm(X(i+1)-X(i));
    end

    d = sum_dist/n;
end