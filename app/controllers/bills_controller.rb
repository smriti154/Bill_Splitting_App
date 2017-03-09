class BillsController < ApplicationController
  before_action :set_bill, only: [:destroy]

 
  def index
    @bills = Bill.all
  end

  def new
    @bill = Bill.new
  end

  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to new_bill_path, notice: 'Bill was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
    end
  end

  private

    def set_user
      @bill = Bill.find(params[:id])
    end
  
    def bill_params
      params.require(:bill).permit(:event, :bill_date, :location, :total_amount)
    end
end
