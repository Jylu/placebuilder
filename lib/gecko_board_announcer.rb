class GeckoBoardAnnouncer
  @queue = :statistics

  EXCLUDED_COMMUNITIES = %w[
    Raleigh
    Clarkston
    GroveHall
    Akron
    Hinckley
    MissionHill
    GraduateCommons
    HarvardNeighbors
  ]

  def self.perform
    tz = "Eastern Time (US & Canada)"
    dashboard = Leftronic.new(ENV['LEFTRONIC_API_KEY'] || '')
    dashboard.text("Statistics Information", "Update Started", "Began updating at #{DateTime.now.in_time_zone(tz).to_s}")
    dashboard.number("Users on Network", User.count)
    growths = []
    populations = []
    growth_headers = ["Community", "Users", "Wkly Growth", "Penetration", "Posts Per Day"]
    Community.find_each do |community|
      next if EXCLUDED_COMMUNITIES.include? community.slug
      growth = (community.growth_percentage.round(2))
      growth = "DNE" if growth.infinite?
      penetration = community.penetration_percentage.round(2)
      begin
        posts_per_day = ((community.posts.count + community.announcements.count + community.events.count + community.group_posts.count) / (Date.today - community.launch_date.to_date)).to_d.round(2).to_s
      rescue
        posts_per_day = ""
      end
      growths << [community.name, community.users.count, "#{growth}%", "#{penetration.to_s.gsub("-1.0", "0")}%", posts_per_day]
      populations << {
        community.name => community.users.count
      }
    end

    growths = growths.sort_by do |v|
      v[1]
    end.append(growth_headers).reverse
    dashboard.table("Growth by Community", growths)
    dashboard.pie("Population by Community", populations)

    penetrations = Community.all.map { |c| c.penetration_percentage(false) }.reject { |v| v < 0 }
    dashboard.number("Overall Penetration", 100 * penetrations.inject{ |sum, el| sum + el }.to_f / penetrations.size)

    growth_rates = Community.all.map { |c| c.growth_percentage(false) }.reject { |v| v.infinite? }
    dashboard.number("Overall Weekly Growth Rate", 100 * growth_rates.inject{ |sum, el| sum + el }.to_f / growth_rates.size.to_f)

    dashboard.number("Daily Bulletins Sent Today", DailyStatistic.value("daily_bulletins_sent") || 0)
    dashboard.number("Daily Bulletins Opened Today", DailyStatistic.value("daily_bulletins_opened") || 0)
    dashboard.number("Daily Bulletin Open Rate Today", DailyStatistic.value("daily_bulletins_opened").to_f / DailyStatistic.value("daily_bulletins_sent").to_f)
    dashboard.number("Single Post Emails Sent Today", DailyStatistic.value("single_posts_sent") || 0)
    dashboard.number("Single Post Emails Opened Today", DailyStatistic.value("single_posts_opened") || 0)
    dashboard.number("Single Post Email Open Rate Today", DailyStatistic.value("single_posts_opened").to_f / DailyStatistic.value("single_posts_sent").to_f)
    # emails = []
    # Resque.redis.keys("statistics:daily:*_sent").each do |key|
      # email_tag = key.gsub("statistics:daily:", "").gsub("_sent", "")
      # emails << {
        # email_tag => Resque.redis.get(key).to_i
      # }
    # end
    # dashboard.pie("Todays Emails by Tag", emails)
    #
    postings = {}
    [Post, Announcement, GroupPost, Event].each do |klass|
      key = (klass.first.respond_to? :category) ? Proc.new { |obj| obj.category } : Proc.new { |obj| obj.class.name }
      klass.today.each do |item|
        if postings.include? key.call(item)
          postings[key.call(item)] += 1
        else
          postings[key.call(item)] = 1
        end
      end
    end
    posts = []
    postings.each do |k,c|
      posts << {
        k => c
      }
    end
    dashboard.pie("Todays Posts by Category", posts)

    dashboard.number("Active Workers", HerokuResque::WorkerScaler.count("worker"))

    dashboard.number("E-Mails in Queue", Resque.size("notifications"))

    dashboard.text("Statistics Information", "Update Finished", "Finished updating at #{DateTime.now.in_time_zone(tz).to_s}")

    unless Rails.env.production?
      dashboard.text("Statistics Information", "Non-Authoritative Update", "The current update is not from production")
    end
  end
end
