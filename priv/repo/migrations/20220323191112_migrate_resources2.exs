defmodule AshHq.Repo.Migrations.MigrateResources2 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:library_versions) do
      add :data, :map
    end
  end

  def down do
    alter table(:library_versions) do
      remove :data
    end
  end
end