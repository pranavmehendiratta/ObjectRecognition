% test generateLabeledImage
two_obj_img = imread('many_objects_2.png');
labeled_two_obj_img = generateLabeledImage(two_obj_img, graythresh(two_obj_img));
%figure(); imshow(labeled_two_obj_img);

% test compute2DProperties
[two_obj_db, out_img] = compute2DProperties(two_obj_img, labeled_two_obj_img);
%figure(); imshow(out_img);

% compare many_object_1 with two_objects
many_obj_one_img = imread('many_objects_1.png');
labeled_many_obj_img = generateLabeledImage(many_obj_one_img, graythresh(many_obj_one_img));
output_img = recognizeObjects(many_obj_one_img, labeled_many_obj_img, two_obj_db);
figure(); imshow(output_img);