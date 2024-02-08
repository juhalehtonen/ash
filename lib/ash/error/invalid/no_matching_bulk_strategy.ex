defmodule Ash.Error.Invalid.NoMatchingBulkStrategy do
  @moduledoc "Used when an identity name is used that does not reference identity on the resource"
  use Ash.Error.Exception

  def_ash_error(
    [:resource, :action, :requested_strategies, :not_atomic_batches_reason, :not_atomic_reason],
    class: :invalid
  )

  defimpl Ash.ErrorKind do
    def id(_), do: Ash.UUID.generate()

    def code(_), do: "no_matching_bulk_strategy"

    def message(%{
          resource: resource,
          action: action,
          requested_strategies: requested_strategies,
          not_atomic_batches_reason: not_atomic_batches_reason,
          not_atomic_reason: not_atomic_reason
        }) do
      reasons =
        [
          "Could not use `:stream`": "Not in requested strategies",
          "Could not use `:atomic_batches`":
            not_atomic_batches_reason || "Not in requested strategies",
          "Could not use `:atomic`": not_atomic_reason || "Not in requested strategies"
        ]
        |> Enum.map_join("\n", fn {reason, message} -> "#{reason}: #{message}" end)

      """
      #{inspect(resource)}.#{action} had no matching bulk strategy that could be used.

      Requested strategies: #{inspect(requested_strategies)}

      #{reasons}
      """
    end
  end
end