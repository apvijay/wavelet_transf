% Given an image, returns the reconstructed image using wavelet
% thresholding such that the reconstructed error is 0.01. Also returns the
% number of non-zero coefficients, i.e. the sparsity level to achieve the
% desired reconstruction error

function [img_reconst reconst_err spars] = hard_wavelet_thresh_err(img, wave, req_err)

calc_err = @(x,y) sum((double(x(:)) - double(y(:))).^2);

% Wavelet parameters
% dwtmode('per');
% wave.name = 'db4';
% wave.level = 6;
% reconst_err = req_err - 1;
[alpha wave.Cbook] = wavedec2(img, wave.level, wave.name);
% while reconst_err < req_err
%     abs_alpha = abs(alpha);
%     alpha(abs_alpha == min(min(abs_alpha))) = 0;
%     img_reconst = waverec2(alpha, wave.Cbook, wave.name);
%     reconst_err = calc_err(img,img_reconst);
% end
thresh_h = 100.0;
thresh_m = thresh_h / 2;
thresh_l = 0.0;

eps = 1e-4;
iter = 1;
max_iter = 200;
while true
    alpha_thresh = alpha;
    alpha_thresh(abs(alpha_thresh) < thresh_m) = 0;
    img_reconst = waverec2(alpha_thresh, wave.Cbook, wave.name);
    reconst_err = calc_err(img,img_reconst);
%     if rem(iter,1) == 0
%         fprintf('%d,%f,%f\n',iter,thresh_m,reconst_err);
%     end
    if (reconst_err + eps >= req_err && reconst_err - eps <= req_err) || ...
            iter == max_iter
        break;
    end
    if reconst_err > req_err
        thresh_h = thresh_m;
        thresh_m = (thresh_m + thresh_l) / 2;
    else
        thresh_l = thresh_m;
        thresh_m = (thresh_m + thresh_h) / 2;
    end
    iter = iter + 1;
end
spars = sum(abs(alpha(:)) > 0);
