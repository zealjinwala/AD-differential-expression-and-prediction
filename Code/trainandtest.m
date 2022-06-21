function numerrors = trainandtest(Xtrain, Ttrain, Xtest, Ttest)
    model = fitcsvm(Xtrain, Ttrain,'KernelFunction', 'rbf', 'Standardize', true);
    preds = predict(model, Xtest);
    numerrors = sum(preds ~= Ttest);
end


