%% Class: abstract system
classdef System

    %% Properties: generic ones inherited by child classes
    properties
        MASS                      % total mass
        MASS_MAT                  % mass matrix
        EXT_ACC                   % external acceleration vector
        DIM                       % spatial dimensions
        nDOF                      % total amount of degrees of freedom
        mCONSTRAINTS              % total amount of scalar constraints
        nBODIES                   % number of individual bodies
        nLM                       % number of Lagrange multipliers
        GEOM                      % vector with geometry parameters
        nPotentialInvariants      % number of invariants of the potential
        nConstraintInvariants     % number of invariants of the constraint on position level
        nVconstraintInvariants    % number of invariants of the constraint on velocity level
        
    end

end
