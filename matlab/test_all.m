% tests all sets of algorithms with bootstrap_test('...', 200, 400, 4)

[errors, bestLearner, results, loss, testTime] = bootstrap_test('lse', 250, 400, 4);

[errors, bestLearner, results, loss, testTime] = bootstrap_test('soft', 250, 400, 4);

[errors, bestLearner, results, loss, testTime] = bootstrap_test('hard', 250, 400, 4);

[errors, bestLearner, results, loss, testTime] = bootstrap_test('sigmoid', 250, 400, 4);

%  [errors, bestLearner, results, loss, testTime] = bootstrap_test('lin', 200, 400, 4);

%  [errors, bestLearner, results, loss, testTime] = bootstrap_test('gauss', 200, 400, 4);

%  [errors, bestLearner, results, loss, testTime] = bootstrap_test('min', 200, 400, 4);

%  [errors, bestLearner, results, loss, testTime] = bootstrap_test('binary', 200, 400, 4);
