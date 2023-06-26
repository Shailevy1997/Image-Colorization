clc;
clear;
close all;
    
myFolder = 'C:\Users\HP USER\FinalProj\ColorImages\data2\data\test_color';
filePattern = fullfile(myFolder, '*.bmp');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
%for k = 1:1
  %%length(jpegFiles) replaces 4
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  %fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  imSrc = imresize(imageArray,[256 256]);
  fullFileName = fullFileName(1:end-4);
  imwrite(imSrc, fullFileName+".bmp");


[hei, wid, chan] = size(imSrc);

bayer = uint8(zeros(hei,wid,3));
bayer_BW = uint8(zeros(hei,wid,3));
pattern = uint8(zeros(hei,wid,3));
out = uint8(zeros(hei,wid,3));

for ver = 1:hei
    for hor = 1:wid
        if((1 == mod(ver,16)) && (1 == mod(hor,16)))
            pattern(ver:ver+4,hor:hor+4,:) = 1;
        end
    end
end

%%%%%%%BWWR mask
%for ver = 1:hei
%    for hor = 1:wid
%        if((mod(ver+hor,2)==0))
%            pattern(ver,hor,:) = 1;
%        end
%    end
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% RANDOM MASK



%for ver = 1:hei
    %for hor = 1:wid
    %    if (mod(ver,4)==1 && mod(hor,4)==1)
    %        pattern(ver,hor,:) = 1;
   %     elseif ((mod(ver,4)==1 && mod(hor,4)==0))
   %         pattern(ver,hor,:) = 1;
   %     elseif ((mod(ver,4)==2 && mod(hor,4)==2))
   %         pattern(ver,hor,:) = 1;
   %     elseif ((mod(ver,4)==2 && mod(hor,4)==0))
   %         pattern(ver,hor,:) = 1;
   %     elseif ((mod(ver,4)==3 && mod(hor,4)==2))
  %          pattern(ver,hor,:) = 1;
 %       elseif ((mod(ver,4)==3 && mod(hor,4)==3))
 %           pattern(ver,hor,:) = 1;
 %       elseif ((mod(ver,4)==0 && mod(hor,4)==1))
%            pattern(ver,hor,:) = 1;
%        elseif ((mod(ver,4)==0 && mod(hor,4)==3))
%            pattern(ver,hor,:) = 1;
%        end
%    end
%end




%% BGGR
for ver = 1:hei
    for hor = 1:wid
        if((1 == mod(ver,2)) && (1 == mod(hor,2)))
            bayer(ver,hor,3) = imSrc(ver,hor,3);
            bayer_BW(ver,hor,3) = imSrc(ver,hor,3);
            bayer_BW(ver,hor,2) = imSrc(ver,hor,3);
            bayer_BW(ver,hor,1) = imSrc(ver,hor,3);
        elseif((0 == mod(ver,2)) && (0 == mod(hor,2)))
            bayer(ver,hor,1) = imSrc(ver,hor,1);
            bayer_BW(ver,hor,3) = imSrc(ver,hor,1);
            bayer_BW(ver,hor,2) = imSrc(ver,hor,1);
            bayer_BW(ver,hor,1) = imSrc(ver,hor,1);
        else
            bayer(ver,hor,2) = imSrc(ver,hor,2);
            bayer_BW(ver,hor,3) = imSrc(ver,hor,2);
            bayer_BW(ver,hor,2) = imSrc(ver,hor,2);
            bayer_BW(ver,hor,1) = imSrc(ver,hor,2);
        end
    end
end

out(pattern == 0) = bayer_BW(pattern == 0);
out(pattern == 1) = bayer(pattern == 1);
%%end bayeringp




 
out_ds = uint8(zeros(192,192,3));
R = 0; G = 0; B = 0;
%BGGR

%for i = 1:2:192*2
   % for j = 1:2:192*2
      %  t=(i+1)/2;
       % s=(j+1)/2;
      %  R=(uint16(out(i+1,j+1,1))+uint16(out(i,j+1,1))+uint16(out(i+1,j,1)))/3;
     %   G=(uint16(out(i,j+1,2))+uint16(out(i+1,j,2)))/2;
    %    B=(uint16(out(i,j,3))+uint16(out(i,j+1,1))+uint16(out(i+1,j,1)))/3;
   %     out_ds(t,s,1)=R;
  %       out_ds(t,s,3)=B;
 %   end
%end
%figure(1);
%imshow(out_ds);
%title("OUT_DS");


%%%%%%8CELL_16STRECH_DS
%{
for i = 1:2:192*2
    for j = 1:2:192*2
        t=(i+1)/2;
        s=(j+1)/2;
        if(pattern(i,j)==1)
            R=out(i+1,j+1,1);
            B=out(i,j,3);
            G=(uint16(out(i,j+1,2))+uint16(out(i+1,j,2)))/2;
            out_ds(t,s,1)=R;
            out_ds(t,s,2)=G;
            out_ds(t,s,3)=B;

        else
            avg=(uint16(out(i,j,1))+uint16(out(i+1,j,1))+uint16(out(i,j+1,1))+uint16(out(i+1,j+1,1)))/4;
            out_ds(t,s,1)=avg;
            out_ds(t,s,2)=avg;
            out_ds(t,s,3)=avg;
        end
    end 
end
%}   

  fullFileName = fullfile('C:\Users\HP USER\FinalProj\ColorImages\data_15_5_23\masked_data\test\', baseFileName);
  %fullFileName2 = fullfile('C:\Users\HP USER\FinalProj\ColorImages\data_6_5_23\bayer_data\train\', baseFileName);
  %figure(2);
  %imshow(out);
  %title("OUT");
  fullFileName = fullFileName(1:end-4);
 % imwrite(out_ds, fullFileName+".bmp");
  imwrite(out, fullFileName+".bmp");    
  %imwrite(bayer,fullFileName2)
  if (mod(k,50)==0)
    prcnt=k/length(jpegFiles) * 100 ;
    fprintf(1,"Percentage is : %4f\n",prcnt);
  end 
  %imwrite(bayer, fullFileName+"bayer.bmp");
  %imwrite(bayer_BW, fullFileName+"bayer_BW.bmp");
end


return; 



%%%%%%%%%%%%MOSAICING



%figure,imshow(bayer);
%figure,imshow(bayer_BW);
%figure,imshow(out);
%{
bayerPadding = zeros(hei+2,wid+2);
bayerPadding(2:hei+1,2:wid+1) = bayer;
bayerPadding(1,:) = bayerPadding(3,:);
bayerPadding(hei+2,:) = bayerPadding(hei,:);
bayerPadding(:,1) = bayerPadding(:,3);
bayerPadding(:,wid+2) = bayerPadding(:,wid);
imDst = zeros(hei+2, wid+2, chan);

for ver = 2:hei+1
    for hor = 2:wid+1
        if (1 == mod(ver-1,2))
            if(1==mod(hor-1,2))
                imDst(ver,hor,3)=bayerPadding(ver,hor);
                imDst(ver,hor,1)=(bayerPadding(ver-1,hor-1)+bayerPadding(ver-1,hor+1)+bayerPadding(ver+1,hor-1)+bayerPadding(ver+1,hor+1))/4;
                imDst(ver,hor,2)=(bayerPadding(ver-1,hor)+bayerPadding(ver+1,hor)+bayerPadding(ver,hor-1)+bayerPadding(ver,hor+1))/4;
            else
                imDst(ver,hor,2)=bayerPadding(ver,hor);
                imDst(ver,hor,1)=(bayerPadding(ver-1,hor)+bayerPadding(ver+1,hor))/2;
                imDst(ver,hor,3)=(bayerPadding(ver,hor-1)+bayerPadding(ver,hor+1))/2;
            end
        else
            if(1==mod(hor-1,2))
                imDst(ver,hor,2)=bayerPadding(ver,hor);
                imDst(ver,hor,1)=(bayerPadding(ver,hor-1)+bayerPadding(ver,hor+1))/2;
                imDst(ver,hor,3)=(bayerPadding(ver-1,hor)+bayerPadding(ver+1,hor))/2;
            else
                imDst(ver,hor,1)=bayerPadding(ver,hor);
                imDst(ver,hor,2)=(bayerPadding(ver-1,hor)+bayerPadding(ver+1,hor)+bayerPadding(ver,hor-1)+bayerPadding(ver,hor+1))/4;
                imDst(ver,hor,3)=(bayerPadding(ver-1,hor-1)+bayerPadding(ver-1,hor+1)+bayerPadding(ver+1,hor-1)+bayerPadding(ver+1,hor+1))/4;
            end
        end
    end
end

imDst=uint8(imDst(2:hei+1,2:wid+1,:));
figure,imshow(imDst);
%}








  