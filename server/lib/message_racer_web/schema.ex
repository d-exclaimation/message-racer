#
#  schema.ex
#  server
#
#  Created by d-exclaimation on 19:54.
#

defmodule MessageRacerWeb.Schema do
  @moduledoc """
  Root Schema
  """
  alias MessageRacer.{PlayerLoader, RoomLoader}
  use Absinthe.Schema

  import_types(MessageRacerWeb.RoomResolver)

  query do
    import_fields(:room_queries)
  end

  mutation do
    import_fields(:room_mutations)
  end

  subscription do
    import_fields(:room_subscriptions)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(PlayerLoader, PlayerLoader.data())
      |> Dataloader.add_source(RoomLoader, RoomLoader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
