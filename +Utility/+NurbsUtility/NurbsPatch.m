classdef NurbsPatch < Utility.BasicUtility.Patch

    properties
        nurbs_data_       % nurbs data
    end
    
    methods
        function this = NurbsPatch(dim, name, type, region)
            this@Utility.BasicUtility.Patch(dim, name, type, region)
        end
    end
    
end

