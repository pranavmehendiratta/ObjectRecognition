function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
    [new_db, out_img] = compute2DProperties(orig_img, labeled_img);
    
    
    area_threshold = 330;
    roundness_threshold = 0.03;
    inertia_threshold_min = 1.5;
    inertia_threshold_max = 2.8;
     
    fh2 = figure(); 
    imshow(orig_img);
    hold on;
    
    for i = 1 : size(new_db, 2)
        area_min = Inf;
        roundness_min = Inf;
        inertia_min = Inf;
        
        image_min = 1;
        old_area_min = 1;
        old_inertia_min = 1;
        
        new_area = new_db(7, i);
        new_roundness = new_db(6, i);
        new_inertia = new_db(4, i);
        
        %fprintf("many_object image = %s with area = %s and inertia = %s", num2str(i), num2str(new_area), num2str(new_inertia));
        for j = 1 : size(obj_db, 2)
            old_area = obj_db(7, j);
            old_roundness = obj_db(6, j);
            old_inertia = obj_db(4, j);
            
            inertia_diff = abs(old_inertia - new_inertia) / 100000;
            
            if abs(old_area - new_area) < area_min && abs(new_roundness - old_roundness) < roundness_min && (inertia_diff < inertia_threshold_min || inertia_diff > inertia_threshold_max)
                area_min = abs(old_area - new_area);
                image_min = j;
                old_area_min = old_area;
                old_inertia_min = old_inertia;
                roundness_min = abs(new_roundness - old_roundness);
            end  
        end
        
        if area_min < area_threshold && roundness_min < roundness_threshold
            %fprintf(" matches two objects image %s with area %s and inertia = %s", num2str(image_min), num2str(old_area_min), num2str(old_inertia_min)); 
            % Plot the lines
            m = tan(new_db(5, i));
            b = new_db(3, i) - (new_db(2, i) * m);    
            hold on;
            plot(new_db(2, i), new_db(3, i), 'r*');

            [r, c] = find(labeled_img == i);
            x = linspace(min(c), max(c));
            y = m * x  + b;

            hold on;
            plot(x, y, 'LineWidth', 1);
        end
        %fprintf("\n");
    end
    
    output_img = saveAnnotatedImg(fh2);
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



