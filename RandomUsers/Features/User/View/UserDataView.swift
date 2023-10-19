import SwiftUI

struct UserDataView: View {
    let userDataTitle: String
    let userDataValue: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(userDataTitle):")
                .font(.headline)
            
            Text(userDataValue.capitalizeFirst())
                .multilineTextAlignment(.leading)
            
        }
        .textInputAutocapitalization(.sentences)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(2)
    }
}

struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserDataView(userDataTitle: "Title", userDataValue: "location value")
            UserDataView(userDataTitle: "Title 2", userDataValue: "location value 2")
        }
    }
}
