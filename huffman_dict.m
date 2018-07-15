function [cw_list] = huffman_dict (source_prob)

  origsource_prob = source_prob;

  togglecode = 0;
  minvar = 0;
  L = length (source_prob);
  index = 1:L;
  for itr1 = 1:L
    for itr2 = itr1:L
      if (source_prob(itr1) < source_prob(itr2))
        t = source_prob(itr1);
        source_prob(itr1) = source_prob(itr2);
        source_prob(itr2) = t;

        t = index(itr1);
        index(itr1) = index(itr2);
        index(itr2) = t;
      end
    end
  end

  stage_list = {};
  cw_list    = cell (1, L);

  stage_curr = {};
  stage_curr.prob_list = source_prob;
  stage_curr.sym_list = {};
  S = length (source_prob);
  for i = 1:S;
    stage_curr.sym_list{i} = i;
    %cw_list{i} = '';
  end

  % another O(n^2) part.
  I = 1;
  while (I < S)
    L = length (stage_curr.prob_list);
    nprob = stage_curr.prob_list(L-1) + stage_curr.prob_list(L);
    nsym = [stage_curr.sym_list{L-1}(1:end), stage_curr.sym_list{L}(1:end)];

    % stage_curr;
    % archive old stage list.
    stage_list{I} = stage_curr;

    % insert the new probability into the list, at the
    % first-position (greedy?) possible.
    for i = 1:(L-2)
      if ((minvar && stage_curr.prob_list(i) <= nprob) || ...
          stage_curr.prob_list(i) < nprob)
        break;
      end
    end



    stage_curr.prob_list = [stage_curr.prob_list(1:i-1) nprob stage_curr.prob_list(i:L-2)];
    stage_curr.sym_list = {stage_curr.sym_list{1:i-1}, nsym, stage_curr.sym_list{i:L-2}};

    
    I = I + 1;
  end

  if (togglecode == 0)
    one_cw = 1;
    zero_cw = 0;
  else
    one_cw = 0;
    zero_cw = 1;
  end

  % another O(n^2) part.
  I = I - 1;
  while (I > 0)
    stage_curr = stage_list{I};
    L = length (stage_curr.sym_list);

    clist = stage_curr.sym_list{L};
    for k = 1:length (clist)
      cw_list{1,clist(k)} = [cw_list{1,clist(k)} one_cw];
    end

    clist = stage_curr.sym_list{L-1};
    for k = 1:length (clist)
      cw_list{1,clist(k)} = [cw_list{1,clist(k)}, zero_cw];
    end

    I = I - 1;
  end

  % zero all the code-words of zero-probability length, 'cos they
  % never occur.
  S = length (source_prob);
  for itr = (S+1):length (origsource_prob)
    cw_list{1,itr} = -1;
  end

  %disp('Before resorting')
  %cw_list

  nw_list = cell (1, L);
  %
  % Re-sort the indices according to the probability list.
  %
  L = length (source_prob);
  for itr = 1:(L)
    t = cw_list{index(itr)};
    nw_list{index(itr)} = cw_list{itr};
  end
  cw_list = nw_list;


end


