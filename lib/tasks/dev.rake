if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:reset" do
      include FactoryBot::Syntax::Methods

      def sometimes?
        rand(4) == 1
      end

      def version_params_and_history(member)
        request_id = SecureRandom.uuid

        PaperTrail.request(
          { whodunnit: member.id, controller_info: { request_id: request_id } },
        ) { yield }
        History.create_for_request(request_id)
      end

      def update_issue_with_history(issue, member)
        version_params_and_history(member) do
          parent_id =
            if sometimes?
              Issue.parentable_issues(issue).last&.id
            else
              issue.parent&.id
            end

          description =
            if sometimes?
              issue.description.split("\n\n\n").tap do |paragraphs|
                paragraphs[rand(paragraphs.count)] = Faker::Markdown.random
              end.join("\n\n\n")
            else
              issue.description
            end

          subject =
            if sometimes?
              issue.subject.split(" ").tap do |words|
                words[rand(words.count)] = Faker::Lorem.word
              end.join(" ")
            else
              issue.subject
            end

          assignee_id =
            if sometimes?
              issue.project.project_members.sample.id
            else
              issue.assignee_id
            end

          due_at = sometimes? ? rand(1..30).days.from_now : issue.due_at

          issue.update(
            parent_id: parent_id,
            description: description,
            subject: subject,
            assignee_id: assignee_id,
            due_at: due_at,
          )
        end
      end

      member =
        Member.create!(
          provider_id: "test@exmaple.com",
          email: "test@exmaple.com",
          provider: "developer",
          name: "Hoge Moge",
        )

      create_list(:project, 10).each do |project|
        project_member =
          create :project_member, owner: true, member: member, project: project

        invitations =
          create_list :invitation, 15, project_member: project_member

        invitations.first(5).each do |invitation|
          Invitation.accept(invitation.token, create(:member))
        end

        30.times do
          # Create a issue with histroy
          request_id = SecureRandom.uuid

          PaperTrail.request(
            {
              whodunnit: member.id, controller_info: { request_id: request_id }
            },
          ) do
            create :issue, project: project
            History.create_for_request(request_id)
          end

          issue = Issue.last

          rand(10).times { update_issue_with_history(issue, member) }
        end
      end
    end
  end
end
