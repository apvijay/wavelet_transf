% Given an image, returns the reconstructed image using wavelet
% thresholding retaining only the top req_spars coefficients. Also returns
% the reconstruction error.

function [img_reconst reconst_err spars] = hard_wavelet_thresh_spars(img, wave, req_spars)

calc_err = @(x,y) sum((double(x(:)) - double(y(:))).^2);

[alpha wave.Cbook] = wavedec2(img, wave.level, wave.name);
[alpha_sort alpha_sort_ind] = sort(abs(alpha(:)),'descend');
req_ind = alpha_sort_ind(req_spars+1:end);
alpha(req_ind) = 0;
spars = sum(abs(alpha(:)) > 0);
img_reconst = waverec2(alpha, wave.Cbook, wave.name);
reconst_err = calc_err(img,img_reconst);
