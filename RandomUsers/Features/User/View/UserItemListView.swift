import SwiftUI

struct UserItemListView: View {
    let user: User
    
    var body: some View {
        HStack {
            ZStack {
                if let imageUrl = URL(string: user.picture.thumbnail) {
                    AsyncImage(url: imageUrl)
                        .cornerRadius(10)
                        .scaledToFit()
                } else {
                    Image(K.Images.userPlaceHolder)
                        .resizable()
                        .cornerRadius(20)
                        .scaledToFit()
                }
                if user.isBlackListed ?? false {
                    Image(systemName: K.Images.blackListMark)
                        .opacity(0.6)
                        .scaleEffect(3.0)
                        .foregroundStyle(.black)
                }
            }
            
            VStack {
                HStack {
                    Text(user.name.first)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(user.name.last)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                Text(user.location.city)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text(user.location.country)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
        }
    }
}


struct UserListItemView_Previews: PreviewProvider {
    static var previews: some View {
        UserItemListView(user: User.exampleToPreview(isBlacklisted: false))
        UserItemListView(user: User.exampleToPreview(isBlacklisted: true))
    }
}
