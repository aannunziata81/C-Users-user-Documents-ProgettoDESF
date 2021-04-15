%% Clear all, clc, close all
clear all, clc, close all

%% Parametri iniziali
ore = 0:23;

%ottobre - gennaio
PloadH = [195 187 180 167 167.5 169.5 175 173 220 232 240 245 225 212 213 235 248 250 249.5 247.5 240 230 218 213]; %KW
%febbraio-aprile e luglio-settembre
PloadI = [85 82 81.8 75 74.8 74.9 64 74.3 102 118 121 120 100 77 103 112 114 121 120 105 104 105 102 101]; %KW
%maggio-giugno
PloadL = [15 15 15 14 14 14 8 7 7 7 7 7 7 7  7 7 7 7 7 7 8 12.5 13 13]; %KW

p(1:24) = 0;

figure(1)
plot(ore, Pload, ore, p)
