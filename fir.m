% Define the input signal
input_signal = [4, 8, 4, 0, 4, 8, 4];

% Define the FIR filter coefficients
filter_coeffs = [0.25, 0.5, 0.25];

% Get the length of the input signal and filter
input_length = length(input_signal);
filter_length = length(filter_coeffs);

% Initialize the output signal
output_signal = zeros(1, input_length);

% Apply the FIR filter
for i = 1:input_length
    for j = 1:filter_length
        if i-j+1 > 0
            output_signal(i) = output_signal(i) + filter_coeffs(j) * input_signal(i-j+1);
        end
    end
end

% Display the results
disp('Input signal:');
disp(input_signal);
disp('Output signal:');
disp(output_signal);
