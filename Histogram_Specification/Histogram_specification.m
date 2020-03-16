clear; close all;
i1 = imread('cameraman.png');
i2 = imread('einstein.png');

[r,c] = size(i1);
[r2,c2] = size(i2);

finalResult = uint8(zeros(r,c)); % cameraman equalized output image
finalResult2 = uint8(zeros(r2,c2)); % einstein equalized output image  

h1 = zeros(1,c); % cameraman original histogram
h2 = zeros(1,c2); % einstein original histogram

% for i = 1:c
%     h1(i) = sum(sum(i1==i)); % cameraman
% end

for i = 1:r
    for j = 1:c
        x=i1(i,j);
        h1(x+1)=h1(x+1)+1;
    end
end

% for i = 1:c2
%     h2(i) = sum(sum(i2==i)); % einstein
% end

for i = 1:r
    for j = 1:c
        x=i2(i,j);
        h2(x+1)=h2(x+1)+1;
    end
end

n = sum(h1); % cameraman total no of pixels
n2 = sum(h2); % einstein total no of pixels

pdf = h1/n; % camraman
pdf2 = h2/n2; % einstein

cdf = zeros(1,c); % camraman
cdf2 = zeros(1,c2); % einstein

cdf_multiplied_graylevel = zeros(1,c); % camraman
cdf_multiplied_graylevel2 = zeros(1,c2); % einstein

cumulative_sum = 0;

final_mapped_cdf = zeros(1,c); % camraman
final_mapped_cdf2 = zeros(1,c2); % einstein
% camraman
for i = 1:c
    cumulative_sum = cumulative_sum + pdf(1,i);
    cdf(1,i) = cumulative_sum;
    cdf_multiplied_graylevel(1,i) = (255*cdf(1,i));
end
round_cdf = round(cdf_multiplied_graylevel);


% einstein
cumulative_sum = 0;
for i = 1:c2
    cumulative_sum = cumulative_sum + pdf2(1,i);
    cdf2(1,i) = cumulative_sum;
    cdf_multiplied_graylevel2(1,i) = (255*cdf2(1,i));
end
round_cdf2 = round(cdf_multiplied_graylevel2);


% camraman
for i = 1:c
    x = round_cdf(i);
    if x > 0
       final_mapped_cdf(x) = final_mapped_cdf(x) + h1(i); 
    end
end

% einstein
for i = 1:c2
    x = round_cdf2(i);
    if x > 0
       final_mapped_cdf2(x) = final_mapped_cdf2(x) + h2(i); 
    end
end

% camraman
for i = 1:r
    for j = 1:c
        finalResult(i,j) = round_cdf(i1(i,j) + 1);
    end
end

% einstein
for i = 1:r2
    for j = 1:c2
        finalResult2(i,j) = round_cdf2(i2(i,j) + 1);
    end
end

specification_map = zeros(1,c);
for i = 1:c
%     if round_cdf(i) > 0
        for j = 1:c
           if  round_cdf(i) == round_cdf2(j) || round_cdf(i) < round_cdf2(j) 
                specification_map(i) = j;
                break;
           end
       end
%     end
end

desired_image_histogram = zeros(1,c);
for i = 1:c
   x = specification_map(i);
%    if x>0
      desired_image_histogram(x) = desired_image_histogram(x) + h1(i); 
%    end
end


desired_image = uint8(zeros(r,c));
for i = 1:r
    for j = 1:c
        desired_image(i,j) = specification_map(i1(i,j) + 1);
    end
end

J = histeq(i1,h2);
% figure; bar(h1);

% figure; bar(round_cdf);
% h22 = imhist(i2);
% figure; bar(final_mapped_cdf);

figure; imhist(J);
% figure; imshow(J);

% figure; imshow(finalResult);
% figure; imhist(finalResult);

% figure; imshow(finalResult2);
% figure; imhist(finalResult2);

figure; bar(desired_image_histogram);
% figure; imshow(desired_image);

% figure; imshow(i2);
% figure; imhist(i2);

% subplot(1,2,1), bar(h1),title('Original Image Histogram');
% subplot(1,2,2), bar(desired_image_histogram), title('Desired Image Histogram');
% subplot(1,2,2), imhist(desired_image), title('Desired Image Histogram');

% figure;
% subplot(1,2,1), imshow(i1),title('Original Image');
% subplot(1,2,2), imshow(desired_image), title('Desired Image');