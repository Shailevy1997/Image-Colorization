
%original_images = dir('original_images/*.png');
%pix2pix_output_images = dir('pix2pix_output/*.png');
bccr_images = dir('imgs_to_interpolate/*.bmp');

avg_ssim_pix = 0;
avg_psnr_pix = 0;
avg_ssim_intr = 0;
avg_psnr_intr = 0;

for i = 1:numel(bccr_images)

%filename_1 = original_images(i).name;
%filename_2 = pix2pix_output_images(i).name;
filename_3 = bccr_images(i).name;

%original_img = imread("original_images/"+filename_1);
%imPix2pixOutput = imread("pix2pix_output/"+filename_2);
imBCCR = imread("imgs_to_interpolate/"+filename_3);


%%%%%% BCCR_TO_COLOR START %%%%%%

[hei, wid, chan] = size(imBCCR);
imInterpolated = uint8(zeros(hei,wid));

r = 0.2989;
g = 0.587;
b = 0.114;

for ver = 2+1:hei-2
    for hor = 2+1:wid-2
        if((1 == mod(ver,2)) && (1 == mod(hor,2)))         % Blue
            imInterpolated(ver,hor,3) = imBCCR(ver,hor,3);
            imInterpolated(ver,hor,2) = imBCCR(ver-1,hor,2) / 4 + imBCCR(ver,hor-1,2) / 4 + imBCCR(ver+1,hor,2) / 4 + imBCCR(ver,hor+1,2) / 4 + imBCCR(ver-1,hor-1,2) / 4 + imBCCR(ver-1,hor+1,2) / 4 + imBCCR(ver+1,hor-1,2) / 4 + imBCCR(ver+1,hor+1,2) / 4;
            imInterpolated(ver,hor,1) = imBCCR(ver-1,hor,1) / 8 + imBCCR(ver,hor-1,1) / 8 + imBCCR(ver+1,hor,1) / 8 + imBCCR(ver,hor+1,1) / 8 + imBCCR(ver-1,hor-1,1) / 8 + imBCCR(ver-1,hor+1,1) / 8 + imBCCR(ver+1,hor-1,1) / 8 + imBCCR(ver+1,hor+1,1) / 8;
        elseif((0 == mod(ver,2)) && (0 == mod(hor,2)))     % Red
            imInterpolated(ver,hor,3) = imBCCR(ver-1,hor,3) / 8 + imBCCR(ver,hor-1,3) / 8 + imBCCR(ver+1,hor,3) / 8 + imBCCR(ver,hor+1,3) / 8 + imBCCR(ver-1,hor-1,3) / 8 + imBCCR(ver-1,hor+1,3) / 8 + imBCCR(ver+1,hor-1,3) / 8 + imBCCR(ver+1,hor+1,3) / 8;
            imInterpolated(ver,hor,2) = imBCCR(ver-1,hor,2) / 4 + imBCCR(ver,hor-1,2) / 4 + imBCCR(ver+1,hor,2) / 4 + imBCCR(ver,hor+1,2) / 4 + imBCCR(ver-1,hor-1,2) / 4 + imBCCR(ver-1,hor+1,2) / 4 + imBCCR(ver+1,hor-1,2) / 4 + imBCCR(ver+1,hor+1,2) / 4;
            imInterpolated(ver,hor,1) = imBCCR(ver,hor,1);
        else                                               % Green
            imInterpolated(ver,hor,3) = imBCCR(ver,hor,3) / 7 + imBCCR(ver-1,hor,3) / 7 + imBCCR(ver,hor-1,3) / 7 + imBCCR(ver+1,hor,3) / 7 + imBCCR(ver,hor+1,3) / 7 + imBCCR(ver-1,hor-1,3) / 7 + imBCCR(ver-1,hor+1,3) / 7 + imBCCR(ver+1,hor-1,3) / 7 + imBCCR(ver+1,hor+1,3) / 7;
            imInterpolated(ver,hor,2) = imBCCR(ver,hor,2) / 5 + imBCCR(ver-1,hor,2) / 5 + imBCCR(ver,hor-1,2) / 5 + imBCCR(ver+1,hor,2) / 5 + imBCCR(ver,hor+1,2) / 5 + imBCCR(ver-1,hor-1,2) / 5 + imBCCR(ver-1,hor+1,2) / 5 + imBCCR(ver+1,hor-1,2) / 5 + imBCCR(ver+1,hor+1,2) / 5;
            imInterpolated(ver,hor,1) = imBCCR(ver,hor,1) / 7 + imBCCR(ver-1,hor,1) / 7 + imBCCR(ver,hor-1,1) / 7 + imBCCR(ver+1,hor,1) / 7 + imBCCR(ver,hor+1,1) / 7 + imBCCR(ver-1,hor-1,1) / 7 + imBCCR(ver-1,hor+1,1) / 7 + imBCCR(ver+1,hor-1,1) / 7 + imBCCR(ver+1,hor+1,1) / 7;
        end
    end
end

imwrite(imInterpolated, strcat('interp_output_tomer/FilteredInterpolatedImage', num2str(i), '.bmp'));
continue;

%%%%%% BCCR_TO_COLOR END %%%%%%



best_sigma = 0.001;
[ssimval_1,ssimmap_1] = ssim(imPix2pixOutput,original_img);
for sigma = 0.1:0.01:0.9
    imPix2pixOutput_filtered = imgaussfilt(imPix2pixOutput,sigma, 'FilterSize', [3 3]);
    [ssimval_2,ssimmap_2] = ssim(imPix2pixOutput_filtered, original_img);
    if (ssimval_2 > ssimval_1)
       ssimval_1 = ssimval_2;
       best_sigma = sigma; 
    end
end
fprintf('\n image no. %0d BEST SIGMA: %0.4f', i, best_sigma);
%% 0, 1, 22


% Gaussian filter on output image and interpolated image
imPix2pixOutput = imgaussfilt(imPix2pixOutput, best_sigma);
imInterpolated = imgaussfilt(imInterpolated, best_sigma);



%%%%% CROP IMAGES NO BOUNDARIES %%%%%
crop = 5;
original_img = original_img(crop:end-crop,crop:end-crop,:);
imPix2pixOutput = imPix2pixOutput(crop:end-crop,crop:end-crop,:);
imInterpolated = imInterpolated(crop:end-crop,crop:end-crop,:);





imwrite(imPix2pixOutput, strcat('interp_output_tomer/FilteredPixpixOutput', num2str(i), '.bmp'));
imwrite(imInterpolated, strcat('interp_output_tomer/FilteredInterpolatedImage', num2str(i), '.bmp'));

[ssimval,ssimmap] = ssim(imPix2pixOutput,original_img);
fprintf('\n Global SSIM Value original and pix2pix: %0.4f', ssimval);
[ssimval_i,ssimmap_i] = ssim(imInterpolated,original_img);
fprintf('\n Global SSIM Value original and interpolated: %0.4f', ssimval_i);
[peaksnr, snr] = psnr(imPix2pixOutput, original_img);
fprintf('\n The Peak-SNR Value original and pix2pix is %0.4f [dB]', peaksnr);
[peaksnr_i, snr_i] = psnr(imInterpolated, original_img);
fprintf('\n The Peak-SNR Value original and interpolated is %0.4f [dB]\n', peaksnr_i);
avg_ssim_pix = avg_ssim_pix + ssimval;
avg_psnr_pix = avg_psnr_pix + peaksnr;
avg_ssim_intr = avg_ssim_intr + ssimval_i;
avg_psnr_intr = avg_psnr_intr + peaksnr_i;
end

avg_ssim_pix = avg_ssim_pix / 51;
avg_psnr_pix = avg_psnr_pix / 51;
avg_ssim_intr = avg_ssim_intr / 51;
avg_psnr_intr = avg_psnr_intr / 51;

fprintf('\n avg_ssim_pix: %0.4f, avg_psnr_pix: %0.4f, avg_ssim_intr: %0.4f, avg_psnr_intr: %0.4f', avg_ssim_pix, avg_psnr_pix, avg_ssim_intr, avg_psnr_intr);


%1022552022_2b93faf9e7_n


%err = immse(imPix2pixOutput,original_img);
%fprintf('\n The mean-squared error is %0.4f\n', err);


