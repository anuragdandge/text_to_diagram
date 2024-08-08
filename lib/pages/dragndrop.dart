// import 'package:flutter/material.dart';
// import 'package:flutter_flowchart/flutter_flowchart.dart';

// class FlowchartApp extends StatefulWidget {
//   @override
//   _FlowchartAppState createState() => _FlowchartAppState();
// }

// class _FlowchartAppState extends State<FlowchartApp> {
//   final List<FlowchartNode> nodes = [
//     FlowchartNode(
//       id: '1',
//       label: 'User adds excel file from webpage',
//       position: Offset(200, 50),
//     ),
//     FlowchartNode(
//       id: '2',
//       label: 'Call Magic API',
//       position: Offset(200, 150),
//     ),
//     // ... add other nodes
//   ];

//   final List<FlowchartEdge> edges = [
//     FlowchartEdge(
//       id: '1-2',
//       fromId: '1',
//       toId: '2',
//     ),
//     // ... add other edges
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Editable Flowchart'),
//       ),
//       body: Flowchart(
//         nodes: nodes,
//         edges: edges,
//         onNodeTap: (node) {
//           // Handle node tap for editing or other actions
//         },
//         onEdgeTap: (edge) {
//           // Handle edge tap for modification
//         },
//         onNodeDrag: (node, offset) {
//           setState(() {
//             node.position = node.position + offset;
//           });
//         },
//       ),
//     );
//   }
// }
