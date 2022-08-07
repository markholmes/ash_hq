defmodule AshHq.Accounts.UserToken do
  @moduledoc false

  use AshHq.Resource,
    data_layer: AshPostgres.DataLayer,
    notifiers: [AshHq.Accounts.EmailNotifier],
    authorizers: [Ash.Policy.Authorizer]

  actions do
    defaults [:read]

    read :verify_email_token do
      argument :token, :url_encoded_binary, allow_nil?: false
      argument :context, :string, allow_nil?: false
      prepare AshHq.Accounts.Preparations.SetHashedToken
      prepare AshHq.Accounts.Preparations.DetermineDaysForToken

      filter expr(
               token == ^context(:hashed_token) and context == ^arg(:context) and
                 created_at > ago(^context(:days_for_token), :day)
             )
    end

    create :build_session_token do
      primary? true

      argument :user, :map

      change manage_relationship(:user, type: :replace)
      change set_attribute(:context, "session")
      change AshHq.Accounts.UserToken.Changes.BuildSessionToken
    end

    create :build_email_token do
      accept [:sent_to, :context]

      argument :user, :map

      change manage_relationship(:user, type: :replace)
      change AshHq.Accounts.UserToken.Changes.BuildHashedToken
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :token, :binary
    attribute :context, :string
    attribute :sent_to, :string

    create_timestamp :created_at
  end

  identities do
    identity :token_context, [:context, :token]
  end

  postgres do
    table "user_tokens"
    repo AshHq.Repo

    references do
      reference :user, on_delete: :delete, on_update: :update
    end
  end

  policies do
    policy always() do
      description """
      There are currently no usages of user tokens resource that should be publicly
      accessible, they should all be using authorize?: false.
      """

      forbid_if always()
    end
  end

  relationships do
    belongs_to :user, AshHq.Accounts.User
  end

  resource do
    description """
    Represents a token allowing a user to log in, reset their password, or confirm their email.
    """
  end
end