close all
clear

img = im2double(imread('TV.png'));
img_noisy = imnoise(img, "gaussian", 0, 0.01);
figure
imshow(img_noisy)

lambda = 10;
alpha = 0.01;
GapTol = 0.01;
N_iterations = 100;
[u,w1,w2,Energy,Dgap,TimeCost,itr] = TV_GPCL(img_noisy,img_noisy,img_noisy,lambda,alpha,N_iterations,GapTol,true);

figure 
subplot(1, 2, 1)
imshow(img_noisy)
subplot(1, 2, 2)
imshow(u)
title("TV GPCL")
saveas(gcf, "tvgpcl.png")
%%

lbd = 10;
alpha = 0.01;
GapTol = 0.01;
NIT = 100;
[u,w1,w2,Energy,Dgap,TimeCost,itr] = TV_Chambolle(img_noisy,img_noisy,img_noisy,lambda,alpha,N_iterations,GapTol, true);

figure 
subplot(1, 2, 1)
imshow(img_noisy)
subplot(1, 2, 2)
imshow(u)
title("TV Chambolle")
saveas(gcf, "Chambolle.png")