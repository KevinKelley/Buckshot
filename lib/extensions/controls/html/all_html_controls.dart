library all_html_controls_buckshot;
/**
 * Import this library to conveniently load all available html extensions.
 *
 * Once the library is imported.  Make a call to...
 *
 *     initHtmlControls();
 *
 * ...in your code.
 */
import 'package:buckshot/buckshot_browser.dart';
import 'package:buckshot/extensions/controls/html/social/plus_one.dart';
import 'package:buckshot/extensions/controls/html/list_box.dart';
import 'package:buckshot/extensions/controls/html/popup.dart';
import 'package:buckshot/extensions/controls/html/media/youtube.dart';
import 'package:buckshot/extensions/controls/html/media/hulu.dart';
import 'package:buckshot/extensions/controls/html/media/vimeo.dart';
import 'package:buckshot/extensions/controls/html/media/funny_or_die.dart';
import 'package:buckshot/extensions/controls/html/modal_dialog.dart';
import 'package:buckshot/extensions/controls/html/dock_panel.dart';
import 'package:buckshot/extensions/controls/html/treeview/tree_view.dart';
import 'package:buckshot/extensions/controls/html/tab_control/tab_control.dart';
import 'package:buckshot/extensions/controls/html/accordion/accordion.dart';
import 'package:buckshot/extensions/controls/html/menus/menus.dart';
import 'package:buckshot/extensions/controls/html/canvas/bitmap_canvas.dart';
import 'package:buckshot/extensions/controls/html/canvas/webgl_canvas.dart';

export 'package:buckshot/buckshot_browser.dart';
export 'package:buckshot/extensions/controls/html/social/plus_one.dart';
export 'package:buckshot/extensions/controls/html/list_box.dart';
export 'package:buckshot/extensions/controls/html/popup.dart';
export 'package:buckshot/extensions/controls/html/media/youtube.dart';
export 'package:buckshot/extensions/controls/html/media/hulu.dart';
export 'package:buckshot/extensions/controls/html/media/vimeo.dart';
export 'package:buckshot/extensions/controls/html/media/funny_or_die.dart';
export 'package:buckshot/extensions/controls/html/modal_dialog.dart';
export 'package:buckshot/extensions/controls/html/dock_panel.dart';
export 'package:buckshot/extensions/controls/html/treeview/tree_view.dart';
export 'package:buckshot/extensions/controls/html/tab_control/tab_control.dart';
export 'package:buckshot/extensions/controls/html/accordion/accordion.dart';
export 'package:buckshot/extensions/controls/html/menus/menus.dart';
export 'package:buckshot/extensions/controls/html/canvas/bitmap_canvas.dart';
export 'package:buckshot/extensions/controls/html/canvas/webgl_canvas.dart';

void initHtmlControls(){
  initPresenter();
  assert(htmlPlatform != null);
  registerElement(new PlusOne.register());
  registerElement(new ListBox.register());
  registerElement(new YouTube.register());
  registerElement(new Hulu.register());
  registerElement(new Vimeo.register());
  registerElement(new FunnyOrDie.register());
  registerElement(new DockPanel.register());
  registerElement(new TreeView.register());
  registerElement(new TabControl.register());
  registerElement(new Accordion.register());
  registerElement(new BitmapCanvas.register());
  registerElement(new WebGLCanvas.register());
  registerMenuControls();
}