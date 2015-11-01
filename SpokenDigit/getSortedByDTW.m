function [distance_with_class] = getSortedByDTW(testSample, train)
	
	num_classes = length(train);
	num_train_samples = 0;
	for i = 1:num_classes
		num_train_samples = num_train_samples + size(train{i},1);
	end
	distance_with_class = zeros(num_train_samples, 2);	
	train_counter = 1; 
	for i=1:num_classes
		for j=1:length(train{i})
            
			distance_with_class(train_counter, :) = [dtw(testSample, train{i}{j}) i];
			train_counter = train_counter +1;
		end
	end
    distance_with_class = sortrows(distance_with_class, 1);
end