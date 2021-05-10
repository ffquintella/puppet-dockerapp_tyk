require 'spec_helper'

describe 'dockerapp_tyk' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          version: '1.4.1',
          service_name: 'tyk',
        }
      end

      it { is_expected.to compile }


    end
  end
end
