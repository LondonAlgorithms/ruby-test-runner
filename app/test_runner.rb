require "rspec/autorun"
require "rspec"
require_relative "spec_helper"
require "json"


  def run(folder)

    describe "Pathfinder" do
      require_file(folder)

      path = File.expand_path("../../builds/#{folder}/challenge.json", __FILE__)
      f = open(path).read
      json = JSON.parse(f)
      challenges = json["challenges"]

      outputs = []
      after(:all) do
        process_outputs(outputs)
        path = File.expand_path("../../builds/#{folder}/output.json", __FILE__)
        File.write(path, outputs.to_json.to_s)
      end

      challenges.each_with_index do |challenge, index|
        outputs << run_challenge(challenge,index)
      end
    end
  end

  private

  def process_outputs(outputs)
    outputs.each do |challenge|
      challenge[:test_results].each do |result|
        result[:result] = result[:result].execution_result.status == :passed
      end
    end
  end
  def require_file(folder)
    path = File.expand_path("../../builds/#{folder}/algo", __FILE__)
    require(path)
  end

  def run_challenge(challenge, pb_index)
    initialize_params = challenge["class_initialize_params"]
    solution = Pathfinder.new(*initialize_params)

    object = { problem_id: pb_index }
    tests = []
    challenge["tests"].each_with_index do |test_obj, index|
      context "test #{index}" do
        x = test_obj["check_name"]
        y = test_obj["value"]
        functions = challenge["functions_to_call_on_instance"]


        if x == "equality"
          result = test_equality(solution, functions, y)
        elsif x == "functionCalled"
          result = test_function_called(solution, functions, y)
        end
        tests << { test_id: index, result: result }
      end
    end
    object[:test_results] = tests
    object
  end

  def test_function_called(solution, functions, expected)
    it "functionCalled" do
      allow(solution).to receive(expected.to_sym)
      run_functions(solution,functions)
      expect(solution).to have_received(expected.to_sym)
    end
  end

  def test_equality(solution, functions, expected)
    it "equality" do
      res = run_functions(solution,functions)

      expect(res).to(eq(expected))
    end
  end

  def run_functions(solution,function_array)
    function_array.each do |fn_obj|
      x = fn_obj["function_name"]
      y = fn_obj["params"]
      solution = solution.send(x, *y)
    end
    solution
  end
