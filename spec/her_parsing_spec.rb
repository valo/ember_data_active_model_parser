require 'spec_helper'
require 'her'
require 'active_support/core_ext/object/json'

class Project
  include Her::Model

  parse_root_in_json true, format: :active_model_serializers

  has_many :tasks
  has_one :organization
end

class Task
  include Her::Model

  parse_root_in_json true, format: :active_model_serializers
end

class Organization
  include Her::Model

  parse_root_in_json true, format: :active_model_serializers
end


describe "Parsing" do
  let(:tasks) do
    [{
      id: 1,
      name: "Milk",
    },
    {
      id: 2,
      name: "Bread"
    },
    {
      id: 3,
      name: "Butter"
    }]
  end

  let(:organizations) do
    [{
      id: 1,
      name: "ACME Inc."
    }]
  end

  let(:project_response) do
    {
      project: { id: 1, name: "Shop list", task_ids: [1,2,3], organization_id: 1 },
      tasks: tasks,
      organizations: organizations
    }.to_json
  end

  before do
    stub_api_for(Project) do |stub|
      stub.get("/projects/1") { |env| [200, {}, project_response] }
    end
    stub_api_for(Organization) { }
    stub_api_for(Task) { }
  end

  describe :find do
    let(:project) { Project.find(1) }

    it "has an array of tasks" do
      expect(project.tasks).to be_an(Array)
    end

    it "has the correct number of tasks" do
      expect(project.tasks.length).to eq(tasks.length)
    end

    it "has an organization" do
      expect(project.organization).to be_an(Organization)
    end

    it "assigns the correct organization" do
      expect(project.organization.id).to eq(organizations[0][:id])
    end
  end
end
