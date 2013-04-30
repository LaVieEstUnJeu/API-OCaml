(* ************************************************************************** *)
(* Project: La Vie Est Un Jeu - Public API, example with OCaml                *)
(* Description: API Special Types                                             *)
(* Author: db0 (db0company@gmail.com, http://db0.fr/)                         *)
(* Latest Version is on GitHub: https://github.com/LaVieEstUnJeu/Public-API   *)
(* ************************************************************************** *)

(* ************************************************************************** *)
(* Date & Time                                                                *)
(* ************************************************************************** *)

(* Full time with date + hour                                                 *)
module type DATETIME =
sig
  type t = CalendarLib.Calendar.t
  val format : string

  val to_string : t -> string
  val of_string : string -> t

  val empty : t
  val now : unit -> t
  val is_past : t -> bool
end

(* Only date                                                                  *)
module type DATE =
sig
  type t = CalendarLib.Date.t
  val format : string

  val to_string : t -> string
  val of_string : string -> t

  val empty : t
  val today : unit -> t
end

(* Only date                                                                  *)
module Date : DATE =
struct
  type t =  CalendarLib.Date.t
  let format = "%Y-%m-%d"

  let to_string date =
    CalendarLib.Printer.Date.sprint format date
  let of_string str_date =
    CalendarLib.Printer.Date.from_fstring format str_date

  let empty = CalendarLib.Date.make 0 0 0
  let today () = CalendarLib.Date.today ()
end
(* Full time with date + hour                                                 *)
module DateTime : DATETIME =
struct
  type t = CalendarLib.Calendar.t
  let format = Date.format ^ " %H:%M:%S"

  let to_string date =
    CalendarLib.Printer.Calendar.sprint format date
  let of_string str_date =
    CalendarLib.Printer.Calendar.from_fstring format str_date

  let empty = CalendarLib.Calendar.make 0 0 0 0 0 0
  let now () = CalendarLib.Calendar.now ()
  let is_past date =
    CalendarLib.Calendar.compare (now ()) date >= 0
end

(* ************************************************************************** *)
(* Gender type                                                                *)
(* ************************************************************************** *)

module type GENDER =
sig
  type t
  val default   : t
  val to_string : t -> string
  val of_string : string -> t
end
module Gender : GENDER =
struct
  type t = Male | Female | Other | Undefined
  let default = Undefined
  let to_string = function
    | Male      -> "male"
    | Female    -> "female"
    | Other     -> "other"
    | Undefined -> "undefined"
  let of_string = function
    | "male"      -> Male
    | "female"    -> Female
    | "other"     -> Other
    | "undefined" -> Other
    | _           -> default
end

(* ************************************************************************** *)
(* Privacy                                                                    *)
(* ************************************************************************** *)

module type PRIVACY =
sig
  type t
  val default   : t
  val to_string : t -> string
  val of_string : string -> t
end
module Privacy : PRIVACY =
struct
  type t = Enemy | Pure | Hardcore | Discutable
  let default = Discutable
  let to_string = function
    | Enemy      -> "enemy"
    | Pure       -> "pure"
    | Hardcore   -> "hardcore"
    | Discutable -> "discutable"
  let of_string = function
    | "enemy"      -> Enemy
    | "pure"       -> Pure
    | "hardcore"   -> Hardcore
    | "discutable" -> Hardcore
    | _            -> default
end
