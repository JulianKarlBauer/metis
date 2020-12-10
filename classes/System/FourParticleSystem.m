classdef FourParticleSystem < System

    %% 4-particle system in 2 or 3 dimensions
    properties
        K1
        K2
        p
    end
        
    methods

        function self = FourParticleSystem(CONFIG)

            self.mCONSTRAINTS = 2;
            self.nBODIES      = 4;
            self.DIM          = CONFIG.DIM;
            self.MASS         = CONFIG.MASS;
            self.nDOF         = self.nBODIES*CONFIG.DIM;
            self.MASS_MAT     = diag([repmat(self.MASS(1),self.DIM,1);repmat(self.MASS(2),self.DIM,1);repmat(self.MASS(3),self.DIM,1);repmat(self.MASS(4),self.DIM,1)]);
            self.EXT_ACC      = repmat(CONFIG.EXT_ACC,self.nBODIES,1);
            self.GEOM(1)      = norm(CONFIG.Q_0(CONFIG.DIM+1:2*CONFIG.DIM)-CONFIG.Q_0(1:CONFIG.DIM)); %length of 1st rod 
            self.GEOM(2)      = norm(CONFIG.Q_0((3*CONFIG.DIM)+1:4*CONFIG.DIM)-CONFIG.Q_0((2*CONFIG.DIM)+1:3*CONFIG.DIM)); %length of 2nd rod
            self.GEOM(3)      = norm(CONFIG.Q_0((2*CONFIG.DIM)+1:3*CONFIG.DIM)-CONFIG.Q_0(1:CONFIG.DIM)); %length of 1st spring without strain
            self.GEOM(4)      = norm(CONFIG.Q_0((3*CONFIG.DIM)+1:4*CONFIG.DIM)-CONFIG.Q_0(CONFIG.DIM+1:2*CONFIG.DIM)); %length of 2nd spring without strain
            self.K1           = 100;
            self.K2           = 1000;
            self.p            = 2;
        end

        function self = initialise(self, CONFIG, this_integrator)
            % Set initial values
            self.z       = zeros(this_integrator.NT, this_integrator.nVARS);
            self.z(1, :) = [CONFIG.Q_0', (self.MASS_MAT * CONFIG.V_0)', this_integrator.LM0'];
        end
        
        function V = potential(self, q)
            % External potential
            V_ext = (self.MASS_MAT*self.EXT_ACC)'*q;
            
            % Internal potential
            q1 = q(1:self.DIM);
            q2 = q(self.DIM+1:2*self.DIM);
            q3 = q(2*self.DIM+1:3*self.DIM);
            q4 = q(3*self.DIM+1:4*self.DIM);
            
            V_int = 1/2*self.K1*(norm(q3-q1)^self.p-self.GEOM(3)^self.p)^2 + 1/2*self.K2*(norm(q4-q2)^self.p-self.GEOM(4)^self.p)^2;
            
            V = V_int+V_ext;
        end
        
        function DV = potential_gradient(self,q)
            DV_ext = self.MASS_MAT*self.EXT_ACC;
            
            q1 = q(1:self.DIM);
            q2 = q(self.DIM+1:2*self.DIM);
            q3 = q(2*self.DIM+1:3*self.DIM);
            q4 = q(3*self.DIM+1:4*self.DIM);
            P  = self.p;
            
            DV_int = [self.K1*P*(norm(q3-q1)^P-self.GEOM(3)^P)*norm(q3-q1)^(P-1)*(q1-q3);
                      self.K2*P*(norm(q4-q2)^P-self.GEOM(4)^P)*norm(q4-q2)^(P-1)*(q2-q4);
                      self.K1*P*(norm(q3-q1)^P-self.GEOM(3)^P)*norm(q3-q1)^(P-1)*(q3-q1);
                      self.K2*P*(norm(q4-q2)^P-self.GEOM(4)^P)*norm(q4-q2)^(P-1)*(q4-q2)];
                
            DV = DV_ext + DV_int;
            
        end
        
        function D2V = potential_hessian(~,q)
            D2V = zeros(size(q,1));
        end

        function g = constraint(self, q)
            % Constraint on position level
            q1 = q(1:self.DIM);
            q2 = q(self.DIM+1:2*self.DIM);
            q3 = q(2*self.DIM+1:3*self.DIM);
            q4 = q(3*self.DIM+1:4*self.DIM);
            
            g1 = 0.5 * ((q2-q1)' * (q2-q1) -self.GEOM(1)^2);
            g2 = 0.5 * ((q4-q3)' * (q4-q3) -self.GEOM(2)^2);
            g  = [g1 ; g2];
            
        end

        function Dg = constraint_gradient(self, q)
            % Gradient of constraint w.r.t q
            q1 = q(1:self.DIM);
            q2 = q(self.DIM+1:2*self.DIM);
            q3 = q(2*self.DIM+1:3*self.DIM);
            q4 = q(3*self.DIM+1:4*self.DIM);
            
            Dg = [-(q2-q1)' (q2-q1)' zeros(self.DIM,1)' zeros(self.DIM,1)';
                  zeros(self.DIM,1)'  zeros(self.DIM,1)' -(q4-q3)' (q4-q3)'];
            
        end
        
        function D2g = constraint_hessian(self,~,m)
            
            tmp = [eye(self.DIM) -eye(self.DIM); -eye(self.DIM) eye(self.DIM)];
            
            if m == 1
                % Hessian of g_1 w.r.t. q
                D2g = [tmp  zeros(2*self.DIM); zeros(2*self.DIM) zeros(2*self.DIM)]; 
            elseif 2
                % Hessian of g_2 w.r.t. q
                D2g = [zeros(2*self.DIM) zeros(2*self.DIM) ; zeros(2*self.DIM) tmp];
            end
            
        end
        
        function give_animation(self,fig)
            
            
                DIM = self.DIM;
                q1 = self.z(:, 1:DIM);
                q2 = self.z(:,DIM+1:2*DIM);
                q3 = self.z(:,2*DIM+1:3*DIM);
                q4 = self.z(:,3*DIM+1:4*DIM);
                xmin = min([min(q1(:,1)) min(q2(:,1)) min(q3(:,1)) min(q4(:,1))]);
                ymin = min([min(q1(:,2)) min(q2(:,2)) min(q3(:,2)) min(q4(:,2))]);
                zmin = min([min(q1(:,3)) min(q2(:,3)) min(q3(:,3)) min(q4(:,3))]);
                xmax = max([max(q1(:,1)) max(q2(:,1)) max(q3(:,1)) max(q4(:,1))]);
                ymax = max([max(q1(:,2)) max(q2(:,2)) max(q3(:,2)) max(q4(:,2))]);
                zmax = max([max(q1(:,3)) max(q2(:,3)) max(q3(:,3)) max(q4(:,3))]);
                NT = size(q1,1);

                axis equal
                axis([xmin, xmax, ymin, ymax, zmin, zmax]);
                xlabel('x');
                ylabel('y');
                zlabel('z');
                grid on;

                xa1 = q1(1, 1);
                xa2 = q2(1, 1);
                xa3 = q3(1, 1);
                xa4 = q4(1, 1);
                ya1 = q1(1, 2);
                ya2 = q2(1, 2);
                ya3 = q3(1, 2);
                ya4 = q4(1, 2);
                
                if DIM == 3
                    za1 = q1(1, 3);
                    za2 = q2(1, 3);
                    za3 = q3(1, 3);
                    za4 = q4(1, 3);
                else
                    za1 = 0;
                    za2 = 0;
                    za3 = 0;
                    za4 = 0;
                end

                for j = 1:NT

                    cla(fig);
                    hold on

                    %% Current position
                    x1 = q1(j, 1);
                    x2 = q2(j, 1);
                    x3 = q3(j, 1);
                    x4 = q4(j, 1);
                    
                    y1 = q1(j, 2);
                    y2 = q2(j, 2);
                    y3 = q3(j, 2);
                    y4 = q4(j, 2);
                    
                    if DIM == 3
                        z1 = q1(j, 3);
                        z2 = q2(j, 3);
                        z3 = q3(j, 3);
                        z4 = q4(j, 3);
                    else
                        z1 = 0;
                        z2 = 0;
                        z3 = 0;
                        z4 = 0;
                    end

                    %% Reference sphere
                    plot3(xa1, ya1, za1, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [0.75, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    hold on
                    plot3(xa2, ya2, za2, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [0.75, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    hold on
                    plot3(xa3, ya3, za3, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [0.75, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    hold on
                    plot3(xa4, ya4, za4, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [0.75, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    hold on

                    %% Reference constraint
                    xx3 = [xa1; xa2];
                    yy3 = [ya1; ya2];
                    zz3 = [za1; za2];
                    xxx3 = [xa3; xa4];
                    yyy3 = [ya3; ya4];
                    zzz3 = [za3; za4];
                    plot3(xx3, yy3, zz3, 'k', 'LineWidth', 2);
                    hold on
                    plot3(xxx3, yyy3, zzz3, 'k', 'LineWidth', 2);
                    
                    %% Reference position of the springs
                    xx_3 = [xa1; xa3];
                    yy_3 = [ya1; ya3];
                    zz_3 = [za1; za3];
                    xxxx_3 = [xa2; xa4];
                    yyyy_3 = [ya2; ya4];
                    zzzz_3 = [za2; za4];
                    plot3(xx_3, yy_3, zz_3, 'k--');
                    hold on
                    plot3(xxxx_3, yyyy_3, zzzz_3, 'k--');
                    

                    %% current position of the mass
                    %hold on
                    %if DIM == 3
                    %    plot3(q1(1:j, 1), q1(1:j, 2), q1(1:j, 3), 'k');
                    %    plot3(q2(1:j, 1), q2(1:j, 2), q2(1:j, 3), 'k');
                    %    plot3(q3(1:j, 1), q3(1:j, 2), q3(1:j, 3), 'k');
                    %    plot3(q4(1:j, 1), q4(1:j, 2), q4(1:j, 3), 'k');
                    %else
                    %    plot3(q1(1:j, 1), q1(1:j, 2), zeros(j, 1), 'k');
                    %    plot3(q2(1:j, 1), q2(1:j, 2), zeros(j, 1), 'k');
                    %    plot3(q3(1:j, 1), q3(1:j, 2), zeros(j, 1), 'k');
                    %    plot3(q4(1:j, 1), q4(1:j, 2), zeros(j, 1), 'k');
                    %end
                    plot3(x1, y1, z1, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    plot3(x2, y2, z2, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    plot3(x3, y3, z3, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    plot3(x4, y4, z4, 'mo', 'MarkerSize', 10, 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceColor', [0.75, 0, 0]);
                    
                    grid on

                    %% current position of the constraint
                    x_3 = [x1; x2];
                    y_3 = [y1; y2];
                    z_3 = [z1; z2];
                    xxx3 = [x3; x4];
                    yyy3 = [y3; y4];
                    zzz3 = [z3; z4];
                    plot3(x_3, y_3, z_3, 'k', 'linewidth', 2);
                    plot3(xxx3, yyy3, zzz3, 'k', 'linewidth', 2);
                    
                    %% Current position of the springs
                    xx3 = [x1; x3];
                    yy3 = [y1; y3];
                    zz3 = [z1; z3];
                    xxxx3 = [x2; x4];
                    yyyy3 = [y2; y4];
                    zzzz3 = [z2; z4];
                    plot3(xx3, yy3, zz3, 'k--');
                    hold on
                    plot3(xxxx3, yyyy3, zzzz3, 'k--');
                    
                    
                    if DIM == 2
                        view(0, 90)
                    else
                        view(136, 23)
                    end

                    drawnow
                    
                end
                
        end
        
    end

end
