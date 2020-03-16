I = imread('me2.jpg');
I = rgb2gray(I);
figure('Name','Grayscale of Original Image'); imshow(I);
figure('Name','Grayscale Image Histogram');  imhist(I);

%negative image
maxPixel = max(I(:));
negativeImage = maxPixel - I;
figure('Name','Negative Image Output'); imshow(negativeImage);
figure('Name','Negative Image Histogram');  imhist(negativeImage);

% increase/decrease brightness
A = input('input the threshold value A: ');
[r,c] = size(I);
K = uint8(ones(r, c));

for i = 1:r
    for j = 1:c
        if I(i,j) > A
            K(i,j) = I(i,j)+ floor(I(i,j)*0.5);
        else
            K(i,j) = I(i,j)- floor(I(i,j)*0.25);
        end
    end
end

figure('Name','Brightness Increase/Decrease Output'); imshow(K);
figure('Name','Brightness Increase/Decrease Histogram'); imhist(K);

% Log Transformation
image_double = im2double(I);
[r,c] = size(image_double);

for i = 1:r
    for j = 1:c
            i2(i,j) = 1.5 * log(image_double(i,j)+1);
    end
end
figure('Name','Log Transform Output'); imshow(i2);
figure('Name','Log Transform Histogram'); imhist(i2);

% Power Law Transformation
gamma = input('input the gamma value : ');
for i = 1:r
    for j = 1:c
            i3(i,j) = 1.5 * power(image_double(i,j),gamma);
    end
end
figure('Name','Power Law Output'); imshow(i3);
figure('Name','Power Law Histogram'); imhist(i3);


