class CommentsController < ApplicationController
    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params)
        @comment.user_id = current_user.id
        @comment.save
        redirect_back(fallback_location: posts_path)
    end

    def destroy
        @comment = current_user.comments.find_by(id: params[:id])
        @comment.destroy
        flash[:success] = 'コメントを削除しました'
        redirect_back(fallback_location: posts_path)
    end

    private
    def comment_params
        params.require(:comment).permit(:content)
    end
end
