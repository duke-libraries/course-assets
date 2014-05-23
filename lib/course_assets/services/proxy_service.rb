module CourseAssets
  module Services
    class ProxyService
      
      def self.list(user = nil)
        user_proxies = []
        if user.present?
          proxied_user = user.is_a?(User) ? user : User.find_by_user_key(user)
          unless proxied_user.present?
            raise ArgumentError, I18n.t("course_assets.user_not_found", user_key: user)
          end
          user_proxies << { user: proxied_user, proxies: proxied_user.can_receive_deposits_from }
        else
          User.all.each do |user|
            if user.can_receive_deposits_from.present?
              user_proxies << { user: user, proxies: user.can_receive_deposits_from }
            end
          end
        end
        user_proxies
      end
      
      def self.add(user, proxy)
        raise ArgumentError, I18n.t("course_assets.argument_missing", argument: "user") unless user.present?
        raise ArgumentError, I18n.t("course_assets.argument_missing", argument: "proxy") unless proxy.present?
        proxied_user = user.is_a?(User) ? user : User.find_by_user_key(user)
        unless proxied_user.present?
          raise ArgumentError, I18n.t("course_assets.user_not_found", user_key: user)
        end
        proxy_user = proxy.is_a?(User) ? proxy : User.find_by_user_key(proxy)
        unless proxy_user.present?
          raise ArgumentError, I18n.t("course_assets.user_not_found", user_key: proxy)
        end
        if proxied_user.can_receive_deposits_from.include?(proxy_user)
          return false
        else
          proxied_user.can_receive_deposits_from << proxy_user
          proxied_user.save
        end
      end

      def self.remove(user, proxy)
        raise ArgumentError, I18n.t("course_assets.argument_missing", argument: "user") unless user.present?
        raise ArgumentError, I18n.t("course_assets.argument_missing", argument: "proxy") unless proxy.present?        
        proxied_user = user.is_a?(User) ? user : User.find_by_user_key(user)
        unless proxied_user.present?
          raise ArgumentError, I18n.t("course_assets.user_not_found", user_key: user)
        end
        proxy_user = proxy.is_a?(User) ? proxy : User.find_by_user_key(proxy)
        unless proxy_user.present?
          raise ArgumentError, I18n.t("course_assets.user_not_found", user_key: proxy)
        end
        if proxied_user.can_receive_deposits_from.include?(proxy_user)
          proxied_user.can_receive_deposits_from.delete(proxy_user)
          proxied_user.save
        else
          return false
        end
      end
    end
  end
end