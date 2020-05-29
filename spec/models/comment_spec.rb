require 'rails_helper'

describe Comment, type: :model do
    let(:user) { create(:user) }
    let(:other_user) { create(:other_user) }
    let(:post) { create(:post, user:user) }
    it 'contentが入っていれば有効であること' do
        post
        comment = post.comments.build(content: 'コメント', user: user)
        expect(comment.save).to be_truthy
    end
    it 'contentが入っていない場合、無効となること' do
        post
        comment = post.comments.build(content: nil, user: user)
        expect(comment.save).to be_falsey
    end
    it '投稿者であれば投稿削除できること' do
        post
        comment = post.comments.build(content: 'コメント', user: user)
        comment.save
        expect(comment.destroy).to be_truthy
    end
    it '投稿者でない場合、投稿削除できないこと' do
        post
        comment = post.comments.build(content: 'コメント', user: user)
        comment.save
        other_user
        expect(other_user.comments.destroy).to be_falsey
    end
end