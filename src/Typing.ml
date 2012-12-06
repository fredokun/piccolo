(* module Typing
   -------------
   
   Type checking and (simple) inference

*)
(** This module defines various utility functions used in other parts of the compiler. *)

open Utils;;
open Types;;
open Syntax;;

(** type representing typeError *)
type typeError =
  | TypeWarning of (string * ast_type)
  | TypeError of (string * ast_type)
      
(** string representing a typeError *)
let string_of_typeError = function
  | TypeWarning (msg,ast) -> "Warning at " ^ (ast#posString) ^ "\n  ==> " ^ msg
  | TypeError(msg, ast) -> "Error at "  ^ (ast#posString) ^ "\n  ==> " ^ msg
      
(** type representing a list of typeErrors *)      
type typeErrors = typeError list
    
(** string representing a list if typeErrors *)
let string_of_typeErrors errs = string_of_collection "" "" "\n" string_of_typeError errs
  
(** representation of the type of a fold_node *)

type typingEnv = ((string * valueType) * ast_binder_type) list

let print_typingEnv env =
  List.iter (fun ((name, ty), binder) -> Printf.printf "%s:%s (%s)\n" name (string_of_valueType ty) binder#toString ) env;
  Printf.printf "\n%!"

let string_of_typeErrors errs = string_of_collection "" "" "\n" string_of_typeError errs

(* class typing_pass_node (verbosity:int) =  *)
(* object(self) *)
(*   inherit [typeErrors] ASTUtils.simple_abstract_fold_node_repr verbosity *)
 
(*   (\* module *\) *)
(*   method moduleDef_val (m:module_type) : unit = *)
(*     self#echoln 2 "Low-level Typing pass started" *)
(*   method moduleDef_fold (m:module_type) (errs:typeErrors list) : typeErrors = *)
(*     self#echoln 2 "Low-level Typing pass finished" ; *)
(*     let errs' = List.fold_left (fun es es' -> es@es') [] errs *)
(*     in *)
(*     if empty_list errs' *)
(*     then begin  *)
(*       self#echoln 2 ("  ==> no low-level type error") ; errs' *)
(*     end else begin *)
(*       List.iter (fun err -> self#echoln 1 (string_of_typeError err)) errs' ; *)
(*       errs' *)
(*     end *)

(*   (\* definition *\) *)
(*   method definition_fold (m:module_type) (d:definition_type) (errs:typeErrors) :typeErrors = *)
(*     self#echoln 3 "-- Typing definition [TODO] check if correct" ; *)
(*     errs *)
(*   (\* process *\) *)
(*   method choice_val v m d p = () *)
        
(*   method choice_fold (m:module_type) (d:definition_type) (p:process choice_process_type) (errs:typeErrors list) :typeErrors = *)
(*     self#echoln 3 "-- Typing choice [TODO] check if correct" ; *)
(*     List.flatten errs *)
(*   method branch_fold (m:module_type) (d:definition_type) (parent:process choice_process_type) (index:int) (p:process prefix_process_type) (guardErrs:typeErrors) (actErrs:typeErrors) (continuationErrs:typeErrors) :typeErrors = *)
(*     self#echoln 3 "-- Typing branch [TODO] check if correct" ; *)
(*     guardErrs @ actErrs @ continuationErrs *)
(*   method call_fold (m:module_type) (d:definition_type) (p:call_process_type) (errs:typeErrors list) : typeErrors = *)
(*     self#echoln 3 "-- Typing call [TODO] !!!" ; *)
(*     List.flatten errs *)

(*   method term_fold (m:module_type) (d:definition_type) (p:term_process_type) : typeErrors = *)
(*     self#echoln 3 "-- Typing term" ; *)
(*     [] *)

(*   (\* action *\) *)
(*   method outAction_fold (m:module_type) (d:definition_type) (p:process prefix_process_type) (a:out_action_type) (errs:typeErrors) : typeErrors = *)
(*     self#echoln 3 "-- Typing output" ; *)
(*     (if a#channelIndex == -1 *)
(*      then [TypeError("Channel variable '" ^ a#channel ^ "' not in scope",(a:>ast_type))] *)
(*      else []) @ *)
(*       (match (a#channelType, a#valueType) with *)
(*       | (TChan t1,t2) ->  *)
(*         if type_eq t1 t2 then [] *)
(*         else [TypeError("Mismatch channel type, expecting '" ^ (string_of_valueType (TChan t2)), (a:>ast_type))] *)
(*       | (_,t2) -> [TypeError("Not a channel type, expecting '" ^ (string_of_valueType (TChan t2)), (a:>ast_type))]) @ *)
(*       errs *)
(*   method inAction_fold (m:module_type) (d:definition_type) (p:process prefix_process_type) (a: in_action_type) :typeErrors = *)
(*     self#echoln 3 "-- Typing input"; *)
(*     (\* [TOASK] what is a channelIndex ?? do we test ?? cf outAction_fold *\) *)
    
(*     (if a#variableType <> TUnknown then Printf.printf "%s already typed ?? [check !!]\n%!" a#variable); *)
(*     match d#fetchBinderType a#channel with  *)
(*       (\*binder can be something else than the definition correction !!! *\) *)
(*       None -> (\* search binder and only if not found then error*\) *)
(* 	[ TypeError (("Unbound channel "^a#channel), (a:>ast_type)) ] *)
(*     | Some (TChan var_ty)->  *)
(*       a#setChannelBinder (d:>ast_binder_type); *)
(*       a#setVariableType var_ty;  *)
(*       self#echoln 3 ("---- setting var to type :" ^ (string_of_valueType var_ty)); *)
(*       [] *)
(*     |Some _ -> [TypeError("Mismatch type for " ^ a#channel ^ " expecting Channel type'", (a:>ast_type))] *)

(*   method tauAction_fold (m:module_type) (d:definition_type) (p:process prefix_process_type) (a:tau_action_type) : typeErrors = *)
(*     (\* self#echoln 3 "-- Typing tau" ; *\) *)
(*     [] *)
  
(*   method newAction_fold (m:module_type) (d:definition_type) (p:process prefix_process_type) (a:new_action_type) : typeErrors = *)
(*     self#echoln 3 "-- Typing new_action" ; *)
(*     (\*enrichir un environnement local ??*\) *)
(*     [] *)

(*   method spawnAction_fold (m:module_type) (d:definition_type) (p:process prefix_process_type) (s:spawn_action_type) (errs:typeErrors list) :typeErrors = *)
(*     self#echoln 3 "-- Typing spawn" ; *)
(*     List.flatten errs *)
    
(*   method primAction_fold: module_type -> definition_type -> process prefix_process_type ->  prim_action_type -> typeErrors list -> typeErrors = *)
(*     failwith "primAction_fold: not yet implemented" *)
(*   method letAction_fold (m:module_type) (d:definition_type) (p:process prefix_process_type) (a:let_action_type) (errs: typeErrors): typeErrors = *)
(*     failwith "letAction_fold: not yet implemented" *)
(*   (\* value *\) *)
(*   method trueValue_fold (m:module_type) (d:definition_type) (p:process_type) (t:Types.valueType) (v:bool const_value_type) : typeErrors = *)
(*     self#echoln 3 "-- Typing constant true" ; *)
(*     let errs = match t with *)
(*       | TBool -> [] *)
(*       | _ -> [TypeError("Mismatch type '" ^ (string_of_valueType t) ^ "' for constant, expected Bool", (v:>ast_type))] *)
(*     in *)
(*     v#setType TBool; *)
(*     errs *)
(*   method falseValue_fold (m:module_type) (d:definition_type) (p:process_type) (t:Types.valueType) (v:bool const_value_type) : typeErrors = *)
(*     self#echoln 3 "-- Typing constant false" ; *)
(*     let errs = match t with *)
(*       | TBool -> [] *)
(*       | _ -> [TypeError("Mismatch type '" ^ (string_of_valueType t) ^ "' for constant, expected Bool", (v:>ast_type))] *)
(*     in *)
(*     v#setType TBool; *)
(*     errs *)

(*   method intValue_fold (m:module_type) (d:definition_type) (p:process_type) (t:Types.valueType) (v:int const_value_type) : typeErrors = *)
(*     self#echoln 3 "-- Typing constant int" ; *)
(*     let errs = match t with *)
(*       | TInt -> [] *)
(*       | _ -> [TypeError("Mismatch type '" ^ (string_of_valueType t) ^ "' for constant, expected Int", (v:>ast_type))] *)
(*     in *)
(*     v#setType TInt; *)
(*     errs *)

(*   method stringValue_fold (m:module_type) (d:definition_type) (p:process_type) (t:Types.valueType) (v:string const_value_type) : typeErrors = *)
(*     self#echoln 3 "-- Typing string constant" ; *)
(*     let errs = match t with *)
(*       | TString -> [] *)
(*       | _ -> [TypeError("Mismatch type '" ^ (string_of_valueType t) ^ "' for constant, expected String", (v:>ast_type))] *)
(*     in *)
(*       v#setType TString; *)
(*       errs *)
      
(*   method tupleValue_fold (m: module_type) (d: definition_type) (p: process_type) (t: Types.valueType) (v: value tuple_value_type) (errs: typeErrors list) : typeErrors = *)
(*     failwith "tupleValue_fold: not yet implemented" *)
  
(*   method varValue_fold (m:module_type) (d:definition_type) (p:process_type) (t:Types.valueType) (v: variable_type) : typeErrors = *)
(*     self#echoln 3 "-- Typing variable"; *)
(*     (if v#ofType <> TUnknown then Printf.printf "%s already typed ?? [check !!]\n%!" v#name); *)
(*     match d#fetchBinderType v#name with  *)
(*       (\*binder can be something else than the definition correction !!! *\) *)
(*       None -> (\* search binder and only if not found then error*\) *)
(* 	  [ TypeError (("Unbound value "^v#name), (v:>ast_type)) ] *)
(*     | Some ty -> v#setType ty; [] *)
      
(*   method primValue_fold: module_type -> definition_type -> process_type -> Types.valueType ->  value prim_value_type -> typeErrors list -> typeErrors = *)
(*     failwith "primValue_fold: not yet implemented" *)
(* end *)

(* let typing_pass n = ((new typing_pass_node n) :> (unit,typeErrors) ASTUtils.fold_node) *)


class typing_pass_node (n:int) : [typingEnv, typeErrors] ASTUtils.fold_node = 
  let lookup env v = 
    try Some (List.find (fun ((name,_), _) -> name=v ) env)
    with Not_found -> None
  in
object(self)
  val mutable currentEnv = []
  (* config *)
  method verbosity = n
  method echo vn str = if vn<=n then print_string str
  method echoln vn str = if vn<=n then print_endline str
  (* module *)
  method moduleDef_val (m:module_type) : typingEnv = 
    self#echoln 2 "Low-level Typing pass started";[]
  
  method moduleDef (m:module_type) (errs:typeErrors list) : typeErrors =
    self#echoln 2 "Low-level Typing pass finished" ;
    let errs' = List.fold_left (fun es es' -> es@es') [] errs
    in
    if empty_list errs'
    then begin 
      self#echoln 2 ("  ==> no low-level type error") ; errs'
    end else begin
      List.iter (fun err -> self#echoln 1 (string_of_typeError err)) errs' ;
      errs'
    end

  (* definitions *)
  method definition_val _ (m:module_type) (d:definition_type) : typingEnv = 
    List.map (fun p -> (p, (d:>ast_binder_type))) d#params

  method definition _ (m:module_type) (d:definition_type) (errs:typeErrors) :typeErrors = 
    self#echoln 2 ("-- typing pass finished in definition "^ d#name ^" [TODO] check if correct") ;
    errs 

  (* processes *)
  method choice_val env m d p = env
  method choice env (m:module_type) (d:definition_type) (p:process choice_process_type) (errs:typeErrors list) :typeErrors = 
    self#echoln 3 "-- Typing choice [TODO] check if correct" ;
    List.flatten errs

  method branch_val env m d c i p = 
    match p#action with
    | Input a -> ((a#variable, a#variableType), (a:>ast_binder_type))::env
    | New a -> ((a#variable, a#variableType), (a:>ast_binder_type))::env
    | Let a -> ((a#variable, a#variableType), (a:>ast_binder_type))::env
    | _ -> env
  method branch env (m:module_type) (d:definition_type) (parent:process choice_process_type) (index:int) (p:process prefix_process_type) (guardErrs:typeErrors) (actErrs:typeErrors) (continuationErrs:typeErrors) :typeErrors =
    self#echoln 3 "-- Typing branch [TODO] check if correct" ;
    guardErrs @ actErrs @ continuationErrs

  method call_val env m d p = env
  method call env (m:module_type) (d:definition_type) (p:call_process_type) (errs:typeErrors list) : typeErrors =
    self#echoln 3 "-- Typing call [TODO] !!!" ;
    List.flatten errs

  method term_val env m d p = ()
  method term _ (m:module_type) (d:definition_type) (p:term_process_type) : typeErrors =
    self#echoln 5 "-- Typing term" ;
    []
    
  (* actions *)
  method outAction_val env m d p a = env
  method outAction env (m:module_type) (d:definition_type) (p:process prefix_process_type) (a:out_action_type) (errs:typeErrors) : typeErrors =
    self#echoln 3 "-- Typing output" ;
    (if a#channelIndex == -1
     then [TypeError("Channel variable '" ^ a#channel ^ "' not in scope",(a:>ast_type))]
     else []) @
      (match (a#channelType, a#valueType) with
	 | (TChan t1,t2) -> 
             if type_eq t1 t2 then []
             else [TypeError("Mismatch channel type, expecting '" ^ (string_of_valueType (TChan t2)), (a:>ast_type))]
	 | (_,t2) -> [TypeError("Not a channel type, expecting '" ^ (string_of_valueType (TChan t2)), (a:>ast_type))]) @
      errs
      
  (* method for typing an input? action *)
  method inAction_fold: module_type -> definition_type -> process prefix_process_type ->  in_action_type -> typeErrors =
    failwith "inAction_fold: not yet implemented"
      
  (* method for typing a silent action tau *) 
  method tauAction_fold (m:module_type) (d:definition_type) (p:process prefix_process_type) (a:tau_action_type) : typeErrors =
   self#echoln 3 "-- Typing tau" ;
    []
      
 (* method for typing the channel creation new *)
 method newAction_fold: module_type -> definition_type -> process prefix_process_type ->  new_action_type -> typeErrors =
   failwith "newAction_fold: not yet implemented"
   
 (* method for typing the thread creation spawn *)
 method spawnAction_fold: module_type -> definition_type -> process prefix_process_type ->  spawn_action_type -> typeErrors list -> typeErrors =
   failwith "spawnAction_fold: not yet implemented"
     
 (* method for typing a primitve action *)
 method primAction_fold: module_type -> definition_type -> process prefix_process_type ->  prim_action_type -> typeErrors list -> typeErrors =
   failwith "primAction_fold: not yet implemented"
     
 (* method for typing a let action *)
 method letAction_fold: module_type -> definition_type -> process prefix_process_type ->  let_action_type -> typeErrors-> typeErrors =
   failwith "letAction_fold: not yet implemented"
     
 (* value *)
 (* method for folding the value true *)
 method trueValue_fold (m:module_type) (d:definition_type) (p:process_type) (t:Types.valueType) (v:bool  const_value_type) : typeErrors =
   self#echoln 3 "-- Typing constant true" ;
   let errs = match t with
      | TBool -> []
      | _ -> [TypeError("Mismatch type '" ^ (string_of_valueType t) ^ "' for constant, expected Bool", (v:>ast_type))]
    in                                                                                                         v#setType TBool;
      errs
	
 (* method for folding the value false *)
 method falseValue_fold: module_type -> definition_type -> process_type -> Types.valueType -> bool  const_value_type -> typeErrors =
   failwith "falseValue_fold: not yet implemented"
     
 (* method for folding a int value *)
 method intValue_fold: module_type -> definition_type -> process_type -> Types.valueType -> int  const_value_type -> typeErrors =
   failwith "intValue_fold: not yet implemented"
     
 (* method for folding a string value *)
 method stringValue_fold (m:module_type) (d:definition_type) (p:process_type) (t:Types.valueType) (v:string  const_value_type) : typeErrors =
   self#echoln 3 "-- Typing string constant" ;
   let errs = match t with
      | TString -> []
      | _ -> [TypeError("Mismatch type '" ^ (string_of_valueType t) ^ "' for constant, expected String", (v:>ast_type))]
    in                                                                                                         v#setType TString;
      errs

  (* method for folding a tuple *)
  method tupleValue_fold: module_type -> definition_type -> process_type -> Types.valueType -> value  tuple_value_type -> typeErrors list -> typeErrors =
    failwith "tupleValue_fold: not yet implemented"
      
  (* method for folding a variable *) 
  method varValue_fold: module_type -> definition_type -> process_type -> Types.valueType ->  variable_type -> typeErrors =
    failwith " varValue_fold: not yet implemented"
      
  (* method for folding a primitive value *)
  method primValue_fold: module_type -> definition_type -> process_type -> Types.valueType ->  value prim_value_type -> typeErrors list -> typeErrors =
    failwith "primValue_fold: not yet implemented"
end
  
(** takes a node and give a type to its pass *)
let typing_pass n = ((new typing_pass_node n) :> (unit,typeErrors) ASTUtils.fold_node)
  

