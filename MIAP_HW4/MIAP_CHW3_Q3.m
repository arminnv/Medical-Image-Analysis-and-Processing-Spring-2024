images = zeros(256, 256, 5);

% Loading
for i=1:5
    images(:, :, i) = im2double(imread("Data\q3_data\Mri" + num2str(i) + ".bmp"));
end

figure 
subplot(1,2,1)
imshow(images(:, :, [1,2,3]))
title('channels 1,2,3')
subplot(1,2,2)
imshow(images(:, :, [1, 4, 5]))
title('channels 1,4,5')
saveas(gcf, 'rgb.png')

%%
Q = [1.1, 2, 5];

for q=Q
    % Running FCM algorithm
    [center, U, obj_fcn] = fcm(reshape(images, [], 5), 5, [q; 100; 1e-5; 1]);
    
    img = reshape(U', 256, 256, 5);
    figure
    for i=1:5
        subplot(1, 5, i)
        imshow(img(:, :, i));
    end
    sgtitle("FCM q = " + num2str(q))
    saveas(gcf, num2str(q)+"fcm.png")
end

%%
Q = [1.1, 2, 5];

[IDX, C] = kmeans(reshape(images, [], 5), 5);
options = fcmOptions(NumClusters=5, ClusterCenters=C);

for q=Q
    [center, U, obj_fcn] = fcm(reshape(images, [], 5), 5, options);
    
    img = reshape(U', 256, 256, 5);
    figure
    for i=1:5
        subplot(1, 5, i)
        imshow(img(:, :, i));
    end
    sgtitle("FCM q = " + num2str(q))
    saveas(gcf, num2str(q)+"fcm.png")
end


%%

X = reshape(images, [], 5);

% Fitting GMM with 5 clusters
GMM = fitgmdist(X, 5, 'RegularizationValue', 1e-4);

figure
for i=1:5
    mu  = GMM.mu(i, :);
    sigma = GMM.Sigma(:,:,i);

    % Calculating probability map
    P = mvnpdf(X, mu, sigma) * GMM.ComponentProportion(i);

    subplot(1, 5, i)
    imshow(reshape(P, 256, 256)/max(P(:)))
end
sgtitle('GMM')
saveas(gcf, 'GMM.png')

%%

figure
P = zeros(65536, 5);
for i=1:5
    mu  = GMM.mu(i, :);
    sigma = GMM.Sigma(:,:,i);

    % Calculating probability map
    P(:, i) = mvnpdf(X, mu, sigma) * GMM.ComponentProportion(i);
end

% Finding max probabilities
[m, IDX] = max(P, [], 2);

for i=1:5
    subplot(1, 5, i)
    imshow(reshape(IDX==i, 256, 256))
end
sgtitle('GMM')
saveas(gcf, 'GMM hard.png')
