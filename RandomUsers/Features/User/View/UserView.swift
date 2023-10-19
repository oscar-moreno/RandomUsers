import SwiftUI

struct UserView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack {
                if let imageUrl = URL(string: user.picture.large) {
                    AsyncImage(url: imageUrl)
                        .cornerRadius(20)
                        .scaledToFit()
                        .padding()
                } else {
                    Image("user-placeholder")
                        .cornerRadius(20)
                        .padding()
                }
                HStack {
                    Text(user.name.first)
                    Text(user.name.last)
                }
                .font(.title)
                .bold()
                .padding(10)
                VStack(alignment: .leading, spacing: 2) {
                    UserDataView(userDataTitle: NSLocalizedString("email_title",
                                                                  comment: ""), userDataValue: String(user.email))
                    UserDataView(userDataTitle: NSLocalizedString("phone_title",
                                                                  comment: ""), userDataValue: String(user.phone))
                    UserDataView(userDataTitle: NSLocalizedString("age_title",
                                                                  comment: ""), userDataValue: String(user.dob.age))
                    UserDataView(userDataTitle: NSLocalizedString("city_title",
                                                                  comment: ""), userDataValue: String(user.location.city))
                    UserDataView(userDataTitle: NSLocalizedString("state_title",
                                                                  comment: ""), userDataValue: String(user.location.state))
                    UserDataView(userDataTitle: NSLocalizedString("country_title",
                                                                  comment: ""), userDataValue: String(user.location.country))
                }
                .padding()
                
                Spacer()
                
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User.exampleToPreview())
    }
}
