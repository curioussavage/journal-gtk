import gintro/[gtk, glib, gobject, gio, gtksource]


type
  BClickArgs = object
    stack: Stack
    page: ScrolledWindow

  Entry = ref object of ListBoxRow


proc back_click(b: Button, args: ref BClickArgs) =
  #let main_stack = cast[Stack](getObject(builder, "main_stack"))
  #let entries_list = cast[ScrolledWindow](getObject(builder, "entries_list"))
  #main_stack.set_visible_child(entries_list)
  args.stack.set_visible_child(args.page)

proc appActivate(app: Application) =
  var
    builder: Builder

    e: Entry

  new e
  
  # dummy sourceview so that the builder knows about the type
  # TODO follow up with registering the type when I figure that out
  var dummy = newView()
  builder = newBuilder()
  discard addFromFile(builder, "builder.ui")

  # get refs to widgets
  let window = cast[ApplicationWindow](getObject(builder, "window"))

  let main_stack = cast[Stack](getObject(builder, "main_stack"))
  let back_button = cast[Button](getObject(builder, "back_button"))

  let entries_list = cast[ScrolledWindow](getObject(builder, "entries_list"))
  let editor = cast[ScrolledWindow](getObject(builder, "editor"))

  # setup signal handlers
  var args: ref BClickArgs
  new args
  args.stack = main_stack
  args.page = entries_list

  back_button.connect("clicked", back_click, args)

  window.setApplication(app)

proc main =
  let app = newApplication("org.gtk.example")
  connect(app, "activate", appActivate)
  discard run(app)

main()
