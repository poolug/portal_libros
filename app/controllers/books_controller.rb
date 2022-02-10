class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy reserve not_reserve buy not_buy]
  before_action :authenticate_user!, only: [ :reserve, :destroy, , :buy, :show, :edit]

  # GET /books or /books.json
  def index
    @books_available = Book.where(status: :available)
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
    self.select_status
  end

  # GET /books/1/edit
  def edit
    self.select_status
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def reserve
    respond_to do |format|
      if @book.update!(status: 1, user: current_user)
        sleep 1.seconds
        format.js { render nothing: true, notice: 'El libro fue reservado.' }
      end
    end
  end

  def not_reserve
    respond_to do |format|
      if @book.update!(status: 0, user: nil)
        format.js { render nothing: true, notice: 'El libro ya no está reservado.' }
      end
    end
  end

  def buy
    respond_to do |format|
      if @book.update!(status: 2, user: current_user)
        format.js { render nothing: true, notice: 'El libro fue comprado.' }
      end
    end
  end

  def not_buy
    respond_to do |format|
      if @book.update!(status: 3, user: current_user)
        format.js { render nothing: true }
      end
    end
  end

  def select_status
    @statuses = Book.statuses.keys.to_a
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :status, :code)
    end
end
