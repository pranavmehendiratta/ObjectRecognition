function labeled_img = generateLabeledImage(gray_img, threshold)
    bw_img = im2bw(gray_img, threshold);
    [labeled_img, n] = bwlabel(bw_img);
end