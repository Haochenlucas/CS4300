policies_s = string([]);
for i = 1:length(policies(1,1,:))
    policy = string(policies(:,:,i));
    policy(policy == "1") = "^";
    policy(policy == "2") = "<";
    policy(policy == "3") = "v";
    policy(policy == "4") = ">";
    policy(policy == "-1") = "x";
    policies_s(:,:,i) = policy;
end