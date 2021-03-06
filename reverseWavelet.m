function s = reverseWavelet(x, wave)
% reverseWavelet Determine the inverse wavelet transform of a given signal
% 
% s : signal (i.e. wavelet domain)
% wave is a structure containing the following elements
% wave.name   : Name of the wavelet as a string e.g. 'db4'
% wave.level  : Number of wavelet decomposition levels
% wave.siz    : Size of the signal 
% wave.Cbook  : Book keeping matrix, used in signal synthesis function 
%               reverseWavelet; Can be generated by the following command
% [tmp, wave.Cbook] = wavedec2(randn(wave.siz), wave.level, wave.name);
% 
% Signal x will be reshaped into a matrix of size wave.siz before wavelet
% analysis
% Output s will be a column vector

x = reshape(x, wave.siz);
tmp = waverec2(x, wave.Cbook, wave.name);
s = tmp(:);