namespace :milestones do
  desc "Generate realistic test external milestones with categories"
  task create_external: :environment do
    require "open-uri"

    puts "🛠️ Creating test external milestones with categories..."

    category_data = {
      "Travel" => { 
        description: "Exploring new places and experiencing different cultures.",
        milestones: ["Visit 3 New Countries", "Go on a Road Trip"]
      },
      "Adventure" => { 
        description: "Exciting and adrenaline-filled experiences.",
        milestones: ["Go Skydiving", "Climb a Mountain"]
      },
      "Fitness" => { 
        description: "Physical health and endurance challenges.",
        milestones: ["Run a Half Marathon", "Complete a 30-Day Fitness Challenge"]
      },
      "Education" => { 
        description: "Expanding knowledge and learning new skills.",
        milestones: ["Read 12 Books This Year", "Learn a New Language"]
      },
      "Career" => { 
        description: "Advancing in your professional life.",
        milestones: ["Get a Promotion", "Start a New Business"]
      },
      "Relationships" => { 
        description: "Building and maintaining strong connections.",
        milestones: ["Plan a Surprise for a Loved One"]
      },
      "Hobbies" => { 
        description: "Developing and exploring personal interests.",
        milestones: ["Learn to Play an Instrument", "Complete a 1000-Piece Puzzle"]
      },
      "Health & Wellness" => { 
        description: "Improving overall well-being.",
        milestones: ["Meditate Daily for 60 Days", "Drink 2L of Water Every Day for a Month"]
      },
      "Personal Growth" => { 
        description: "Self-improvement and mental growth.",
        milestones: ["Write a Short Story", "Keep a Journal for 3 Months"]
      },
      "Achievements" => { 
        description: "Personal or professional accomplishments.",
        milestones: ["Give a Public Speech", "Launch a Personal Blog"]
      },
      "Creativity" => { 
        description: "Artistic and creative pursuits.",
        milestones: ["Start a YouTube Channel", "Paint a Large-Scale Artwork"]
      },
      "Volunteering" => { 
        description: "Giving back to the community.",
        milestones: ["Volunteer for a Local Charity", "Organize a Fundraiser"]
      },
      "Finances" => { 
        description: "Financial stability and money management.",
        milestones: ["Save $1,000 in an Emergency Fund", "Invest in Stocks"]
      },
      "Family" => { 
        description: "Strengthening family bonds.",
        milestones: ["Plan a Family Vacation", "Host a Holiday Dinner"]
      },
      "Home & Lifestyle" => { 
        description: "Enhancing living spaces and lifestyle.",
        milestones: ["Redecorate a Room", "Start a Home Garden"]
      }
    }

    # Create or find categories
    category_records = {}
    category_data.each do |name, data|
      category_records[name] = Category.find_or_create_by!(name: name) do |category|
        category.description = data[:description]
      end
    end

    # Create external milestones
    category_data.each do |category_name, data|
      data[:milestones].each do |milestone_name|
        milestone = Milestone.create!(
          name: milestone_name,
          description: "A goal in the #{category_name} category.",
          private: false,
          user_id: nil, # External milestone
          due_date: Date.today + rand(30..365).days, # Random deadline within a year
          created_at: rand(1..30).days.ago
        )

        # Attach a random image from Picsum
        image_url = "https://picsum.photos/1000"
        downloaded_image = URI.open(image_url)
        milestone.image.attach(io: downloaded_image, filename: "milestone_#{milestone.id}.jpg", content_type: "image/jpeg")

        # Assign category to milestone
        MilestoneCategory.create!(
          milestone: milestone,
          category: category_records[category_name]
        )
      end
    end

    puts "✅ Successfully created external milestones with unique images!"
  end
end
