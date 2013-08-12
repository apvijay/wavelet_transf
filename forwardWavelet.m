function x = forwardWavelet(s, wave)
% forwardWavelet Determine the forward wavelet transform of a given signal
% 
% s : signal
% wave is a structure containing the following elements
% wave.name   : Name of the wavelet as a string e.g. 'db4'
% wave.level  : Number of wavelet decomposition levels
% wave.siz    : Size of the signal 
% wave.Cbook  : Book keeping matrix, used in signal synthesis function 
%               reverseWavelet; Can be generated by the following command
% [tmp, wave.Cbook] = wavedec2(randn(wave.siz), wave.level, wave.name);
% 
% Signal s will be reshaped into a matrix of size wave.siz before wavelet
% analysis
% Output x will be a column vector

s = reshape(s, wave.siz);
tmp = wavedec2(s, wave.level, wave.name);
x = tmp(:);
