classdef ConjugateGradientDescent < handle

  properties (Constant)
    tolerance = 10^-4;
  end

  methods (Static)

    function [optimalPoint, gradients] = findOptimalPoint(mathFunction, initialPoint)

      point = initialPoint;

      % implement non-quadratic conjugate gradient descent
      gradientVector = mathFunction.gradientVectorAt(point);

      residualVector = -gradientVector; % initialize
      searchDirection = residualVector; % initialize

      lineSearcher = algorithm.supplementary.BacktrackingLineSearcher(0.15, 0.8, 1.0);

      gradients = []; % initialize

      % repeat until converge
      while norm(residualVector) >= algorithm.optimization.ConjugateGradientDescent.tolerance

        % determine step length
        stepLength = lineSearcher.fitStepLength(point, searchDirection, mathFunction);

        % next point
        point = point + searchDirection * stepLength;


        % next gradient vector
        nextGradientVector = mathFunction.gradientVectorAt(point);

        % next residual vector
        nextResidualVector = -nextGradientVector;

        % next search direction
        % Fletcher-Reeves
        searchDirection = nextResidualVector + (nextResidualVector' * nextResidualVector) / (residualVector' * residualVector) * searchDirection;

        % update residual vector
        residualVector = nextResidualVector;

        % update next hessian matrix
        % hessianMatrix = mathFunction.hessianMatrixAt(point);

        % log trace
        gradients = [gradients gradientVector];

        gradientVector = nextGradientVector;
      end % while

      gradients = gradients';
      optimalPoint = point;
    end % find optimal point

  end % static methods

end % class
