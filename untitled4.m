for r = 1:expt.Nroi
    ViewROI3D(expt{x}, ROI{r,x}, fluor{x}, loco{x}, 'minInt', 2000, 'setROI', 1:expt{x}.Nroi, 'save', false);
end
ViewROI3D()
