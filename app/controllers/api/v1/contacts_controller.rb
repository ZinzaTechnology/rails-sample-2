class Api::V1::ContactsController < Api::BaseController
  def create
    @contact = Contact.new(contact_params)
    @contact.save!
    # SenderMailer.contact(@contact).deliver
    json_response
  end

  private

  def contact_params
    params.permit(:content, :email, :name, :status)
  end
end
