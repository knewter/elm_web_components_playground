defmodule Backend.UploadSignatureController do
  use Backend.Web, :controller
  @service "s3"
  @aws_request "aws4_request"

  def create(conn, %{"filename" => filename, "mimetype" => mimetype}) do
    conn
    |> put_status(:created)
    |> render("create.json", signature: sign(filename, mimetype))
  end

  defp sign(filename, mimetype) do
    policy = policy(filename, mimetype)

    %{
      key: filename,
      date: get_date(),
      content_type: mimetype,
      acl: "public-read",
      success_action_status: "201",
      action: bucket_url(),
      aws_access_key_id: aws_access_key_id(),
      policy: policy,
      credential: credential(),
      signature: hmac_sha1(aws_secret_key(), policy)
    }
  end

  def get_date() do
    datetime = Timex.now
    {:ok, t} = Timex.format(datetime, "%Y%m%d", :strftime)
    t
  end

  defp credential() do
    credential(aws_config[:access_key_id], get_date())
  end

  defp credential(key, date) do
    key <> "/" <> date <> "/" <> region() <> "/" <> @service <> "/" <> @aws_request
  end

  defp hmac_sha1(secret, msg) do
    Base.encode64(:crypto.hmac(:sha, secret, msg))
  end

  defp now_plus(minutes) do
    import Timex

    now
      |> shift(minutes: minutes)
      |> format!("{ISO:Extended:Z}")
  end

  defp policy(key, mimetype, expiration_window \\ 60) do
    %{
      expiration: now_plus(expiration_window),
      conditions: [
        %{bucket: bucket_name},
        %{acl: "public-read"},
        ["starts-with", "$Content-Type", mimetype],
        ["starts-with", "$key", key],
        %{success_action_status: "201"}
      ]
    }
    |> Poison.encode!
    |> Base.encode64
  end

  def aws_access_key_id() do
    aws_config[:access_key_id]
  end

  def aws_secret_key() do
    aws_config[:secret_key]
  end

  defp bucket_name() do
    aws_config[:bucket_name]
  end

  defp region() do
    aws_config[:region]
  end

  defp aws_config() do
    Application.get_env(:backend, :aws)
  end

  defp bucket_url() do
    case region() do
      "us-east-1" -> "https://s3.amazonaws.com/#{bucket_name()}"
      reg -> "https://s3-#{reg}.amazonaws.com/#{bucket_name()}"
    end
  end
end
