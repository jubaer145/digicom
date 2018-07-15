function [decoded_msg] = huffman_decode (hcode, dict, unique_symbol)

  cd library
  tree = dict2tree(dict);
  cd ..
  index = [];
  pointer = 1; 
  for i = 1:length(hcode);
    if (tree(pointer) ~= -1)
      index = [index, tree(pointer)];
      pointer = 1;
    end
    pointer = 2 * pointer + hcode(i);
  end
  if (tree(pointer) == -1)
%     warning ('huffmandeco: could not decode last symbol')
    index = [index, 4];
  else
      index = [index, tree(pointer)];
  end
  decoded_msg = unique_symbol(index);
end


