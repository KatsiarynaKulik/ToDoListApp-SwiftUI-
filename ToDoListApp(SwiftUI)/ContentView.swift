//
//  ContentView.swift
//  ToDoListApp(SwiftUI)
//
//  Created by Екатерина  on 30.03.26.
//

import SwiftUI
import Observation

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool
}

@Observable
class TaskViewModel {
    var tasks: [Task] = []
    func addTask(title: String) {
        tasks.append(Task(name: title, isCompleted: false))
    }

    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)

    }
}

struct ContentView: View {
    @State private var viewModel = TaskViewModel()
    @State private var newTaskTitle: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    TextField("Enter new Task", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        guard !newTaskTitle.isEmpty else { return }
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.borderless)
                    .tint(.blue)
                }
                .padding()

                List {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Text(task.name)
                                .strikethrough(task.isCompleted)
                                .foregroundStyle(task.isCompleted ? .gray : .primary)
                            Spacer()
                            Button {
                                viewModel.toggleCompletion(for: task)
                            } label: {
                                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "circle")
                            }
                            .buttonStyle(.borderless)
                            .tint(task.isCompleted ? .green : .gray)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
            }
            .navigationTitle("ToDo List")
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    ContentView()
}
