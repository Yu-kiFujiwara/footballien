require 'rails_helper'

describe Post, type: :model do
    before do
        @user = create(:user)
    end
    it 'userが作成されていること' do
        expect(@user).to be_valid
    end
    it 'postが作成されていないことを確認' do
        expect(Post.count).to eq 0
    end
    context '成功する場合' do
        it 'postが作成されたことを確認' do
            @post = create(:post, user:@user)
            expect(@post).to be_valid
        end
    end
    context '失敗する場合' do
        it 'contentが入っていない場合、無効となること' do
            @post = create(:post, user:@user)
            @post.content = nil
            expect(@post).to_not be_valid
        end
        it 'user_idが入っていない場合、無効となること' do
            @post = create(:post, user:@user)
            @post.user_id = nil
            expect(@post).to_not be_valid
        end
    end
end