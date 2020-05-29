require 'rails_helper'

describe PostsController, type: :controller do
    render_views
    let(:user) { create(:user) }
    let(:other_user) { create(:other_user) }
    let(:tweet) { create(:post, user:user) }
    let(:posts){ user.posts }

    # インスタンス変数 post を設定
    before :each do
        instance_variable_set(:@post, tweet)
    end

    describe 'GET#index' do
        context 'ログインできた場合' do
            before do
                login_user(user)
                tweet
            end
            it 'ページの表示を確認' do
                get :index, params: { id: tweet.id }
                expect(response).to be_success
            end
            it 'ログイン後投稿一覧ページが表示されているか' do
                get :index, params: { id: tweet.id }
                expect(response).to have_http_status '200'
            end
        end

        context 'ユーザー登録、ログインしていない場合' do
            before do
                user
            end
            it 'レスポンスのステータスが302であることを確認' do
                get :index
                expect(response).to have_http_status "302"
            end
            it 'ユーザー登録画面へ遷移' do
                get :index
                expect(response).to redirect_to ("/users/sign_in")
            end
        end
    end

    describe 'GET#new' do
        context 'ログイン後投稿画面へ遷移' do
            before do
                login_user(user)
            end
            it '投稿作成画面' do
                get :new
                expect(response).to render_template :new
            end
            it '投稿作成を確認' do
                get :new
                expect(@post).to be_valid
            end
        end
        context 'ログインしていない場合' do
            before do
                user
            end
            it 'レスポンスのステータスが302であることを確認' do
                get :new
                expect(response).to have_http_status "302"
            end
            it 'ログイン画面を表示' do
                get :new
                expect(response).to redirect_to ("/users/sign_in")
            end
        end
    end

    describe 'POST#create' do
        context 'ログイン後、postを作成した場合' do
            before do
                login_user(user)
            end
            let(:params){ { content: '新規投稿' } }
            context 'contentが有効である場合' do
                it '投稿をデータベースに保存' do
                    expect{ post :create, params: { post: params } }.to change{ Post.count }.by(1)
                end
                it "content:'新規投稿'の投稿の保存を確認" do
                    post :create, params: { post: params }
                    expect(controller.instance_variable_get("@post").content).to eq '新規投稿'
                end
                it "user_idを投稿に保存できていることを確認" do
                    post :create, params: { post: params }
                    expect(controller.instance_variable_get("@post").user_id).to eq user.id
                end
                it '投稿保存後、一覧ページへ遷移' do
                    post :create, params: { post: params }
                    expect(response).to redirect_to ("/posts")
                end
            end
            context 'content:nilで無効の場合' do
                it "content:nilの場合、保存されない" do
                    expect{ post :create, params: { post: { content: nil } } }.to change{ Post.count }.by(0)
                end
                it '投稿作成ページへリダイレクト' do
                    post :create, params: { post: { content: nil } }
                    expect(response).to redirect_to ("/posts/new")
                end
            end
        end
        context 'ログインしていない場合' do
            before do
                user
            end
            let(:params){ '新規投稿' }
            it 'レスポンスのステータスが302であることを確認' do
                post :create, params: { post: params }
                expect(response).to have_http_status "302"
            end
            it 'ログインページへ遷移' do
                post :create, params: { post: params }
                expect(response).to redirect_to ("/users/sign_in")
            end
        end
    end

    describe 'GET#show' do
        context 'ログイン後、詳細画面を表示' do
            before do
                login_user(user)
                tweet
            end
            it '詳細画面を表示' do
                get :show, params: { id: tweet.id }
                expect(response).to render_template :show
            end
            it '200レスポンスが返ってきているか' do
                get :show, params: { id: tweet.id }
                expect(response).to have_http_status "200"
            end
        end
        context 'ログインしていない場合' do
            before do
                user
            end
            it 'レスポンスのステータスが302であることを確認' do
                get :show, params: { id: tweet.id }
                expect(response).to have_http_status "302"
            end
            it 'ログインページへ遷移' do
                get :show, params: { id: tweet.id }
                expect(response).to redirect_to ("/users/sign_in")
            end
        end
    end

    describe 'GET#edit' do
        context 'ログイン後、編集画面を表示' do
            before do
                login_user(user)
                tweet
            end
            it '編集画面を表示' do
                get :edit, params: { id: tweet.id }
                expect(response).to render_template :edit
            end
            it '200レスポンスが返ってきているか' do
                get :edit, params: { id: tweet.id }
                expect(response).to have_http_status "200"
            end
        end
        context 'ログインしていない場合' do
            before do
                user
            end
            it 'レスポンスのステータスが302であることを確認' do
                get :edit, params: { id: tweet.id }
                expect(response).to have_http_status "302"
            end
            it 'ログインページへ遷移' do
                get :edit, params: { id: tweet.id }
                expect(response).to redirect_to ("/users/sign_in")
            end
        end
        context '他のユーザーが編集しようとした場合' do
            before do
                tweet
                login_user(other_user)
            end
            it 'レスポンスのステータスが302であることを確認' do
                get :edit, params: { id: tweet.id }
                expect(response).to have_http_status "302"
            end
            it '編集画面を表示せず、一覧ページへ' do
                get :edit, params: { id: tweet.id }
                expect(response).to redirect_to ("/posts")
            end
        end
    end

    describe 'PATCH#update' do
        let(:post_params){ { content: '編集済' } }
        context 'ログイン後、編集画面から更新情報を受け取った場合' do
            before do
                login_user(user)
                tweet
            end
            context 'contentが有効な場合' do
                it '投稿を編集し、保存を確認' do
                    patch :update, params: { id: tweet.id, post: post_params }
                    expect(@post.reload.content).to eq '編集済'
                end
                it '投稿編集したが、投稿数は変化なし' do
                    expect{ patch :update, params: { id: tweet.id, post: post_params } }.to change{ Post.count }.by(0)
                end
                it '一覧画面へ遷移' do
                    patch :update, params: { id: tweet.id, post: post_params }
                    expect(response).to redirect_to ("/posts")
                end
            end
            context 'content:nilで無効な場合' do
                it '投稿を編集するが無効なため更新されないことを確認' do
                    patch :update, params: { id: tweet.id, post: { content: nil } }
                    expect(@post.reload.content).to eq '新規投稿'
                end
                it '編集画面へリダイレクト' do
                    patch :update, params: { id: tweet.id, post: { content: nil } }
                    expect(response).to redirect_to ("/posts/#{@post.id}/edit")
                end
            end
        end
        context 'ログインしていない場合' do
            before do
                user
            end
            it 'レスポンスのステータスが302であることを確認' do
                patch :update, params: { id: tweet.id, post: post_params }
                expect(response).to have_http_status "302"
            end
            it 'ログインページへ遷移' do
                patch :update, params: { id: tweet.id, post: post_params }
                expect(response).to redirect_to ("/users/sign_in")
            end
        end
        context '他のユーザーが編集しようとした場合' do
            before do
                tweet
                login_user(other_user)
            end
            it 'レスポンスのステータスが302であることを確認' do
                patch :update, params: { id: tweet.id, post: post_params }
                expect(response).to have_http_status "302"
            end
            it '投稿を編集するが無効なため更新されないことを確認' do
                patch :update, params: { id: tweet.id, post: post_params }
                expect(@post.reload.content).to eq '新規投稿'
            end
            it '編集画面を表示せず、一覧ページへ' do
                patch :update, params: { id: tweet.id, post: post_params }
                expect(response).to redirect_to ("/posts")
            end
        end
    end

    describe 'DELETE#destroy' do
        context 'ログイン後削除を実行した場合' do
            before do
                login_user(user)
                tweet
            end
            it '投稿を削除' do
                expect{ delete :destroy, params: { id:tweet.id } }.to change{ Post.count }.by(-1)
            end
            it '削除後、ページを表示' do
                delete :destroy, params: { id: tweet.id }
                expect(response).to redirect_to ("/posts")
            end
        end
        context 'ログインしていない場合' do
            before do
                user
            end
            it 'レスポンスのステータスが302であることを確認' do
                get :destroy, params: { id: tweet.id }
                expect(response).to have_http_status "302"
            end
            it 'ログインページへ遷移' do
                get :destroy, params: { id: tweet.id }
                expect(response).to redirect_to ("/users/sign_in")
            end
        end
        context '他のユーザーが削除しようとした場合' do
            before do
                tweet
                login_user(other_user)
            end
            it 'レスポンスのステータスが302であることを確認' do
                get :destroy, params: { id: tweet.id }
                expect(response).to have_http_status "302"
            end
            it '投稿が削除されないことを確認' do
                expect{ delete :destroy, params: { id:tweet.id } }.to change{ Post.count }.by(0)
            end
            it '編集画面を表示せず、一覧ページへ' do
                get :destroy, params: { id: tweet.id }
                expect(response).to redirect_to ("/posts")
            end
        end
    end
end