(* ************************************************************************** *)
(* Project: Life - the game, Official OCaml SDK                               *)
(* Author: nox                                                                *)
(* Latest Version is on GitHub: https://github.com/Life-the-game/SDK-OCaml    *)
(* ************************************************************************** *)

open ApiTypes
open Network

(* PRIVATE *)
(* ************************************************************************** *)
(* Type                                                                       *)
(* ************************************************************************** *)

module type ROLE =
sig
    type t =
        | Ambassador
        | Admin
        | Translator
        | Designer
        | Newser
    val to_string : t -> string
    val of_string : string -> t
end
module Role : ROLE =
    struct
        type t =
            | Ambassador
            | Admin
            | Translator
            | Designer
            | Newser
        let to_string = function
            | Ambassador -> "ambassador"
            | Admin -> "admin"
            | Translator -> "translator"
            | Designer -> "designer"
            | Newser -> "newser"
        let of_string = function
            | "ambassador" -> Ambassador
            | "admin" -> Admin
            | "translator" -> Translator
            | "designer" -> Designer
            | "newser" -> Newser
            | _ -> Newser
    end

type t =
    {
        info            : Info.t;
        role            : Role.t;
        achievements    : ApiAchievement.t list;
        lang            : string list;
    }

(* ************************************************************************** *)
(* Tools                                                                      *)
(* ************************************************************************** *)

let from_json c =
  let open Yojson.Basic.Util in
  {
    info            = Info.from_json c;
    role            = Role.of_string (c |> member "role" |> to_string);
    achievements    = convert_each ApiAchievement.from_json (c |> member "achievements");
    lang            = convert_each to_string (c |> member "lang");
  }

(* ************************************************************************** *)
(* API Methods                                                                *)
(* ************************************************************************** *)

(* ************************************************************************** *)
(* Get roles                                                                  *)
(* ************************************************************************** *)
let get ~auth user_id =
    Api.go ~path:(["users"; user_id; "roles"]) ~req:(Some (Auth auth))
    (Page.from_json from_json)

(* ************************************************************************** *)
(* Add a role                                                                 *)
(* ************************************************************************** *)
let add ~auth ~role ?(achievements = "") ?(lang = "") user_id =
    let post_parameters =
        Network.empty_filter
        [("role", Role.to_string role);
        ("achievements", achievements);
        ("lang", lang);] in
    let post =
        Network.PostList post_parameters in
    Api.go
    ~rtype:POST
    ~post:post
    ~path:(["users"; user_id; "roles"])
    ~req:(Some (Auth auth))
    from_json

(* ************************************************************************** *)
(* Delete a role                                                              *)
(* ************************************************************************** *)
let delete ~auth role_id =
    Api.go
    ~rtype:DELETE
    ~path:(["roles"; role_id])
    ~req:(Some (Auth auth))
    Api.noop



(* /PRIVATE *)
