let email_re = Re2.create_exn "([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\\.[a-zA-Z0-9_-]+)"

open Lwt
open Cohttp_lwt_unix
(*It converts the ULR you give it into a URI*)
let req url =
  Client.get (Uri.of_string url) >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body
(*it takes the URL from a comand line argument and prints the email*)
let () =
  let body = Lwt_main.run (req Sys.argv.(1)) in
  let matches = Re2.find_all_exn email_re body in
  List.iter (Printf.printf "%s\n") matches
