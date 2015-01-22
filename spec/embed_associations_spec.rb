require 'ember_data_active_model_parser'

describe EmberDataActiveModelParser::EmbedAssociations do
  describe "#call" do
    context "with an object with some associations" do
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

      let(:json) do
        {
          project: { id: 1, name: "Shop list", task_ids: [1,2,3] },
          tasks: tasks
        }
      end
      let(:expected_json) do
        {
          project: { id: 1, name: "Shop list", tasks: { tasks: tasks }, task_ids: [1,2,3] },
          tasks: tasks
        }
      end
      let(:embed_associations) { EmberDataActiveModelParser::EmbedAssociations.new(json) }

      it "embeds the objects from the root to the proper parents" do
        expect(embed_associations.call).to eq(expected_json)
      end
    end

    context "with an array of objects with some associations" do
      let(:tasks) do
        [{
          id: 1,
          name: "Milk",
          project_id: projects[0][:id]
        },
        {
          id: 2,
          name: "Bread",
          project_id: projects[0][:id]
        },
        {
          id: 3,
          name: "Butter",
          project_id: projects[1][:id]
        }]
      end

      let(:projects) do
        [{
          id: 1,
          name: "Shop list",
          task_ids: [1,2]
        }, {
          id: 2,
          name: "Other Shop list",
          task_ids: [3]
        }]
      end

      let(:json) do
        {
          projects: projects,
          tasks: tasks
        }
      end

      let(:expected_tasks) do
        [{
          id: 1,
          name: "Milk",
          project: projects[0],
          project_id: projects[0][:id]
        },
        {
          id: 2,
          name: "Bread",
          project: projects[0],
          project_id: projects[0][:id]
        },
        {
          id: 3,
          name: "Butter",
          project: projects[1],
          project_id: projects[1][:id]
        }]
      end

      let(:expected_projects) do
        [{ id: 1, name: "Shop list", tasks: { tasks: expected_tasks[0, 2] }, task_ids: [1,2] }, { id: 2, name: "Other Shop list", tasks: { tasks: expected_tasks[2, 3] }, task_ids: [3] }]
      end

      let(:expected_json) do
        {
          projects: expected_projects,
          tasks: expected_tasks
        }
      end
      let(:embed_associations) { EmberDataActiveModelParser::EmbedAssociations.new(json) }

      it "embeds the objects from the root to the proper parents" do
        expect(embed_associations.call).to eq(expected_json)
      end
    end

    context "with an object with some associations that have associations" do
      let(:tasks) do
        [{
          id: 1,
          name: "Milk",
          author_id: 1
        },
        {
          id: 2,
          name: "Bread",
          author_id: 2
        },
        {
          id: 3,
          name: "Cheese",
          author_id: nil
        }]
      end

      let(:expected_tasks) do
        [{
          id: 1,
          name: "Milk",
          author: authors[0],
          author_id: 1
        },
        {
          id: 2,
          name: "Bread",
          author: authors[1],
          author_id: 2
        },
        {
          id: 3,
          name: "Cheese",
          author: nil,
          author_id: nil
        }]
      end

      let(:authors) do
        [{
          id: 1,
          name: "Mom"
        },
        {
          id:2,
          name: "Dad"
        }]
      end

      let(:json) do
        {
          project: { id: 1, name: "Shop list", task_ids: [1, 2, 3] },
          tasks: tasks,
          authors: authors
        }
      end
      let(:expected_json) do
        {
          project: { id: 1, name: "Shop list", tasks: { tasks: expected_tasks }, task_ids: [1, 2, 3] },
          tasks: expected_tasks,
          authors: authors
        }
      end
      let(:embed_associations) { EmberDataActiveModelParser::EmbedAssociations.new(json) }

      it "embeds the objects from the root to the proper parents" do
        expect(embed_associations.call).to eq(expected_json)
      end
    end
  end
end
