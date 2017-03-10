class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  
  def index
    @payments = Payment.where("bill_id" => params[:bill_id]).all
    @results = Array.new
    @payments.each do |x|
      @results << {"id" => x.id, "user_name" => User.find_by_id(x.user_id).name, "paid_amount" => x.paid_amount}
    end
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to :back, notice: 'Payment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def split_the_bills
    @payments_made = Payment.where("bill_id" => params[:bill_id]).all
    @total_amount_paid_by_friends = @payments_made.sum(:paid_amount)
    @bill_total_amount = Bill.find_by_id(params[:bill_id]).total_amount
    get_creditor_and_debtor
    get_the_final_results 
    get_payers_names
  end

   def get_creditor_and_debtor
    @debtor_hash = Hash.new
    @creditor_hash = Hash.new
      if @total_amount_paid_by_friends.equal?(@bill_total_amount)
        per_head_bill = @bill_total_amount.to_f / @payments_made.count
        @payments_made.each do |pay|
          calculated_amount = per_head_bill - pay.paid_amount
          if calculated_amount > 0
            @debtor_hash["#{pay.user_id}"] = calculated_amount
          elsif calculated_amount == 0
            @creditor_hash["#{pay.user_id}"] = calculated_amount
          else
            @creditor_hash["#{pay.user_id}"] = -calculated_amount
          end
        end
      end
  end

  def get_the_final_results
    @results_set = Array.new
    @new_debtor_hash = Hash.new
    @new_creditor_hash = Hash.new
    while !@debtor_hash.empty? and !@creditor_hash.empty? do
      @debtor_hash.each do |x, y|
        @creditor_hash.each do |u, v|
          if y >= v
            @new_debtor_hash[x] = y - v
            @debtor_hash.delete(x)
            @debtor_hash = @new_debtor_hash.merge(@debtor_hash)
            @results_set << {"from" => x, "pay" => v, "to" => u }
            @creditor_hash.delete(u)
          else
            @new_creditor_hash[u] = v - y
            @creditor_hash.delete(u)
            @creditor_hash = @new_creditor_hash.merge(@creditor_hash)
            @results_set << {"from" => x, "pay" => y, "to" => u}
            @debtor_hash.delete(x)
          end    
        end
      end
    end
  end

  def get_payers_names
    @results = Array.new
    @results_set.each do |x|
        payer_user_name = User.find_by_id(x["from"]).name
        receiver_user_name = User.find_by_id(x["to"]).name
        if x["pay"] != 0
          @results << {"from" => payer_user_name, "pay" => x["pay"], "to" => receiver_user_name} 
        end
      end
  end

  private
    
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def payment_params
      params.require(:payment).permit(:user_id, :bill_id, :paid_amount)
    end
end
