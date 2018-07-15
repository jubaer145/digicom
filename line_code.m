function [ modulated_signal ] = line_code(bit, bit_rate, method )

M = 16;
global_phase_shift = pi/4;

N = 72;
frequency = 3* bit_rate;
amplitude = 3;

delta_f = 50;
starting_frequency = 200;
bit_period= 1/bit_rate;
B= 0.3/bit_period;

cd library
if isequal(method, 'MPSK')
    modulated_signal = MPSK_coder(bit, M, N, bit_rate, ...
                                global_phase_shift, frequency, amplitude);
elseif isequal(method, 'MFSK')
    modulated_signal = MFSK_coder(bit, M, N, bit_rate, amplitude , delta_f, starting_frequency);

elseif isequal(method, 'MASK')
    modulated_signal = MASK_coder(bit, M, N, bit_rate, frequency, amplitude);

elseif isequal(method, 'GMSK')
   modulated_signal = GMSK_encoder(bit, B, N, bit_rate, frequency); 
end

cd ..
end

