function [distance] = dtw(feature1,feature2)
    length1 = size(feature1,1);
    length2 = size(feature2,1);
    matrix = zeros(length1,length2);
    for i = 1:length1
        for j = 1:length2
            matrix(i,j) = dist(feature1(i), feature2(j));
        end
    end
    for i = 2:length1
        matrix(i,1) = matrix(i-1,1)+matrix(i,1);
    end
    for j = 2:length2
        matrix(1,j) = matrix(1,j-1)+matrix(1,j);
    end
    for i = 2:length1
        for j = 2:length2
            matrix(i,j) = matrix(i,j) + min(matrix(i-1,j),min(matrix(i-1,j-1),matrix(i,j-1)));
        end
    end
    distance = matrix(length1,length2)/(length1*length2);
end
