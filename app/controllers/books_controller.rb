class BooksController < ApplicationController
  before_action :ensure_correct_book, only: [:edit, :update]

  def show
    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day # Time.current はconfig/application.rbに設定してあるタイムゾーンを元に現在日時を取得している　#at_end_of_day は1日の終わりを23:59に設定している
    from = (to - 6.day).at_beginning_of_day # at_beginning_of_day　は1日の始まりの時刻を0:00に設定している
    @books = Book.includes(:favorited_users). # ユーザーの情報がfavorited_usersに格納されていて、includesの引数に入れてあげることで、事前にユーザーのデータを読み込ませてあげることができる
      sort { |a, b| # sort {|b,a|なら、いいねの少ない順に投稿を表示
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    if params[:latest]
      @books = Book.latest.page(params[:page])
    elsif params[:old]
      @books = Book.old.page(params[:page])
    elsif params[:star_count]
      @books = Book.star_count.page(params[:page])
    else
      @books = Book.all.page(params[:page])
    end
    @book = Book.new
    # @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render "index"
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search_book
    @book = Book.new
    @books = Book.search(params[:keyword])
  end

  private
    def book_params
      params.require(:book).permit(:title, :body, :star, :category)
    end

    def ensure_correct_book
      @book = Book.find(params[:id])
      unless @book.user == current_user
        redirect_to books_path
      end
    end
end
