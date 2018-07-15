function [ received_signal ] = awgn_channel( modulated_signal, SNR )

    received_signal = awgn(modulated_signal, SNR, 'measured');
    
end

