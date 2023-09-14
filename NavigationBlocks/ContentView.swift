//
//  ContentView.swift
//  NavigationBlocks
//
//  Created by Tehya Laughlin on 9/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var blockStyles: [BlockStyle] = []
    @State var oneStyle: BlockStyle = BlockStyle(radii: [0,0,0,0,0], color: Color.blue)
    
    var body: some View {
        TabView {
            BlocksDisplay(blockStyles: $blockStyles, showingAlert: false).tabItem{
                Label("Blocks", systemImage:"person")
            }
            BlocksEdit(blockStyles: $blockStyles, blockSee: $oneStyle).tabItem{
                Label("Edit Blocks", systemImage:"globe")
            }
        }
    }
}


//Blocks Display: as tab 1, displays the squares, as added in edit mode
//@param: array of BlockStyles
//intialize bool for button alert
//calls Squares iteratively over the array of tups
//button -> clear all blocks, alert checkpoint, on OK, clear array of tups
struct BlocksDisplay: View {
    
    @Binding var blockStyles: [BlockStyle]
    @State var showingAlert: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                
                Button("Clear All Blocks") {
                    showingAlert = true
                }.alert("Are you sure you want to clear your blocks?", isPresented: $showingAlert){
                    Button("OK", role: .none) {
                        blockStyles = []
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .padding(.top, 30)
                
                ScrollView{
                    VStack {
                        ForEach($blockStyles){
                            BlockStyle in
                            
                            Squares(radii: BlockStyle.radii, color: BlockStyle.color)
                            
                        }
                    }
                }
                .frame(height: 500)
                .padding(.top, 30)
            }.navigationTitle("Blocks")
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
    @Binding var blockSee: BlockStyle
    @State var sheetPres: Bool = false
    @State var radii: [Int] = [0,0,0,0,0]
    @State var seeNew: Bool = false;
    @State var color: Color = Color.blue
    
    var body: some View {
        NavigationView {
            VStack {
                
                ColorPicker("Color", selection: $color)
                    .frame(width: 100.0, height: 100.0)
                
                Button("Radii") {
                    sheetPres = true
                }
                .sheet(isPresented: $sheetPres){
                    
                } content: {
                    Radii(radii: $radii)
                }
                
                Button("Add Blocks"){
                    
                    blockSee.radii = radii
                    blockSee.color = color
                    blockStyles.append(blockSee)
                    
                    radii = [0,0,0,0,0]
                    seeNew = true
                    
                }.padding(.top, 30)
                
                if(seeNew){
                    NavigationLink("See the new blocks or go to Blocks Tab"){
                        SeeNewBlocks(blocks: $blockSee, tog: $seeNew)
                    }.padding(.top, 30)
                }
            }.onAppear{
                seeNew = false
                color = Color.blue
               
            }
            .navigationTitle("Edit Blocks")
        }
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
            .frame(width: /*@START_MENU_TOKEN@*/275.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/)
            
            Stepper(value: $radii[1], in: 0...35, step:5) {
                Text("Border Radius 2: \(radii[1])")
            }
            .frame(width: 275.0, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/)
            
            Stepper(value: $radii[2], in: 0...35, step:5) {
                Text("Border Radius 3: \(radii[2])")
            }.frame(width: /*@START_MENU_TOKEN@*/275.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/)
            
            Stepper(value: $radii[3], in: 0...35, step:5) {
                Text("Border Radius 4: \(radii[3])")
            }.frame(width: /*@START_MENU_TOKEN@*/275.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/)
            
            Stepper(value: $radii[4], in: 0...35, step:5) {
                Text("Border Radius 5: \(radii[4])")
            }.frame(width: /*@START_MENU_TOKEN@*/275.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/)
            
            
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
            .frame(width: /*@START_MENU_TOKEN@*/150.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/)
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
