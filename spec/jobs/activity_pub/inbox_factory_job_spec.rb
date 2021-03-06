require 'rails_helper'

RSpec.describe ActivityPub::InboxFactoryJob, type: :job do
  context 'Create Note' do
    let(:body) { file_fixture("inbox_create_note.json").read }
    let(:json) { JSON.parse(body) }
    let(:remote_account) { create(:remote_account) }
    let(:local_account) { create(:federated_account) }

    it 'saves a new federated message' do
      ActivityPub::InboxFactoryJob.new.perform(remote_account, local_account, body)
      message = remote_account.messages.first
      expect(message).to be_present
      expect(message.object_data).to hash_eql(json['object'])
      expect(message.local_account_id).to be_nil
      expect(message.local_message_id).to be_nil
    end
  end
end
