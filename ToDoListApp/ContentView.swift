//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Ilona on 4/23/25.
//

import SwiftUI
import Observation

struct Task : Identifiable {
    let id = UUID()
    var title: String
    var isComlited: Bool
}

@Observable
class TaskViewModel {
    var tasks : [Task] = []
    
    func addTask(title: String) {
        tasks.append(Task(title: title, isComlited: false))
    }
    
    func toggleComplition(for task: Task) {
        if let index = tasks.firstIndex(where: {$0.id == task.id} ) {
                tasks[index].isComlited.toggle()
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
        NavigationStack{
            VStack {
                HStack {
                    TextField("Enter task name...", text: $newTaskTitle).textFieldStyle(.roundedBorder)
                    
                    Button {
                        guard !newTaskTitle.isEmpty else { return }
                        
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.title2)
                    }
                    .buttonStyle(.borderless)
                    .tint(.blue)
                }
                .padding()
                
                List {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Text(task.title)
                                .strikethrough(task.isComlited)
                                .foregroundStyle(task.isComlited ? .gray : .primary)
                            Spacer()
                            Button {
                                viewModel.toggleComplition(for: task)
                            } label: {
                                Image(systemName: task.isComlited ? "checkmark.circle.fill" : "circle").font(.title2)
                            }
                            .buttonStyle(.borderless)
                            .tint(task.isComlited ? .green : .gray)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
            }
            .navigationTitle("ToDo List")
            .toolbar{
                EditButton()
            }
        }
    }
}

#Preview {
    ContentView()
}
