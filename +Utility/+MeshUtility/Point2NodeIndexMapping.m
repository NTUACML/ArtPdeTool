classdef Point2NodeIndexMapping < handle
    %POINT2NODEMAPPING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dict_ = containers.Map('KeyType','double','ValueType','double')
        node_id_counter_ = 0
    end
    
    methods
        function this = Point2NodeIndexMapping()
        end
        
        function node_id = addPointId(this, point_id)
            this.setPointId(point_id);
            node_id = this.getNodeId(point_id);
        end
        
        function node_id = getNodeId(this, point_id)
            len_point = length(point_id);
            node_id = zeros(1, len_point);
            for i = 1 : len_point
                if(isKey(this.dict_,point_id(i)))
                    node_id(i) = this.dict_(point_id(i));
                else
                    this.setPointId(point_id(i));
                    node_id(i) = this.dict_(point_id(i));
                end
            end
        end
        
        function clear(this)
            this.dict_ = containers.Map('KeyType','double','ValueType','double');
            this.node_id_counter_ = 0;
        end
        
        function node_id = getAllNodeId(this)
            node_id = cell2mat(values(this.dict_));
        end
        
        function point_id = getAllPointId(this)
            point_id = cell2mat(keys(this.dict_));
        end
    end
    
    methods (Access = private)
        function setPointId(this, point_id)
            len_point = length(point_id);
            for i = 1 : len_point
                if(isKey(this.dict_,point_id(i)))
                    continue;
                else
                    this.node_id_counter_ = this.node_id_counter_ + 1;
                    this.dict_(point_id(i)) = this.node_id_counter_;
                end
            end
        end
    end
end

