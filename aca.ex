defmodule Main do
  use ClusterOS.DSL

  alias FromStage1.Stage1
  alias FromStage2.Stage2
  alias FromStage3.Stage3

  defcomposite ACA do
    output("a")
    output("b")
    output("c")

    @impl true
    def on_bootstrap(this, _args) do
      {:ok, stage1} = add_component(this, "stage 1", Stage1, %{}, %{})

      {:ok, stage2} =
        add_component(this, "stage 2", Stage2, %{}, %{"p" => get_output(stage1, "p")})

      {:ok, stage3} =
        add_component(this, "stage 3", Stage3, %{}, %{"f" => get_output(stage2, "f")})

      expose_output(this, get_output(stage1, "a"), as: "a")
      expose_output(this, get_output(stage1, "b"), as: "b")
      expose_output(this, get_output(stage3, "c"), as: "c")
    end
  end
end
