module HistoriesHelper
  def diff(from, to)
    return if from.blank? && to.blank?

    Diffy::Diff.new(h(from), h(to), {
      include_plus_and_minus_in_html: true,
      context: 1,
    }).to_s(:html).html_safe
  end

  def diff_attribute(history, attribute)
    from = history.public_send("from_#{attribute}")
    to = history.public_send("to_#{attribute}")

    diff(from, to)
  end

  def diff_date_attribute(history, attribute)
    from = history.public_send("from_#{attribute}")
    to = history.public_send("to_#{attribute}")

    diff(from ? l(from) : "", to ? l(to) : "")
  end
end
