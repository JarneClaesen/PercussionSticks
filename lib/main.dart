import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percussion_mallets/settings_page.dart';
import 'package:percussion_mallets/widgets/PanelContent.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'excerpt.dart';

//todo: hide fab not working

void main() async {
  // Initialize Hive
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ExcerptSchema],
    directory: dir.path,
  );

  runApp(MyApp(isar: isar));
}

Color brandColor = Colors.deepPurple;

class MyApp extends StatelessWidget {
  final Isar isar;

  MyApp({required this.isar});

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
            home: ExcerptsPage(isar: isar),
          );
        }
    );
  }
}

class ExcerptsPage extends StatefulWidget {
  final Isar isar;

  const ExcerptsPage({super.key, required this.isar});

  @override
  _ExcerptsPageState createState() => _ExcerptsPageState(isar);
}


class _ExcerptsPageState extends State<ExcerptsPage> {
  final Isar isar;
  _ExcerptsPageState(this.isar);
  List<Excerpt> _selectedExcerpts = [];

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerFab = ScrollController();
  bool _showFab = true;

  final PanelController _panelController = PanelController();
  double _fabPadding = 80.0;


  @override
  void initState() {
    super.initState();
    _scrollControllerFab.addListener(() {
      _updateFabVisibility();
    });
    //_updateFabVisibility();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerFab.dispose();
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
                MaterialPageRoute(builder: (context) => SettingsPage(isar: isar)),
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
        controller: _panelController,
        color: Theme.of(context).colorScheme.surface,
        onPanelSlide: (position) {
          setState(() {
            _fabPadding = position == 1.0 ? 0.0 : 80.0;
          });
        },
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        minHeight: 80,
        maxHeight: MediaQuery.of(context).size.height / 1.3,
        panel: Column(
          children: [
            SizedBox(height: 12), // Space for the handle
            Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: 12), // Additional space
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _getSelectedMallets(),
                builder: (context, snapshot) {
                  bool isPanelFullyOpen = _panelController.panelPosition == 1.0;

                  if (snapshot.hasData) {
                    return NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {
                        if (notification.direction == ScrollDirection.forward &&
                            _panelController.panelPosition == 1.0 &&
                            _scrollController.offset <= 0) {
                          _panelController.close();
                        }
                        return true;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: CustomScrollPhysics(isScrollable: isPanelFullyOpen),
                        padding: const EdgeInsets.only(top: 20, bottom: 25, left: 25, right: 25),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              snapshot.data![index],
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container when data is not available
                  }
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Excerpt>>(
          future: isar.excerpts.where().findAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final excerpt = snapshot.data![index];
                  return CheckboxListTile(
                    title: Text(excerpt.title),
                    subtitle: Text(excerpt.mallets.join(', ')),
                    value: excerpt.selected,
                    onChanged: (value) {
                      setState(() {
                        excerpt.selected = value ?? false;
                        isar.writeTxn(() async {
                          await isar.excerpts.put(excerpt);
                        });
                      });
                    },
                  );
                },
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 5.1),
              );
            } else {
              return Container(); // Return an empty container when data is not available
            }
          },
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
      ),
    );
  }



  void _updateFabVisibility({bool forceShow = false}) {
    final isListScrollable =
        _scrollControllerFab.position.maxScrollExtent -
            _scrollControllerFab.position.minScrollExtent >
            1.0;

    if (!isListScrollable || forceShow) {
      if (!_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    } else {
      if (_scrollControllerFab.position.userScrollDirection == ScrollDirection.reverse &&
          _scrollControllerFab.position.atEdge == false) {
        if (_showFab) {
          setState(() {
            _showFab = false;
          });
        }
      } else if ((_scrollControllerFab.position.atEdge && _scrollControllerFab.position.pixels == 0) && !_showFab) {
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

          void addExcerpt() async {
            final title = titleController.text;
            final excerpt = Excerpt()..title = title..mallets = mallets..selected = false;

            await isar.writeTxn(() async {
              await isar.excerpts.put(excerpt);
            });

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


  Future<List<String>> _getSelectedMallets() async {
    final selectedExcerpts = await isar.excerpts.filter().selectedEqualTo(true).findAll();
    final selectedMallets = <String>{};
    for (final excerpt in selectedExcerpts) {
      for (final mallet in excerpt.mallets) {
        if (mallet.isNotEmpty) {
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
          content: const Text('Are you sure you want to delete the selected excerpts?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                final selectedExcerpts = await isar.excerpts.filter().selectedEqualTo(true).findAll();
                await isar.writeTxn(() async {
                  for (final excerpt in selectedExcerpts) {
                    await isar.excerpts.delete(excerpt.id);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) => setState(() {}));
  }


  void _showEditExcerptsDialog(BuildContext context) async {
    final selectedExcerpts = await isar.excerpts.filter().selectedEqualTo(true).findAll();

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

          void updateExcerpt() async {
            final title = titleController.text;
            final updatedExcerpt = selectedExcerpt..title = title..mallets = mallets;

            await isar.writeTxn(() async {
              await isar.excerpts.put(updatedExcerpt);
            });

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




