def update obj, name_of
    begin
        obj.add_twitter.save
        puts "Updated #{name_of}"
    rescue
        puts "Failed to update #{name_of}"
    end
    sleep 5
end

task :update_reps do
    reps = Rep.where(['updated_at < ?', 72.hours.ago]).limit(25)
    reps.each{ |r| update r, "#{r.first_name} #{r.last_name}" }
end
task :update_partners do
    partners = Partner.where(['updated_at < ?', 72.hours.ago]).limit(25)
    partners.each{ |p| update p, "#{p.name}" }
end

task :update => :environment do
    Rake::Task["update_reps"].execute
    Rake::Task["update_partners"].execute
end
