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
          project: { id: 1, name: "Shop list", tasks: { tasks: tasks } },
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
          project: { project: projects[0] }
        },
        {
          id: 2,
          name: "Bread",
          project: { project: projects[0] }
        },
        {
          id: 3,
          name: "Butter",
          project: { project: projects[1] }
        }]
      end

      let(:expected_projects) do
        [{ id: 1, name: "Shop list", tasks: { tasks: expected_tasks[0, 2] } }, { id: 2, name: "Other Shop list", tasks: { tasks: expected_tasks[2, 3] } }]
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
        }]
      end

      let(:expected_tasks) do
        [{
          id: 1,
          name: "Milk",
          author: { author: authors[0] }
        },
        {
          id: 2,
          name: "Bread",
          author: { author: authors[1] }
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
          project: { id: 1, name: "Shop list", task_ids: [1,2] },
          tasks: tasks,
          authors: authors
        }
      end
      let(:expected_json) do
        {
          project: { id: 1, name: "Shop list", tasks: { tasks: expected_tasks } },
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
