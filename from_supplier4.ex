defmodule FromSupplier4 do
  use ClusterOS.DSL

  alias Types.T6

  defactor O do
    output("i", spec: T6.output_spec())
  end

  defactor P do
    output("h", spec: T6.output_spec())
  end

  defcomposite Supplier4 do
    output("i")
    output("h")

    @impl true
    def on_bootstrap(this, _args) do
      {:ok, o} = add_component(this, "O", O, %{}, %{})
      {:ok, p} = add_component(this, "P", P, %{}, %{})

      expose_output(this, get_output(o, "i"), as: "i")
      expose_output(this, get_output(p, "h"), as: "h")
    end
  end
end
