//
//  CoreDataView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/27.
//

import SwiftUI
import CoreData

struct CoreDataView: View {
    var body: some View {
        Text("Core Data")
            .onAppear {
                func1()
            }
    }
    
    func func1() {
        PersistenceController.shared.parseEntities()
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
    
    private func createBook() {
        let context = PersistenceController.shared.container.viewContext
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book",
                                                        into: context) as! Book
        book.name = "三体"
        book.isbm = "isbm1"
        book.page = Int32(800)
        if context.hasChanges {
            do {
                try context.save()
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
