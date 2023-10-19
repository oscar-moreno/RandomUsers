import SwiftUI

struct UserItemListView: View {
    let user: User
    
    var body: some View {
        HStack {
            if let imageUrl = URL(string: user.picture.thumbnail) {
                AsyncImage(url: imageUrl)
                    .cornerRadius(20)
                    .scaledToFit()
            } else {
                Image("user-placeholder")
                    .resizable()
                    .cornerRadius(20)
                    .scaledToFit()
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
        UserItemListView(user: User.exampleToPreview())
    }
}
