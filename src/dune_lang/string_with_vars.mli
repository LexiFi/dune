(** String with variables of the form %\{...\} or %(...)

    Variables cannot contain "%\{", "%(", ")" or "\}". For instance in "%(cat
    %\{x\})", only "%\{x\}" will be considered a variable, the rest is text. *)

open Stdune
open Dune_sexp

(** A sequence of text and variables. *)
type t

val compare_no_loc : t -> t -> Ordering.t

val equal_no_loc : t -> t -> bool

(** [loc t] returns the location of [t] — typically, in the [dune] file. *)
val loc : t -> Loc.t

val to_dyn : t Dyn.builder

include Conv.S with type t := t

(** For complex cases, such as [enabled_if] fields *)
val decode_manually :
  (Pform.Env.t -> Template.Pform.t -> Pform.t) -> t Decoder.t

val decoding_env_key : Pform.Env.t Univ_map.Key.t

val set_decoding_env :
  Pform.Env.t -> ('a, 'k) Decoder.parser -> ('a, 'k) Decoder.parser

val add_user_vars_to_decoding_env :
  string list -> ('a, 'k) Decoder.parser -> ('a, 'k) Decoder.parser

(** [t] generated by the OCaml code. The first argument should be [__POS__].
    [quoted] says whether the string is quoted ([false] by default). *)
val virt_pform : ?quoted:bool -> string * int * int * int -> Pform.t -> t

val virt_text : string * int * int * int -> string -> t

val make_pform : ?quoted:bool -> Loc.t -> Pform.t -> t

val make_text : ?quoted:bool -> Loc.t -> string -> t

val is_pform : t -> Pform.t -> bool

val has_pforms : t -> bool

(** If [t] contains no variable, returns the contents of [t]. *)
val text_only : t -> string option

module Mode : sig
  (** How many values expansion of a template must produce.

      The caller always knows which of the contexts below it requires, therefore
      it can specify this to the expansion functions. This allows us to return a
      precise result type from the expansion, and do some validation to make
      sure we aren't expanding into multiple values in cases where it's not
      allowed. *)
  type _ t =
    | Single : Value.t t  (** Expansion must produce a single value *)
    | Many : Value.t list t  (** Expansion may produce any number of values *)
    | At_least_one : (Value.t * Value.t list) t
        (** Expansion may produce 1 or more values *)
end

type yes_no_unknown =
  | Yes
  | No
  | Unknown of { source_pform : Template.Pform.t }

type known_suffix =
  | Full of string
  | Partial of
      { source_pform : Template.Pform.t
      ; suffix : string
      }

type known_prefix =
  | Full of string
  | Partial of
      { prefix : string
      ; source_pform : Template.Pform.t
      }

val known_suffix : t -> known_suffix

val known_prefix : t -> known_prefix

val is_suffix : t -> suffix:string -> yes_no_unknown

val is_prefix : t -> prefix:string -> yes_no_unknown

val fold_pforms :
  t -> init:'a -> f:(source:Template.Pform.t -> Pform.t -> 'a -> 'a) -> 'a

type 'a expander = source:Template.Pform.t -> Pform.t -> 'a

module type Expander = sig
  type 'a app

  (** [expand ~f] attempts to expand all percent forms in a template. If [f]
      returns [None] for any variable (no substitution was found), then this
      function will raise. *)
  val expand :
    t -> mode:'a Mode.t -> dir:Path.t -> f:Value.t list app expander -> 'a app

  (** [expand_as_much_as_possible] expands all variables for which [f] returns
      [None] and left other unexpanded. *)
  val expand_as_much_as_possible :
    t -> dir:Path.t -> f:Value.t list option app expander -> t app
end

include Expander with type 'a app := 'a Memo.t

module Make_expander (A : Applicative) : Expander with type 'a app := 'a A.t

val remove_locs : t -> t
