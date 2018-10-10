function [db, out_img] = compute2DProperties(orig_img, labeled_img)
    num_connented_components = max(labeled_img(:));
    %fprintf('n is equal to %s\n', num2str(num_connented_components));
    obj_db = zeros(7, num_connented_components);
    
    for i = 1 : num_connented_components       
       % Finding the connected connected component
       connected_component = double(labeled_img == i);
       
       % showing the connected component
       %figure(); imshow(connected_component);
       
       % finding the number of columns and rows
       rows = size(connected_component, 1);
       cols = size(connected_component, 2);
       %fprintf("i: %s", num2str(i));
       
       % finding the area of the connected component
       area = sum(sum(connected_component));
       
       % Finding x_bar
       out1 = sum(connected_component);
       indexes = [1:cols];
       x_bar = sum(times(out1, indexes)) / area;
       
       % Finding y_bar
       out2 = sum(connected_component, 2);
       indexes = [1:rows].';
       y_bar = sum(times(out2, indexes)) / area;
       
       % Finding moment inertia - a
       m = [1:cols] - x_bar;
       i_2 = m.^2;
       a = sum(times(out1, i_2));
       %disp("a: " + a + "\n");
       
       % c
       n = [1:rows].' - y_bar;
       j_2 = n.^2;
       c = sum(times(out2, j_2));
       %disp("c: " + c + "\n");
       
       % b
       result_cols = [];
       result_rows = [];
       zero_arr = zeros(1, cols);
       for k = 1 : rows
            result_cols = [result_cols ; [1 : cols]]; 
            result_rows = [result_rows ; zero_arr + k];
       end
       b = 2*sum(sum(times(times(result_cols - x_bar, result_rows - y_bar), connected_component), 1), 2);
       %disp("b: " + b + "\n");
       
       % calculaing theta
       theta1 = atan2(b, (a - c)) / 2;
       %disp("theta1: " + theta1 + "\n");      
       theta2 = theta1 + (pi / 2);
       %disp("theta2: " + theta2 + "\n");
       
       % calculating moment
       Emin = (a * (sin(theta1) ^ 2)) - (b * sin(theta1) * cos(theta1)) + (c * (cos(theta1) ^ 2));
       %disp("Emin: " + Emin + "\n");
       Emax = (a * (sin(theta2) ^ 2)) - (b * sin(theta2) * cos(theta2)) + (c * (cos(theta2) ^ 2));
       %disp("Emin: " + Emax + "\n");
       
       obj_db(1, i) = i; 
       obj_db(2, i) = x_bar;
       obj_db(3, i) = y_bar;   
       obj_db(4, i) = Emin;
       obj_db(5, i) = theta1;
       obj_db(6, i) = (Emin / Emax);
       obj_db(7, i) = area;
    end
    
    %fprintf('obj_db is\n');
    disp(obj_db);
    
    % change this to represent out_img
    db = obj_db;
    
    fh2 = figure(); 
    imshow(orig_img);
    hold on;
    for i = 1 : num_connented_components
       m = tan(db(5, i));
       b = db(3, i) - (db(2, i) * m);    
       hold on;
       plot(db(2, i), db(3, i), 'r*');
        
       [r, c] = find(labeled_img == i);
       x = linspace(min(c), max(c));
       y = m * x  + b;
       
       hold on;
       plot(x, y, 'LineWidth', 1);
    end
    annotated_img = saveAnnotatedImg(fh2);
    out_img = annotated_img;
    delete(fh2);
end

function annotated_img = saveAnnotatedImg(fh)
    figure(fh); % Shift the focus back to the figure fh

    % The figure needs to be undocked
    set(fh, 'WindowStyle', 'normal');

    % The following two lines just to make the figure true size to the
    % displayed image. The reason will become clear later.
    img = getimage(fh);
    truesize(fh, [size(img, 1), size(img, 2)]);

    % getframe does a screen capture of the figure window, as a result, the
    % displayed figure has to be in true size. 
    frame = getframe(fh);
    frame = getframe(fh);
    pause(0.5); 
    % Because getframe tries to perform a screen capture. it somehow 
    % has some platform depend issues. we should calling
    % getframe twice in a row and adding a pause afterwards make getframe work
    % as expected. This is just a walkaround. 
    annotated_img = frame.cdata;
end
