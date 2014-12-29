% Comparison of reconstruction error of blurred images for a given sparsity
clc;
close all;
clear all;

calc_err = @(x,y) sum((double(x(:)) - double(y(:))).^2);

% Read image
pathname = '~/iitm/code/std_images/';
% filename = 'card_monster_colour_256.png';
% filename = 'cars_colour_256.png';
filename = 'shore_colour_1024.jpg';

tmp = imread([pathname filename]);
% tmp = imresize(tmp, [256 256], 'bilinear');
orig.img = double(tmp(:,:,1)) / 255;

% Wavelet parameters
dwtmode('per');
wave.name = 'db6';
wave.level = 6;
req_spars = ceil(0.8 * numel(orig.img));

% Sparsity of orig image
[orig.reconst orig.err orig.spars] = hard_wavelet_thresh_spars(orig.img,wave,req_spars);

% Sparsity of blurred images
iter = 1;
for sigma = [0.1:0.1:2.0]
    % Filter parameters
    kernel_size = 5;
    filtparams.hsize = [kernel_size kernel_size];
    filtparams.sigma = sigma;

    % Create rotationally symmetric Gaussian filter
    h = fspecial('gaussian', filtparams.hsize, filtparams.sigma);

    % Convolve
    blur.img = conv2(orig.img,h,'same');

    [blur.reconst blur.err blur.spars] = hard_wavelet_thresh_spars(blur.img,wave,req_spars);

    spars.sigma(iter) = sigma;
    spars.val(iter) = blur.err;

    iter = iter + 1;
end
spars.sigma = [0 spars.sigma];
spars.val = [orig.err spars.val];
figure;
plot(spars.sigma, spars.val);
xlabel('Blur sigma');
ylabel('Reconstruction error');
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
