  $ jbuilder utop -j1 --display short --root . forutop -- init_forutop.ml
      ocamldep forutop/.utop/utop.ml.d
      ocamldep forutop/forutop.ml.d
        ocamlc forutop/.forutop.objs/forutop.{cmi,cmo,cmt}
        ocamlc forutop/.utop/utop.{cmi,cmo,cmt}
        ocamlc forutop/forutop.cma
        ocamlc forutop/.utop/utop.exe
  hello in utop
