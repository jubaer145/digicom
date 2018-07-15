function [ demodulated_signal ] = line_decode( received_signal,bit_rate, method, number_of_bits )
M = 16;
global_phase_shift = pi/4;

N = 72;
frequency = 3* bit_rate;
amplitude = 3;

delta_f = 50;
starting_frequency = 200;


cd library
if isequal(method, 'MPSK')
    demodulated_signal = MPSK_decoder (received_signal, M, N, bit_rate, ...
                                global_phase_shift, frequency, amplitude);
elseif isequal(method, 'MFSK')
    demodulated_signal = MFSK_decoder(received_signal, M, N, bit_rate, amplitude, delta_f, starting_frequency);

elseif isequal(method, 'MASK')
    demodulated_signal =  MASK_decoder(received_signal, M, N, bit_rate,frequency, amplitude);

elseif isequal(method, 'GMSK')
   demodulated_signal = GMSK_decoder(received_signal, N, bit_rate, frequency, number_of_bits);
end
demodulated_signal = demodulated_signal(1:number_of_bits);
cd ..


end

