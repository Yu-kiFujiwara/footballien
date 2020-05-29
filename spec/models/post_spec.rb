require 'rails_helper'

describe Post, type: :model do
    let(:user) { create(:user) }
    let(:post) { create(:post, user:user) }
    it 'userが作成されていること' do
        expect(user).to be_valid
    end
    # it 'contentが入っていれば有効であること' do
    #     user
    #     post = Post.new(content:'新規投稿', user:user)
    #     expect(post.save).to be_truthy
    # end
    # it 'contentが入っていない場合、無効となること' do
    #     user
    #     post = Post.new(content:nil, user:user)
    #     expect(post.save).to be_falsey
    # end
    it 'contentが入っていれば有効となること' do
        expect(post).to be_valid
    end
    it 'contentが入っていない場合、無効となること' do
        post.content = nil
        expect(post).to_not be_valid
    end
    it 'user_idが入っていない場合、無効となること' do
        post.user_id = nil
        expect(post).to_not be_valid
    end
end