Start Dune in watch mode, sending errors to `/dev/null` to suppress the alerts
about using the unstable module Dune_rpc.

  $ export XDG_STATE_HOME="$PWD/.dune.state"
  $ mkdir $XDG_STATE_HOME

  $ dune build -w 2> /dev/null &

Wait for the program produced by the above step to exist.
  $ while ! test -f _build/default/hello.exe; do sleep 1; done

Run the program. The program takes care of shutting down the build server.
  $ ../../rpc_client.exe
  Sending ping to server...
  Got response from server...
  Creating progress stream...
  Waiting for next progress event...
  Got progress_event: Success
  Shutting down RPC server...

  $ wait
