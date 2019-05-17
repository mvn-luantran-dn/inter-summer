module Common
  module Const
    module TimerStatus
      ON  = 'on'.freeze
      OFF = 'off'.freeze
    end

    module ProductStatus
      SELLING   = 'selling'.freeze
      UNSELLING = 'unselling'.freeze
    end

    module AuctionStatus
      RUNNING  = 'running'.freeze
      FINISHED = 'finished'.freeze

      STATUS = ['running', 'finished'].freeze
    end
  end
end
