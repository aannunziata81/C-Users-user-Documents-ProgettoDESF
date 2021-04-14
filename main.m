%% Clear all, clc, close all
clear all, clc, close all

%% Parametri iniziali
ore = 0:23;

%ottobre - gennaio
PloadH = [195 187 180 167 167.5 169.5 175 173 220 232 240 245 225 212 213 235 248 250 249.5 247.5 240 230 218 213]; %KW
%febbraio-aprile e luglio-settembre
PloadI = [85 82 81.8 75 74.8 64 175 173 220 232 240 245 225 212 213 235 248 250 249.5 247.5 240 230 218 213]; %KW
%maggio-giugno
PloadL = [195 187 180 167 167.5 169.5 175 173 220 232 240 245 225 212 213 235 248 250 249.5 247.5 240 230 218 213]; %KW

p(1:24) = 0;

figure(1)
plot(ore, Pload, ore, p)
