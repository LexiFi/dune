(** Promoting rule targets to the source tree. *)

open! Stdune

val promote :
     dir:Path.Build.t
  -> targets_and_digests:(Path.Build.t * Digest.t) list
  -> promote:Rule.Promote.t
  -> promote_source:
       (   chmod:(int -> int)
        -> src:Path.Build.t
        -> dst:Path.Source.t
        -> unit Fiber.t)
  -> unit Fiber.t

(** The set of files created in the source tree that need to be deleted. *)
val files_in_source_tree_to_delete : unit -> Path.Set.t

val delete_stale_dot_merlin_file :
     dir:Path.Build.t
  -> source_files_to_ignore:Path.Source.Set.t
  -> Path.Source.Set.t
