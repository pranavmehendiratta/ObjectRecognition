# ObjectRecognition

This project takes two input images and creates a database for images based on connected components with properties such as
center x, center y, minimum moment of inertia, orientation, roundeness, and area.

This database of properties is then used to recognize if any objects in image 1 is present in image 2 based on properties
such as roundess, area, and minimum moment of inerita.

Moreover, for each object it draws a line passing through the center of the object and with slope = orientation of the object.
