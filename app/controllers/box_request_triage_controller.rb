class BoxRequestTriageController < ApplicationController

  def create
    if request_params.empty?
      head :unprocessable_entity
      return
    end

    # Rails.logger.warn request_params
    @payload = request_params
    requester = Requester.new

    [:first_name,
     :last_name,
     :email,
     :phone,
     :street_address,
     :city,
     :state,
     :zip,
     :ok_to_email,
     :ok_to_text,
     :ok_to_call,
     :ok_to_mail].each do |requester_attribute|
      requester.update(requester_attribute => @payload[requester_attribute])
    end

    requester.underage = @payload[:is_underage]
    requester.save!

    box_request = requester.box_requests.build

    [
      :is_interested_in_counseling_services,
      :is_interested_in_health_services,
      :is_safe,
      :question_re_affect,
      :question_re_current_situation,
      :question_re_if_not_self_completed,
      :question_re_referral_source,
      :summary,
    ].each do |box_request_attribute|
      box_request.update(box_request_attribute => @payload[box_request_attribute])
    end

    box_request.save!

  end

  private

  def request_params
    params.require(:boxRequest)
  end
end