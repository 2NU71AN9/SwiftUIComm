//
//  CoreDataView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/27.
//

import SwiftUI
import CoreData

struct CoreDataView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Book.entity(), sortDescriptors: [], animation: .default)
    private var books: FetchedResults <Book>
    
    var body: some View {
        List {
            ForEach(books) { book in
                Text("\(book.name ?? "")")
            }
            Button("添加", action: createBook)
            Button("修改", action: modifyBook)
            Button("删除", action: deleteBook)
        }
        .onAppear {
//            func1()
        }
    }
    
    func func1() {
        parseEntities()
        createBook()
        readBooks()
        modifyBook()
        deleteBook()
    }
}

struct CoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataView()
    }
}

extension CoreDataView {
    
    func parseEntities() {
        let entities = PersistenceController.shared.container.managedObjectModel.entities
        print("Entity count = \(entities.count)\n")
        for entity in entities {
            print("Entity: \(entity.name!)")
            for property in entity.properties {
                print("Property: \(property.name)")
            }
            print("")
        }
    }
    
    private func createBook() {
        
//        let moc = PersistenceController.shared.container.viewContext
//        let book = NSEntityDescription.insertNewObject(forEntityName: "Book",
//                                                        into: moc) as! Book
        
        let book = Book(context: moc)
        book.name = "三体"
        book.isbm = "isbm1"
        book.page = Int32(800)
        if moc.hasChanges {
            do {
                try moc.save()
                print("Insert new book 三体 successful.")
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func readBooks() {
        let context = PersistenceController.shared.container.viewContext
        let fetchBooks = NSFetchRequest<Book>(entityName: "Book")
        do {
            let books = try context.fetch(fetchBooks)
            print("Books count = \(books.count)")
            for book in books {
                print("Book name = \(book.name!)")
            }
        } catch {
            
        }
    }
    
    private func modifyBook() {
        let context = PersistenceController.shared.container.viewContext
        let fetchBooks = NSFetchRequest<Book>(entityName: "Book")
        fetchBooks.predicate = NSPredicate(format: "isbm = \"isbm1\"")
        do {
            let books = try context.fetch(fetchBooks)
            if !books.isEmpty {
                books[0].name = "四体"
                if context.hasChanges {
                    try context.save()
                    print("Update success.")
                }
            }
        } catch {
            
        }
    }
    
    private func deleteBook() {
        let context = PersistenceController.shared.container.viewContext
        let fetchBooks = NSFetchRequest<Book>(entityName: "Book")
        fetchBooks.predicate = NSPredicate(format: "isbm = \"isbm1\"")
        do {
            let books = try context.fetch(fetchBooks)
            for book in books {
                context.delete(book)
            }
            if context.hasChanges {
                try context.save()
            }
        } catch {
            
        }
    }
}
