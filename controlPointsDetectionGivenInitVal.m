function [ ind ] = controlPointsDetectionGivenInitVal(A, cardK, threshold, initState)
% FUNCTION:
%           return the index of the control points with given initial
%           partition
% INPUT: 
%           A: network/adjacient matrix
%           cardK: number of control points
%           threshold: threshold ratio of detecting the boundary points
%           initState: initial partition
Kset = zeros(1, size(A, 1));
I = eye(size(A,1));
partition = initState;
communities = unique(partition);
A = A./ max(A(:));
for i = 1:communities
   ind1 = find(partition == i); 
   ind2 = (partition ~= i);
   for j = 1 : numel(ind1)
       lala = sum(A(ind1(j), ind2));
       if ( lala >= threshold)
           Kset(ind1(j)) = 1;
       end
   end
end


while (sum(Kset) < cardK)
   uniPVal = unique(partition);
   eigVals = zeros(1, numel(uniPVal));
   for i = 1 : numel(uniPVal)
      if all(Kset(partition == uniPVal(i)))
          eigVals(i) = Inf;
      else
          [~, eigVals(i)] = Gramian(A, I(:, (partition == uniPVal(i))));
      end
   end
   if (all(eigVals == Inf))
      ind = ones(1, size(A,1));
      return;
   end
   [~, l] = min(eigVals);
   indL = find(partition == uniPVal(l));
   [boundInd, newPart, ~] = boundaryDetection(A, indL, threshold);
   Kset(boundInd) = 1;
   if (numel(newPart > 0))
       partition(newPart) = max(uniPVal) + 1;
   end
end
ind = Kset;