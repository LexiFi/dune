  $ jbuilder build -j1 --display short --root . @install --debug-dep
        ocamlc a/ppx/.a.objs/a.{cmi,cmo,cmt}
      ocamlopt a/ppx/.a.objs/a.{cmx,o}
      ocamlopt a/ppx/a.{a,cmxa}
      ocamlopt a/ppx/a.cmxs
        ocamlc a/kernel/.a_kernel.objs/a_kernel.{cmi,cmo,cmt}
      ocamlopt a/kernel/.a_kernel.objs/a_kernel.{cmx,o}
      ocamlopt a/kernel/a_kernel.{a,cmxa}
      ocamlopt a/kernel/a_kernel.cmxs
        ocamlc a/ppx/a.cma
        ocamlc a/kernel/a_kernel.cma
      ocamlopt .ppx/a.kernel/ppx.exe
      ocamlopt .ppx/a/ppx.exe
           ppx b/b.pp.ml
      ocamldep b/b.pp.ml.d
        ocamlc b/.b.objs/b.{cmi,cmo,cmt}
      ocamlopt b/.b.objs/b.{cmx,o}
      ocamlopt b/b.{a,cmxa}
      ocamlopt b/b.cmxs
        ocamlc b/b.cma
