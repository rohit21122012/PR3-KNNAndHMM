format compact
diary result.txt

[train, test] = datasets('TestFeatures/forest/','TestFeatures/mountain/','TestFeatures/opencountry/');

train = train';
test = test';



num_classes = length(train);

%%%%%%%%%%%%%%%TESTING%%%%%%%%%%%%%%%%%%%
display('Testing the model');
num_test_samples = 0;
num_train_samples = 0;

for i = 1:num_classes
	num_train_samples = num_train_samples + length(train{i});
end

confusionMatrix = cell(1,num_train_samples);
accuracy = zeros(1, num_train_samples);
confusionMatrix(:) = {zeros(num_classes, num_classes)};	
for i = 1:num_classes %for each class 
    for j=1:length(test{i}) %for each classes's test data 
        display(['Testing for testSample = ', num2str(num_test_samples+1)]);
        sorted_train_dtw_dist = getSortedByDTW(test{i}{j}, train);	 %test{i}{j} is one (36*23) sample	%returned matrix's 1st value is the dist & 2nd is the classid
        class_count = zeros(num_train_samples, num_classes);
		for k = 1:num_train_samples
			if(k>1)
				for c = 1:num_classes
			    		class_count(k,:) = class_count(k-1,:);
				end
			end
			class_count(k,sorted_train_dtw_dist(k,2)) = class_count(k,sorted_train_dtw_dist(k,2)) + 1;
			[neighcount_with_predicted_label, predicted_label] = max(class_count(k,:));
			confusionMatrix{k}(i,predicted_label) = confusionMatrix{k}(i,predicted_label) + 1;
		end
		num_test_samples = num_test_samples + 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%STATS%%%%%%%%%%%%%%%%
for k=1:num_train_samples
	display(['Stats for k = ', num2str(k), ' nearest neighbours']);   
	confusionMatrix{k}
	correct = sum(diag(confusionMatrix{k}))
	incorrect = num_test_samples - correct
	accuracy(k) = correct/num_test_samples;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig = figure('Visible', 'off');
plot(accuracy*100,'.b');
title('Accuracy vs K in KNN');
xlabel('K');
ylabel('Accuracy in %');
ylim([0 100]);
saveas(fig, 'accuracy with k.png');


diary off