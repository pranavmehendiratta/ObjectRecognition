A = [1 2 3; 1 2 3; 1 2 3];
out = sum(A, 2);

rows = size(A, 1);
cols = size(A, 2);

x = ones(rows,1)*[1:cols];    % Matrix with each pixel set to its x coordinate
y = [1:rows]'*ones(1,cols);   % Matrix with each pixel set to its y coordinate

result_cols = [];
result_rows = [];
zero_arr = zeros(1, cols);
for k = 1 : rows
    result_cols = [result_cols ; [1 : cols]]; 
    result_rows = [result_rows ; zero_arr + k];
end

disp(result_cols);
disp(y);
disp(x);
disp(result_rows);

disp(times(times(result_cols, result_rows), A));

% 
% B = [1;2;3];
% 
% disp(A);
% disp(B);
% 
% fprintf("Running");
% disp(sum(out.*B));

