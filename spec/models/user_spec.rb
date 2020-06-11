require 'rails_helper'

describe User, type: :model do
    describe 'validation' do
        context '成功する場合' do
            it '全ての項目が埋められた場合' do
                user = create(:user)
                expect(user).to be_valid
            end
            it '必須項目のみ埋められた場合' do
                user = User.create(
                    name:'owner',
                    email:'owner@example.com',
                    password:'password',
                    password_confirmation:'password',
                    job:'owner',
                    sex:'man'
                )
                expect(user).to be_valid
            end
        end
        context '失敗する場合' do
            it 'nameが未記入' do
                user = User.create(
                    email:'owner@example.com',
                    password:'password',
                    password_confirmation:'password',
                    job:'owner',
                    sex:'man'
                )
                expect(user).to_not be_valid
            end
            it 'emailが未記入' do
                user = User.create(
                    name:'owner',
                    password:'password',
                    password_confirmation:'password',
                    job:'owner',
                    sex:'man'
                )
                expect(user).to_not be_valid
            end
            it 'passwordが未記入' do
                user = User.create(
                    name:'owner',
                    email:'owner@example.com',
                    password_confirmation:'password',
                    job:'owner',
                    sex:'man'
                )
                expect(user).to_not be_valid
            end
            it 'jobが未記入' do
                user = User.create(
                    name:'owner',
                    email:'owner@example.com',
                    password:'password',
                    password_confirmation:'password',
                    sex:'man'
                )
                expect(user).to_not be_valid
            end
            it 'sexが未記入' do
                user = User.create(
                    name:'owner',
                    email:'owner@example.com',
                    password:'password',
                    password_confirmation:'password',
                    job:'owner',
                )
                expect(user).to_not be_valid
            end
        end
    end
    describe 'already_liked?' do
        before do
            @user1 = create(:user)
            @user2 = create(:user)
            @user3 = create(:user)
            @post = create(:post, user:@user1)
        end
        context '成功する場合' do
            it 'まだlikeされていないことを確認' do
                expect(@user2.already_liked?(@post)).to be false
            end
            it 'likeができたかの確認' do
                Like.create(post_id: @post.id, user_id: @user2.id)
                expect(@user2.already_liked?(@post)).to be true
            end
        end
        context '失敗する場合' do
            it 'user2がlikeをしたが、user3はlikeをしていないことを確認' do
                Like.create(post_id: @post.id, user_id: @user2.id)
                expect(@user3.already_liked?(@post)).to be false
            end
        end
    end
    describe 'follow機能' do
        before do
            @user1 = create(:user)
            @user2 = create(:user)
            @user3 = create(:user)
        end
        describe 'following?' do
            context '成功する場合' do
                it 'フォローしている人がいる場合' do
                    @user1.follow!(@user2)
                    expect(@user1.following?(@user2)).to be_truthy
                end
            end
            context '失敗する場合' do
                it 'フォローしている人がいない場合' do
                    @user1.follow!(@user2)
                    expect(@user3.following?(@user2)).to be_falsey
                end
            end
        end
        describe 'follow!' do
            context '成功する場合' do
                it '@user1が@user2をフォローできたことを確認' do
                    @user1.follow!(@user2)
                    expect(@user1.following_ids).to include (@user2.id)
                end
            end
            context '失敗する場合' do
                it '@user1が@user2をフォローしたが、@user2はフォローしていないことを確認' do
                    @user1.follow!(@user2)
                    expect(@user2.following_ids).to_not include (@user1.id)
                end
            end    
        end
        describe 'unfollow!' do
            context '成功する場合' do
                it '@user1が@user2のフォローを解除' do
                    @user1.follow!(@user2)
                    @user1.unfollow!(@user2)
                    expect(@user1.following_ids).to_not include (@user2.id)
                end
            end
            context '失敗する場合' do
                it 'フォローしていないのに解除しようとする' do
                    expect{ @user1.unfollow!(@user2) }.to raise_error
                end
            end
        end
    end
end