% Comparison of sparsity levels of blurred images
clc;
close all;
clear all;

% Read image
pathname = '~/iitm/code/std_images/';
filename = 'card_monster_colour_256.png';
% filename = 'cars_colour_256.png';
tmp = imread([pathname filename]);
orig.img = double(tmp(:,:,1)) / 255;

% Wavelet parameters
dwtmode('per');
wave.name = 'db4';
wave.level = 6;
req_err = 2;

% Sparsity of orig image
[orig.reconst orig.err orig.spars] = hard_wavelet_thresh_err(orig.img,wave,req_err);
orig.spars_perc = orig.spars / numel(orig.img) * 100;

% Sparsity of blurred images
iter = 1;
for sigma = [0.01,0.1:0.1:1.0]
% Filter parameters
kernel_size = 3;
filtparams.hsize = [kernel_size kernel_size];
filtparams.sigma = sigma;

% Create rotationally symmetric Gaussian filter
h = fspecial('gaussian', filtparams.hsize, filtparams.sigma);

% Convolve
blur.img = conv2(orig.img,h,'same');

[blur.reconst blur.err blur.spars] = hard_wavelet_thresh_err(blur.img,wave,req_err);
blur.spars_perc = blur.spars / numel(blur.img) / size(blur.img,3) * 100;

spars.sigma(iter) = sigma;
spars.val(iter) = blur.spars;

iter = iter + 1;
end

figure;
plot([0 spars.sigma], [orig.spars spars.val] / size(orig.img,1) / size(orig.img,2));

% % % figure;
% % % subplot(121), imshow(uint8(orig.img * 255));
% % % titlename = ['Using top ' num2str(orig.spars_perc) '% (' num2str(orig.spars) ') coeffs'];
% % % subplot(122), imshow(uint8(orig.reconst * 255)), 
% % % title(titlename), xlabel(['Reconst err = ' num2str(orig.err)]);
% % % 
% % % 
% % % figure;
% % % subplot(121), imshow(uint8(blur.img * 255));
% % % titlename = ['Using top ' num2str(blur.spars_perc) '%  (' num2str(blur.spars) ') coeffs'];
% % % subplot(122), imshow(uint8(blur.reconst * 255)),
% % % title(titlename), xlabel(['Reconst err = ' num2str(blur.err)]);
