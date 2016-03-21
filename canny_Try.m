%Canny Edge Detector

clear;
%THE IMAGE HAS BEEN READ HERE.
I=imread('bowl.jpg');	
I=rgb2gray(I);

%THE INTENSITY OF THE IMAGE HAS BEEN ADJUSTED HERE.
I=imadjust(I,stretchlim(I),[]);	

%APPLYING THE GAUSSIAN FILTER OVER THE IMAGE
%gaussian_filter=fspecial("gaussian",3);
%I=imfilter(I,gaussian_filter);

%sobel_x=[-1 0 1;-2 0 2;-1 0 1];
%sobel_y=[1 2 1 ; 0 0 0; -1 -2 -1];

%APPLYING THE SOBEL OPERATOR 
%img_x=imfilter(I,img_x);
%img_y=imfilter(I,img_y);

%CONVOLUTION WITH DERIVATIVE OF GAUSSIAN
sig=0.5;
dG=dgauss(sig);
[dummy, filterLen] = size(dG);
offset = (filterLen-1)/2;

img_y = conv2(I, dG ,'same');
img_x = conv2(I, dG','same');



%NORM OF THE GRADIENT
img_norm=sqrt(img_y.^2+img_x.^2);

%TAKING THE POSITIVE VALUES
img_x=abs(img_x);
img_y=abs(img_y);

%DIRECTION OF GRADIENT
sAngle = atan2( img_y, img_x) * (180.0/pi);

a=size(sAngle);
m=a(1);
n=a(2);
%img_norm=histeq(img_norm);


%NON MAXIMUM SUPPRESSION
%FUNCTION TO DIVIDE ANGLES INTO THEIR NEAREST 45 DEGREE ANGLE
for i=1:m
	for j=1:n
	if(sAngle(i,j)>=-22.5 && sAngle(i,j)< 22.5 && i > 1 &&  j > 1 && i< 256 && j< 256)
		sAngle(i,j)=0;
		if(img_norm(i,j)>=img_norm(i,j+1) && img_norm(i,j)>=img_norm(i,j-1))
		img_new(i,j)=img_norm(i,j);	
		endif
	endif
	if(sAngle(i,j)>=22.5 && sAngle(i,j)< 67.5 && i > 1 &&  j > 1 && i< 256 && j< 256)
		sAngle(i,j)=45;
		if(img_norm(i,j)>=img_norm(i+1,j+1) && img_norm(i,j)>=img_norm(i-1,j-1))
		img_new(i,j)=img_norm(i,j);
		endif
	endif
	if(sAngle(i,j)>= 67.5 && sAngle(i,j)< 112.5 && i > 1 &&  j > 1 && i< 256 && j< 256)
		sAngle(i,j)=90;
		if(img_norm(i,j)>=img_norm(i-1,j) && img_norm(i,j)>=img_norm(i+1,j))
		img_new(i,j)=img_norm(i,j);
		endif
	endif
	if(sAngle(i,j)< -67.5 && sAngle(i,j)>= -112.5 && i > 1 &&  j > 1 && i< 256 && j< 256)
		sAngle(i,j)=-90;
		if(img_norm(i,j)>=img_norm(i-1,j) && img_norm(i,j)>=img_norm(i+1,j))
		img_new(i,j)=img_norm(i,j);
		endif
	endif
	if(sAngle(i,j)>= -67.5 && sAngle(i,j)< -22.5 && i > 1 &&  j > 1 && i< 256 && j< 256)
		sAngle(i,j)=-45;
		if(img_norm(i,j)>=img_norm(i-1,j+1) && img_norm(i,j)>=img_norm(i+1,j-1))
		img_new(i,j)=img_norm(i,j);
		endif
	endif
	endfor
endfor

%DOUBLE THRESHOLDING

thresh_low=0.25;
thresh_high=0.5;
for i=2:254
	for j=2:254
	if(img_new(i,j) >= 0.5)
	img_final(i,j)=img_new(i,j);
	endif
	if(img_new(i,j) < 0.5 && img_new(i,j)>=0.25)
		if(img_new(i,j+1)>=0.5 || img_new(i,j-1)>=0.5 || img_new(i-1,j)>=0.5 || img_new(i+1,j)>=0.5)
		img_new(i,j)=0.5;
		img_final(i,j)=img_new(i,j);
		endif
	endif
	endfor
endfor

imshow(img_final);



