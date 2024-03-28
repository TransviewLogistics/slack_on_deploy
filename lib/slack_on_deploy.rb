require 'slack_on_deploy/version'
require 'slack-notifier'

module SlackOnDeploy
  class Ping
    def initialize(username_json_str, deploy_msg_base, num_seconds_between_pings=120)
      self.slack_pings = Array(JSON.parse(username_json_str))
      self.deploy_msg = "#{deploy_msg_base} #{slack_ping_str}"
      self.num_seconds_between_pings = num_seconds_between_pings
    end

    def send_to(notifier)
      return if last_ping_less_than_n_minutes_ago

      REDIS.set(redis_key, Time.now.to_i)
      notifier.ping(deploy_msg)
    end

    private

    attr_accessor :slack_pings, :deploy_msg, :num_seconds_between_pings

    # Click dropdown next to username when chat is open with them > View full profile > click 3 dots > Copy member ID
    def username_mapping
      {
        'calvin' => 'U02B898JW',
        'damon' => 'UUUEL7SCD',
        'zach' => 'UL7714L84',
        'mike' => 'U0RDXDMU0',
        'scott' => 'U03TPQ6F7SN',
        'juan' => 'U032G9E31GQ',
        'jose' => 'U031URW202Y',
        'fernando' => 'U038C2ZRD2M',
        'nicolas' => 'U036SSXCR6J',
        'dylan' => 'U058Z6Q01M2',
        'franco' => 'U05RDKS16KH',
        'mark' => 'U053NQKBPEJ',
        'joel' => 'U068WUGRNJZ'
      }
    end

    def last_ping_less_than_n_minutes_ago
      return false if num_seconds_between_pings.nil?

      REDIS.get(redis_key).to_i + num_seconds_between_pings > Time.now.to_i
    end

    def redis_key
      'SlackOnDeployLastTime'
    end

    def slack_ping_str
      slack_ids = slack_ids_for_mention

      slack_ids.map { |id| "<@#{id}>" }.join(' ')
    end

    def slack_ids_for_mention
      slack_pings.map do |str_input|
        username_mapping[str_input] || username_mapping[find_user_mapping(str_input)]
      end.compact
    end

    def find_user_mapping(str_input)
      str_input.length.times do |num_chars|
        str = str_input[0..num_chars]
        matches = username_mapping.keys.select do |mapping_name|
          mapping_name =~ /^#{str}/
        end
        return matches[0] if matches.length == 1
      end

      nil
    end
  end
end
