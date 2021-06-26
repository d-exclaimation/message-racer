#
#  store.ex
#  server
#
#  Created by d-exclaimation on 14:34.
#

defmodule MessageRacer.InMemory.Store do
  @moduledoc """
  InMemory store
  """
  use GenServer

  @typedoc """
  State of InMemory
  """
  @type state :: %{String.t() => [String.t()]}

  @doc """
  Start GenServer
  """
  @spec start_link(GenServer.options()) :: GenServer.on_start()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Initialize GenServer
  """
  @impl true
  @spec init(:ok) :: {:ok, state()}
  def init(:ok) do
    {:ok, %{}}
  end

  @doc """
  Handle called
  """
  @impl true
  @spec handle_call({atom, any}, any, state) :: {:reply, any, state()}
  def handle_call({:start, id}, _from, state) do
    case Map.fetch(state, id) do
      {:ok, messages} ->
        {:reply, messages, state}

      :error ->
        messages = get_messages()
        {:reply, messages, Map.put(state, id, messages)}
    end
  end

  def handle_call({:check, %{index: i, word: word, id: id}}, _from, state) do
    case Map.fetch(state, id) do
      {:ok, messages} ->
        is_correct = if(length(messages) > i, do: Enum.at(messages, i) == word, else: false)
        is_ended = is_correct and length(messages) - 1 == i

        cond do
          is_ended ->
            # Remove from InMemory as it is no longer needed
            {:reply, "end", state |> Map.delete(id)}

          # Keep the stat
          is_correct ->
            {:reply, "pass", state}

          true ->
            {:reply, "fail", state}
        end

      :error ->
        {:reply, "not-exist", state}
    end
  end

  @data [
    "encompassing",
    "Exclusive fault-tolerant knowledge base",
    "encoding",
    "Ameliorated bifurcated data-warehouse",
    "high-level",
    "Focused actuating collaboration",
    "matrix",
    "Pre-emptive web-enabled functionalities",
    "conglomeration",
    "Versatile secondary structure",
    "executive",
    "Right-sized executive portal",
    "installation",
    "Ameliorated radical strategy",
    "regional",
    "Reduced bifurcated Graphic Interface",
    "Stand-alone",
    "Front-line value-added analyzer",
    "forecast",
    "User-centric national matrix",
    "next generation",
    "Balanced multimedia model",
    "approach",
    "Profit-focused solution-oriented protocol",
    "Virtual",
    "Persistent methodical paradigm",
    "migration",
    "Compatible system-worthy protocol",
    "demand-driven",
    "Realigned global application",
    "Mandatory",
    "Sharable optimal concept",
    "artificial intelligence",
    "Fully-configurable exuding core",
    "Stand-alone",
    "Phased full-range budgetary management",
    "reciprocal",
    "Mandatory bi-directional circuit",
    "portal",
    "Virtual directional infrastructure",
    "transitional",
    "Open-architected upward-trending middleware",
    "high-level",
    "Face to face content-based hardware",
    "maximized",
    "Enhanced uniform analyzer",
    "approach",
    "Horizontal multi-tasking process improvement",
    "artificial intelligence",
    "Managed bifurcated firmware",
    "Reduced",
    "Diverse neutral monitoring",
    "productivity",
    "Self-enabling dynamic workforce",
    "4th generation",
    "Diverse fresh-thinking product",
    "Virtual",
    "Re-engineered dynamic Graphical User Interface",
    "Compatible",
    "Virtual even-keeled artificial intelligence",
    "task-force",
    "Compatible tertiary hardware",
    "open system",
    "Digitized demand-driven utilisation",
    "Persevering",
    "Self-enabling intermediate internet solution",
    "Face to face",
    "Reduced solution-oriented array",
    "Pre-emptive",
    "Polarised intangible approach",
    "Persistent",
    "Configurable context-sensitive neural-net",
    "Extended",
    "Automated empowering contingency",
    "real-time",
    "Proactive discrete open architecture",
    "mobile",
    "Business-focused motivating initiative",
    "time-frame",
    "Integrated tertiary moratorium",
    "Distributed",
    "Switchable upward-trending Graphic Interface",
    "Innovative",
    "Centralized uniform pricing structure",
    "Switchable",
    "Automated solution-oriented knowledge user",
    "workforce",
    "Organic human-resource capacity",
    "Virtual",
    "Exclusive client-driven leverage",
    "time-frame",
    "Optional encompassing frame",
    "Implemented",
    "Extended foreground artificial intelligence",
    "Cloned",
    "De-engineered attitude-oriented application",
    "Inverse",
    "Visionary secondary productivity",
    "Enhanced",
    "Programmable responsive portal",
    "Exclusive",
    "Switchable fault-tolerant complexity",
    "system engine",
    "Right-sized attitude-oriented archive",
    "pricing structure",
    "User-friendly transitional data-warehouse",
    "Multi-layered",
    "Visionary dynamic budgetary management",
    "web-enabled",
    "Function-based 24/7 parallelism",
    "superstructure",
    "De-engineered system-worthy process improvement",
    "intangible",
    "Front-line human-resource analyzer",
    "encryption",
    "Focused radical initiative",
    "local",
    "Profound reciprocal protocol",
    "mission-critical",
    "Grass-roots dedicated adapter",
    "intermediate",
    "Ergonomic 4th generation policy",
    "dynamic",
    "Virtual fresh-thinking capacity",
    "extranet",
    "Persistent grid-enabled protocol",
    "Secured",
    "Front-line coherent initiative",
    "installation",
    "Mandatory fresh-thinking budgetary management",
    "framework",
    "Mandatory modular alliance",
    "web-enabled",
    "Re-contextualized value-added function",
    "Open-source",
    "Quality-focused discrete attitude",
    "foreground",
    "Implemented clear-thinking methodology",
    "Distributed",
    "Progressive logistical internet solution",
    "frame",
    "Versatile discrete flexibility",
    "orchestration",
    "Persevering bifurcated framework",
    "workforce",
    "Sharable context-sensitive ability",
    "Configurable",
    "Programmable background firmware",
    "Triple-buffered",
    "Multi-channelled tangible utilisation",
    "Multi-tiered",
    "Object-based local encoding",
    "methodical",
    "Cross-platform responsive ability",
    "info-mediaries",
    "Mandatory full-range structure",
    "24 hour",
    "Streamlined multimedia pricing structure",
    "architecture",
    "Expanded contextually-based adapter",
    "knowledge base",
    "Networked fresh-thinking hub",
    "Cloned",
    "Innovative systematic capacity",
    "core",
    "Seamless content-based infrastructure",
    "responsive",
    "Implemented modular ability",
    "Customizable",
    "Fundamental dynamic complexity",
    "value-added",
    "Optimized intermediate definition",
    "Customizable",
    "Vision-oriented hybrid complexity",
    "Intuitive",
    "Triple-buffered solution-oriented system engine",
    "Reduced",
    "Ergonomic optimal intranet",
    "process improvement",
    "Expanded multi-state challenge",
    "Synergized",
    "Realigned system-worthy installation",
    "Face to face",
    "Programmable global monitoring",
    "Future-proofed",
    "Re-contextualized real-time task-force",
    "Vision-oriented",
    "Vision-oriented asymmetric definition",
    "Graphic Interface",
    "Diverse dynamic archive",
    "Versatile",
    "Multi-lateral eco-centric frame",
    "static",
    "Grass-roots explicit functionalities",
    "Graphic Interface",
    "Ameliorated discrete info-mediaries",
    "leverage",
    "User-friendly zero defect parallelism",
    "Total",
    "Streamlined 3rd generation superstructure"
  ]

  defp get_messages(), do: @data |> Enum.shuffle() |> Enum.slice(0..10)
end
