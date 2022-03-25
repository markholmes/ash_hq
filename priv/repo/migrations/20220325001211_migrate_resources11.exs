defmodule AshHq.Repo.Migrations.MigrateResources11 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:options) do
      add :path, {:array, :text}
    end
  end

  def down do
    alter table(:options) do
      remove :path
    end
  end
end