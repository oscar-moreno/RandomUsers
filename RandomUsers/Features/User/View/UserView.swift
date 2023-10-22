import SwiftUI

struct UserView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    if let imageUrl = URL(string: user.picture.large) {
                        RemoteImage(url: imageUrl)
                            .cornerRadius(20)
                            .scaledToFit()
                            .padding()
                    } else {
                        Image(K.Images.userPlaceHolder)
                            .cornerRadius(20)
                            .padding()
                    }
                    if user.isBlackListed ?? false {
                        Image(systemName:K.Images.blackListMark)
                            .opacity(0.7)
                            .frame(maxWidth: .infinity,alignment: .center)
                            .scaleEffect(7.0)
                            .foregroundStyle(.black)
                    }
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
        UserView(user: User.exampleToPreview(isBlacklisted: false))
        UserView(user: User.exampleToPreview(isBlacklisted: true))
    }
}
