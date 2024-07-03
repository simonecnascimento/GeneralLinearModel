circularity = res_dbg.featureTable1{6,:};
%then copy the circularity of these events with the events that are already
%found in circularityAll
circularityAll = num2cell(circularityAll);
histogram(cell2mat(circularityAll));
