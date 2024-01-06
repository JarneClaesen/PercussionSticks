import 'dart:math';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percussion_mallets/settings_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:convert';

import 'excerpt.dart';

void main() async {
  // Initialize Hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter for the Excerpt class
  Hive.registerAdapter(ExcerptAdapter());

  // Open the box for storing the excerpts
  await Hive.openBox<Excerpt>('excerpts');

  runApp(MyApp());
}

Color brandColor = Colors.deepPurple;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {

          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          /*if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor);
            darkColorScheme = ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.dark);
          }*/

          lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor);
          darkColorScheme = ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.dark);

          return MaterialApp(
            title: 'Excerpts',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              scaffoldBackgroundColor: lightColorScheme.background,
              //fontFamily: GoogleFonts.poppins().fontFamily,
              appBarTheme: const AppBarTheme(
                color: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
              scaffoldBackgroundColor: darkColorScheme.background,
              //fontFamily: GoogleFonts.poppins().fontFamily,
              appBarTheme: const AppBarTheme(
                color: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
            ),
            home: const ExcerptsPage(),
          );
        }
    );
  }
}

class ExcerptsPage extends StatefulWidget {
  const ExcerptsPage({super.key});

  @override
  _ExcerptsPageState createState() => _ExcerptsPageState();
}

class _ExcerptsPageState extends State<ExcerptsPage> {
  final Box<Excerpt> _excerptsBox = Hive.box<Excerpt>('excerpts');
  List<Excerpt> _selectedExcerpts = [];

  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  final PanelController _panelController = PanelController();
  double _fabPadding = 80.0;


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _updateFabVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Excerpts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditExcerptsDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteExcerptsDialog(context),
            ),
          ],
        ),
        body: SlidingUpPanel(
          color: Theme.of(context).colorScheme.surface,
          controller: _panelController,
          onPanelSlide: (position) {
            setState(() {
              _fabPadding = position == 1.0 ? 0.0 : 80.0;
            });
          },
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          minHeight: 80, // Adjust the minHeight to show the drag handle
          maxHeight: MediaQuery.of(context).size.height / 1.3,
          panel: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 12),
                Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    //controller: _scrollController,
                    padding: const EdgeInsets.only(top: 20, bottom: 25, left: 25, right: 25),
                    children: _getSelectedMallets()
                        .map((mallet) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                          mallet,
                          style:
                          TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimaryContainer
                          )
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _excerptsBox.listenable(),
                  builder: (context, Box<Excerpt> box, _) {
                    final excerpts = box.values.toList();
                    return ReorderableListView(
                      children: [
                        for (final excerpt in excerpts)
                          CheckboxListTile(
                            key: Key(excerpt.key.toString()), // Unique key for each item
                            title: Text(excerpt.title),
                            subtitle: Text(excerpt.mallets.join(', ')),
                            value: excerpt.selected,
                            onChanged: (value) {
                              setState(() {
                                excerpt.selected = value ?? false;
                                _excerptsBox.putAt(excerpts.indexOf(excerpt), excerpt);
                              });
                            },
                          ),
                      ],
                      onReorder: _onReorder,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 5.1),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: IgnorePointer(
            ignoring: !_showFab,
            child: AnimatedPadding(
              padding: EdgeInsets.only(bottom: _fabPadding),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _showAddExcerptDialog(context),
              ),
            ),


          ),
        )
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final itemsBox = Hive.box<Excerpt>('excerpts');
      final items = itemsBox.values.toList();

      // Adjust newIndex to stay within the range
      newIndex = newIndex > items.length - 1 ? items.length - 1 : newIndex;

      final Excerpt movingItem = items.removeAt(oldIndex);
      items.insert(newIndex, movingItem.copyWith());

      // Update the Hive box for only the affected items
      if (oldIndex < newIndex) {
        for (int i = oldIndex; i <= newIndex; i++) {
          itemsBox.putAt(i, items[i]);
        }
      } else {
        for (int i = newIndex; i <= oldIndex; i++) {
          itemsBox.putAt(i, items[i]);
        }
      }
    });
  }


  /*
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final itemsBox = Hive.box<Excerpt>('excerpts');
      final items = itemsBox.values.toList();
      final Excerpt movingItem = items.removeAt(oldIndex);

      // Create a new instance for the moving item
      final updatedMovingItem = Excerpt(
        title: movingItem.title,
        mallets: movingItem.mallets,
        selected: movingItem.selected,
      );

      items.insert(newIndex, updatedMovingItem);

      // Update the Hive box for only the affected items
      if (oldIndex < newIndex) {
        for (int i = oldIndex; i <= newIndex; i++) {
          itemsBox.putAt(i, items[i]);
        }
      } else {
        for (int i = newIndex; i <= oldIndex; i++) {
          itemsBox.putAt(i, items[i]);
        }
      }
    });
  }
   */


  /*
  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1; // Compensate for the removal
    }

    setState(() {
      final itemsBox = Hive.box<Excerpt>('excerpts');
      final Excerpt oldItem = itemsBox.getAt(oldIndex)!;
      final Excerpt newItem = itemsBox.getAt(newIndex)!;

      // Create new instances with the same properties but swapped orders
      final updatedOldItem = Excerpt(
        title: oldItem.title,
        mallets: oldItem.mallets,
        selected: oldItem.selected,
      );
      final updatedNewItem = Excerpt(
        title: newItem.title,
        mallets: newItem.mallets,
        selected: newItem.selected,
      );

      // Update the Hive box
      itemsBox.putAt(oldIndex, updatedNewItem);
      itemsBox.putAt(newIndex, updatedOldItem);
    });
  }
   */




  void _updateFabVisibility({bool forceShow = false}) {
    final isListScrollable =
        _scrollController.position.maxScrollExtent -
            _scrollController.position.minScrollExtent >
            1.0;

    if (!isListScrollable || forceShow) {
      if (!_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    } else {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse &&
          _scrollController.position.atEdge == false) {
        if (_showFab) {
          setState(() {
            _showFab = false;
          });
        }
      } else if ((_scrollController.position.atEdge && _scrollController.position.pixels == 0) && !_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    }
  }

  void _showAddExcerptDialog(BuildContext context) {
    final titleController = TextEditingController();
    final malletsController = TextEditingController();
    List<String> mallets = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          void addMallet() {
            final mallet = malletsController.text.trim();
            if (mallet.isNotEmpty) {
              mallets.add(mallet);
              malletsController.clear();
              setState(() {});
            }
          }

          void removeMallet(int index) {
            mallets.removeAt(index);
            setState(() {});
          }

          void addExcerpt() {
            final title = titleController.text;
            final excerpt = Excerpt(title: title, mallets: mallets);
            _excerptsBox.add(excerpt);
            _updateFabVisibility();
            Navigator.of(context).pop();
          }

          return AlertDialog(
            title: const Text('Add Excerpt'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  for (int i = 0; i < mallets.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: Text(mallets[i]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeMallet(i),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: malletsController,
                          decoration: const InputDecoration(
                            hintText: 'Mallet/Stick/Instrument',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: addMallet,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Add'),
                onPressed: addExcerpt,
              ),
            ],
          );
        });
      },
    );
  }

  List<String> _getSelectedMallets() {
    final selectedExcerpts = _excerptsBox.values.where((excerpt) =>
    excerpt.selected).toList();
    final selectedMallets = <String>{};
    for (final excerpt in selectedExcerpts) {
      for (final mallet in excerpt.mallets) {
        if (mallet != '') {
          selectedMallets.add(mallet);
        }
      }
    }
    return selectedMallets.toList();
  }

  void _showDeleteExcerptsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Selected Excerpts'),
          content: const Text(
              'Are you sure you want to delete the selected excerpts?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                final selectedExcerpts = _excerptsBox.values.where((
                    excerpt) => excerpt.selected).toList();
                for (final excerpt in selectedExcerpts) {
                  _excerptsBox.delete(excerpt.key);
                }
                _updateFabVisibility(forceShow: true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _selectedExcerpts = _getSelectedMallets().cast<Excerpt>();
      });
    });
  }

  void _showEditExcerptsDialog(BuildContext context) {
    final selectedExcerpts = _excerptsBox.values.where((excerpt) => excerpt.selected).toList();

    if (selectedExcerpts.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Excerpt Selected'),
            content: const Text('Please select an excerpt to edit.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }

    if (selectedExcerpts.length > 1) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Multiple Excerpts Selected'),
            content: const Text('Please select only one excerpt to edit.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }

    Excerpt selectedExcerpt = selectedExcerpts.first;
    final titleController = TextEditingController(text: selectedExcerpt.title);
    final malletsController = TextEditingController();
    List<String> mallets = List<String>.from(selectedExcerpt.mallets);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          void addMallet() {
            final mallet = malletsController.text.trim();
            if (mallet.isNotEmpty) {
              mallets.add(mallet);
              malletsController.clear();
              setState(() {});
            }
          }

          void removeMallet(int index) {
            mallets.removeAt(index);
            setState(() {});
          }

          void updateExcerpt() {
            final title = titleController.text;
            final updatedExcerpt = Excerpt(title: title, mallets: mallets);
            _excerptsBox.put(selectedExcerpt.key, updatedExcerpt);
            Navigator.of(context).pop();
          }

          return AlertDialog(
            title: const Text('Edit Excerpt'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  for (int i = 0; i < mallets.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: Text(mallets[i]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeMallet(i),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: malletsController,
                          decoration: const InputDecoration(
                            hintText: 'Mallet/Stick/Instrument',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: addMallet,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: updateExcerpt,
              ),
            ],
          );
        });
      },
    );
  }



}



