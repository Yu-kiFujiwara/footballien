require 'rails_helper'

describe Post, type: :model do
    let(:user) { create(:user) }
    it 'userが作成されていること' do
        expect(user).to be_valid
    end
    it 'postが作成されていないことを確認' do
        expect(Post.count).to eq 0
    end
    it 'postが作成されたことを確認' do
        post = Post.create(content:'新規投稿', user:user)
        expect(Post.count).to eq 1
    end
    
    it 'contentが入っていれば有効であること' do
        user
        post = user.posts.build(content:'新規投稿', user:user)
        expect(post).to be_valid
    end
    it 'contentが入っていない場合、無効となること' do
        user
        post = user.posts.build(content:nil, user:user)
        expect(post).to_not be_valid
    end
    it 'user_idが入っていない場合、無効となること' do
        post = Post.create(content:'新規投稿', user:nil)
        expect(post).to_not be_valid
    end
end