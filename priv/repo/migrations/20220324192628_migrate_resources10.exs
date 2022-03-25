defmodule AshHq.Repo.Migrations.MigrateResources10 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    drop constraint(:options, "options_library_version_id_fkey")

    alter table(:options) do
      modify :library_version_id,
             references(:library_versions,
               column: :id,
               name: "options_library_version_id_fkey",
               type: :uuid
             )
    end
  end

  def down do
    drop constraint(:options, "options_library_version_id_fkey")

    alter table(:options) do
      modify :library_version_id,
             references(:dsls, column: :id, name: "options_library_version_id_fkey", type: :uuid)
    end
  end
end