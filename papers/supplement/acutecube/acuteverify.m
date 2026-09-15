function [da, fa] = acuteverify(fname, dispopt)
% ACUTEVERIFY Verifying acute triangulation.
%    [DA, FA] = ACUTEVERIFY(FNAME, DISPOPT)  Computes the Delaunay
%        triangulation of the list of 3-dimensional Euclidean vertices in
%        file FNAME and returns the dihedral angles in matrix DA and the
%        face angles in matrix FA of the tetrahedra of the Delaunay
%        triangulation.  If DISPOPT = TRUE, the angles are also printed
%        to the display.  Each row of each returned matrix contains the
%        angles calculated for one tetrahedron of the triangulation.
%
%    [DA, FA] = ACUTEVERIFY(FNAME)           Defaults DISPOPT to FALSE.
%
%    [DA, FA] = ACUTEVERIFY                  Runs with FNAME =
%        'acutevtxcoord.txt' and DISPOPT = FALSE.
%
%    This script does not perform robust error checking.  Each row of
%    the input file should contain three double values written in ASCII,
%    separated by white space.
%
%    Note also that most face angles are reported twice by this script
%    because interior facets of a triangulation are facets of two
%    simplices.  Face angles for facets on the boundary of the
%    triangulation are reported only once.

% Set defaults
if (nargin < 2)
    dispopt = false;
    if (nargin < 1)
        fname = 'acutevtxcoord.txt';
    end
end

% Open and read the file
fid = fopen(fname);
[V, count] = fscanf(fid, '%f %f %f');
V = reshape(V, 3, count/3);

% Compute the Delaunay triangulation
T = delaunay3(V(1,:), V(2,:), V(3,:));
numtets = size(T, 1);

% Allocate the matrices for return data
da = zeros(numtets, 6);
fa = zeros(numtets, 12);

% Calculate the angles
for tet = 1:numtets

    % compute the dihedral angles
    da(tet, :) = dihangs(V(:, T(tet,:)));
    
    % compute the face angles
    fa(tet, :) = faceangs(V(:, T(tet, :)));
end

% Display the results, if user has requested
if (~dispopt)
    return;
end

disp(' '); disp('Dihedral Angles:'); disp(' ');
disp(sprintf('   %7.3f   %7.3f   %7.3f   %7.3f   %7.3f   %7.3f\n', da));
disp(' '); disp(' '); disp('Face Angles:'); disp(' ');
disp(sprintf(['   %7.3f %7.3f %7.3f %7.3f  %7.3f  %7.3f  %7.3f ', ...
    '%7.3f %7.3f %7.3f %7.3f %7.3f\n'], fa));

end  % end main function

function da = dihangs(V)
   % compute inward unit normals to the faces of the tetrahedron as
   %   cross products
   faces = [1 2 3; 1 4 2; 1 3 4; 2 4 3];
   normals = zeros(3, 4);
   for f = 1:4
       normals(:, f) = cross(V(:, faces(f, 2)) - V(:, faces(f, 1)), ...
           V(:, faces(f, 3)) - V(:, faces(f, 1)));
       if (norm(normals(:, f)) < (2^12)*eps*norm(V(:, faces(f, 1))))
           % if the initially chosen vectors are too nearly parallel,
           % compute the cross product of some other vectors on the face
           normals(:, f) = cross(V(:, faces(f, 3)) - V(:, faces(f, 2)),...
           V(:, faces(f, 1)) - V(:, faces(f, 2)));
       end
       normals(:, f) = normals(:, f)./norm(normals(:, f));
   end

   % for each pair of faces, compute the dihedral angle along intersection
   % as the arccos of the angle between the inward unit normal to one face
   % and the outward unit normal to the other face
   % (computed as dot product of the unit normals)
   da = zeros(1, 6);
   etyps = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
   for i = 1:6
       da(i) = (180/pi)*acos(...
           dot(normals(:, etyps(i, 1)), -normals(:, etyps(i, 2))));
   end
end

% Function to compute the face angles of a tetrahedron
function fa = faceangs(V)
  fa = zeros(1, 12);
  atyps = [1 2 3; 2 3 1; 3 1 2; 1 4 2; 4 2 1; 2 1 4; ...
      1 3 4; 3 4 1; 4 1 3; 2 4 3; 4 3 2; 3 2 4];
  % compute the face angles as the arccos of the angles' cosines, which
  %   are computed as dot products of vectors divided by vector norms
  for i = 1:12
      fa(i) = (180/pi)*acos(dot(V(:, atyps(i, 2)) - V(:, atyps(i, 1)),...
          V(:, atyps(i, 3)) - V(:, atyps(i, 1)))/...
          (norm(V(:, atyps(i, 2)) - V(:, atyps(i, 1)))*...
          norm(V(:, atyps(i, 3)) - V(:, atyps(i, 1)))));
  end
end