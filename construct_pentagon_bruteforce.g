# This script allows one to construct brute force all solutions to the PE
# of small sizes.

# Let S be a set.
# s[x,y]=[xy, theta_x(y) is a solution the the PE if and only if
# for every x,y,z in S the following holds
# 1. x(yz)=(xy)z
# 2. theta_x(yz) = theta_x(y)theta_{xy}(z)
# 3. theta_{theta_x(y))theta_{xy}(z) = theta_y(z)

# For a tuple x,y,z check if the first condition is satisfied
first_condition:=function(S,x,y,z)
  return S[x][S[y][z]] = S[S[x][y]][z];
end;

# For a tuple x,y,z check if the second condition is satisfied
second_condition := function(S,T,x,y,z)
  return T[x][S[y][z]] = S[T[x][y]][T[S[x][y]][z]];
end;

# For a tuple x,y,z check if the third condition is satisfied
third_condition := function(S,T,x,y,z)
  return T[T[x][y]][T[S[x][y]][z]] = T[y][z];
end;

# Check if S is a semigroup
is_a_semigroup:=function(S,n)
  local t;
  for t in Tuples([1..n],3) do
    if first_condition(S,t[1],t[2],t[3]) = false then
      return false;
    fi;
  od;
  return true;
end;

is_homomorphis:=function(f,S1,S2,n)
  local x,y;
  for x in [1..n] do
    for y in [1..n] do
      if not S1[x^f][y^f] = (S2[x][y])^f then
        return false;
      fi;
    od;
  od;
  return true;
end;

are_isomorphic_semigroups:=function(S1,S2,n)
  return true in List(SymmetricGroup(n), f->is_homomorphis(f,S1,S2,n));
end;

# For a given S and T check if it is a solution
is_a_solution:=function(S,T,n)
  local t;
  for t in Tuples([1..n],3) do
    if second_condition(S,T,t[1],t[2],t[3]) = false then
      return false;
    fi;
    if third_condition(S,T,t[1],t[2],t[3]) = false then
      return false;
    fi;
  od;
  return true;
end;


construct_solutions:=function(n)
  local possible_rows, S, T, Solutions;
  Solutions:=[];
  possible_rows:=Tuples([1..n],n);
  for S in Tuples(possible_rows, n) do
    if is_a_semigroup(S,n) = true then
      for T in Tuples(possible_rows, n) do
        if is_a_solution(S,T,n) = true then
          Add(Solutions,[S,T]);
        fi;
      od;
    fi;
  od;
  return Solutions;
end;

is_isomorphism := function(f, S1, T1, S2, T2,n)
  local x, y, u, v;
	for x in [1..n] do
		for y in [1..n] do
			v:= y^f;
      u:=x^f;
			if not S1[v][u] = (S2[y][x])^f then
				return false;
			fi;
      if not T1[v][u] = (T2[y][x])^f then
				return false;
      fi;
		od;
 	od;
	return true;
end;

isomorphism_solutions := function(S1,T1,S2,T2,n)
	return true in List(SymmetricGroup(n), f->is_isomorphism(f, S1,T1,S2,T2,n));
end;

construct_solutions:=function(n)
  local possible_rows, S, T, solutions;
  solutions:=[];
  possible_rows:=Tuples([1..n],n);
  for S in Tuples(possible_rows, n) do
    if is_a_semigroup(S,n) = true then
      for T in Tuples(possible_rows, n) do
        if is_a_solution(S,T,n) = true then
          Add(solutions,[S,T]);
        fi;
      od;
    fi;
  od;
  return solutions;
end;

is_already_in_the_list:=function(sol, up_to_iso,n)
  local sol2;
  for sol2 in up_to_iso do
    if isomorphism_solutions(sol[1],sol[2],sol2[1],sol2[2],n) = true then
      return true;
    fi;
  od;
  return false;
end;

solutions_up_to_iso:=function(solutions,n)
  local up_to_iso, sol;
  up_to_iso:=[];
  Add(up_to_iso,solutions[1]);
  for sol in solutions do
    if is_already_in_the_list(sol, up_to_iso,n) = false then
      Add(up_to_iso,sol);
    fi;
  od;
  return up_to_iso;
end;

construct_solutions_up_to_iso:=function(n)
  local possible_rows, S, T, solutions;
  solutions:=[];
  possible_rows:=Tuples([1..n],n);
  for S in Tuples(possible_rows, n) do
    if is_a_semigroup(S,n) = true then
      for T in Tuples(possible_rows, n) do
        if is_a_solution(S,T,n) = true then
          if solutions =[] then
            Add(solutions,[S,T]);
          elif is_already_in_the_list([S,T],solutions,n) = false then
            Add(solutions,[S,T]);
          fi;
        fi;
      od;
    fi;
  od;
  return solutions;
end;
