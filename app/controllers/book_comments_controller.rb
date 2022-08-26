class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save
    # render :create
    # @book_comment = BookComment.new
  end

  # 同じ画面に戻る（redirect_to request.referer）

  def destroy
    @book = Book.find(params[:book_id])
    BookComment.find(params[:id]).destroy
    # @comment.destroy
  end

  private
    def book_comment_params
      params.require(:book_comment).permit(:comment)
    end
end
