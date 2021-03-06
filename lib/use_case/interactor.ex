defmodule UseCase.Interactor do
  @moduledoc """
    Adds `ok/0`,`ok/1`, `error/0`, `error/1` and `error/2` functions to a module that uses it
  """

  defmacro __using__(opts \\ []) do
    quote do
      defstruct unquote(Keyword.get(opts, :input, []))
      defmodule Output, do: defstruct(unquote(Keyword.get(opts, :output, [])) ++ [:_state])
      defmodule Error, do: defexception(unquote(Keyword.get(opts, :error, []) ++ [:message]))

      def ok, do: {:ok, %__MODULE__.Output{}}
      def ok(nil), do: {:ok, %__MODULE__.Output{}}
      def ok([]), do: {:ok, %__MODULE__.Output{}}
      def ok(attr_values), do: {:ok, struct(__MODULE__.Output, attr_values)}
      def error, do: {:error, %__MODULE__.Error{}}
      def error(nil), do: {:error, %__MODULE__.Error{}}
      def error(nil, []), do: {:error, struct(__MODULE__.Error, [])}
      def error(nil, attr_values), do: {:error, struct(__MODULE__.Error, attr_values)}
      def error(message, []), do: {:error, struct(__MODULE__.Error, message: message)}

      def error(message, attr_values),
        do: {:error, struct(__MODULE__.Error, attr_values ++ [message: message])}

      def error(message), do: {:error, struct(__MODULE__.Error, message: message)}
    end
  end
end
