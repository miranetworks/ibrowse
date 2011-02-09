-module(ibrowse_build_rel).

-export([
        start/1
        ]).

% Interface functions
start(RelFile)->
    ok = systools:make_script(RelFile),
    ok = systools:make_tar(RelFile, [{dirs, [include, src, priv, doc]}]),
    halt().

%EOF
