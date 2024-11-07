function output_signal = fir(input_signal, filter_coefficients)

% Get the length of the input signal and filter coefficients
input_length = length(input_signal);
filter_length = length(filter_coefficients);

% Initialize the output signal
output_signal = zeros(1, input_length);

% Apply the FIR filter
for i = 1:input_length
    for j = 1:filter_length
        if i-j+1 > 0
            output_signal(i) = output_signal(i) + filter_coefficients(j) * input_signal(i-j+1);
        end
    end
end