//
//  ContentView.swift
//  NavigationBlocks
//
//  Created by Tehya Laughlin on 9/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var blockStyles: [BlockStyle] = []
    
    
    var body: some View {
        TabView {
            BlocksDisplay(blockStyles: $blockStyles, showingAlert: false).tabItem{
                Label("Blocks", systemImage:"person")
            }
            BlocksEdit(blockStyles: $blockStyles).tabItem{
                Label("Edit Blocks", systemImage:"globe")
            }
        }
    }
    
}

struct BlockStyle: Identifiable {
    var radii: [Int]
    var color: Color
    var id: Int{radii[0]}
}

//Blocks Display: as tab 1, displays the squares, as added in edit mode
//@param: array of tuples: array of doubles, color
//@param: bool for button alert
//calls Squares iteratively over the array of tups
//button -> clear all blocks, alert checkpoint, on OK, clear array of tups
struct BlocksDisplay: View {
    
    @Binding var blockStyles: [BlockStyle]
    @State var showingAlert: Bool
    
    
    var body: some View {
        VStack{
            
            Button("Clear All Blocks") {
                showingAlert = true
            }.alert("Are you sure you want to clear your blocks?", isPresented: $showingAlert){
                Button("OK", role: .none) {
                    blockStyles = []
                }
                Button("Cancel", role: .cancel) {}
            }
            
            ForEach($blockStyles){
                BlockStyle in
                
                Squares(radii: BlockStyle.radii, color: BlockStyle.color)
                
            }
            
        }
    }
    
}

//Blocks Edit: as tab 2, displays an edit page for adding blocks. If want to change the radii, click change radii button, sheet pops up with
//@param: array of tups
//toggle -> color
//add changes button, returns to other tab?

struct BlocksEdit: View {
    @Binding var blockStyles: [BlockStyle]
    @State var colorSwitch: Bool = false
    @State var newStyle: BlockStyle = BlockStyle(radii: [],color: Color.blue)
    @State var sheetPres: Bool = false
    @State var radii: [Int] = [0,0,0,0,0]
    @State var seeNew: Bool = false;
    
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Switch Color", isOn: $colorSwitch)
                    .frame(width: 170.0, height: 30.0)
                    .tint(Color.blue)
                
                Button("Radii") {
                    sheetPres = true
                }
                .sheet(isPresented: $sheetPres){
                    
                } content: {
                    Radii(radii: $radii)
                }
                
                Button("Add Blocks"){
                    
                    newStyle.radii = radii
                    newStyle.color = colorSwitch == true ? Color.blue : Color(red: 0.059, green: 0.006, blue: 0.177)
                    blockStyles.append(newStyle)
                    
                    radii = [0,0,0,0,0]
                    colorSwitch = false
                    seeNew = true
                    
                }
                
                if(seeNew){
                    NavigationLink("See the new blocks or go to Blocks Tab"){
                        SeeNewBlocks(blocks: $newStyle, tog: $seeNew)
                    }
                }
            }
        }.navigationTitle("Edit Blocks")
    }
}

//Edit radii: ^
//@param array for doubles
//text field -> 5 doubles to an array of doubles
//another button to save and close
//another button to cancel
struct Radii: View {
    @Binding var radii: [Int]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            
            Stepper(value: $radii[0], in: 0...35, step:5) {
                Text("Border Radius 1: \(radii[0])")
            }
            
            Stepper(value: $radii[1], in: 0...35, step:5) {
                Text("Border Radius 2: \(radii[1])")
            }
            
            Stepper(value: $radii[2], in: 0...35, step:5) {
                Text("Border Radius 3: \(radii[2])")
            }
            
            Stepper(value: $radii[3], in: 0...35, step:5) {
                Text("Border Radius 4: \(radii[3])")
            }
            
            Stepper(value: $radii[4], in: 0...35, step:5) {
                Text("Border Radius 5: \(radii[4])")
            }
            
            
            HStack {
                Button("Cancel") {
                    radii = [0,0,0,0,0]
                    dismiss()
                }
                Spacer()
                Button("Confirm") {
                    dismiss()
                }
            }
        }
    }
}

//See newly added blocks: navigation view to see new blocks adde
//
struct SeeNewBlocks: View{
    @Binding var blocks: BlockStyle
    @Binding var tog: Bool
    
    var body: some View {
        NavigationView{
            VStack(content: {
                Squares(radii: $blocks.radii, color: $blocks.color)
               
            })
           
        } .navigationBarTitle("New Blocks")
    }
}


//Squares: 5 squares in horizontal row
//@param: array of doubles, radius corner size
//@param: color of all blocks
struct Squares: View {
    @Binding var radii: [Int]
    @Binding var color: Color
    
    var body: some View {
        
        HStack{
            RoundedRectangle(cornerRadius: CGFloat(radii[0]))
                    .fill(color)
          
            RoundedRectangle(cornerRadius: CGFloat(radii[1]))
                .fill(color)

            RoundedRectangle(cornerRadius: CGFloat(radii[2]))
                    .fill(color)
            
            RoundedRectangle(cornerRadius: CGFloat(radii[3]))
                    .fill(color)
            
            RoundedRectangle(cornerRadius: CGFloat(radii[4]))
                    .fill(color)
         
        }
        .padding(.horizontal)
        .frame(width: 400.0, height: 70.0)
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
